# InfluxDbHelper.h

Source: `roblox-sandbox/ClientShared/InfluxDbHelper.h` (29 lines)

## Purpose

Declares `InfluxDb`, the helper for shipping client metrics to an InfluxDB time-series endpoint (see InfluxDbHelper.cpp). Pulls in the vendored rapidjson headers for its `addPoint(const std::string&, const rapidjson::Value&)` interface.

## API

```cpp
class InfluxDb
{
    typedef std::map<std::string, std::string> PointList;
    PointList points;   // column name -> pre-rendered JSON value text
public:
    static void init(const std::string& reporter, const std::string& _url,
                     const std::string& _database, const std::string& _user, const std::string& _pw);
    static const std::string& getUrlHost();
    static void setLocation(const std::string& loc);
    static void setAppVersion(const std::string& ver);
    static const std::string& getUrlPath();
    static const std::string& getReportingUrl();
    std::string getJsonStringForPosting(const std::string& seriesName);
    void addPoint(const std::string& name, const rapidjson::Value& value);
};
```

## Usage

Callers build a `rapidjson::Document`, then addPoint each field and POST `getJsonStringForPosting("<series>")` to `getReportingUrl()`. Includes `rapidjson/document.h`, `writer.h`, `stringbuffer.h` from the vendored copy in this directory.

## Gotchas

- Static config + instance points: one process-wide endpoint, many point sets.
- The writer/stringbuffer includes are unused by the header itself — kept for callers' convenience.
- Dead code in this tree: verified by tree-wide grep, nothing includes InfluxDbHelper.h (and it is not in CMakeLists.txt's source list), so the usage pattern above is aspirational — there are currently no callers at all.
