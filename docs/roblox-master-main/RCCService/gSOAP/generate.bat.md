# generate.bat

Source: `roblox-sandbox/RCCService/gSOAP/generate.bat` (1 line)

## Purpose

The two-command build recipe that regenerates the entire `gSOAP/generated/` binding tree from `RCCService.wsdl`. It is the bridge between the service contract (WSDL) and the compiled server code (`RCCServiceSoapServiceImpl.cpp` implements the generated class).

## API

Not applicable — a Windows batch script with two tool invocations:

```
wsdl2h -o generated/prototypes.h RCCService.wsdl
soapcpp2 -x -i -S -Iimport -dgenerated generated/prototypes.h
```

Step 1 — `wsdl2h`: translates `RCCService.wsdl` into the gSOAP header spec `generated/prototypes.h`.

Step 2 — `soapcpp2` flags:
- `-x` — do not generate sample XML message files (.xml request/response samples).
- `-i` — generate SOAP 1.1 **and** 1.2 service classes as C++ (produces the `soapRCCServiceSoapService.*` / `soapRCCServiceSoap12Service.*` pairs).
- `-S` — **server-side** code only (no client stubs) — consistent with RCCService being a pure server.
- `-Iimport` — import search path pointing at this directory's `import/` folder.
- `-dgenerated` — output directory for generated sources.

## Usage

Run from the `gSOAP/` directory on Windows (both `wsdl2h.exe` and `soapcpp2.exe` sit here):

```
cd gSOAP && generate.bat
```

## Gotchas

- The script assumes both .exe tools are on PATH or resolvable from the current directory.
- Regeneration overwrites everything in `generated/`; hand edits there (e.g. to dispatch logic in the service class files) would be lost unless made in `RCCServiceSoapServiceImpl.cpp`, which is outside `generated/`.
- No `-w` flag: WSDL is not re-exported; no `-t` typemap customization is applied.

UNKNOWN: exact gSOAP tool version invoked at the time the checked-in generated files were produced (tools are binaries; license headers suggest ~2005-era 2.7 line).

