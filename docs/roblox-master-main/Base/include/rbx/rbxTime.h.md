# rbxTime.h

## Purpose
Defines RBX::Time (absolute monotonic timestamp, double seconds since process start) and RBX::Time::Interval (relative duration). Design intent (in-file comment): shield callers from OS time APIs; numerical values only via subtracting two Time objects. Also provides templated `Timer<method>` and a `RemoteTime` subclass that re-exposes the protected double constructor for deserialization.

## API
```cpp
class RBX::Time {
    class Interval {  // double sec, private
        static Interval max()/zero()/from_milliseconds(double)/from_seconds(double)/from_minutes(double)/from_hours(double);
        explicit Interval(double seconds);
        double seconds() const; double msec() const; bool isZero() const;
        void sleep();                       // implemented in Time.cpp
        operators +,-,+=,-=,<,>,<=,>=,==,!= ; ostream<<
    };
    Time();                                 // zero epoch
    static Time max();
    enum SampleMethod { Fast, Benchmark, Precise, Multimedia };
    static SampleMethod preciseOverride;    // see gotchas
    static bool isSpeedCheater();           // Win32 desktop only
    static bool isDebugged();               // Win32 desktop only
    template<SampleMethod M> static Time now();
    static Time now(SampleMethod);
    static long long getTickCount();        // raw OS counter
    static long long getStart();            // counter at first call (process epoch)
    static double nowFastSec();             // discouraged in comments
    static Time nowFast();
    bool isZero() const;
    Time operator±(Interval); +=,-=; comparisons; ostream<<
    double timestampSeconds() const;        // discouraged: breaks encapsulation
};
template<Time::SampleMethod M> class Timer { Timer(); Interval delta() const; Interval reset(); };
class RemoteTime : public Time { RemoteTime(); RemoteTime(double); RemoteTime(const Time&); };
```

## Usage
The universal clock of the engine — TaskScheduler, profiler, network timeouts, animation all sample `Time::now<...>()`. Header undefines min/max on Windows before everything else.

## Gotchas
- `preciseOverride` semantics (comment): if it equals Precise, Fast AND Benchmark become precise; if Benchmark, only Benchmark is precise. Default is Precise ⇒ Fast/Benchmark are just QPC/mach clocks.
- `sec` is private with a `friend operator-`; the ONLY sanctioned way to read elapsed time is subtraction. `timestampSeconds()`/`RemoteTime` are the acknowledged encapsulation leaks.
- Time values are process-relative (getStart() epoch), NOT wall-clock — persisting them across sessions is meaningless.
