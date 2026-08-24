# util/ExponentialRunningAverage.h

## Purpose
Exponentially-weighted running averages (EMA): scalar (`floatERA`) and per-component Vector3 (`Vector3ERA`) flavors. Each new sample nudges the average by `weight * (value - avg)`; default weight 0.5.

## Declared API
```cpp
class floatERA {   // "ToDo - templatize this" per header
public:
    floatERA();                 // weight = 0.5f, avg = 0
    floatERA(float weight);
    void reset();               // avg = 0
    float pushAndGetAverage(float value);  // avg = avg + weight*(value-avg)
    float getAverage();
private:
    float weight, avg;
};

class Vector3ERA {
public:
    Vector3ERA();               // weight = 0.5f, avg = zero vector
    Vector3ERA(float weight);
    void reset(const Vector3& value);
    void reset();               // reset to Vector3::zero()
    void push(const Vector3& value);           // component-wise EMA update
    const Vector3& getAverage();
private:
    float weight;
    Vector3 avg;
};
```

## Gotchas
- Default `reset()` sets the average to **zero**, not to the first sample — early readings are biased toward zero unless you seed via ctor-time usage patterns or (Vector3) `reset(value)`.
- Weight semantics: larger weight = faster adaptation, less smoothing. No validation on weight.
- `getAverage()` is non-const in both classes.
- Distinct from `RunningAverage.h` (windowed/other scheme) and `Average.h` (ring buffer).

## UNKNOWN
- Primary consumers (camera smoothing / stats likely; outside this slice).
