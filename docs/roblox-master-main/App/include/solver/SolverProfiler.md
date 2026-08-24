# App/include/solver/SolverProfiler.h

## Purpose

Trivial averaging stopwatch used to profile solver phases. Accumulates wall time across N samples then prints the average through `StandardOut`. Entirely compiled out unless `ENABLE_SOLVER_PROFILER` is defined.

## Declared API

- `class SolverProfiler`
  - `SolverProfiler(int samples, const char* format)` — ctor stores sample count and printf format string; zeroes accumulator.
  - `void start()` / `void end()` — bracket a timing window with `Time::now(Time::Precise)`; `end()` adds the interval and increments the sample count.
  - `void printStats()` — when `currentSamples >= maxSamples`, prints `format` with average msec (`accumulator.msec() / maxSamples`) via `StandardOut::singleton()->printf(MESSAGE_OUTPUT, ...)`, resets accumulator and count.

## Gotchas

- All three methods have empty bodies without `ENABLE_SOLVER_PROFILER` — zero cost in release, but also zero data if you enable profiling late (the macro must be set at build time for every TU).
- `printStats` reads a function-local `static bool enable = true;` that nothing ever sets to false — dead kill-switch left in.
- Division by `maxSamples` uses the ctor value; passing 0 divides by zero once samples accrue.

## UNKNOWN

- Which solver call sites instantiate this class (search lives in solver .cpps outside App/include).
