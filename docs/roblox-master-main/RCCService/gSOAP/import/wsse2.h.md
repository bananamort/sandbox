# wsse2.h

Source: `roblox-sandbox/RCCService/gSOAP/import/wsse2.h` (200 lines)

## Purpose

Legacy-namespace clone of `wsse.h`: per its own header comment it was **"Copied from wsse.h"** with prefix `wsse__` → `wsse2__` and the namespace rebound to the pre-OASIS draft **`http://schemas.xmlsoap.org/ws/2002/12/secext`**. It exists purely so specs written against the 2002/12 WS-Security draft keep compiling. Vendored toolchain material; not used by RCCService.

## API

Identical shape to `wsse.h`, all identifiers renamed:

- `#import "wsu.h"` (line 28), `#import "ds2.h"` (line 172 — the ds2 (draft-signature) variant rather than ds.h).
- Directives (36–38): prefix `wsse2`, qualified elements, unqualified attributes.
- Enum: `wsse2__FaultcodeEnum` — same 7 fault codes as wsse.h (97–108).
- Structs (all with `wsse2__` prefixes): `_wsse2__UsernameToken` (113–119), `_wsse2__BinarySecurityToken` (124–129), `_wsse2__Reference` (134–137), `_wsse2__Embedded` (142–146), `_wsse2__KeyIdentifier` (151–156), `_wsse2__SecurityTokenReference` (161–167), `_wsse2__Security` (173–180, still referencing `struct _wsu__Timestamp*` and **`ds__SignatureType`** un-prefixed), `_wsse2__Password` (188–191). Same blank placeholders as wsse.h.

## Usage

```
#import "wsse2.h"   // only for legacy 2002/12 secext peers
soapcpp2 -Iimport ...
```

## Gotchas

- Copy-paste inconsistencies retained from wsse.h: doc comments still cite the 2004/01 OASIS namespace while the directive binds 2002/12; trailing end-marker still says "End of wsse.h"; and `_wsse2__Security::ds__Signature` uses the `ds` (not `ds2`) type name even though the import pulls in `ds2.h`.
- Mixing wsse.h and wsse2.h in one spec would double-declare the shared `wsu` types only once (fine) but produce two Security header element names.

UNKNOWN: none beyond the above.

