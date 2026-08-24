# App/include/v8datamodel/HttpService.h

## Purpose

`HttpService` Instance (PERSISTENT_HIDDEN) — the script-facing HTTP utility: JSON encode/decode, URL encoding, GUID generation, and user-level async GET/POST gated by the `HttpEnabled` property.

## Declared API

`class HttpService : public DescribedCreatable<HttpService, Instance, sHttpService, Reflection::ClassDescriptor::PERSISTENT_HIDDEN>, public Service`

- `enum HttpContentType { APPLICATION_JSON=0, APPLICATION_XML=1, APPLICATION_URLENCODED=2, TEXT_PLAIN=3, TEXT_XML=4 };`
- User HTTP: `void userHttpGetAsync(std::string url, bool noCache, resume(str), error(str));` `void userHttpPostAsync(std::string url, std::string data, HttpContentType content, bool compress, resume, error);`
- Utilities: `Reflection::Variant decodeJSON(std::string input); std::string encodeJSON(Reflection::Variant obj); std::string urlEncode(std::string data); std::string generateGuid(bool wrapInCurlyBraces);`
- Gate: private `bool httpEnabled;` + `static BoundProp<bool> prop_httpEnabled;` validation `bool checkEverything(std::string& url, errorFunction)`; header injection `void addIdHeader(Http& request);`
- Throttle: member `ThrottlingHelper throttle;`

## Gotchas

- The whole surface is subject to `HttpEnabled` (off by default in games historically) — checkEverything enforces it plus URL rules.
- This is the general-purpose service; Roblox-API traffic goes through [HttpRbxApiService](HttpRbxApiService.md).

## UNKNOWN

- Which ID header addIdHeader injects (.cpp — see [HttpService.md](../../v8datamodel/HttpService.md)).

## Cross-links

- Implementation: [App/v8datamodel/HttpService.md](../../v8datamodel/HttpService.md).
- Kin: [HttpRbxApiService.md](HttpRbxApiService.md), [ContentProvider.md](ContentProvider.md).
