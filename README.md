# CSBroadcast

CSBroadcast is a local broadcast overlay controller for Counter-Strike productions.
It ships as desktop executables (`CSBroadcast.exe` + `CSBroadcastServer.exe`) and serves HTML overlays to OBS Browser Sources.

> **Important:** The application is now packaged as EXE files. `launch.py` is legacy/development-only and not needed in normal use.

---

## Quick Start

### Install
1. Download and run the CSBroadcast installer (`CSBroadcast-Setup.exe`) from the project release page.
2. Install to the default folder (recommended).
3. Always start the app with **`launch.bat`**.

### Add OBS overlays
- In OBS: **Scene Collection → Import**
- Import the provided scene collection JSON (`csbroadcastscenes.json`) from your CSBroadcast install folder.

### Install recommended OBS plugins/tools
- [VLC media player](https://www.videolan.org/vlc/download-windows.html) (needed if you use VLC Video Source / replay workflows)

### Operate
- Fill **Match tab**: teams, abbreviations, logos, scores, players, map picks/results.
- Fill **General tab**: map count, host/casters, logos, theme colors, status text.
- Fill **Draft tab**: select map pool shown in `draft.html`.
- Fill **Waiting tab**: countdown, waiting texts, socials, and video settings.
- Fill **Standings tab**: groups, teams, logos, and results.
- Fill **Bracket tab**: import teams from standings, load bracket, assign teams.
- Click **Update** to push changes to overlays.
- Use **Swap** to flip teams (including map picks/scores).
- Use **Reset** per tab to clear only that tab.

See **GUI Reference** below for field-level behavior.

---

## Overlays

All overlays are HTML/CSS/JS pages served locally by `CSBroadcastServer.exe` and updated through SSE (`/events`).

### Scoreboard (`scoreboard.html`)
- Left/right team areas with logo, name, score, and team color.
- Series/map strip fed by match data.
- Updates from Match + General tab values.

### Team Rosters (`team1.html`, `team2.html`)
- Team roster layouts for player names/roles.
- Supports full roster/substitute style based on filled player rows.

### Caster Screens
- `singlecam.html`, `duorow.html`, `triorow.html`
- Caster names and theme colors are pulled from General settings.

### Transition (`transition.html`)
- Transition/stinger scene using transition logo + theme colors.

### Replay (`replay.html`)
- Replay overlay page used with local replay playlist/workflow.

### Waiting Screens
- `startingsoon.html` → Starting Soon
- `berightback.html` → Be Right Back
- `thankyouforwatching.html` → Thank You for Watching
- Typical features include: title text, optional countdown, logo area, socials ticker/row, and video panel.

### Draft (`draft.html`)
- Series draft/map card view (picks/results/map status) with team colors.

### Maps (`maps.html`)
- Full series map overview with per-map results.

### Bracket (`bracket.html`)
- Tournament bracket view fed by Bracket tab exports.

### Standings (`standings.html`)
- Group standings/results view fed by Standings tab exports.

---

## GUI Reference

## Match tab
- **Team 1 / Team 2**
  - Name, Abbreviation, Score, Team Color
  - Load Logo
- **Players**
  - Per-player fields (name + role/link data depending on layout)
- **Maps**
  - Up to BO7-style map rows
  - Per-map values: map name, map score/result, pick side/team, completion status
- **Buttons**
  - **Update**: writes match exports and pushes live update event
  - **Swap**: flips Team 1/Team 2 and related map context
  - **Reset**: clears Match tab fields

## General tab
- Number of maps / first-to setup
- Host, Caster 1, Caster 2
- Status text
- Overlay logo + Transition logo
- Theme colors (multiple named slots used across scenes)
- **Update**: writes `Scoreboard/General/*`
- **Reset**: clears General tab fields

## Draft tab
- Select/maintain map pool shown in draft overlays.

## Waiting tab
- Waiting texts (Starting Soon / BRB / Thanks)
- Countdown timer controls
- Social handles/rows
- Video directory/playlist-related fields
- **Update** writes waiting export files
- **Reset** clears waiting fields

## Standings tab
- Group/team table editor + result fields for `standings.html`
- **Update** exports standings data
- **Reset** clears standings fields

## Bracket tab
- Import teams from Standings
- Load/select bracket template
- Assign teams and progress winners
- **Update** exports bracket data for `bracket.html`
- **Reset** clears bracket fields

## Team import/export
- Per-team import/export JSON helpers are available in the app menu/actions.

---

## Replay workflow (recommended)

1. Save replay exports into the expected replay input location under `Scoreboard/Replay`.
2. Let CSBroadcast replay workflow copy/index clips into `Scoreboard/Replay/Playlist`.
3. Keep `replay.html` Browser Source loaded for instant transitions.

If your replay source does not update:
- verify file naming/path,
- verify OBS source points to `http://127.0.0.1:8324/HTML/replay.html`,
- verify server is still running.

---

## File/scene wiring

### Start sequence
1. Run `launch.bat`
2. `CSBroadcastServer.exe` starts local server (`127.0.0.1:8324`)
3. `CSBroadcast.exe` opens GUI
4. On GUI close, launcher stops server

### Overlay URL pattern
Use OBS Browser Sources with URLs such as:
- `http://127.0.0.1:8324/HTML/scoreboard.html`
- `http://127.0.0.1:8324/HTML/draft.html`
- `http://127.0.0.1:8324/HTML/maps.html`
- `http://127.0.0.1:8324/HTML/standings.html`
- `http://127.0.0.1:8324/HTML/bracket.html`

### Runtime data exports
The app continuously writes overlay data under:
- `Scoreboard/General/*`
- `Scoreboard/Match/*`
- `Scoreboard/Maps/*`
- `Scoreboard/Waiting/*`
- plus standings/bracket/replay-related folders

---

## Troubleshooting

### App opens but overlays do not update
- Ensure `CSBroadcastServer.exe` is running.
- Open `http://127.0.0.1:8324/HTML/scoreboard.html` in a browser.
- Confirm OBS Browser Source URLs use `127.0.0.1:8324`.
- Check firewall/security rules for localhost traffic.

### `launch.bat` reports missing EXE
Expected files:
- `CSBroadcastServer.exe` (or `CSBroadcastServer\CSBroadcastServer.exe`)
- `CSBroadcast.exe` (or `CSBroadcast\CSBroadcast.exe`)

### Port 8324 already in use
Close the conflicting process and relaunch.
(If needed for development, run server manually with another port and update Browser Source URLs.)

### Logos/maps not showing
- Re-select files in GUI.
- Confirm files exist and are readable.
- Check generated files in `Scoreboard/General` and `Scoreboard/Maps`.

---

## Developer note

- Production usage is EXE-based (`launch.bat` + packaged binaries).
- `launch.py` exists only for source/dev workflows and can be ignored in installer builds.

---

## License

See `LICENSE`.
