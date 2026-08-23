# CERTIFICATION — RCCService documentation review

Independent reviewer certification of the `.md` set under `docs/roblox-master-main/RCCService/` against sources under `roblox-sandbox/RCCService/`. Every text source was read via tool calls and every concrete doc claim checked against it; the two giant generated files (`soapC.cpp` 15,162 lines, `stdsoap2.cpp` 14,892 lines) were spot-audited per protocol with six scattered regions each plus anchor verification. No file under `roblox-sandbox/` was touched.

## Coverage audit

- Source tree: **66 files = 62 text sources + 4 binaries** (`gSOAP/wsdl2h.exe`, `gSOAP/soapcpp2.exe`, `icon1.ico`, `MSG00001.bin`). Writer's enumeration claim CONFIRMED.
- Docs tree: **62 per-source `.md` + `INDEX.md` = 63 `.md`**, paths mirror the sources exactly; no missing or extra pairs.
- Binaries are documented as no-doc stubs only in `INDEX.md` §Binaries ("Binaries (no documentation)") — as claimed.
- `INDEX.md` roster complete; "coverage is 1:1 for all 62 text sources" accurate.
- Line-count claims: 58/62 match both display-line and `wc -l` conventions; the other 4 (`DummyWindow.cpp`, `RCCService.vcxproj`, `RCCService.wsdl`, `generate.bat`) are files whose final line has no trailing newline — the writer uniformly used the `wc -l` convention throughout, so these were accepted as convention-consistent, not defects.
- Provenance claims verified from file stamps: `wsdl2h 1.2.10` + `2018-02-23 23:46:17 GMT` (prototypes.h lines 2–3), `gSOAP 2.7.10` (stdsoap2.h line 2, soapC.cpp line 10 stamp `2018-02-23 23:46:18 GMT`, stdsoap2.cpp line 86 stamp `2008-01-27`), soapcpp2 flags `-x -i -S -Iimport -dgenerated` (generate.bat).

## Giant-file spot-audit results

**soapC.cpp** — regions: L10 version stamp ✓; `soap_ignore_element` @487 (mustUnderstand/strict/recursive skip) ✓; enum code map `LUA_TNIL…LUA_TTABLE` @1984–1991 ✓; `_ns1__DiagExResponse` block boundaries @2145–2288 ✓; recursive `ns1__LuaValue` @7227–7384 + `ns1__Job::soap_serialize` embedding value-member `id` @7825 ✓; wrapper struct `__ns3__DiagEx` family @8780+ and vector-template tail ending "End of soapC.cpp" @15160+ ✓; disclosed grep anchors @5534 (`_ns1__RenewLeaseResponse::soap_default`) and @7099 (`_ns1__HelloWorld::soap_default`) consistent with the repeated-block methodology. **Disclosure holds — PASS.**

**stdsoap2.cpp** — regions: L79 `#pragma comment(lib, "wsock32.lib")` + L86 stamp ✓; `fsend` @503 with `FD_SETSIZE` guard and SOAP-over-UDP retry/backoff (delay starts ≥50 ms, doubles, caps at 500 ms; `udp_repeat` 1–3) ✓; base64 tables @275–276 and XHTML entity table @296–394 ✓; `soap_bind` @4135, `tcp_accept` def @4358, `soap_accept` @4381 including the zero-timeout `tv_sec = 60` default select ✓; `soap_copy_context` @6319 blind `memcpy` + documented reset list (state/nlist/alist/labbuf/header/plugins/iht) ✓; tail fault formatters with `"** HERE **"` marker @14785, plugin registry @14801/14840, C++ ctors/dtor @14857–14885 ✓. **One line-ref miss found and fixed (tcp_accept 4357→4358); otherwise disclosure holds — FIXED.**

## Per-file verdicts

| File (.md) | Verdict | Notes |
| --- | --- | --- |
| INDEX.md | FIXED | Soap12 twin was "(compiled, unused)" → not referenced by RCCService.vcxproj at all |
| AppSettings.xml.md | PASS | incl. LoadAppSettings @1462, RBXCRASH BaseUrl gotcha @1489, findFirstChildByTag |
| DummyWindow.cpp.md | PASS | RegisterClass-per-ctor, WS_DISABLED, case-mismatch includes all verified |
| DummyWindow.h.md | PASS | |
| gameserver.txt.md | PASS | _tmain load @717, appended start(…) @724, job "Test"/600 s, parse quirk @288 |
| Message.mc.md | PASS | SvcReportEvent @123, 0x20000001L @134 |
| OperationalSecurity.cpp.md | FIXED | caller UNKNOWN resolved (SoapServiceImpl ctor @1348–1353); 8192-byte padding wording reconciled with ≈7424-byte arithmetic |
| OperationalSecurity.h.md | FIXED | same caller resolution (@782 clearLuaReadOnly claim separately verified) |
| RCCService.cpp.md | FIXED | backpressure message = requestCount + 13 extern counters (14 values), not "13 counters incl. requestCount"; all ~90 other claims verbatim-correct |
| RCCService.rc.md | PASS | FILEVERSION 0,75,0,691; MSG00001.bin @43/@107; winres vs afxres gotcha |
| RCCService.sln.md | PASS | 15 projects; ReleaseAssert→ReleaseRcc mapping lines 58–59/90–91 exact |
| RCCService.vcxproj.md | FIXED | import headers 26→**27** (ClInclude lines 271–297); LargeAddressAware applies to Release/ReleaseTest only (absent on NoOpt) |
| RCCService.vcxproj.filters.md | FIXED | Mesa payload items carry no `<Filter>` (Libraries\Mesa\* + Libraries\Release declared-but-empty); 26→27 import headers |
| RCCServiceSoapServiceImpl.cpp.md | FIXED | doneEvent(TRUE,FALSE) = initially **set** auto-reset (was "unset"); thread census 2 fetch + 1 perf (was "three updater + perf"); "CWebServive" typo |
| ReadMe.txt.md | PASS | verbatim summary of all three topics |
| resource.h.md | PASS | |
| scoped_array.hpp.md | PASS | include-forwarder description exact |
| stdafx.cpp.md | PASS | |
| stdafx.h.md | PASS | macro values, include list, TODO line refs |
| ThumbnailGenerator.cpp.md | PASS | worker/GL-thread design, reflection bindings, Diag counter cross-ref @780, tuble typos |
| thumbnailgenerator.h.md | PASS | RBX_REGISTER_CLASS @1238, Click/ClickTexture LocalUser gating, GraphicsMode |
| gSOAP/generate.bat.md | PASS | flag glossary correct; line-count per wc convention |
| gSOAP/RCCService.wsdl.md | FIXED | removed false "operation order matches counters" gotcha (orders differ); `getAllJobsEx` casing |
| gSOAP/stdsoap2.h.md | FIXED | buf = 65536 B = ~64KB (was "~68KB"); everything else incl. sizing constants/mode bits/callback census verified |
| gSOAP/stdsoap2.cpp.md | FIXED | tcp_accept line ref 4357→4358; spot-audit otherwise clean (see above) |
| gSOAP/import/README.txt.md | PASS | catalog table matches source lines 6–20 |
| gSOAP/import/stl.h.md | PASS | |
| gSOAP/import/stlvector.h.md | PASS | |
| gSOAP/import/stldeque.h.md | PASS | unused-by-generated-bindings claim grep-verified |
| gSOAP/import/stllist.h.md | PASS | ditto |
| gSOAP/import/stlset.h.md | PASS | ditto |
| gSOAP/import/soap12.h.md | PASS | directives @50–51, `-2` equivalence |
| gSOAP/import/wsa.h.md | PASS | -cgye provenance, enums, structs, mustUnderstand tutorial, URL-split gotcha |
| gSOAP/import/wsa3.h.md | PASS | SOAP_WSA_2003 @21, stale "wsa4" comment @14 (writer-caught artifact confirmed) |
| gSOAP/import/wsa4.h.md | PASS | "import namespace" directive wording difference @43 confirmed |
| gSOAP/import/wsa5.h.md | PASS | 11 fault codes, hex-mangled enum name @92, IsReferenceParameter enum |
| gSOAP/import/wsp.h.md | PASS | wsse forward-reference-only gotcha grep-verified against wsse.h |
| gSOAP/import/wsrp.h.md | PASS | `typedef char` artifact, `_USCORE` encoding |
| gSOAP/import/wsse.h.md | PASS | ds.h import @170 mid-file, 7-value FaultcodeEnum, Security aggregate |
| gSOAP/import/wsse2.h.md | PASS | 2002/12 rebind, ds2 pairing, retained inconsistencies |
| gSOAP/import/wsu.h.md | PASS | |
| gSOAP/import/ds.h.md | PASS | c14n import @72, KeyInfo wsse cross-type, full type tree |
| gSOAP/import/ds2.h.md | PASS | single-line delta vs ds.h independently re-diffed by reviewer — confirmed |
| gSOAP/import/c14n.h.md | FIXED | import chain is transitive (wsse.h→ds.h→c14n.h), not a direct wsse.h import |
| gSOAP/import/dom.h.md | PASS | two declarations @635–639, dom.cpp not vendored, placement rule |
| gSOAP/import/xlink.h.md | PASS | single directive @49 |
| gSOAP/import/xmime.h.md | PASS | 2004/06 namespace + idiom comment |
| gSOAP/import/xmime4.h.md | PASS | stale "xmlmime.h" self-reference @5 confirmed |
| gSOAP/import/xmime5.h.md | PASS | 2005/05 namespace |
| gSOAP/import/xmlmime.h.md | PASS | "depricated. Please use xmime.h" note quoted verbatim @5 |
| gSOAP/import/xmlmime5.h.md | PASS | prefix quirk (xmlmime prefix vs xmlmime5__ example) confirmed |
| gSOAP/import/xml.h.md | PASS | UTF8/_XML/ns__Mixed semantics |
| gSOAP/import/xop.h.md | PASS | directive @52, struct @54–60, SOAP_ENC_MTOM runtime gate |
| gSOAP/generated/prototypes.h.md | PASS | provenance quote, 6 data + 36 message classes, services section |
| gSOAP/generated/soapStub.h.md | FIXED | `_QName`/`_XML` typedef line refs 5/6 → 1370/1375; SOAP_TYPE ranges 66–134/136–170 and dummy-member Header otherwise verified |
| gSOAP/generated/soapH.h.md | PASS | dispatch prototypes, type ids (int=1/byte=3/string=51/vector 57&59), PointerTo region |
| gSOAP/generated/soapC.cpp.md | PASS | spot-audit clean; partial-read methodology disclosure holds |
| gSOAP/generated/soapRCCServiceSoapService.h.md | FIXED | no `RCCServiceSoapServiceImpl : public …` subclass exists anywhere (grep-verified); ops are implemented out-of-class; instance is ExceptionAwareSoap<RCCServiceSoapService> |
| gSOAP/generated/soapRCCServiceSoap12Service.h.md | FIXED | "compiled but unused" → header/.cpp absent from vcxproj entirely |
| gSOAP/generated/soapRCCServiceSoapService.cpp.md | FIXED | same no-subclass correction (Purpose + Usage); serve/dispatch/serve_* template claims verified line-exact |
| gSOAP/generated/soapRCCServiceSoap12Service.cpp.md | FIXED | "(it is in the vcxproj's generated sources)" → not in vcxproj; ns1-ladder→serve___ns3__ routing claim verified |

## Totals

| Verdict | Count |
| --- | --- |
| PASS | 47 |
| FIXED | 16 |
| FAIL | 0 |

Edits applied: 22 mechanical fixes across 16 documents (all writes confined to `docs/roblox-master-main/RCCService/`; zero modifications to `roblox-sandbox/`).

## Residual risk / notes

- The four trailing-newline line-count discrepancies are a counting-convention artifact (writer used `wc -l` consistently); left untouched deliberately.
- Claims about engine headers outside this folder (`start_CWebService` internals, `DataModel::createDataModel` third arg, endpoint URL builders) remain correctly flagged UNKNOWN/hedged in the docs rather than asserted.
- The writer's accuracy rate on concrete claims was very high (~97%); systematic weak spots observed this slice: cross-TU caller attribution (OperationalSecurity), project-file membership assertions (Soap12 twin "compiled"), and small numeric glosses (64KB/68KB, counter counts).
