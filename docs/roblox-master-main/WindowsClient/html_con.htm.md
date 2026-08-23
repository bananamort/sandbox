# WindowsClient/html_con.htm

## Purpose

Minimal placeholder page displayed while the client is "Contacting the server..." — a centered light-grey body (BODY ID="CSaveToRobloxDialog") with one styled line. Serves as the initial document for web flows that will navigate to a real BaseUrl-derived page once connectivity/auth completes; the BODY id suggests it was authored for a save-to-roblox dialog flow.

## API

Plain HTML fragment (no DOCTYPE, uppercase legacy tags). Body text verbatim: "Contacting the server...".

## Usage

The only one of the two HTML assets actually wired into the build: `WindowsClient.rc:143` maps it to HTML resource `IDR_HTML_CONTACTINGSERVER` (ID 114 in resource.h), so it compiles into the exe as a Win32 HTML resource. `html_can.htm` has NO such wiring (orphan — see its doc).

## Gotchas

- Filename "con" invites confusion with the DOS reserved device name CON, but reserved names apply only to bare base names like `con.*`; `html_con.*` is safe on Windows filesystems. The practical hazard is merely mix-ups with the similarly named (and unwired) html_can.htm.
