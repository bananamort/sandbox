# FrameRateManager.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/FrameRateManager.h` (201 lines)

## Purpose

Declares `RBX::FrameRateManager`, the adaptive-quality controller: watches frame/render/prepare time averages and steps the quality level (0–21) up/down to hold target frame times, while exposing derived render knobs — SSAO level, GBuffer, shading distance, anisotropy, light-grid radius, particle throttle, view/render cull distances.

## API

```cpp
enum RBX::SSAOLevel { ssaoNone=0, ssaoFullBlank, ssaoFull };
struct THROTTLE_LOCKSTEP;    // opaque; table lives in .cpp

class FrameRateManager {
public:
    FrameRateManager(); ~FrameRateManager();
    void configureFrameRateManager(CRenderSettings::FrameRateManagerMode mode, bool hasCharacter);
    void setAggressivePerformance(bool);

    struct Metrics { bool AutoQuality; int QualityLevel, NumberOfSettles;
                     double AverageSwitchesPerSettle, AverageFps; };

    void AddBlockQuota(int blocksInCluster, float sqDistanceToCamera, bool isInSpatialHash);
    bool getGBufferSetting();
    SSAOLevel getSSAOLevel();
    bool isSSAOSupported();                 // inline over mSSAOSupported
    float getShadingDistance() const; float getShadingSqDistance() const;
    int getTextureAnisotropy() const;  int getPhysicsThrottling() const;
    float getLightGridRadius() const;  bool getLightingNonFixedEnabled() const;
    unsigned getLightingChunkBudget() const;

    void SubmitCurrentFrame(double frameTime, double renderTime, double prepareTime,
                            double bonusTime);
    void ThrottleTo(double rendertime_ms);   // "adjusts quality to try to fit rendering to this timespan"
    double getMetricValue(const std::string& metric);

    int GetRecomputeDistanceDelay();
    float GetViewCullSqDistance();  float GetRenderCullSqDistance();
    double GetMaxNextViewCullDistance();     // farthest possible next frame
    int GetQualityLevel();
    IsBlockCullingEnabled/SetBlockCullingEnabled (inline);

    void Configure(const RenderCaps*, CRenderSettings*);  // "special information ... formulate exceptions"
    CRenderSettings::AntialiasingMode getAntialiasingMode();
    void updateMaxSettings();               // "best possible quality ... with current settings"

    GetVisibleBlockTarget/GetVisibleBlockCounter; 
    float GetTargetFrameTimeForNextLevel() const; float GetTargetRenderTimeForNextLevel() const;
    ResetStableFramesCounter/GetStableFramesCounter (inline);
    double GetParticleThrottleFactor();      // "]0..1], 1 for full detail"
    GetRenderTimeAverage/GetPrepareTimeAverage/GetFrameTimeAverage;
    const WindowAverage<double,double>& GetRenderTimeStats/GetFrameTimeStats;
    void StartCapturingMetrics(); Metrics GetMetrics();
    PauseAutoAdjustment/ResumeAutoAdjustment;
    GetQualityDelayUp/GetQualityDelayDown/GetBackoffCounter/GetBackoffAverage;

protected:
    bool mSSAOSupported, mAdjustmentOn, mBlockCullingEnabled, mAggressivePerformance,
         mThrottlingOn, mWasQualityUp;
    CRenderSettings* mSettings; const RenderCaps* mRenderCaps;   // borrowed ptrs
    int mStableFramesCounter, mCurrentQualityLevel;
    unsigned mQualityCount[QualityLevelMax];
    int mQualityDelayUp, mQualityDelayDown, mRecomputeDistanceDelay, mSwitchCounter;
private:
    float mSqDistance, mSqRenderDistance;
    UpdateStats / AdjustQuality / StepQuality(direction,isBackOff) /
        UpdateQualitySettings / SendQualityLevelStats / GetAvarageQuality [sic] /
        GetTargetFrameTime(level)
    WindowAverage ×5: frameTimeAverage, renderTimeAverage, prepareTimeAverage,
        frameTimeVarianceAverage, fastBackoffAverage
    int mBadBackoffFrameCounter; Metrics mMetrics;
    Timer<Time::Fast> mSettleTimer; bool mIsStable, mIsGatheringDistance;
    int mBlockCounter, mBlockTarget, mLastBlockCounter;
    class AvgFpsCounter { Update(deltaMs) skips ≥1000ms frames; GetFPS() = harmonic mean }; 
    AvgFpsCounter mFPSCounter;
    THROTTLE_LOCKSTEP* LockstepTable;
};
```

## Usage

Includes boost ublas vector (with 4996 warning push/pop), RunningAverage, RenderSettings. Instantiated by VisualEngine; per-frame SubmitCurrentFrame drives AdjustQuality.

## Gotchas
- `mSettings`/`mRenderCaps` are non-owning pointers set in Configure — lifetime managed elsewhere.
- `GetAvarageQuality` misspelling is the real symbol name.
- AvgFpsCounter ignores frames ≥1000 ms (loading hitches excluded from FPS average).
- LockstepTable raw pointer to static-ish THROTTLE_LOCKSTEP data — implementation detail in the 743-line cpp.
