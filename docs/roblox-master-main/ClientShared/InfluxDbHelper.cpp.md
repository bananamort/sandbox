# InfluxDbHelper.cpp

Source: `roblox-sandbox/ClientShared/InfluxDbHelper.cpp` (155 lines)

## Purpose

Implements `InfluxDb`: a minimal one-series-at-a-time builder for posting metrics to an InfluxDB 0.9-style `/db/<database>/series?u=<user>&p=<password>` endpoint as JSON. Static configuration (reporter tag, host, credentials) plus per-instance column points.

## API

```cpp
static void InfluxDb::init(const std::string& reporter, const std::string& _url,
                           const std::string& _database, const std::string& _user, const std::string& _pw);
static const std::string& getUrlHost();
static const std::string& getUrlPath();
static void setLocation(const std::string& loc);
static void setAppVersion(const std::string& ver);
static const std::string& getReportingUrl();
std::string InfluxDb::getJsonStringForPosting(const std::string& seriesName);
void InfluxDb::addPoint(const std::string& name, const rapidjson::Value& value);
```

File-scope globals: reporter/location/appVersion (tag columns), hostName/database/user/password/canSend/url/path.

## Usage

- `init` composes `path = "/db/" + database + "/series?u=" + user + "&p=" + password` and `url = hostName + path`; `canSend=true`. Credentials are embedded in the URL query string.
- `addPoint` accepts rapidjson scalars (null/bool/string/number) and rejects objects/arrays with `std::runtime_error`; numbers are re-serialized via stringstream by exact int-width type.
- `getJsonStringForPosting(seriesName)` renders `[{"name":"<series>","columns":["reporter","version","location",<points...>],"points":[[<reporter>,<version>,<location>,<values...>]]}]`.

## Gotchas

- No JSON escaping of series/reporter/location/appVersion strings when composing the document by hand — quotes inside any of them yield invalid JSON. Same for point names and for string point values (`addPoint` just wraps them in literal quotes).
- `canSend` is set but never read anywhere in this file; gating must live at call sites. Verified by tree-wide grep: NOTHING includes InfluxDbHelper.h (not even other ClientShared files) and it is absent from CMakeLists.txt's source list — this helper is dead code in the current tree. (The `InfluxDb` symbols in `App/util/Analytics.cpp` / `Game.cpp` are a same-named but unrelated `RBX::Analytics::InfluxDb` namespace.)
- Points persist across posts: nothing clears `points` after getJsonStringForPosting, so repeated posts accumulate unless the caller resets or discards the instance.
- The URL carries plaintext DB credentials — relevant for the sandbox's logging proxy design (these will appear in captured egress).
