# util/Profiling.h

## Purpose
Lightweight hierarchical code profiler: `CodeProfiler` sections measured via scoped `Mark` RAII objects into time-bucketed statistics (512 buckets per profiler), plus `BucketProfile` for histogramming integer values into static bucket limits.

## Declared API
```cpp
namespace RBX::Profiling {
    void init(bool enabled);
    void setEnabled(bool enabled);
    bool isEnabled();

    struct Bucket {
        float sampleTimeElapsed;   // system time span the bucket sampled for
        float wallTimeSpan;
        int frames;
        double getActualFPS() const;           // frames/sec
        double getNominalFPS() const;
        double getNominalFramePeriod() const;  // secs/frame
        double getSampleTime() const;  double getWallTime() const;  int getFrames() const;
        Bucket();
        Bucket& operator+=(const Bucket& b);   // accumulates
    };

    class Profiler : public boost::noncopyable {
    protected:
        const Time::Interval bucketTimeSpan;       // minimum time per bucket
        int currentBucket;
        boost::array<Bucket, 512> buckets;         // "TODO: Use boost::circular_buffer"
        Time lastSampleTime;
    public:
        const std::string name;
        Profiler(const char* name);
        virtual ~Profiler();
        Bucket getWindow(double window) const;     // aggregate last `window` seconds
        Bucket getFrames(int frames) const;        // aggregate last n frames
        static double profilingWindow;
    };

    class CodeProfiler : public Profiler {          // profiles code sections via Mark
    public:
        CodeProfiler(const char* name);
    private:
        friend class Mark;
        void log(bool frameTick, double wallTimeElapsed);
        void unlog(double wallTimeElapsed);
    };

    class Mark {                                    // RAII section marker
    public:
        // Enclosing Mark is disabled for this object's lifetime:
        Mark(CodeProfiler& section, bool frameTick, bool logInclusive = false);
        ~Mark();
    private:
        CodeProfiler& section;
        Mark* enclosingMark;
        bool frameTick;
        Time startTime;
        const bool enabled;
        Time::Interval childrenElapsed;   // sum of inclusive elapsed of child Marks
        const bool logInclusive;          // true: include children; false: subtract them
    };

    class BucketProfile {                           // histogram of ints
    public:
        // WARNING: assumes pointer to bucketLimits is static and saves it directly
        BucketProfile(const int* bucketLimits, int size);
        BucketProfile(const BucketProfile& rhs);
        BucketProfile();
        const BucketProfile& operator=(const BucketProfile& rhs);
        void addValue(int v);
        void removeValue(int v);
        void clear();
        int getTotal();
        const std::vector<int>& getData() const;
        const int* getLimits() const;
    private:
        std::vector<int> data;
        const int* bucketLimits;
        unsigned int findBucket(int v);
        int total;
    };
}
```

## Gotchas
- Global enable flag (`init`/`setEnabled`); when disabled Marks are no-ops (ctor captures `enabled`).
- Nesting: a child Mark suppresses its enclosing Mark's timing and reports up via `childrenElapsed`; with `logInclusive=false` parent logs only its exclusive time.
- `BucketProfile` stores the raw `bucketLimits` POINTER — the limits array must outlive the profile (static data expected).
- 512 fixed buckets per profiler; header notes circular_buffer as a TODO.
- `removeValue` allows decrementing histogram counts — unusual; keep add/remove paired.

## UNKNOWN
- Where sampled buckets get reported/aggregated (telemetry pipeline outside this slice).
