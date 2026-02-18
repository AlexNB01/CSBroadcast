# CSBroadcast

CSBroadcast is a desktop control panel for driving local broadcast overlays for esports productions.
It combines:

- A **PyQt5 GUI** (`CSBroadcast.py`) for entering match data.
- A **local HTTP server** (`server.py`) that serves overlay pages and pushes live update events.
- A set of **HTML overlay scenes** in `HTML/` (scoreboard, draft, standings, bracket, waiting screens, etc.).
- A generated **`Scoreboard/` data tree** (text files + images) consumed by browser sources in OBS.

The app is designed to run locally on a broadcast PC and keep overlays synchronized as operators edit data.

---

## Features

- Team and player management (names, abbreviations, logos, colors).
- Match series tracking (maps, score progression, current map).
- General broadcast metadata (host, caster names, status text, brand colors, logos).
- Overlay data export to structured files under `Scoreboard/`.
- FACEIT-powered imports for maps/players (when API details are configured in-app).
- Live overlay refresh via local `/notify` + SSE `/events` endpoints.
- Built-in autosave and manual save/load of match state JSON.

---

## Repository layout

```text
.
├─ CSBroadcast.py        # Main PyQt application
├─ server.py             # Local HTTP + SSE server
├─ launch.py             # Python launcher (starts server + GUI)
├─ launch.bat            # Windows launcher for packaged EXEs
├─ HTML/                 # Overlay pages to use in OBS Browser Sources
├─ Scoreboard/           # Runtime export output (created/updated by app)
├─ assets.json           # Asset catalog (heroes/maps/etc.)
├─ match.json            # Serialized match snapshot
└─ autosave.json         # Last autosaved full GUI state
```

---

## Requirements

### Runtime

- Python **3.9+** recommended.
- `PyQt5`.
- Windows is the primary target (paths and launcher behavior assume local desktop operation).

### Install dependencies

```bash
python -m pip install --upgrade pip
python -m pip install PyQt5
```

> If you are using packaged binaries (`CSBroadcast.exe`, `CSBroadcastServer.exe`), you do not need a local Python install for normal operation.

---

## Quick start

## 1) Start the application

Choose one of the launch modes:

### A. Python mode (source)

```bash
python launch.py
```

`launch.py` starts `server.py` on `127.0.0.1:8324`, opens the GUI, and keeps a simple restart menu after GUI exit.

### B. Windows packaged mode

Double-click:

```text
launch.bat
```

`launch.bat` expects these binaries either in repo root or nested folder:

- `CSBroadcastServer.exe` (or `CSBroadcastServer\CSBroadcastServer.exe`)
- `CSBroadcast.exe` (or `CSBroadcast\CSBroadcast.exe`)

It launches the server minimized, starts GUI, and kills the server when GUI exits.

### C. Manual server + GUI (advanced)

Terminal 1:

```bash
python server.py --bind 127.0.0.1 --port 8324 --root .
```

Terminal 2:

```bash
python CSBroadcast.py
```

---

## 2) Configure match data in GUI

Inside the GUI, fill the main sections (names can vary by tab label):

- **Teams**: team names, abbreviations, logo files, team colors, player names/roles/links.
- **Maps / Draft**: selected map list, pick/ban context, per-map result progression.
- **General**: host, caster names, first-to value, overlay/transition logos, palette colors.
- **Statistics / FACEIT** (optional): FACEIT match page, API key, data source settings.
- **Standings / Bracket** (if used): tournament table and bracket exports.

Changes are continuously exported to overlay data files and autosaved.

---

## 3) Add overlays in OBS

Use **Browser Source** entries that point to the local server URLs for pages in `HTML/`:

Examples:

- `http://127.0.0.1:8324/HTML/scoreboard.html`
- `http://127.0.0.1:8324/HTML/draft.html`
- `http://127.0.0.1:8324/HTML/standings.html`
- `http://127.0.0.1:8324/HTML/bracket.html`
- `http://127.0.0.1:8324/HTML/startingsoon.html`
- `http://127.0.0.1:8324/HTML/berightback.html`
- `http://127.0.0.1:8324/HTML/thankyouforwatching.html`

Recommended Browser Source settings:

- Width/Height matching your production canvas (e.g., 1920x1080).
- Refresh browser when scene becomes active: optional.
- Shutdown source when not visible: optional (can reduce resource use).

---

## How live updates work

1. GUI writes exported files under `Scoreboard/`.
2. GUI posts changed key info to `http://127.0.0.1:8324/notify`.
3. Overlay pages keep an SSE connection to `/events`.
4. On event, overlays re-read the needed files and update on-screen values.

This means your OBS browser scenes can stay loaded while content updates in near real-time.

---

## Exported data structure (important for customization)

`Scoreboard/` contains the runtime files overlays consume.

Typical paths:

- `Scoreboard/General/host.txt`
- `Scoreboard/General/caster1.txt`
- `Scoreboard/General/caster2.txt`
- `Scoreboard/General/first_to.txt`
- `Scoreboard/General/colors.txt`
- `Scoreboard/General/OverlayLogo.png`
- `Scoreboard/General/TransitionLogo.png`
- `Scoreboard/Maps/index.txt`
- `Scoreboard/Maps/index.json`
- `Scoreboard/Maps/<map-slug>.png`
- `Scoreboard/Match/T1Name.txt`, `T2Name.txt`, scores, colors, players, logos
- `Scoreboard/Match/maps.txt`, `map_pool.txt`

The app also maintains:

- `autosave.json` — latest full editor state.
- `match.json` and `assets.json` — structured snapshots used by the workflow.

---

## Saving and loading

- The app autosaves to `autosave.json`.
- You can **Save As** to named JSON files (e.g., per match day).
- You can **Load** prior state files from the UI.

Recommended workflow:

1. Create a baseline event template JSON.
2. Duplicate per match.
3. Load before each series and adjust only team/map specifics.

---

## FACEIT integration (optional)

If you use FACEIT imports:

1. Set **match FACEIT URL** in the relevant statistics tab.
2. Set **FACEIT API key** in app settings (where prompted).
3. Use import actions for maps/players/team details.

If imports fail, verify:

- API key validity.
- Match URL format.
- Network access from the broadcast machine.

---

## Troubleshooting

### GUI opens but overlays do not update

- Confirm server is running on `127.0.0.1:8324`.
- Open `http://127.0.0.1:8324/HTML/scoreboard.html` directly in a browser.
- Ensure firewall or security software is not blocking localhost traffic.

### Port conflict on 8324

Run server on another port:

```bash
python server.py --port 9000
```

Then update OBS Browser Source URLs to port `9000`.

### Missing logos/maps in overlay

- Re-select image files in GUI to refresh source paths.
- Confirm files exist and are readable.
- Check generated files under `Scoreboard/General/` and `Scoreboard/Maps/`.

### launch.bat exits with "exe not found"

Ensure packaged binaries exist in expected paths:

- `CSBroadcastServer.exe` or `CSBroadcastServer/CSBroadcastServer.exe`
- `CSBroadcast.exe` or `CSBroadcast/CSBroadcast.exe`

---

## Developer notes

### Run server only

```bash
python server.py --bind 127.0.0.1 --port 8324 --root .
```

### Server endpoints

- `GET /HTML/...` static overlay files.
- `GET /events` SSE stream for live changes.
- `POST /notify` accepts JSON payload like `{ "changed": ["key"] }`.
- `GET /external?path=<absolute-file-path>` serves specific local files.

### Code entry points

- GUI app + export logic: `CSBroadcast.py`
- HTTP/SSE server: `server.py`
- Source launcher: `launch.py`
- Packaged launcher: `launch.bat`

---

## Recommended production checklist

Before going live:

1. Start server + GUI.
2. Verify all required OBS Browser Sources load locally.
3. Fill teams, players, maps, and caster metadata.
4. Trigger a few score/map changes and confirm scene updates.
5. Save match state snapshot.
6. Keep server window/process alive for entire broadcast.

---

## License

See `LICENSE`.
