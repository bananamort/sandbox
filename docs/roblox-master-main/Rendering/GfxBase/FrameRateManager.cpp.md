# FrameRateManager.cpp

Source: `roblox-sandbox/Rendering/GfxBase/FrameRateManager.cpp` (743 lines)

## Purpose

Full implementation of the adaptive-quality controller: two 22-row lockstep tables (60 FPS desktop / 30 FPS mobile) mapping quality level → {target framerate, cull distance, block budget, shading distance, anisotropy, SSAO, light-grid params, physics throttle, StepHill}, plus the hysteresis state machine that steps levels up/down from rolling time averages.

## API

### Settings / FastLog
- `LOGGROUP(FRM)`; `FFlag::DebugSSAOForce(false)`; `FInt::FRMRecomputeDistanceFrameDelay(100)`; `FInt::RenderGBufferMinQLvl(20)` (comment "14 for later").

### Tweakable constants (all static)
AveragingFrames=40, VarianceFrames=20, LockStepDelayDown=100, LockStepDelayUp=150, RenderFraction=0.625, VarianceLimit=5, MultiCoreRenderBottleneckFraction=0.8, MultiCorePrepareFraction=0.3, SwitchCounterMax=10, SettleDelay=20ms, FastBackoffMaxFrameLen=60 (40 mobile), FastBackoffFPSAve=10, FastBackoffWatchingFrames=5, SqDistanceBump=50.

### THROTTLE_LOCKSTEP (row struct)
`framerate, distance, blockCount, shadingDistance, textureAnisotropy, ssao, lightGridRadius, lightAllowNonFixed, lightChunkBudget, throttlingFactor` (comment: matches World.cpp physics table 0/8..15/16), `StepHill, MaxStepHill`.

- `kLockstepTable60FPS[22]` — L0 Studio (max framerate, dist 100000); L1–19 ramp cull distance 200→100000 & blockCount 500→100000; **L20 = ssaoFullBlank with big StepHill 6**, L21 = ssaoFull (StepHill 2). Level-0 comment notes "scpAlways is a hack to enable shadowing in Ogre".
- `kLockstepTable30FPS[22]` — same shape, flatter framerate targets (35 ms ≈ 28 FPS for most rows), bigger SSAO hills (14/2).

### Key methods
- ctor — asserts QualityLevelMax == ARRAYSIZE of both tables ("you probably added another quality level without syncing"); picks 30FPS table on iOS/Android else 60FPS; inits mSqDistance from L0; asserts AveragingFrames+VarianceFrames ≤ LockStepDelayDown.
- `configureFrameRateManager(mode, hasCharacter)` — hasCharacter: block-culling ON unless FRM Off; no character: ON only when mode==On.
- `getAntialiasingMode()` — Auto resolves to **AntialiasingOff** (caps query commented out).
- `updateMaxSettings()` — mSSAOSupported = caps->getSupportsGBuffer().
- dtor → `SendQualityLevelStats()` — GA trackUserTiming "GraphicsQualityLevel", avgQuality×1000 (1 level == 1 s), skipped under ≤100 samples.
- `GetTargetFrameTime(level)` — aggressivePerformance pins 19 ms else table.
- `AddBlockQuota(blocksInCluster, sqDist, isInSpatialHash)` — accumulates until mBlockTarget; spatial-hash clusters give valid increasing-distance cutoff (+SqDistanceBump), non-hash fall back to level distance.
- `SubmitCurrentFrame(frameTime, renderTime, prepareTime, bonusTime)` — updateMaxSettings; UpdateStats; carry last gather into mSqRenderDistance; if FRM enabled: countdown recompute delay then one UNLOCKED gathering frame at L0 distance; first-call init picks auto (clamped [1,max−1]) or fixed level; later calls re-sync manual level changes and AdjustQuality; FRM disabled path pins editQualityLevel.
- `UpdateStats` — ignores near-zero times; samples 4 averages + FPS counter; halves all mQualityCount at UINT_MAX−1.
- `AdjustQuality(frameTime, renderTime, adjustmentOn, bonusTime)` — decrement delays; subtract bonusTime from stats; FAST-BACKOFF: fast avg > 60 ms while prev-level target < 60 for 5 frames → forced StepQuality(down, backoff) below level 2 guard (`mCurrentQualityLevel > 1`); bail while either delay > 0 or frame variance > 5; render-limited test uses RenderFraction single-core / 0.8 multi-core (TaskScheduler thread count); step DOWN needs over target AND render-limited at level>1; step UP needs under next-level target AND render room (multi-core also prepare < next target ×0.3); settle detection after 20 ms stable timer.
- `StepQuality(stepUp, isBackOff)` — ±1 level, clears averages, resets delays (down constant; up = LockStepDelayUp × mSwitchCounter when stepping down), oscillation damping raises StepHill of the abandoned level (backoff adds only +0.1) up to MaxStepHill, pushes level via `mSettings->setAutoQualityLevel`, resets settle timer.
- `GetMetrics()` — copies + fills AutoQuality, rounded average quality, live FPS, switches/settle normalization.
- `UpdateQualitySettings()` — sets mBlockTarget from row (or L0's 1,000,000 when FRM off), re-arms gathering at L0 distance.
- `getMetricValue(metric)` — string keys: "FRM", "FRM Target", "FRM Visible", "FRM Distance", "FRM Quality", "FRM Auto Quality", "FRM Switch Counter", "FRM Step Hill" (−1 unless auto), "FRM Adjust Delay Up/Down", "FRM Variance", "FRM Backoff Counter/Average"; unknown −1.
- Accessors — shading/shadingSq distance, physicsThrottling, anisotropy, lightGridRadius, lightingNonFixed, chunkBudget all read current row. `GetMaxNextViewCullDistance` = sqrt(mSqDistance)×1.1. `getSSAOLevel`: DebugSSAOForce→ssaoFull; unsupported→ssaoNone; else row.
- `GetParticleThrottleFactor()` — L0 → 1.0; else clamp(quality/22, 0..1) (NOTE: divides by QualityLevelMax=22, so max reachable is ~0.95 at L21).
- `getGBufferSetting()` — mobile false; else isSSAOSupported && quality ≥ FInt::RenderGBufferMinQLvl(20).

## Usage

Driven once per frame by VisualEngine via SubmitCurrentFrame; renderers poll getSSAOLevel/getGBufferSetting/cull distances; physics reads throttling factor.

## Gotchas
- StepQuality MUTATES the static lockstep tables' StepHill at runtime — shared global state, never reset except bounded by MaxStepHill.
- `mQualityDelayUp` initialized to LockStepDelayDown (=100), not LockStepDelayUp (150) — looks intentional-ish but suspicious; do not "fix" casually.
- Fast-backoff check indexes `LockstepTable[mCurrentQualityLevel-1]` BEFORE the level>1 guard in the same condition — safe only due to short-circuit order... actually the guard is in the SECOND clause, so level 0 would index −1 if the first clause were true; in practice FastBackoffMaxFrameLen > GetTargetFrameTime(-1) is UB territory. Flagged as latent hazard.
- Particle throttle never reaches 1.0 except at level 0 (divides by 22 not 21).
- GA reporting requires >100 accumulated frames.
