# util/Analytics.h

## Purpose
Client analytics façade with three backends: generic user/place context setters, `EphemeralCounter` (in-memory counters), `GoogleAnalytics` (event/timing tracking with sampling lottery), and `InfluxDb` (points built from rapidjson values, reported to a resource endpoint). Gated by DFFlag `InfluxDb09Enabled`.

## Declared API
```cpp
DYNAMIC_FASTFLAG(InfluxDb09Enabled)

namespace RBX::Analytics {
    void setUserId(int id);
    void setPlaceId(int id);
    void setAppVersion(const std::string& version);
    void setLocation(const std::string& loc);
    void setReporter(const std::string& rep);

namespace EphemeralCounter {
    void reportStats(const std::string& category, float value, bool blocking = false);
    void reportCountersCSV(const std::string& counterNamesCSV, bool blocking = false);
    void reportCounter(const std::string& counterName, int amount, bool blocking = false);
}

namespace GoogleAnalytics {
    void lotteryInit(const std::string& accountPropertyID, int lotteryThreshold,
                     const std::string& productName = "", int robloxAnalyticsLottery = -1,
                     const std::string& sessionKey = "sessionID="); // setCanUseAnalytics + init by lottery
    void init(const std::string& accountPropertyID, const std::string& productName = ""); // before singleton use
    bool getCanUse();
    void setCanUse();
    void sendEventRoblox(const char* category, const char* action = "custom",
                         const char* label = "none", int value = 0, bool sync = false);
    void trackEvent(const char* category, const char* action = "custom",
                    const char* label = "none", int value = 0, bool sync = false);
    void trackEventWithoutThrottling(/* same defaults as trackEvent */);
    void trackUserTiming(const char* category, const char* variable, int milliseconds,
                         const char* label = "none", bool sync = false);
    const std::string& getSessionId();
}

namespace InfluxDb {
    struct Point {
        std::string name;   // point name
        std::string json;   // serialized scalar value
        Point(const std::string& name_, const rapidjson::Value& value); // throws on object/array/unknown
        bool operator==(const Point& other) const { return this->name == other.name; }
    };
    std::size_t hash_value(const Point& p);

    void init();
    void reportPoints(const std::string& resource, const boost::unordered_set<Point>& points,
                      int throttleHundredthsPercentage, bool blocking = false,
                      const std::string& userIdOverride = "");
    void reportPointsV2(/* identical signature */);

    class Points {   // RAII batch collector
    public:
        void setUserIdOverride(const int id);
        void addPoint(const std::string& name, const rapidjson::Value& value, bool override = false);
        void report(const std::string& resource, int throttleHundredthsPercentage, bool blocking = false);
        const boost::unordered_set<Point>& getPoints();
    };
}
}
```

## Gotchas
- `Point` equality/hash is **name-only**: two points with the same name but different values collide in the unordered_set. `Points::addPoint(..., override=true)` exploits this to replace an existing entry (erase + insert).
- `Point` ctor throws `std::runtime_error` for rapidjson objects/arrays and unknown number types — only scalars are valid.
- Under `InfluxDb09Enabled`: string values get double-quote escaping and integer values get an `i` suffix (line-protocol v0.9 conventions).
- `GoogleAnalytics::init` must be called before using that singleton; `lotteryInit` samples clients via `lotteryThreshold` / `robloxAnalyticsLottery`.
- `blocking=true` variants synchronously hit the network path — avoid on hot threads.
- Throttling applies to `trackEvent` (use `trackEventWithoutThrottling` deliberately).

## UNKNOWN
- Implementation .cpp location (not under App/include — likely App/util or V8Lib side).
- Endpoint construction for InfluxDb `resource` strings.
