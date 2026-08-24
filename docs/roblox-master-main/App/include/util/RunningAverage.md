# util/RunningAverage.h

## Purpose
`RunningAverageState`: maintains a smoothed (position + quaternion) running average of a body's center-of-mass CFrame, with a radius-scaled tolerance test — used to detect when motion has settled ("steps to sleep").

## Declared API
```cpp
class RunningAverageState {
public:
    RunningAverageState();                 // uninitialized position/angles until reset()

    static int stepsToSleep();             // number of good steps to sleep
    void reset(const CoordinateFrame& cofm);
    void update(const CoordinateFrame& cofm, float radius);
    bool withinTolerance(const CoordinateFrame& cofm, float radius, float tolerance);
private:
    Vector3    position;
    Quaternion angles;
    static float weight();                 // % of prior average to use
};
```

## Gotchas
- Default ctor leaves state uninitialized — call `reset(cofm)` before `update`.
- `radius` scales the tolerance: bigger bodies get proportionally larger deadzones.
- EMA weight is fixed via private static `weight()` (.cpp constant; UNKNOWN value).
- Quaternion averaging here is linear blending (see Quaternion.md caveats about magnitude/normalize).

## UNKNOWN
- Exact tolerance formula and sleep-count policy values (.cpp-side).
- Relationship to rbx/RunningAverage.h (different header included by PathInterpolatedCFrame).
