Portfolio website scaffold

Open `index.html` in your browser to view the site locally.

Profile image status:
- I added a fallback placeholder at `assets/profile.svg` so the site shows an avatar right away.
- If you want the real photo you attached to appear, save your photo as `assets/profile.jpg` (overwrite if needed). The hero image will load `assets/profile.jpg` if present, otherwise it uses the SVG fallback.

How to replace the image with your photo:
1. Create the `assets` folder next to `index.html` if it doesn't exist.
2. Save your photo file as `profile.jpg` inside `assets`.
	- Example path: `assets/profile.jpg`.
3. Refresh the browser page to see the real photo.

Quick edits:
- Replace the placeholder email in `index.html` if you want mailto links to use your real email.
- Replace project cards in `index.html` with real screenshots and links.

To customize styles, edit `styles.css`. To modify behavior, edit `script.js`.

Preview locally (from the project folder):
```powershell
python -m http.server 8000
```
Open http://localhost:8000 in your browser.
