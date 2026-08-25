# App/include/solver/SolverSerializer.h

## Purpose

Frame-accurate binary recorder of solver state for offline replay/debugging. Buffers each frame's constraints, body forces, computed impulses, and body caches into a `DebugSerializer`, flushing to `%TEMP%/ROBLOX/SolverLog_Client<userId>.bin` when a 10 MB buffer fills or recording toggles off.

## Declared API

- `class SolverSerializer`
  - `SolverSerializer()` — starts disabled with no file open.
  - `void update(bool enabled, int userId, boost::uint64_t debugTime)` — toggle handler + per-frame header write; on first enable opens the temp-dir file and writes `userId`; every recorded frame writes a monotonically increasing `static boost::uint64_t frame` then `debugTime`. Flushes buffer to disk on overflow (>10 MB) or on disable, then closes.
  - `void serializeConstraints(const ArrayBase<Constraint*>& connectors)` — tag `"Connectors"`, uint32 count, then per constraint `(uint8)getType()` followed by the constraint's own `operator&`.
  - `void serializeForces(const ArrayBase<SimBody*>& simBodies, boost::uint32_t total)` — tag `"Forces"`, total count, force/torque/impulse/rotational impulse (`getRotationallmpulse()`) per SimBody; pads remaining entries up to `total` with zero vectors.
  - `void serializeComputedImpulse(const ArrayBase<ConstraintVariables>& velocityStage, const ArrayBase<ConstraintVariables>& positionStage)` — two float arrays of `.impulse` values.
  - `template<class Cache> void serializeBodyCache(const Cache&)` — uint32 size, then per entry `getGuidIndex()` of `it.second.simBodyDebug->getBody()` plus the cache payload.
  - `template<class T> SolverSerializer& operator&(const T&)` — passthrough into `DebugSerializer` (no-op unless recording); array overload casts `ArrayDynamic<T>` → `ArrayBase<T>` first.
  - `SolverSerializer& tag(const char* name)`.
  - Public members: `std::ofstream myFile; bool fileOpened; bool enabled; DebugSerializer debugSerializer;`.

## Gotchas

- Whole file is inert without `ENABLE_SOLVER_DEBUG_SERIALIZER` (defined in [SolverConfig.md](SolverConfig.md)) — but note `serializeConstraints` etc. only guard on `enabled`, not the macro; their bodies still reference `DebugSerializer` methods that must exist regardless.
- The frame counter is a function-local `static` inside `update` — shared across all SolverSerializer instances and never reset.
- Buffer flush threshold uses `static size_t bufferSize = 10 * 1024 * 1024;` inside `update`; reserve is bufferSize+1MB.
- `serializeForces` iterates `simBodies.size()` then zero-fills up to `total` — if callers pass `total < simBodies.size()`, nothing is dropped: all `simBodies.size()` bodies are still written while the count prefix declares only `total`, so a parser consuming exactly `total` entries desyncs on the next tag.
- Typo is API surface: `getRotationallmpulse` (double-l / l-vs-I), see [v8kernel/SimBody.h](../v8kernel/SimBody.md).
- Output path depends on `boost::filesystem::temp_directory_path()` and embeds userId — one file per user id per machine. Opening uses `std::ios::out | std::ios::binary` with **no** `std::ios::app`, so every fresh open **truncates** any pre-existing log: restarting the process (or toggling off→close→on again in one run) discards previously written frames rather than appending.
