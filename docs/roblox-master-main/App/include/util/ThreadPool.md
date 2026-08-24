# util/ThreadPool.h

## Purpose
Fixed-size worker-thread pools over `rbx::threadsafe` primitives: `BaseThreadPool` (lifecycle/shutdown plumbing), `ThreadPool` (FIFO `safe_queue`), and `PriorityThreadPool` (max-heap by float priority). Tasks are `function<void(shared_ptr<rbx::spin_mutex>)>` — each task receives its worker's spin-lock handle (used by AsyncHttpQueue for cancellation-safe locking).

## Declared API
```cpp
namespace RBX {

// TODO: Implement shutdown policies: WaitForPendingTasks, InterruptTasks, etc.
class BaseThreadPool {
public:
    enum ShutdownPolicy {
        WaitForRunningTasks,
        WaitForRunningTasksWithTimeout,
        LockAndKill,
        NoAction
    };

    struct PoolData {   // shared scheduling state (abstract)
        volatile bool done;
        volatile bool fired;      // a task has been scheduled
        boost::condition_variable cond;
        boost::mutex mut;
        PoolData();
        virtual ~PoolData();
        virtual bool shouldSchedule(const BaseThreadPool* targetThreadPool) const = 0;
        virtual bool getNextTask(boost::function<void(boost::shared_ptr<rbx::spin_mutex>)>& task) = 0;
    };

    BaseThreadPool(int count, ShutdownPolicy shutdownPolicy, PoolData* poolData, size_t maxScheduleSize);
    virtual ~BaseThreadPool();
    int getThreadCount() const;
    size_t getMaxScheduleSize() const;
protected:
    boost::shared_ptr<PoolData> poolData;   // subclass injects queue/heap
    bool shouldSchedule(const boost::shared_ptr<PoolData>& poolData) const;
    void taskAdded();                       // wakes a worker
private:
    static void loop(shared_ptr<PoolData>, shared_ptr<rbx::spin_mutex>, ShutdownPolicy);
    int count;
    const size_t kMaxScheduleSize;
    std::vector< shared_ptr<rbx::spin_mutex> > poolLocks;  // one per worker
    std::vector< shared_ptr<boost::thread> > pool;
    ShutdownPolicy shutdownPolicy;
};

// A ThreadPool with fifo ordering:
class ThreadPool : public BaseThreadPool {
public:
    ThreadPool(int count, ShutdownPolicy shutdownPolicy = NoAction, size_t maxScheduleSize = 0);
    bool schedule(boost::function<void(boost::shared_ptr<rbx::spin_mutex>)> task);
};

// A ThreadPool with job priorities:
class PriorityThreadPool : public BaseThreadPool {
public:
    PriorityThreadPool(int count, ShutdownPolicy shutdownPolicy = NoAction, size_t maxScheduleSize = 0);
    bool schedule(boost::function<void(boost::shared_ptr<rbx::spin_mutex>)> task, float priority);
private:
    struct PriorityTask {
        boost::function<void(boost::shared_ptr<rbx::spin_mutex>)> func;
        float priority;
        // operator< REVERSED: higher priority value sorts first in the heap
    };
};
}
```

## Gotchas
- Task signature includes the worker's `rbx::spin_mutex` — tasks must not hold it forever or shutdown (`LockAndKill`) deadlocks.
- `maxScheduleSize == 0` means unbounded; otherwise `schedule` presumably fails/returns false when full.
- `PriorityTask::operator<` is inverted (`>` semantics) so the heap pops the HIGHEST priority first — don't "fix" this.
- Default ShutdownPolicy is `NoAction`; destructor semantics per policy are .cpp-side.
- Header TODO acknowledges missing graceful-drain policies.

## UNKNOWN
- Behavior when `schedule` is called after destruction begins / while done flag set.
