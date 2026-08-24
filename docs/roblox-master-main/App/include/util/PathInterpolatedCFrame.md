# util/PathInterpolatedCFrame.h

## Purpose
Network-smoothing interpolator for a part's CFrame: keeps a short circular history (8 frames) of server-sent CFrames with remote timestamps, tracks the local↔remote clock offset and average sample interval, and computes smoothly interpolated (lerp or Hermite-spline) poses at render time. Also has debug path rendering + analytics.

## Declared API
```cpp
#define NUM_MAX_HISTORY 8
#define NUM_BUFFER_NODES 2

class PathInterpolatedCFrame {
public:
    PathInterpolatedCFrame();
    ~PathInterpolatedCFrame();

    void clearHistory();

    // timeStamp = when value was set; if from network, time it was SENT by the server:
    void setValue(PartInstance* part, const CoordinateFrame& value, const Velocity& vel,
                  const RemoteTime& timeStamp, Time now, float localTimeOffest /*[sic]*/,
                  int numNodesAhead);

    void setTargetDelay(float value);          // interpolation buffer delay in seconds

    void setUiStepId(int id);   int getUiStepId() const;
    double getLocalToRemoteTimeOffset();       // subtract from local time to get remote time

    void setRenderedFrame(const CoordinateFrame& value);
    void setRenderedFrame(const CoordinateFrame& value, const RemoteTime& remoteTime);

    CoordinateFrame computeValue(PartInstance* part, const Time& t);
    CoordinateFrame getLastComputedValue() const;

    bool isBeingMovedByInterpolator() const;

    Color3 getSampleIntervalColor() const;     // debug/analytics visualization
    float getSampleInterval() const;
    void renderPath(Adorn* adorn);
private:
    struct FrameInfo {
        CoordinateFrame coordinateFrame;
        Velocity velocity;
        RemoteTime remoteTime;                 // in sender's time scale
        FrameInfo();
        FrameInfo(const CoordinateFrame& cf, const Velocity& vel, const Time& local, const RemoteTime& remote);
            // NOTE: ctor takes `local` but does not store it!
    };
    FrameInfo prevFrame, lastStartFrame;
    bool beingMoved;
    int uiStepId;
    double localToRemoteTimeOffset;
    RunningAverage<> avgInterval;
    Time prevStepTime;
    boost::circular_buffer_space_optimized<FrameInfo> frameInfos;
    float targetDelayInSeconds;
    int targetFrame;
    double lastTargetDelayValue, targetDelayDeltaMax;   // analytics

    const CoordinateFrame& recordAndReturn(...);
    const CoordinateFrame& recordAndReturnHermite(...);
    const CoordinateFrame& interpolate(const Time& now, const Time& targetTime,
                                       const unsigned int& upper, const PartInstance* part = NULL);
    const CoordinateFrame& interpolateHermiteSpline(/* same args */);
    RemoteTime computeSampleTargetTime(const Time& now);
};
```

## Gotchas
- Two clocks are in play: local `Time` vs sender's `RemoteTime`; `localToRemoteTimeOffset` bridges them — mixing them up yields jumps.
- `FrameInfo`'s 4-arg ctor ignores its `local` parameter (dead parameter in header) — only remoteTime is stored.
- Hermite mode remembers `lastStartFrame` for spline continuity; plain mode doesn't. Which is used depends on internal state (.cpp-side).
- History is tiny (8 entries): bursts of network updates overwrite old samples.
- `beingMoved` flips true whenever the interpolator writes a pose; external code uses it to detect "don't fight the interpolator".
- Header misspells `localTimeOffest` in setValue signature.

## UNKNOWN
- Exact Hermite tangents source (Velocity usage) and adaptive target-delay policy (.cpp outside App/include).
