# RCCService.vcxproj.filters

Source: `roblox-sandbox/RCCService/RCCService.vcxproj.filters` (302 lines)

## Purpose

Visual Studio Solution Explorer *view* mapping for `RCCService.vcxproj` — pure IDE metadata. Assigns every project item to a virtual folder ("filter"). Has zero effect on compilation; safe to regenerate or delete.

## API (structure)

Filters declared: `Source Files`, `Header Files` (+ `\gSOAP`, `\gSOAP\generated`, `\gSOAP\import`), `Resource Files`, `Libraries` (+ `\Mesa\Debug`, `\Mesa\Release`, `\Debug`, `\Release`), `Content`, `Dev Files`.

Notable assignments (mirroring the vcxproj item lists):

- Cross-folder TUs (`..\App\script\LuaVMServer.cpp`, `..\ClientShared\DataModelSerialize.cpp`, all `..\Win\*.cpp`) land in the flat "Source Files" filter.
- gSOAP runtime `stdsoap2.cpp/.h` sit under `Header Files\gSOAP`; generated `soapC.cpp`, `soapRCCServiceSoapService.cpp` and headers under `...\generated`; all 27 import headers under `...\import`.
- `Message.mc` + `MSG00001.bin` under Resource Files; `RCCService.wsdl` (CustomBuild) and tool exes under `Header Files\gSOAP`.
- Mesa DLL/PDB/LIB payload items carry **no filter assignment** — the `Libraries\Mesa\Debug`, `Libraries\Mesa\Release`, and `Libraries\Release` filters are declared but empty; only the RbxDebug pair is explicitly filed under `Libraries\Debug`.
- `Content`, `Dev Files` and the three unpopulated `Libraries` sub-filters are **declared but empty** — leftovers from removed items.

## Usage

Only Visual Studio reads this file. msbuild ignores it entirely.

## Gotchas

- Drift between this file and the .vcxproj is cosmetic only; don't chase "missing" entries here when diagnosing build issues.
- BOM at file start (line 1) is intentional VS encoding.
