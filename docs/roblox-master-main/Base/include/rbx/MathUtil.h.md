# MathUtil.h

## Purpose
Statistical outlier detection helpers used by performance measurement code: given a sample average/stddev, decide whether a new value is an outlier at a chosen confidence level, and compute confidence intervals.

## API
```cpp
namespace RBX {
enum Confidence { C90, C95, C99, C99p9, ConfidenceMax };

double IsValueOutlier(double value, unsigned count, double average, double std, Confidence conf);

void GetConfidenceInterval(double average, double variance, Confidence conf,
                           double* minV, double* maxV);
}
```

## Usage
Implemented in rbx/MathUtil.cpp. Natural callers are the profiler/timing utilities that discard noisy samples.

## Gotchas
- `IsValueOutlier` takes std(standard deviation) while `GetConfidenceInterval` takes variance — inconsistent units across the pair; passing the wrong one silently produces wrong answers.
- `ConfidenceMax` is a sentinel count, not a valid level.
