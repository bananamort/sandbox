# ReadMe.txt

Source: `roblox-sandbox/RCCService/ReadMe.txt` (19 lines)

## Purpose

Three-line-per-topic orientation note for the folder, written by the original developers. Documents exactly three things:

## Content (verbatim summary)

1. **generate.bat** — "Creates the files in the 'generated' folder based on RCCService.wsdl. Since these files change rarely, the generated files are checked into source control." → confirms `gSOAP/generated/*` is regenerated only when the WSDL changes, then committed.
2. **RCCService.cpp** — "Windows-specific code for implementing a Windows Service".
3. **RCCServiceSoapServiceImpl.cpp** — "Implements the Web Service methods".

## Usage

Read-only historical documentation; nothing references it at build time.

## Gotchas

- It does not cover ThumbnailGenerator, DummyWindow, OperationalSecurity, or the gSOAP import tree — treat as incomplete.
- Confirms the intended workflow for regenerating SOAP bindings (see `gSOAP/generate.bat.md`).
