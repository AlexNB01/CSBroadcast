# CSBroadcast

CSBroadcast is a local broadcast overlay tool for Counter-Strike productions.
It runs as packaged Windows executables and serves all overlay pages from a local server for OBS Browser Sources.

---

## Quick Start

### Install
1. Download and run [**CSBroadcast-Setup.exe** from this repository’s Releases page](https://github.com/AlexNB01/CSBroadcast/releases/download/v1.0/CSBroadcast-Setup.exe).
2. Install to the default folder.
3. Always launch with **`launch.bat`**.

### Add OBS overlays
OBS → **Scene Collection** → **Import** → select:

- `csbroadcastscenes.json`

(from your CSBroadcast installation folder)

### Install recommended OBS plugins/tools
- [VLC media player](https://www.videolan.org/vlc/download-windows.html) (recommended if you use VLC sources/replay workflows)

### Operate
- Fill **Match tab**: teams, abbreviations, logos, colors, players, scores, and map rows.
- Fill **General tab**: map count, host, casters, logos, theme colors, status text.
- Fill **Draft tab**: map pool shown in `draft.html`.
- Fill **Waiting Screen tab**: countdown, waiting texts, socials, and video folder.
- Fill **Standings tab**: groups, teams, logos, and records.
- Fill **Bracket tab**: import teams from standings, load bracket, assign teams.
- Fill **Statistics tab**: FACEIT links/API key/match page and stats options.
- Click **Update** buttons to write exports and push live updates.
- Use **Swap** to flip Team 1/Team 2 with related map context.
- Use **Reset this tab** to clear only the current section.

See **GUI Reference** below for details.

---

## Overlays

All overlays are HTML/CSS/JS pages served by the local app server (`127.0.0.1:8324`) and updated via SSE.

## Scoreboard (`scoreboard.html`)
- Team left/right areas with logo, name, score, and color.
- Map strip/series state from Match + Draft data.
- Uses General theme colors.

## Team Rosters (`team1.html`, `team2.html`)
- Team/player roster views.
- Supports the configured player rows from Match data.

## Caster Screens
- `singlecam.html`, `duorow.html`, `triorow.html`
- Pull caster names and theme colors from General tab.

## Transition (`transition.html`)
- Transition/stinger layout using transition logo and theme palette.

## Replay (`replay.html`)
- Replay page fed by replay playlist files under `Scoreboard\Replay\Playlist`.

## Waiting Screens
- `startingsoon.html`
- `berightback.html`
- `thankyouforwatching.html`

Features include title text, countdown support, logo area, social row, and video panel.

## Draft (`draft.html`)
- Draft/map-card view with pick/win/ban context and team colors.
- Uses selected map pool from Draft/Match data.

## Maps (`maps.html`)
- Full series map overview with per-map scores/results.

## Bracket (`bracket.html`)
- Tournament bracket exported from Bracket tab.

## Standings (`standings.html`)
- Group standings exported from Standings tab.

---

## GUI Reference

## Match tab
- **Team 1 / Team 2**
  - Name
  - Abbreviation
  - Score
  - Team color
  - Team logo
  - Team FACEIT link
- **Players**
  - Player rows (name/role/link fields)
  - Team player import from FACEIT
- **Maps**
  - Up to 7 map rows
  - Per-map values: map name, team scores, completion state, pick/side context, winner markers
- **Buttons**
  - **Update**: writes `Scoreboard\Match\*` and notifies overlays
  - **Swap**: flips teams and map context
  - **Reset this tab**: clears Match fields

## General tab
- Host, Caster 1, Caster 2
- Status text
- Overlay logo and Transition logo
- Theme colors:
  - Primary
  - Secondary
  - Tertiary
  - Quaternary
  - Quinary
  - Senary
  - Septenary
  - Octonary
- **Update (General)** writes `Scoreboard\General\*`
- **Reset this tab** clears only General fields

## Draft tab
- Controls which maps are used/shown for draft overlays.

## Waiting Screen tab
- Video folder path
- Starting Soon / BRB / Thank You texts
- Countdown timer controls
- Social links/handles
- **Update (Waiting)** writes `Scoreboard\Waiting\*`
- **Reset** clears waiting settings

## Standings tab
- Create/edit groups
- Enter team rows, records, logos, and status (`qualified` / `eliminated`)
- **Update + sort** exports `Scoreboard\Standings\*`
- **Reset this tab** clears standings UI state

## Bracket tab
- Import team list from Standings
- Load bracket template
- Assign teams into bracket slots
- Mark winners/progression
- **Update** exports `Scoreboard\Bracket\*`
- **Reset this tab** clears bracket state

## Statistics tab (FACEIT)
- Tournament FACEIT links:
  - Group stage
  - Playoffs
  - FACEIT API key
- Match statistics settings:
  - Title
  - Match page URL
  - Source selection
  - Selected match maps
- FACEIT actions:
  - Import picked maps from FACEIT
  - Import Team 1 players from FACEIT
  - Import Team 2 players from FACEIT
- **Update (Statistics)** exports FACEIT/statistics files used by overlays/pages
- **Reset this tab** clears statistics fields

## Team Import/Export
- Menu actions for Home/Away team import/export JSON.
- Useful for reusing team profiles between matches.

## Bulk Import Wizard
- Bulk map/logo asset import workflow (from menu).
- Imports detected assets into app-managed folders and index files.

---

## Replay

Recommended workflow:
1. Export/copy replay clips into the app replay input path.
2. Keep replay files in `Scoreboard\Replay\Playlist` for sequential playback.
3. Keep `replay.html` Browser Source active in OBS for instant use.

If replay does not update:
- Verify file naming/path in `Scoreboard\Replay` and `Scoreboard\Replay\Playlist`.
- Verify OBS source URL is `http://127.0.0.1:8324/HTML/replay.html`.
- Verify `CSBroadcastServer.exe` is still running.

---

## Runtime wiring

### Start sequence
1. Run `launch.bat`
2. `CSBroadcastServer.exe` starts local server on `127.0.0.1:8324`
3. `CSBroadcast.exe` opens GUI
4. Closing GUI stops the server process

### OBS Browser Source URL examples
- `http://127.0.0.1:8324/HTML/scoreboard.html`
- `http://127.0.0.1:8324/HTML/team1.html`
- `http://127.0.0.1:8324/HTML/team2.html`
- `http://127.0.0.1:8324/HTML/draft.html`
- `http://127.0.0.1:8324/HTML/maps.html`
- `http://127.0.0.1:8324/HTML/standings.html`
- `http://127.0.0.1:8324/HTML/bracket.html`
- `http://127.0.0.1:8324/HTML/singlecam.html`
- `http://127.0.0.1:8324/HTML/duorow.html`
- `http://127.0.0.1:8324/HTML/triorow.html`
- `http://127.0.0.1:8324/HTML/transition.html`
- `http://127.0.0.1:8324/HTML/replay.html`
- `http://127.0.0.1:8324/HTML/startingsoon.html`
- `http://127.0.0.1:8324/HTML/berightback.html`
- `http://127.0.0.1:8324/HTML/thankyouforwatching.html`

### Export folders (written by app)
- `Scoreboard\General\*`
- `Scoreboard\Match\*`
- `Scoreboard\Maps\*`
- `Scoreboard\Waiting\*`
- `Scoreboard\Standings\*`
- `Scoreboard\Bracket\*`
- `Scoreboard\Replay\*`

Plus root state files like `autosave.json`, `match.json`, and `assets.json`.

---

## Troubleshooting

### Overlays are blank or not updating
- Ensure `CSBroadcastServer.exe` is running.
- Open `http://127.0.0.1:8324/HTML/scoreboard.html` in a browser.
- Confirm Browser Source URLs point to `127.0.0.1:8324`.
- Check firewall/security rules for localhost traffic.

### `launch.bat` says EXE is missing
Expected files:
- `CSBroadcastServer.exe` (or `CSBroadcastServer\CSBroadcastServer.exe`)
- `CSBroadcast.exe` (or `CSBroadcast\CSBroadcast.exe`)

### Port 8324 conflict
- Close the process already using port 8324.
- Relaunch with `launch.bat`.

### FACEIT import fails
- Confirm FACEIT Match page URL is set in Statistics tab.
- Confirm FACEIT API key is set.
- Confirm network access to FACEIT endpoints.

### Logos/maps not visible
- Re-select files in GUI.
- Check file paths are valid and readable.
- Verify exported files exist in `Scoreboard\General` / `Scoreboard\Maps` / `Scoreboard\Match`.

---

## License

See `LICENSE`.
