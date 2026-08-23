# WindowsClient/RenderJob.h

## Purpose

Declares `RBX::RenderJob` — the TaskScheduler job that drives the render loop on the client. Class comment states the contract: it calls `ViewBase::render()`, which must be exclusive to the DataModel (hence the `DataModelJob::Render` enum preventing concurrent writes) and, for OpenGL, must run in the view's thread (the reason the FunctionMarshaller exists). Extends engine `BaseRenderJob` and implements `IMetric` for stats UI.

## API

```cpp
class RenderJob : public BaseRenderJob, public IMetric {
    FunctionMarshaller* marshaller;
    View* robloxView;
    volatile int stopped;
    CEvent prepareBeginEvent;   // ATL event (atlsync)
    CEvent prepareEndEvent;
    static void scheduleRender(weak_ptr<RenderJob> selfWeak, ViewBase* view, double timeJobStart);
public:
    RenderJob(View* robloxView, FunctionMarshaller* marshaller,
        boost::shared_ptr<DataModel> dataModel);
    Time::Interval timeSinceLastRender() const;
    Time::Interval sleepTime(const Stats& stats);
    virtual TaskScheduler::StepResult stepDataModelJob(const Stats& stats);
    virtual std::string getMetric(const std::string& metric) const;
    virtual double getMetricValue(const std::string& metric) const;
    void stop();
};
```

## Usage

Constructed only by `View::initializeJobs()` (`new RenderJob(this, marshaller, dataModel)`), added to the scheduler by `View::resetScheduler()`, removed via `TaskScheduler::removeBlocking` in `View::RemoveJobs()` with a ProcessMessages callback. See RenderJob.cpp.md.

## Gotchas

- Header comment TODO: "Can Ogre be modified to not require the thread?" — documents that the thread-affinity design predates this snapshot.
