# util/RobloxGoogleAnalytics.h

## Purpose
Studio's Google Analytics singleton (2013): posts events via the Measurement Protocol v1 (`http://www.google-analytics.com/collect`) asynchronously; sampling "lottery" init, category macros, user/place ids, experiment variations, and a per-track signal. Sibling of the `Analytics.h` GoogleAnalytics namespace (similar surface, Studio-oriented, with thread-schedule sizing).

## Declared API
```cpp
// Categories:
#define GA_CATEGORY_GAME "Game"
#define GA_CATEGORY_ACTION "Action"
#define GA_CATEGORY_ERROR "Error"
#define GA_CATEGORY_STUDIO "Studio"
#define GA_CATEGORY_COUNTERS "Counters"
#define GA_CATEGORY_RIBBONBAR "RibbonBar"
#define GA_CATEGORY_SECURITY "Security"
#define GA_CATEGORY_STUDIO_SETTINGS "StudioSettings"
// timing variables:
#define GA_CLIENT_START "ClientStartTime"

namespace RobloxGoogleAnalytics {
    static const std::string kGoogleAnalyticsBaseURL = "http://www.google-analytics.com/collect";

    // lottery-based init: calls setCanUseAnalytics + init:
    void lotteryInit(const std::string& accountPropertyID, size_t maxThreadScheduleSize,
                     int lotteryThreshold, const char* productName = NULL,
                     int robloxAnalyticsLottery = -1, const std::string& sessionKey = "sessionID=");

    // Must be called before using the singleton:
    void init(const std::string& accountPropertyID, size_t maxThreadScheduleSize,
              const char* productName = NULL);

    bool isInitialized();
    bool getCanUseAnalytics();
    void setCanUseAnalytics();

    void setUserID(int userID);
    void setPlaceID(int placeID);

    // Signal sent on each call to track an analytic:
    rbx::signal<void()>& analyticTrackedSignal();

    void setExperimentVariation(const std::string& name, int value);

    void trackEvent(const char* category, const char* action = "custom",
                    const char* label = "none", int value = 0, bool sync = false);
    void trackEventWithoutThrottling(/* same defaults */);
    void trackUserTiming(const char* category, const char* variable, int milliseconds,
                         const char* label = "none", bool sync = false);
    void sendEventRoblox(const char* category, const char* action = "custom",
                         const char* label = "none", int value = 0, bool sync = false);

    const std::string& getSessionId();
}
```

## Gotchas
- All events post asynchronously ("calls to track data should return immediately"); `sync=true` presumably blocks.
- `init` must precede any tracking; `lotteryInit` samples clients by threshold before initializing.
- Base URL is plain http in this vintage.
- `maxThreadScheduleSize` threads into the async dispatch pool — differs from Analytics.h's API.
- Category strings are macros — beware macro collisions in TUs including this header.

## UNKNOWN
- Throttle policy for trackEvent vs trackEventWithoutThrottling (.cpp-side).
