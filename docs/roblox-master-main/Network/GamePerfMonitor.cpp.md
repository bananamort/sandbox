# Network/GamePerfMonitor.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 130 lines)

## Purpose

Implements the sampling loop: `collectAndPostStats` self-reschedules via TimerService at `FInt::GamePerfMonitorReportTimer*60` seconds; `postDiagStats` (only when armed) pulls `ClientDataPing`, `ClientPing`, `ClientPacketLossPercent_<os>` from StatsService→Network→(child 1), `ClientPhysicsFPS`/`ClientPhysicsEnvSpeed` from Workspace stats, and `ClientFPS[_<os>]` from the FrameRateManager (whose shared_ptr is retained past RenderView shutdown) into EphemeralCounters. `onGameClose` reports final FPS on DataModel close.

## API

```cpp
FASTINT GamePerfMonitorPercentage = 2; FASTINT GamePerfMonitorReportTimer = 10; // minutes
void collectAndPostStats(weak_ptr<DataModel>);
void postDiagStats(shared_ptr<DataModel>);
void onGameClose(weak_ptr<DataModel>);
void start(DataModel*);   // setJobsExtendedStatsWindow(30)
```

## Usage

See header. No direct HTTP — everything flows through `Analytics::EphemeralCounter::reportStats`.

## Gotchas

- Reads assume StatsService layout: "Network" child 1 holds per-replicator items with children named exactly "Data Ping"/"Ping"/"MaxPacketLoss"; silent no-op otherwise.
- `baseUrl/jobId/placeId/userId` members are stored but never used in this TU.
