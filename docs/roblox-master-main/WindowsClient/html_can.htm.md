# WindowsClient/html_can.htm

## Purpose

Static fallback page shown in the embedded browser when the client "is unable to connect to the Internet" — a heading plus two troubleshooting bullets (connection present? antivirus/firewall blocking?). Consumed as a local resource by the web-browser plumbing (loaded via file:// into RbxWebView/WebBrowserAxDialog when navigation fails; exact loader call site is in the shared web/browser infrastructure — UNKNOWN within this module's sources).

## API

Plain HTML 4.0 Transitional document; no script, no external references. Body text verbatim: h2 "ROBLOX is unable to connect to the Internet", list items "Do you have an Internet connection?" / "Is anti-virus software or a firewall preventing ROBLOX from accessing the Internet?".

## Usage

Deployed next to the exe; any sandbox harness intercepting HTTP can force this page to render by refusing navigation, which is a cheap way to verify the browser host path works offline.

## Gotchas

- Filename vs purpose: "can" = *cannot* connect (not "canonical"); easy to misread.
