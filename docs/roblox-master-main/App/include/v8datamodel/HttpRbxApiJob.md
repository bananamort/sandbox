# App/include/v8datamodel/HttpRbxApiJob.h

## Purpose

Header-only DataModelJob that drives the [HttpRbxApiService](HttpRbxApiService.md) request pump each scheduler step: refreshes its Hz from a DFInt, refills throttle budgets, executes throttled and retry-queued API requests.

## Declared API

`class HttpRbxApiJob : public DataModelJob`

- Setting: `DYNAMIC_FASTINTVARIABLE(HttpRbxApiJobFrequencyInSeconds, 1)` at file scope.
- Ctor: `HttpRbxApiJob(HttpRbxApiService* owner)` — registers as a **Write** TaskType job named "HttpRbxApiJob", not per-player, 0.01 s step budget, arbiter from `DataModel::get(owner)`.
- `void updateHz()` — desiredHz = 1/DFInt.
- Overrides: `sleepTime(stats)` / `error(stats)` via standard compute helpers; `stepDataModelJob(stats)` — re-reads DFInt (auto-tunes when changed), calls `apiService->addThrottlingBudgets(DFInt/60.0f)`, `executeThrottledRequests()`, `executeRetryRequests()`, returns Stepped.
- Members: `shared_ptr<HttpRbxApiService> apiService; int lastJobFrequency; double desiredHz;`

## Gotchas

- A *Write*-class job runs every ~1 s by default — it contends with game-write jobs for the DataModel lock.
- Budget refill is tied to job frequency: lowering the DFInt also slows budget accrual.

## UNKNOWN

- No implementation doc exists at time of writing; behavior is fully visible in this header (no .cpp sibling).

## Cross-links

- Pump target: [HttpRbxApiService.md](../../v8datamodel/HttpRbxApiService.md); job base [DataModelJob.md](DataModelJob.md).
