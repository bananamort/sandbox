# PointsService.cpp

## Purpose

Implements `PointsService` ("PointsService"), the legacy server-side award-points API. Queues per-user point awards into a batch map flushed on heartbeat against the web endpoint (`points/award-points`, balance via `points/get-point-balance` through HttpRbxApiService), enforces a per-minute HTTP call budget, and broadcasts `PointsAwarded` to clients.

## Key types and API

Descriptors:
- `func_getPointBalance("GetPointBalance(userId):int")` — yield, **Security::None**, marked deprecated.
- `func_getPointBalanceUniverse("GetGamePointBalance(userId):int")` — yield, **Security::None**.
- `func_getAwardBalance("GetAwardablePoints():int")` — **Security::None**, deprecated; always returns INT_MAX.
- `func_awardPoints("AwardPoints(userId, amount)")` — yield returning Tuple, **Security::None**.
- `event_PointsAwarded("PointsAwarded(userId, pointsAwarded, userBalanceInGame, userTotalBalance)")` — RemoteEventDesc, **Security::None**, SCRIPTING + BROADCAST.

Tunables: DFInt PointBalanceCacheInvalidateTimeMs(1000) [declared, unused in this TU], MaxAwardPointsHttpCallsPerMinute(60), SecondsPerBatchAwardPointsCall(10); constant AWARD_POINTS_RATE_LIMIT_RESET 60.0 s.

Flow:
- Guards shared by all entry points: `canUseService()` requires ServerScriptService present with load-string DISABLED ("PointsService requires beta access" / "…loadstring to be disabled"); `backendProcessing` server-only ("not called from server script"); userId > 0; amount ≠ 0 for awards.
- `awardPoints`: accumulates amount + yield-callback list into `batchAwardPointRequests[userId]` under mutex; once-per-process starts heartbeat listening.
- `onHeartbeat`: resets call counter every 60 s; flushes when not batching or ≥10 s since last flush. Over-limit entries error "max number of calls per minute has been exceeded…" and stay batched (`batchNextAwardCalls=true` keeps heartbeat flushing).
- Flush posts via HttpRbxApiService::postAsync (TEXT_PLAIN, PRIORITY_DEFAULT); success JSON needs keys success(bool), userGameBalance, userBalance, pointsAwarded → resumes ALL queued callbacks for that user with Tuple(userId, amountAwarded, universeBalance, totalBalance), fires PointsAwarded broadcast, GA trackEvent "HasAwardedAPoint" once per process.
- Balance getters: GET `points/get-point-balance?userId=N[&placeId=M]` (placeId appended for GetGamePointBalance from DataModel placeID); response JSON key "pointBalance"; non-Windows sets Http auth domain.

## Usage / reflection touchpoints

Script-facing at Security::None but every call is runtime-gated to server context. Pairs with ServerScriptService.md, HttpRbxApiService.md consumers documented under [Network](../../Network/) replication of BROADCAST events.

## Gotchas

- GetPointBalance (no placeId) is deprecated yet GetGamePointBalance is its live replacement — same endpoint differing query param.
- GetAwardablePoints is a hardcoded INT_MAX stub — no real quota check exists despite the rate limiter on calls.
- Award batches are keyed by userId: multiple awards coalesce amounts and ALL original callbacks fire with the TOTAL awarded figure — individual amounts are indistinguishable in resume values.
- doBatchAwardPoints returns early inside catch WITHOUT clearing remaining requests — one throw abandons the whole queue's other users that round (they retry next flush).
- The over-limit branch errors each offending caller (`continue`) but leaves the entries in place until the loop ends — the final `batchAwardPointRequests.clear()` then wipes them, so those callers receive only the error (their award is silently dropped, not deferred).
- canUseService() inverted naming: returns false when SSS missing entirely too.
