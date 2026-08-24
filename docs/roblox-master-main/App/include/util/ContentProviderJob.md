# util/ContentProviderJob.h

## Purpose
`DataModelJob` that drains a thread-safe queue of downloaded-content tasks (URL + payload) and hands each to a caller-supplied processing function inside the DataModel. Bridges `AsyncHttpQueue` completions into scheduler-driven DataModel work.

## Declared API
```cpp
class ContentProviderJob : public DataModelJob {
public:
    enum ExecutionMode { JobMode, ImmediateMode };

    ContentProviderJob(shared_ptr<DataModel> dataModel, const char* name,
        boost::function<TaskScheduler::StepResult(std::string, shared_ptr<const std::string>)> processFunc,
        boost::function<void(std::string)> errorFunc);

    /*override*/ Time::Interval sleepTime(const Stats& stats);
    /*override*/ Job::Error error(const Stats& stats);
    /*override*/ TaskScheduler::StepResult stepDataModelJob(const Stats& stats);

    void abort();
    void addTask(const std::string& id, AsyncHttpQueue::RequestResult result,
                 std::istream* filestream, shared_ptr<const std::string> data);
    void setExecutionMode(ExecutionMode execMode);
private:
    boost::function<TaskScheduler::StepResult(std::string, shared_ptr<const std::string>)> processFunc;
    boost::function<void(std::string)> errorFunc;
    struct ContentProviderTask { std::string id; shared_ptr<const std::string> data; };
    bool aborted;
    rbx::safe_queue<ContentProviderTask> tasks;   // lock-free/thread-safe queue
    ExecutionMode execMode;
    TaskScheduler::StepResult processTask(const ContentProviderTask& task);
};
```

## Gotchas
- `addTask` receives the raw `std::istream*` from AsyncHttpQueue callbacks but only stores id+data — the stream is consumed/discarded by the implementation (UNKNOWN exact handling).
- Failed requests (`RequestResult::Failed`) route to `errorFunc(id)` rather than `processFunc`.
- `ImmediateMode` presumably bypasses scheduler sleep cadence (exact behavior in .cpp — UNKNOWN).
- `abort()` sets a flag; tasks already queued may still be dropped or processed (UNKNOWN drain semantics).
- Tasks queue via `rbx::safe_queue` so producers can be HTTP threads while consumption happens on the DataModel job.

## UNKNOWN
- Precise sleepTime/error throttling policy values.
