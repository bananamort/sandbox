# App/include/v8datamodel/PointsService.h

## Purpose

`PointsService` — INTERNAL creatable service for the legacy player-points economy: async point-balance queries, rate-limited awarding with request batching (per-minute cap, heartbeat-driven flush), a `pointsAwardedSignal` remote signal, and manual batch/reset entry points.

## Declared API

`class PointsService : public DescribedCreatable<PointsService, Instance, sPointsService, Reflection::ClassDescriptor::INTERNAL>, public Service`

- Typedefs: `AwardPointYieldFunction = pair<fn(void(shared_ptr<const Reflection::Tuple>)), fn(void(std::string))>`; `AwardPointYieldFunctions = vector<...>`; `PointRequestValue = pair<int, AwardPointYieldFunctions>`; `PointRequestMap = boost::unordered_map<int, PointRequestValue>`.
- Signals: `rbx::remote_signal<void(int userId, int amount, int userBalanceInUniverse, int userBalance)> pointsAwardedSignal`.
- Public queries: `getUserPointBalanceInUniverse(int userId, resume(int), error(std::string))`, `getUserPointBalance(int userId, resume(int), error(...))`, `int getAwardableBalance()`.
- Awarding: `void awardPoints(int userId, int amount, resume(shared_ptr<const Tuple>), error(std::string))`, `void firePointsAwardedSignal(int userId, int amount, int userBalanceInUniverse, int userBalance)`, `bool doBatchAwardPoints()`, `void resetPointAwardCount()`, `void listenToHeartbeat()`.
- Private: heartbeat connection; `boost::mutex batchAwardPointsMutex`; `PointRequestMap batchAwardPointRequests`; counters `numOfAwardPointCallsLastMinute`, `timeSinceLastMaxAwardPointReset`, `timeSinceLastAwardPointCall`, `shouldBatchAwardPoints`; `bool isAtAwardPointsLimit()`; `onHeartbeat(const Heartbeat&)`; `static void startAwardPointsBatching(weak_ptr<RBX::DataModel> weakDm)`; `onServiceProvider` override; `bool canUseService()`; `internalGetPointBalance(int userId, int placeId, shared_ptr<std::string> methodName, shared_ptr<std::string> keyToReturn, resume(int), error(std::string))`.

## Gotchas

- Rate limiting is real: isAtAwardPointsLimit + per-minute counter + batching mutex — awardPoints during throttle windows queues callbacks into batchAwardPointRequests keyed by userId.
- startAwardPointsBatching holds the DataModel by weak_ptr — service outliving the DataModel must not resurrect it.
- Balance queries pass placeId + method-name/key strings via shared_ptr<std::string> — HTTP plumbing detail leaked into the signature.

## UNKNOWN

- The actual web endpoints and awardable-balance source (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PointsService.md](../../v8datamodel/PointsService.md).
- Sibling economy surface: [MarketplaceService.md](MarketplaceService.md); DataModel plumbing: [DataModel.md](DataModel.md).
