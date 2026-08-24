# Network/GamePerfMonitor.h

**Module**: Network (root) · **Type**: header (.h, 47 lines)

## Purpose

Declares `GamePerfMonitor`, the client-side performance sampling helper created by `PlayerConfigurer` for non-ticket (real game) joins: samples StatsService items into `Analytics::EphemeralCounter` reports on a timer, gated to a small percentage of users.

## API

```cpp
class GamePerfMonitor {
    GamePerfMonitor(const std::string& baseUrl, const std::string& jobId, int placeId, int userId);
    void start(DataModel*);                       // arms first sample at 60 s
    void setPostDiagStats(bool shouldPost);       // enabled 2 min after character spawn
};
```

## Usage

Constructed with BaseUrl/GameId/PlaceId/UserId in GameConfigurer (`gamePerfMonitor->start(dataModel)`), `setPostDiagStats(true)` scheduled by PlayerConfigurer 2 minutes after character resolution.

## Gotchas

- Sampling gate: `(abs(userId) % 100) < FInt::GamePerfMonitorPercentage(2)` — ~2% of users; report cadence `FInt::GamePerfMonitorReportTimer(10)` minutes.
