# INDEX — RCC Service (RCCService)

Documentation for every text source under `roblox-sandbox/RCCService/` — the headless Windows service ("Roblox Compute Cloud Service") that exposes a SOAP job API used by Roblox's web tier to rent compute nodes: open a job (optionally seeding it with a Lua script), execute scripts inside it, renew/close leases, and query diagnostics. One `.md` per source file, mirrored paths.

## Module purpose (lifecycle)

A request's life crosses four layers. **Contract**: `gSOAP/RCCService.wsdl` declares 18 document/literal operations (`OpenJob`, `Execute`, `BatchJob`, lease management, `Diag`) plus the `Job`/`ScriptExecution`/`LuaValue` data model, in twin SOAP 1.1/1.2 bindings. **Generation**: `generate.bat` runs the vendored toolchain (`wsdl2h.exe` 1.2.10 → `generated/prototypes.h`; `soapcpp2.exe` 2.7.10 `-x -i -S` → `soapStub.h` types, `soapH.h` prototypes, `soapC.cpp` serializers, per-binding server classes, nsmaps); `stdsoap2.{h,cpp}` is the runtime engine those call into, and `import/*.h` is its schema stub library. **Server wiring**: process entry `_tmain` (`RCCService.cpp`) installs the Windows service / console modes, then runs an accept loop on port 64989: `bind` → poll `accept` (timeout 1 s so stop requests land) → `copy()` the soap context per connection → NT thread pool calls `serve()`, whose `dispatch()` matches the body tag to one of 18 virtual operations. **Implementation**: `RCCServiceSoapServiceImpl.cpp` overrides those virtuals and drives the engine's DataModel/job/script machinery (`ThumbnailGenerator.cpp`, `OperationalSecurity.cpp`, `DummyWindow.cpp`, settings/resource/message-support files round out the host). Results return as typed `LuaValue` arrays; faults are raised through the runtime's version-aware fault accessors.

## Roster

### Process & service host

| File | Doc | Lines | Role |
| --- | --- | --- | --- |
| `RCCService.cpp` | [doc](RCCService.cpp.md) | 785 | `_tmain` flags, SCM lifecycle, accept loop, backpressure tripwire |
| `RCCServiceSoapServiceImpl.cpp` | [doc](RCCServiceSoapServiceImpl.cpp.md) | — | Implements all 18 SOAP operations against the engine |
| `ThumbnailGenerator.cpp` / `thumbnailgenerator.h` | [cpp](ThumbnailGenerator.cpp.md) / [h](thumbnailgenerator.h.md) | — | Job-scoped thumbnail rendering |
| `OperationalSecurity.cpp` / `.h` | [cpp](OperationalSecurity.cpp.md) / [h](OperationalSecurity.h.md) | — | Lua read-only lockdown pairing |
| `DummyWindow.cpp` / `.h` | [cpp](DummyWindow.cpp.md) / [h](DummyWindow.h.md) | — | Message-pump window host |
| `stdafx.cpp` / `stdafx.h` | [cpp](stdafx.cpp.md) / [h](stdafx.h.md) | — | Precompiled header |
| `scoped_array.hpp` | [doc](scoped_array.hpp.md) | — | Minimal RAII array guard |

### Build, config, resources

| File | Doc |
| --- | --- |
| `RCCService.vcxproj` / `.filters` / `RCCService.sln` | [vcxproj](RCCService.vcxproj.md) · [filters](RCCService.vcxproj.filters.md) · [sln](RCCService.sln.md) |
| `AppSettings.xml`, `gameserver.txt`, `ReadMe.txt` | [xml](AppSettings.xml.md) · [txt](gameserver.txt.md) · [readme](ReadMe.txt.md) |
| `resource.h`, `Message.mc`, `RCCService.rc` | [h](resource.h.md) · [mc](Message.mc.md) · [rc](RCCService.rc.md) |

### gSOAP toolchain root

| File | Doc | Role |
| --- | --- | --- |
| `RCCService.wsdl` | [doc](gSOAP/RCCService.wsdl.md) | Service contract: 18 ops, Job/ScriptExecution/LuaValue types |
| `generate.bat` | [doc](gSOAP/generate.bat.md) | wsdl2h + soapcpp2 regeneration recipe |
| `stdsoap2.h` / `stdsoap2.cpp` | [h](gSOAP/stdsoap2.h.md) / [cpp](gSOAP/stdsoap2.cpp.md) | gSOAP 2.7.10 runtime engine |
| `soapcpp2.exe`, `wsdl2h.exe` | *(binary tools — no doc)* | Compiler front-ends |
| `import/README.txt` | [doc](gSOAP/import/README.txt.md) | Catalog of the import set (older than the set itself) |

### gSOAP import stubs (`gSOAP/import/`)

Schema-vocabulary headers consumed via `#import`; none referenced by RCCService's own WSDL except transitively (`stlvector.h`).

| File | Doc | Namespace / purpose |
| --- | --- | --- |
| `stlvector.h` `stllist.h` `stldeque.h` `stlset.h` `stl.h` | [vector](gSOAP/import/stlvector.h.md) · [list](gSOAP/import/stllist.h.md) · [deque](gSOAP/import/stldeque.h.md) · [set](gSOAP/import/stlset.h.md) · [umbrella](gSOAP/import/stl.h.md) | STL container serializers |
| `soap12.h` | [doc](gSOAP/import/soap12.h.md) | SOAP 1.2 envelope/encoding namespaces |
| `wsa.h` `wsa3.h` `wsa4.h` `wsa5.h` | [04/08](gSOAP/import/wsa.h.md) · [03/03](gSOAP/import/wsa3.h.md) · [04/03](gSOAP/import/wsa4.h.md) · [05/03](gSOAP/import/wsa5.h.md) | WS-Addressing revisions |
| `wsse.h` `wsse2.h` `wsu.h` | [wsse](gSOAP/import/wsse.h.md) · [wsse2](gSOAP/import/wsse2.h.md) · [wsu](gSOAP/import/wsu.h.md) | WS-Security + utility timestamps |
| `ds.h` `ds2.h` `c14n.h` | [ds](gSOAP/import/ds.h.md) · [ds2](gSOAP/import/ds2.h.md) · [c14n](gSOAP/import/c14n.h.md) | XML-DSIG signatures (+ single-line clone) + exc-c14n |
| `wsp.h` `wsrp.h` | [wsp](gSOAP/import/wsp.h.md) · [wsrp](gSOAP/import/wsrp.h.md) | WS-Policy, WS-Routing (legacy) |
| `dom.h` | [doc](gSOAP/import/dom.h.md) | Level-2 DOM parser interface (impl not vendored) |
| `xml.h` `xop.h` `xmime.h` `xmime4.h` `xmime5.h` `xmlmime.h` `xmlmime5.h` `xlink.h` | [xml](gSOAP/import/xml.h.md) · [xop](gSOAP/import/xop.h.md) · [xmime](gSOAP/import/xmime.h.md) · [xmime4](gSOAP/import/xmime4.h.md) · [xmime5](gSOAP/import/xmime5.h.md) · [xmlmime](gSOAP/import/xmlmime.h.md) · [xmlmime5](gSOAP/import/xmlmime5.h.md) · [xlink](gSOAP/import/xlink.h.md) | Literal XML, MTOM/XOP, MIME-typing revisions (two deprecated), XLink |

### Generated bindings (`gSOAP/generated/`)

Regenerated wholesale by generate.bat — never hand-edit.

| File | Doc | Role |
| --- | --- | --- |
| `prototypes.h` | [doc](gSOAP/generated/prototypes.h.md) | wsdl2h output (2018-02-23) — soapcpp2 input spec |
| `soapStub.h` | [doc](gSOAP/generated/soapStub.h.md) | All C++ types: LuaType enum, data classes, message classes, wrappers, envelope structs |
| `soapH.h` | [doc](gSOAP/generated/soapH.h.md) | Serializer prototypes + dispatch/instantiate declarations |
| `soapC.cpp` | [doc](gSOAP/generated/soapC.cpp.md) | Serializer implementations (15k lines) |
| `soapRCCServiceSoapService.h/.cpp` | [h](gSOAP/generated/soapRCCServiceSoapService.h.md) · [cpp](gSOAP/generated/soapRCCServiceSoapService.cpp.md) | SOAP 1.1 server class (used) |
| `soapRCCServiceSoap12Service.h/.cpp` | [h](gSOAP/generated/soapRCCServiceSoap12Service.h.md) · [cpp](gSOAP/generated/soapRCCServiceSoap12Service.cpp.md) | SOAP 1.2 twin (not in the vcxproj — compiled out, unused) |
| `RCCServiceSoap.nsmap` / `RCCServiceSoap12.nsmap` | [11](gSOAP/generated/RCCServiceSoap.nsmap.md) · [12](gSOAP/generated/RCCServiceSoap12.nsmap.md) | Identical namespace tables (wildcard rows cover both bindings) |

### Binaries (no documentation)

`soapcpp2.exe`, `wsdl2h.exe` (toolchain), `MSG00001.bin` (compiled event-log messages from `Message.mc`), `icon1.ico`.

REMAINING: none — coverage is 1:1 for all 62 text sources.
