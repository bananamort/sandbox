# RunningAverage.h

## Purpose
Header-only statistics toolkit behind all scheduler/diagnostic metrics: exponentially-lerped RunningAverage (+variance), windowed WindowAverage with t-test outlier rejection, time-interval/rate trackers (RunningAverageTimeInterval, WindowAverageTimeInterval), duty-cycle pairs (RunningAverageDutyCycle, WindowAverageDutyCycle), counters (TotalCountTimeInterval), throttlers (ThrottlingHelper, BudgetedThrottlingHelper), and lock-free bucket meters (ActivityMeter, InvocationMeter).

## API
```cpp
template<class ValueType=double, class AverageType=double> class RunningAverage {
    RunningAverage(lerp=0.05, initial=0, bufferSize=0);
    void sample(ValueType);            // finite-checked; lerp: avg=(1-l)*avg+l*v; variance likewise
    AverageType value/variance/standard_deviation/variance_to_mean_ratio/coefficient_of_variation() const;
    ValueType lastSample() const; void reset(v=0); bool hasSampled(); template iter(F&);
};
template<class V=double,class A=double> class WindowAverage {  // boost::circular_buffer
    sample(v[, F onBeforeDrop]); Stats getStats(n=~0) / getSanitizedStats(Confidence=C90);
    getLatest(); setMaxSamples/clear/size/iter;
};
template<Time::SampleMethod M=Benchmark> class RunningAverageTimeInterval { sample(); Interval value(); double rate(); ... };
template<M=Benchmark> class WindowAverageTimeInterval { setMaxWindow/sample/getStats; geometric growth via FOnBeforeDrop; };
template<V=int,M=Benchmark> class TotalCountTimeInterval { increment/decrement/getCount; };
class ThrottlingHelper { checkLimit(objectCount=0); };      // per-minute budget from FInt pointers
class BudgetedThrottlingHelper { addBudget(b,max); checkAndReduceBudget(); };
template<M=Benchmark> class RunningAverageDutyCycle { sample(Interval); startSample/stopSample; dutyCycle(); rate(); stepInterval(); stepTime(); };
template<M=Benchmark> class WindowAverageDutyCycle { sample/setMaxWindow/getStats/countTimesGreaterThan/iterTimes/iterIntervals; };
template<int windowSeconds> class ActivityMeter { increment/decrement/averageValue; };   // char buckets[sec*1024], atomics
template<int windowSeconds> class InvocationMeter { increment/getTotalValuePerSecond; };
```

## Usage
TaskScheduler.h embeds these directly (schedulerDutyCycle, sleepingJobCount...). Job stats (dutyCycle, sleepRate) and MathUtil's IsValueOutlier tie into getSanitizedStats.

## Gotchas
- All classes are NOT thread-safe except ActivityMeter/InvocationMeter (atomic swap-based buckets — but even those have TOCTOU between currentValue read and bucket rewrite).
- ActivityMeter buckets are `char` — concurrency above 127 saturates silently.
- RunningAverage::sampleVariance computes diff against the JUST-UPDATED average (order matters; it's a lerp-of-square not a true running variance).
- getSanitizedStats divides by result.samples without checking != 0 — an all-outliers window yields NaN.
- ThrottlingHelper holds RAW int* to FInt variables ("Designed to pass FInt") — lifetime coupling to the FastLog system.
- InvocationMeter.updateBuckets(increment) OVERWRITES the current bucket rather than adding — two increments in the same ~ms slot count as one (comment "changed per Erik 11/18/09" shows history of fixes here).
