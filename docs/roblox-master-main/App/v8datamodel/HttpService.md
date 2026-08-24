# HttpService.cpp

## Purpose

Implements `HttpService` ("HttpService") — the user-facing HTTP + JSON service: server-script GetAsync/PostAsync behind the HttpEnabled gate with per-minute throttling, JSONDecode/JSONEncode over WebParser, UrlEncode, GenerateGUID, and a Roblox-Id place header on every outbound request.

## Key types and API

Descriptors:
- Yield funcs (Security::None — gated at runtime instead): `GetAsync(url, nocache=false) -> string`, `PostAsync(url, data, content_type=ApplicationJson, compress=false) -> string`.
- Funcs (Security::None): `JSONDecode(input) -> Variant` (throws "Can't parse JSON"), `JSONEncode(input) -> string` (accepts only ValueTable/ValueArray Variants; throws "Can't convert to JSON"), `UrlEncode(input) -> string` (Http::urlEncode), `GenerateGUID(wrapInCurlyBraces=true) -> string` (standard GUID; strips {} when false).
- Prop: HttpEnabled (BoundProp bool, STANDARD, Security::LocalUser; default FALSE).
- Enum HttpContentType {ApplicationJson, ApplicationXml, ApplicationUrlEncoded, TextPlain, TextXml} (+Variant/StringConverter templates).

Tunables: DFInt::UserHttpRequestsPerMinuteLimit(500) — throttle constructed against its address (`throttle(&DFInt::UserHttpRequestsPerMinuteLimit)`, live-updating limit).

Behavior:
- checkEverything(url,errorFunction) gates in order: empty URL → "Empty URL"; !httpEnabled → "Http requests are not enabled"; NOT backendProcessing → "Http requests can only be executed by game server"; parent not DataModel → "Unrecognized HttpService"; throttle.checkLimit() → "Number of requests exceeded limit". Passes → one-shot GA event "HttpService" tagged with placeId (boost::call_once).
- Outbound: addIdHeader sets `Roblox-Id: <placeID>` on every request. PostAsync maps content-type enum → Http constants (default case errors "Unsupported content type"); empty data coerced to single space; compress flag forwarded. GetAsync(nocache) adds Cache-Control:no-cache header AND doNotUseCachedResponse flag.
- Completion routed through DataModel::HttpHelper(resume,error).

## Usage / reflection touchpoints

Complements [HttpRbxApiService](HttpRbxApiService.md) (that one is for API-proxy paths, this for arbitrary URLs); Http from Util/Http.h; WebParser JSON codec ([Filters](../App/v8datamodel/Filters.md)-era XML/JSON utilities); Network::Players backend check.

## Gotchas

- Client scripts can never use GetAsync/PostAsync regardless of HttpEnabled — backend-only runtime gate fires first in message order ("game server").
- HttpEnabled defaults false and requires LocalUser security to flip — games must opt in via place settings.
- Throttle is a hard reject (error), no queueing unlike HttpRbxApiService.
- GA "HttpService" event fires once PER PROCESS (static once_flag) not per request.
- JSONEncode rejects scalars — top-level input must be table/array Variant; JSONDecode error is a thrown runtime_error, not an errorFunction callback (sync descriptor).
- UNKNOWN: whether DataModel::HttpHelper re-checks url safety (lives in DataModel.cpp).
