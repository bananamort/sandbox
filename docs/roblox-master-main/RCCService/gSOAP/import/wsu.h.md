# wsu.h

Source: `roblox-sandbox/RCCService/gSOAP/import/wsu.h` (93 lines)

## Purpose

gSOAP import stub for **WS-SecurityUtility 1.0** (OASIS, namespace `http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd`). Generated from `WS/wsu.xsd` via `wsdl2h -cegy` and hand-adjusted by Robert van Engelen so the namespace is *imported* (referenced) rather than copied into generated WSDL. It supplies the timestamp/ID vocabulary that WS-Security (`wsse.h`) signatures reference. Vendored toolchain material; not used by RCCService's WSDL.

## API

Namespace directives (lines 38–40): `wsu` schema import with elementForm qualified / attributeForm unqualified.

```cpp
enum wsu__tTimestampFault
{
	wsu__MessageExpired,	///< xs:QName value "…":MessageExpired"
};
typedef enum wsu__tTimestampFault wsu__tTimestampFault;

typedef struct _wsu__Timestamp
{	@char*	wsu__Id;	// use qualified form to enable signature
	char*	Created;
	char*	Expires;
} _wsu__Timestamp;
```

- `_wsu__Timestamp::Created` / `Expires` are plain `char*` dateTime strings; `wsu__Id` is an attribute — the header notes "use qualified form to enable signature".
- `AttributedDateTime`, `AttributedURI`, `TimestampType` complexTypes are intentionally blank typemap placeholders (lines 50–60); `_wsu__Expires`, `_wsu__Created`, `_wsu__Id` element/attribute definitions are likewise intentionally left blank.

## Usage

```
#import "wsu.h"     // typically pulled in by wsse.h flows
soapcpp2 -Iimport ...
```

## Gotchas

- The enum value comment contains a doubled quote (`value=""http://...`) — cosmetic artifact of generation.
- Blank "intentionally left blank" definitions mean soapcpp2 accepts but does not deeply type these elements; validation of Created/Expires format is the application's job.
- Not referenced by RCCService code or WSDL — dead weight unless WS-Security is ever enabled.

UNKNOWN: none beyond the above.

