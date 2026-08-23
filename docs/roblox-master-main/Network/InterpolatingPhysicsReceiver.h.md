# Network/InterpolatingPhysicsReceiver.h

**Module**: Network (root) · **Type**: header (.h, 157 lines) · **Status**: deprecated-in-waiting — whole file wrapped in `#if 1 // remove this file when fast flag RemoveInterpolationReciever is accepted and removed`

## Purpose

Declares `InterpolatingPhysicsReceiver`, a physics receiver that buffers up to 40 `MechanismItem` history samples per part (a "Nugget") and renders state at `now − lag` by lerping between buffered samples, smoothing network jitter at the cost of latency.

## API

```cpp
class InterpolatingPhysicsReceiver : public PhysicsReceiver {
    class Nugget {   // per-root-part buffer
        shared_ptr<PartInstance> part;  RakNet::Time lastUpdate;  double lag;
        static const int bufferSize = 40;
        struct History { int last, count; MechanismItem data[bufferSize]; };
        void receive(RakNet::BitStream&, RakNet::Time, const ModelInstance* noLagModel,
                     InterpolatingPhysicsReceiver*);
        bool step(RakNet::Time, InterpolatingPhysicsReceiver*) const; // false => erase nugget
    };
    typedef multi_index_container<Nugget,
        indexed_by<hashed_unique<tag<part_tag>, member<...part>>,
                   ordered_non_unique<tag<lastUpdate_tag>, member<...lastUpdate>>>> Nuggets;
    Nuggets nuggets;
    class Job; shared_ptr<Job> job;                       // ReplicatorJob "Net InterpolatePhysics"
    class LagStats { ... }; LagStats lagStats;            // mean/max buffer-seek & lag stats
    MechanismItem reusableMechanismItem;
public:
    RunningAverage<double> outOfOrderMechanisms;
    InterpolatingPhysicsReceiver(Replicator*, bool isServer);
    ~InterpolatingPhysicsReceiver();
    /*override*/ void start(shared_ptr<PhysicsReceiver>);
    void setLerpedPhysics(const MechanismItem& before, const MechanismItem& after, float lerpAlpha);
    virtual void receivePacket(RakNet::BitStream&, RakNet::Time, ReplicatorStats::PhysicsReceiverStats*);
    void sampleBufferSeek(unsigned); void sampleLag(double);
    unsigned getMaxBufferSeek() const; double getAverageBufferSeek() const; double getAverageLag() const;
    void step(RakNet::Time time);
};
```

## Usage

Selected when the replicator wants interpolation; the Job steps all nuggets each tick at the replicator's receive rate (`settings().getReceiveRate()`), priority `DataModelJob::PhysicsIn`.

## Gotchas

- Constructor asserts if `FFlag::RemoveInterpolationReciever` is on — the flag kills this receiver ("nobody should be creating this"); note the flag's misspelling ("Reciever") is baked in.
- `start()` RBXCRASHes if handed a different receiver instance.
- The job cannot be created until the replicator is inside a DataModel; creation is retried via `ancestryChangedSignal`.
