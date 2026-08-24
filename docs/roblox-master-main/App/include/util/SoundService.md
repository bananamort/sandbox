# util/SoundService.h

## Purpose
The FMOD-backed audio service (`Soundscape::SoundService`, a PERSISTENT_HIDDEN creatable Instance + Service): owns the `FMOD::System`, master channel group, loaded-sound caches (2D + 3D) with periodic GC, listener configuration, ambient reverb, 3D settings (doppler/distance/rolloff), stock UI sounds, and per-frame update via its `SoundJob` DataModelJob. Also defines ReverbType/ListenerType enums and the diagnostics stats item.

## Declared API
```cpp
typedef enum { FADE_STATUS_NONE = 0, FADE_STATUS_IN, FADE_STATUS_OUT } FadeStatus;

namespace RBX::Soundscape {

enum ReverbType { NoReverb=0, GenericReverb, PaddedCell, Room, Bathroom, LivingRoom,
    StoneRoom, Auditorium, ConcertHall, Cave, Arena, Hangar, CarpettedHallway, Hallway,
    StoneCorridor, Alley, Forest, City, Mountains, Quarry, Plain, ParkingLot, SewerPipe,
    UnderWater };

enum ListenerType { CameraListener = 0, CFrame, ObjectPosition, ObjectCFrame };

struct listenerValues { CoordinateFrame listenCFrame; shared_ptr<IHasLocation> listenObject; };

extern const char* const sSoundService;

class SoundService : public DescribedCreatable<SoundService, Instance, sSoundService,
                        Reflection::ClassDescriptor::PERSISTENT_HIDDEN>, public Service {
public:
    static bool soundDisabled;   // suppress all fmod calls in soundless builds

    SoundService();
    ~SoundService();

    shared_ptr<Sound> loadSound(SoundId id, bool is3D);
    bool enabled() const;                       // == initialized
    void playSound(SoundType sound);            // stock sounds
    FMOD::DSP* createDSP(FMOD_DSP_DESCRIPTION& dspdesc);
    int getSampleRate();
    unsigned int getfmod_version() const;
    void getSoundStats(unsigned& numSounds, unsigned& numUnusedSounds) const;
    void getChannelsPlaying(int& value) const;
    void muteAllChannels(bool mute);   bool isMuted();

    void setListener(ListenerType listenerType, shared_ptr<const Reflection::Tuple> value);
    shared_ptr<const Reflection::Tuple> getListener();
    CoordinateFrame getListenCFrame(Camera* camera);
    void setMasterVolume(float);   float getMasterVolume();
    void setMasterVolumeFadeOut(float timeToFadeMsec);
    void setMasterVolumeFadeIn(float timeToFadeMsec);
    void gameSettingsChanged(const Reflection::PropertyDescriptor*);
    FMOD::ChannelGroup* getMasterChannel();

    struct CpuStats { float total, dsp, stream, geometry, update; };
    void getCpuStats(CpuStats& stats) const;

    ReverbType getAmbientReverb() const;       void setAmbientReverb(const ReverbType&);
    static Reflection::BoundProp<float> prop_dopplerscale, prop_distancefactor, prop_rolloffscale;
    static Reflection::EnumPropDescriptor<SoundService, ReverbType> prop_AmbientReverb;

    void registerSoundChannel(SoundChannel*);  void unregisterSoundChannel(SoundChannel*);

    void step(const Time::Interval& timeSinceLastStep);

    static void checkResultNoThrow(FMOD_RESULT, const char* fmodOperation,
                                   const void* rbxFmodParent, const void* fmodObject);
    static void checkResult(/* same */);
    static bool convert(const G3D::Vector3& src, FMOD_VECTOR& dst);

protected:
    /*override*/ void onServiceProvider(ServiceProvider*, ServiceProvider*);
private:
    shared_ptr<FMOD::System> system;
    typedef boost::unordered_map<SoundType, shared_ptr<SoundChannel>> StockSounds;
    StockSounds stockSounds;
    float dopplerscale, distancefactor, rolloffscale;
    ListenerType currentListenerType;   listenerValues currentListenerValues;
    shared_ptr<Instance> statsItem;
    ReverbType ambientReverb;
    boost::unordered_set<SoundChannel*> soundChannels;   // friend class SoundChannel
    FMOD::ChannelGroup* channelMaster;
    shared_ptr<SoundJob> soundJob;
    Time nextGarbageCollectTime;
    typedef boost::unordered_map<SoundId, shared_ptr<Sound>> LoadedSounds;
    LoadedSounds loadedSounds, loaded3DSounds;
    float masterChannelFadeTimeMsec;   FadeStatus masterChannelFadeStatus;
    bool initialized, muted;
    void openFmod();  void closeFmod();  void garbageCollectSounds();
    static void gcSounds(LoadedSounds&);
    static void getSoundStats(const LoadedSounds&, unsigned&, unsigned&);
    void updateSoundChannels(const Time::Interval&);
    void updateMasterChannelGroup(const Time::Interval&);
    void update3DSettings();  void on3DSettingChanged(const Reflection::PropertyDescriptor&);
    void updateAmbientReverb();
};

// Responsible for updating all sound logic:
class SoundJob : public DataModelJob {
public:
    explicit SoundJob(SoundService* soundService)
        : DataModelJob("Sound", DataModelJob::Write, false,
                       shared_from_dynamic_cast<DataModel>(DataModel::get(soundService)),
                       Time::Interval(0.003))
        , fps(30), soundService(soundService)
    { cyclicExecutive = true; }
    Time::Interval sleepTime(const Stats& stats)   { return computeStandardSleepTime(stats, fps); }
    virtual Job::Error error(const Stats& stats)   { return computeStandardErrorCyclicExecutiveSleeping(stats, fps); }
    TaskScheduler::StepResult stepDataModelJob(const Stats& stats) {
        soundService->step(stats.timespanSinceLastStep);
        return TaskScheduler::Stepped;
    }
private:
    SoundService* const soundService;
    const double fps;      // 30
};

class SoundServiceStatsItem : public Stats::Item { /* binds fmod version, memory, channels,
    cpu% (total/dsp/stream/geometry/update), #sounds/#unused into the stats tree */
public:
    static shared_ptr<SoundServiceStatsItem> create(const SoundService* service);
    /*override*/ void update();
};
}
```

## Gotchas
- Hard compile-time pin: `#if FMOD_VERSION != 0x00010702 #error` — FMOD 1.07.02 exactly.
- `soundDisabled` static short-circuits ALL fmod usage (server/web-service builds).
- Listener can be camera-driven or object/CFrame driven (`setListener` takes a Reflection Tuple whose shape depends on ListenerType — UNKNOWN exact layout).
- Master-volume fade in/out mutates global channel group over time via step().
- SoundChannel is a friend: registers/unregisters itself in `soundChannels`.
- `checkResult` vs `checkResultNoThrow`: one presumably throws/RBXASSERTs on FMOD errors.
- `convert(Vector3 → FMOD_VECTOR)` handles handedness/scale mapping between RBX and FMOD coordinate systems.

## UNKNOWN
- Exact Tuple layouts accepted by setListener per ListenerType (.cpp-side).
