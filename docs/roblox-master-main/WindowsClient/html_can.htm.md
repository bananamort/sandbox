# WindowsClient/html_can.htm

## Purpose

Static fallback page for the embedded browser's "ROBLOX is unable to connect to the Internet" case — a heading plus two troubleshooting bullets (connection present? antivirus/firewall blocking?). **However, this file is an ORPHAN in the current tree**: unlike `html_con.htm`, it appears nowhere else — no `WindowsClient.rc` resource entry (`IDR_HTML_CONTACTINGSERVER` maps only to html_con.htm), no `<None Include>` in WindowsClient.vcxproj, and no code reference anywhere in roblox-sandbox. Nothing loads it as-is.

## API

Plain HTML 4.0 Transitional document; no script, no external references. Body text verbatim: h2 "ROBLOX is unable to connect to the Internet", list items "Do you have an Internet connection?" / "Is anti-virus software or a firewall preventing ROBLOX from accessing the Internet?".

## Usage

No build artifact deploys it (it is not even listed in WindowsClient.vcxproj). If a harness wants this offline-fallback rendering, it must serve/deploy the file itself; wiring it into the browser path would require adding an .rc HTML resource or explicit navigation code.

## Gotchas

- Filename vs purpose: "can" = *cannot* connect (not "canonical"); easy to misread.
- Dead-asset risk: because nothing references it, pruning scripts may delete it silently; conversely, edits to it have zero runtime effect until something starts loading it.
