import SwiftUI

/// The add / edit form, shown as a sheet.
///
/// The same view handles both "new quote" and "edit existing quote" based on
/// the `EditorState` it's given.
struct EditQuoteView: View {
    @EnvironmentObject private var store: QuoteStore
    @Environment(\.dismiss) private var dismiss

    let state: EditorState

    @State private var text: String = ""
    @State private var author: String = ""

    private var isEditing: Bool {
        if case .edit = state { return true }
        return false
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Quote") {
                    TextField("Enter the quote", text: $text, axis: .vertical)
                        .lineLimit(3...8)
                }
                Section("Author") {
                    TextField("Who said it? (optional)", text: $author)
                }

                if case .edit(let quote) = state {
                    Section {
                        Button(role: .destructive) {
                            store.delete(quote)
                            dismiss()
                        } label: {
                            Label("Delete Quote", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Quote" : "New Quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAndDismiss() }
                        .disabled(trimmedText.isEmpty)
                }
            }
            .onAppear(perform: populateFields)
        }
    }

    private var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// When editing, pre-fill the fields with the existing quote's values.
    private func populateFields() {
        if case .edit(let quote) = state {
            text = quote.text
            author = quote.author
        }
    }

    private func saveAndDismiss() {
        switch state {
        case .new:
            store.add(text: text, author: author)
        case .edit(let quote):
            store.update(quote, text: text, author: author)
        }
        dismiss()
    }
}
