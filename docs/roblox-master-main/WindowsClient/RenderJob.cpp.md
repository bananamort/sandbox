# WindowsClient/RenderJob.cpp

## Purpose

Render-loop implementation. `stepDataModelJob` is invoked by the engine TaskScheduler each cycle; it takes a DataModel write lock, runs `dm->renderStep(...)`, and marshals `ViewBase::renderPrepare/renderPerform` onto the view's thread via FunctionMarshaller, synchronizing with two ATL events. Also hosts release-only anti-cheat probes (speedhack/debugger detection → server-side kick stats "richard"/"suzanne") and the IMetric reporting used by the stats panel (F9).

## API

Real signatures:

- `RenderJob::RenderJob(View* robloxView, FunctionMarshaller* marshaller, boost::shared_ptr<DataModel> dataModel)` — forwards min/max frame rate from `CRenderSettingsItem::singleton()` to `BaseRenderJob`; zeroes `stopped`; both events created non-signaled (`CEvent prepareBeginEvent(false)`).
- `void RenderJob::stop()` — `stopped = 1` only; the job returns `TaskScheduler::Done` on its next step.
- `Time::Interval RenderJob::timeSinceLastRender() const` — `Time::now<Time::Fast>() - lastRenderTime`.
- `Time::Interval RenderJob::sleepTime(const Stats& stats)` — standard throttle when awake (`computeStandardSleepTime(stats, maxFrameRate)`), else `Interval::max()` (sleep forever until woken).
- `TaskScheduler::StepResult RenderJob::stepDataModelJob(const Stats& stats)` — the per-frame body:
  1. No DataModel or `stopped` ⇒ `TaskScheduler::Done`.
  2. Security block (`#if !LOVE_ALL_ACCESS && !RBX_STUDIO_BUILD && !_NOOPT && !DEBUG`, wrapped in `VMProtectBeginMutation("34")`): `Time::isSpeedCheater()` ⇒ submit `reportHacker(dm,"richard")`; `Time::isDebugged()` ⇒ `reportHacker(dm,"suzanne")` — both as DataModel Write tasks.
  3. Two loop variants selected by `FFlag::RenderLowLatencyLoop`:
     - **Low-latency path**: `DataModel::scoped_write_request`; record renderDelta; `lastRenderTime = now`; `isAwake=false`; `marshaller->Submit(bind(&scheduleRender, weak_from(this), view, timeJobStart))`; `view->updateVR()`; `dm->renderStep(renderDelta)`; then `prepareBeginEvent.Set(); prepareEndEvent.Wait();` (handshake: render thread may proceed, this thread waits for prepare completion).
     - **Legacy path**: write-lock scope does `updateVR()`, `dm->renderStep(frameStats-derived seconds)`, `isAwake=false`, and a *synchronous* `marshaller->Execute(renderPrepare)`; after releasing the lock, `marshaller->Submit(scheduleRenderPerform)` performs renderPerform async.
  4. Returns `TaskScheduler::Stepped`.
- `static void scheduleRender(weak_ptr<RenderJob> selfWeak, ViewBase* view, double timeJobStart)` — runs on the view thread: waits `prepareBeginEvent`, calls `view->renderPrepare(self.get())`, sets `prepareEndEvent`, then `view->renderPerform(timeJobStart)`, then `self->wake()`.
- `static void scheduleRenderPerform(const weak_ptr<RenderJob>& selfWeak, ViewBase* view, double timeJobStart)` — legacy-path counterpart: `renderPerform` + `wake()` only (prepare already done synchronously).
- `std::string RenderJob::getMetric(const std::string& metric) const` — string metrics: "Graphics Mode" (enum name of latched mode), "Render" ("%.1f/s %d%%" from averageStepsPerSecond/dutyCycle), "FRM" (block culling On/Off), "Anti-Aliasing". Unknown key ⇒ RBXASSERT(0), "?".
- `double RenderJob::getMetricValue(const std::string& metric) const` — numeric metrics: "Render Duty", "Render FPS", "Render Job Time", "Render Nominal FPS" (1000/GetRenderTimeAverage()), plus pass-throughs to ViewBase ("Delta Between Renders", "Total Render", "Present Time", "GPU Delay") and `SystemUtil::getVideoMemory()` for "Video Memory". Unknown key ⇒ RBXASSERT(0), 0.0.

### File-local helpers

- `static void remoteCheatHelper(boost::weak_ptr<DataModel>)` — locks DM and calls `Network::getSystemUrlLocal(dataModel.get())`; comment: "this will send special item to server and server will kick user off". **Never referenced anywhere in the file** — dead function kept for its side-effect documentation value.
- `static void reportHacker(boost::weak_ptr<DataModel> weakDataModel, const char* stat)` — resolves local Player and calls `player->reportStat(stat)` (server decides kick).

## Usage

Owned by View for exactly one game session: created in `View::initializeJobs`, scheduled in `resetScheduler`, drained in `RemoveJobs` (which also flushes any pending marshalled renderPerform before reset). The weak_from(this) pattern keeps marshalled callbacks safe if the job dies between Submit and execution.

## Gotchas

- The security probes run EVERY step in release clients — speedhack detection keys off Time::Fast vs wall clock drift; a debugger attach trips `isDebugged`. Sandbox instrumentation that slows or debugs the process will trip these unless neutered first (this file is therefore on the graft-critical list).
- `stopped` never resets; RenderJob instances are single-session.
- Metric names are exact strings consumed by the stats UI — renaming breaks F9 output silently.
- `remoteCheatHelper` dead code suggests the kick path moved into reportHacker/server stat handling.
- Legacy path holds the DataModel write lock across renderPrepare (Execute = synchronous); low-latency path shortens the overlap using events instead.
