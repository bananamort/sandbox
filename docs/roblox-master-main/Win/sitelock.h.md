# sitelock.h

Source: `roblox-sandbox/Win/sitelock.h` (760 lines)

## Purpose

**Verbatim vendored Microsoft sample code** — "SiteLock 1.14", the ATL framework for restricting which sites may instantiate a "safe for scripting" ActiveX control (Copyright Microsoft Corporation, last updated July 19 2007; author Andrei Belogortseff / WinAbility Software for the underlying VistaTools-style helpers). It provides `IObjectSafetySiteLock` (an `IObjectSafety` extension carrying an Allow/Deny site list plus control-expiry metadata), the `CSiteLock<T>` helper template (`InApprovedDomain`, `ControlExpired`, URL/zone extraction), site-map macros (`BEGIN_SITELOCK_MAP`/`SITELOCK_ALLOW*`/`SITELOCK_DENY*`), and expiry plumbing that computes a kill-date from the PE image's `TimeDateStamp`.

## API (shape only — see Microsoft's sample docs)

```cpp
#define SITELOCK_VERSION 0x00010014          // 1.14
class IObjectSafetySiteLock : public IObjectSafety { struct SiteList {...}; GetCapabilities/GetApprovedSites/GetExpiryDate };
template <typename T> class CSiteLock { bool InApprovedDomain(...); bool ControlExpired(DWORD days); ... };
// Optional: SITELOCK_USE_MAP, SITELOCK_USE_IOLEOBJECT, SITELOCK_NO_EXPIRY, SITELOCK_SUPPORT_DOWNLOAD (warns: unsupported)
```

## Usage

**Dead code at baseline**: verified by tree-wide grep, NOTHING in roblox-sandbox includes sitelock.h and no Roblox-specific domain list or modification exists anywhere in the file (no "roblox" hits). It is the unmodified Microsoft sample carried in the tree as a ready-made ActiveX activation-restriction primitive.

## Gotchas

- Expiry is real by default: without `SITELOCK_NO_EXPIRY`, `ControlExpired()` compares the linked image's build timestamp against `dwControlLifespan` days — a control built with this header stops activating after its lifespan unless the macro is defined.
- Domain matching is case-sensitive after normalization, first-entry-wins ordering (deny entries must precede allow entries), and `"*.dom"` matches only children while `"=dom"` matches exactly.
