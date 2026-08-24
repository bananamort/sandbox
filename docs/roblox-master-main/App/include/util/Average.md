# util/Average.h

## Purpose
Fixed-size ring-buffer average: keeps N prior samples in a `std::vector<T>` and computes the mean on demand. Header comment: "can average 512 prior values using only 9 floats for storage" (i.e., O(1) memory, O(N) compute).

## Declared API
```cpp
template<typename T>
class Average {
public:
    Average(size_t samples, T initValue);      // pre-fills history so early means are stable
    void sample(T value, bool advanceBuffer = true);
    T getAverage() const;                      // sums all slots / samples
    size_t size() const;
    const T& getValue(size_t index) const;     // raw slot access (ring order)
    void resetValues(const T& value);
    void resetValues(size_t samplesNew, const T& value); // resize + refill
private:
    size_t samples, tag;
    std::vector<T> history;
};
```

## Gotchas
- `getAverage()` divides by `static_cast<float>(samples)` — for integral `T` the result is truncated to integer type after float division.
- Pre-filling with `initValue` means the first reads are averages of init values, not of fewer samples — different from a "warm-up" windowed average.
- `sample(value, advanceBuffer=false)` overwrites the current slot without advancing the tag (repeated overwrite pattern).
- No bounds checking on `getValue(index)`.
- Distinct from `RunningAverage.h` / `ExponentialRunningAverage.h`, which are incremental estimators.

## UNKNOWN
- Primary call sites (likely perf counters; not visible from this slice).
