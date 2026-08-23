# rbx/Countable.h

## Purpose
Live-instance counter mix-in: `RBX::Diagnostics::Countable<T>` keeps a static `rbx::atomic<int>` incremented per construction and decremented per destruction of any T-derived object; `getCount()` reports the current live count for diagnostics.

## API
```cpp
namespace RBX { namespace Diagnostics {
template<typename T> class RBXBaseClass Countable {
    static rbx::atomic<int> count;
public:
    static long getCount();
protected:
    Countable();  // ++count
    ~Countable(); // --count
};
}}
```

## Usage
Inherit privately/protected in classes whose population you want observable (leak detection, telemetry).

## Gotchas
- Counter is per most-derived instantiation of `Countable<T>` — diamond/multi-inheritance can double-count if inherited via two paths.
- Atomic increments make concurrent construction safe, but getCount() is a snapshot.
