# QuoteKeeper

A tiny SwiftUI iPhone app for saving quotes. Add a quote, edit it, delete it —
and everything is still there the next time you open the app. It's built as a
**Swift Playgrounds app package** so you can build, run, and install it to your
Home Screen entirely on the iPhone, with no Mac and no Xcode.

## What it does

- **Add** a quote (and an optional author) with the **+** button
- **View** all saved quotes in a list, newest first
- **Edit** a quote by tapping its row
- **Delete** a quote by swiping left, or from the Delete button in the editor
- **Persists** everything to disk, so quotes survive quitting/relaunching the app

## How to run it on your iPhone

1. Install **Swift Playgrounds** (free, from the App Store).
2. Get the `QuoteKeeper.swiftpm` folder onto your phone. Easiest ways:
   - Open this repo in the **GitHub** app / **Working Copy**, or download the
     folder into the **Files** app, then
   - Tap `QuoteKeeper.swiftpm` — it opens directly in Swift Playgrounds.
3. In Swift Playgrounds, press **▶ Run**. The app launches full‑screen.
4. (Optional) To keep it like a real app: in Swift Playgrounds, use the project
   menu → **"Add to Home Screen" / build the app**. It installs an icon you can
   tap any time — no need to reopen Swift Playgrounds.

> Because this is a personal app signed with a free/personal profile, iOS may
> ask you to trust it, and it can expire after a while and need a re‑build. That
> is normal for apps you install on yourself without the App Store.

## How the data persistence works

This is the part you wanted to understand. It's deliberately simple and
transparent — all of it lives in `QuoteStore.swift`.

1. **In memory:** every quote lives in a Swift array, `quotes: [Quote]`.
2. **On every change:** a `didSet` observer on that array runs `save()`. It uses
   `JSONEncoder` to turn the array into JSON text and writes it to a file.
3. **The file:** it's stored at `<App's Documents folder>/quotes.json`. The
   Documents directory is a private, persistent folder that iOS keeps for your
   app between launches (it's even included in device backups).
4. **On launch:** `init()` calls `load()`, which reads `quotes.json` back off
   disk with `JSONDecoder` and rebuilds the array. If the file doesn't exist yet
   (first launch), it just starts empty.

So the array is the "live" copy your UI shows, and the JSON file is the durable
copy on disk. They're kept in sync on every add/edit/delete and re-loaded every
launch. That round‑trip — **encode → write to disk → read back → decode** — is
the core idea behind almost all local storage, whether an app uses a raw JSON
file (like this), `UserDefaults`, or a database like SwiftData/Core Data.

Want to see the actual saved data? The JSON is written pretty‑printed, e.g.:

```json
[
  {
    "id": "3F2B…",
    "text": "The best way to predict the future is to invent it.",
    "author": "Alan Kay",
    "dateSaved": 774560000
  }
]
```

## Files

| File | Purpose |
|------|---------|
| `Package.swift` | Swift Playgrounds app manifest (name, icon color, iOS version) |
| `QuoteKeeperApp.swift` | App entry point; creates and shares the store |
| `Quote.swift` | The data model (one quote), made `Codable` for JSON |
| `QuoteStore.swift` | **The persistence layer** — in-memory list + save/load to disk |
| `ContentView.swift` | Main list screen (view / add / delete) |
| `EditQuoteView.swift` | The add/edit form sheet |
