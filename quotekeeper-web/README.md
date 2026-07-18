# QuoteKeeper (web version)

The same app as the native one — add / view / edit / delete quotes that persist
between launches — but as a single web page you can **Add to Home Screen** so it
looks and behaves like an app. No App Store, no Swift Playgrounds, no build step.

It's one self-contained file: `index.html` (HTML + CSS + JavaScript, no
dependencies, works offline once loaded).

## How to use it as a "real" app on your iPhone

You need a URL to open it from. Pick whichever is easiest:

- **GitHub Pages** (gives a clean, permanent URL): enable Pages for this repo and
  point it at the folder containing `index.html`. Then visit that URL in Safari.
- **Any static host** (Netlify Drop, etc.): drag the file in, open the URL.
- **Quick local test:** you can even open the file directly in a desktop browser
  to try the functionality; `localStorage` still works.

Then, in **Safari on the iPhone**:

1. Open the page.
2. Tap the **Share** button → **Add to Home Screen**.
3. Name it (e.g. "Quotes") → **Add**.

You now have an icon on your Home Screen. Tapping it launches full-screen with no
Safari toolbar — it looks like a native app. Your quotes are saved on the device.

## How the "saved file" works here

A website isn't allowed to freely read and write a normal file on your phone —
browsers sandbox that for security. Instead the browser gives each site a private
storage area called **`localStorage`** that stays on the device between visits.
It behaves exactly like the file you're picturing:

- **Save:** we turn the whole list of quotes into JSON text and put it in
  `localStorage` under one key (`quotekeeper.quotes`).
- **Load:** on launch we read that text back and parse it into the list.

That `encode → store → read → decode` cycle is the same idea as the native app
writing a `.json` file — the only difference is the browser owns the storage
instead of a file you can see. All of it is in the `<script>` block of
`index.html` (`loadQuotes` / `saveQuotes`).

### Things to know about this kind of storage

- The data is tied to **this browser on this device**. It isn't synced to iCloud
  and isn't in your device backups the way a native app's files are.
- If you clear Safari's website data, the quotes go with it.
- Home-screen web apps keep their data well, but a site you *don't* open for a
  long time can have its storage cleared by Safari. For a personal, regularly
  used app this is rarely an issue.

For a personal experiment where you just want to save, close, reopen, and see
your quote again, this is the simplest possible approach.
