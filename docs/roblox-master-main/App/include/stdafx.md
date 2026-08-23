# App/include/stdafx.h

## Purpose

Precompiled-header style umbrella include for App-layer translation units. Aggregates STL containers, the rbx boost/threading/signal shims, task-scheduler job plumbing, core value types (`util/Name.h`, `util/Region3.h`), reflection yield machinery, and the two pillars of the datamodel (`v8tree/Instance.h`, `V8DataModel/DataModel.h`).

## Declared API

- No declarations — includes only: `<vector>`, `<map>`, `rbx/boost.hpp`, `rbx/threadsafe.h`, `rbx/signal.h`, `rbx/TaskScheduler.Job.h`, `<boost/unordered_map.hpp>`, `<boost/function.hpp>`, `util/Name.h`, `util/Region3.h`, `reflection/YieldFunction.h`, `v8tree/Instance.h`, `V8DataModel/DataModel.h`.

## Usage notes

- Listed first in .cpp files to maximize PCH reuse; any file including it transitively depends on DataModel.

## Gotchas

- Because it drags in `DataModel.h`, using stdafx.h in a lightweight TU creates heavy compile-time and circular-include hazards.
