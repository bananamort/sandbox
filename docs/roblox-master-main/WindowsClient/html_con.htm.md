# WindowsClient/html_con.htm

## Purpose

Minimal placeholder page displayed while the client is "Contacting the server..." — a centered light-grey body (BODY ID="CSaveToRobloxDialog") with one styled line. Serves as the initial document for web flows that will navigate to a real BaseUrl-derived page once connectivity/auth completes; the BODY id suggests it was authored for a save-to-roblox dialog flow.

## API

Plain HTML fragment (no DOCTYPE, uppercase legacy tags). Body text verbatim: "Contacting the server...".

## Usage

Paired with html_can.htm as the two local HTML assets of WindowsClient; loaded by the same browser-host plumbing.

## Gotchas

- Filename "con" collides with the DOS reserved device name CON — tools that extract/copy this tree to certain Windows filesystem contexts can choke on `html_con.htm`? No: reserved names apply to base names like `con.*`; `html_con` is safe. The real hazard is only cosmetic confusion with html_can.htm.
