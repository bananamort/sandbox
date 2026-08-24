# util/ProgressIndicator.h

## Purpose
Minimal progress-reporting interface for long operations: implementers receive percentage updates or step ticks and signal cancellation by returning true.

## Declared API
```cpp
class IProgressIndicator {
public:
    // returns true if cancel requested.
    virtual bool setProgess(float percent) { return step(); }; // optional [note: "Progess" typo is in source]
    virtual bool step() = 0;
};
```

## Gotchas
- `step()` is pure virtual; default `setProgess` just delegates to it — override `setProgess` to use percentages.
- Return-true-means-cancel protocol: long-running code must check the return of every callback.
- Typo `setProgess` is part of the published interface.

## UNKNOWN
- Consumers (asset loading / join flows outside this slice).
