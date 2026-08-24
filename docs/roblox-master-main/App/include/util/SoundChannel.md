# util/SoundChannel.h

## Purpose
The `SoundChannel` Instance ("A simple sound object", DescribedCreatable): Lua-facing sound playback node wrapping a Soundscape::Sound + FMOD channel, with volume/pitch/rollover/loop properties, 3D attachment to a PartInstance, play-count replication hacks, and played/paused/stopped/looped/ended signals.

## Declared API
```cpp
extern void registerSound();   // registers the class with reflection

namespace RBX::Soundscape {

enum RollOffMode { Inverse = 0, Linear };

extern const char* const sSoundChannel;

class SoundChannel
    : public DescribedCreatable<SoundChannel, Instance, sSoundChannel>
    , public Diagnostics::Countable<SoundChannel>
{
public:
    SoundChannel();
    ~SoundChannel();

    // Signals:
    rbx::signal<void(std::string soundId, int)> soundLoopedSignal;
    rbx::signal<void(std::string)> soundPausedSignal;
    rbx::signal<void(std::string)> soundStoppedSignal;
    rbx::signal<void(std::string)> soundPlayedSignal;
    rbx::signal<void(std::string)> soundEndedSignal;

    rbx::remote_signal<void(int)> timePositionUpdatedFromServerSignal;
    rbx::remote_signal<void(int)> timePositionUpdatedFromServerScriptSignal;
    rbx::remote_signal<void(int)> soundResumedFromServerSignal;

    static Reflection::BoundProp<bool> sound_desc_playOnRemove;

    bool doFmodChannelAddressesMatch(const FMOD::Channel* channel) const;
    FMOD::Channel* getFMODChannel();

    void setSoundId(SoundId value);            const SoundId& getSoundId() const;
    float getVolume() const;      void setVolume(float value);
    float getPitch() const;       void setPitch(float value);
    float getMinDistance() const; void setMinDistance(float value);
    float getMaxDistance() const; void setMaxDistance(float value);
    RollOffMode getRollOffMode() const;        void setRollOffMode(RollOffMode value);
    bool getLooped() const;       void setLooped(bool value);
    int  getPlayCount() const;    void setPlayCount(int value);

    void resume();  void play();  void pause();  void stop();

    // do not replicate play count:
    void playLocal();  void pauseLocal();

    bool isPlaying() const;   bool isPaused() const;   bool isSoundLoaded() const;
    double getSoundLength() const;

    void setSoundPosition(double position, bool setFromLua = false);
    void setSoundPositionLua(double position);
    double getSoundPosition() const;

    bool getHasPlayed() const;    void setHasPlayed(bool value);

    void updateListenState(const Time::Interval& timeSinceLastStep);

    static void soundEnded(weak_ptr<SoundChannel> channelWeak, std::string soundId);
    void onChannelEnd(const FMOD_CHANNEL* channel);
    void onSoundLoaded(const Instance* context, bool shouldPlayOnLoad);

protected:
    /*override*/ bool askSetParent(const Instance* instance) const;
    /*override*/ void onAncestorChanged(const AncestorChanged& event);
    /*override*/ void onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider);

private:
    shared_ptr<Sound> sound;
    FMOD::Channel* fmod_channel;             // latest channel
    RBX::Timer<RBX::Time::Fast> lastTimePosReplication;  // replication rate limiter
    SoundId soundId;
    float volume, pitch, minDistance, maxDistance, defaultFrequency;
    RollOffMode rollOff;
    double soundPositionSeconds;
    int numOfTimesLooped;
    unsigned lastSoundPositionMsec;
    bool playOnRemove;
    bool is3D : 1;
    bool looped : 1;
    bool soundDisabled : 1;                  // cached from SoundService
    int playCount;                           // actual plays
    int reqPlayCount;                        // requested plays (-1 stopped / 0 paused / 1+ playing)
    mutable bool invalidChannel : 1;
    PartInstance* part;                      // attached part (if any)
    rbx::signals::scoped_connection serverUpdatedTimeConnection;
    rbx::signals::scoped_connection serverScriptUpdatedTimeConnection;
    rbx::signals::scoped_connection serverResumedSoundConnection;

    bool isHeardLocally(const Instance* context) const;  // e.g. PlayerGui sounds heard only by owner
    bool isHeardGlobally() const;
    void updateLooped();  void update3D(FMOD::Channel*);
    void playLocal(const Instance*);  void playSound(bool isResuming = false);
    void playSound(const Instance*, bool isResuming = false);
    void releaseChannel();  void loadSound(const Instance*, bool shouldPlayOnLoad);
    void serverUpdatedTimePositionFromScript(unsigned);
    void serverUpdatedTimePosition(unsigned);
    bool controlledByAndIsServer() const;
};
}
```

## Gotchas
- Replication protocol quirk: `reqPlayCount` encodes state as an int (-1 stopped, 0 paused, ≥1 play request count) — "Hack to get play() and pause() to replicate".
- `playLocal`/`pauseLocal` deliberately skip play-count replication.
- Time-position sync from server has two paths: script-driven vs engine-driven (`serverUpdatedTimePosition[FromScript]`), throttled by `lastTimePosReplication`.
- `isHeardLocally` special-cases sounds in player GUIs so only the owning peer hears them.
- Bitfield members (`is3D`, `looped`, `soundDisabled`, `invalidChannel`) share a storage unit — don't take addresses/refs.
- `soundEnded` is static + weak_ptr: safe callback into a possibly-dead channel.
- RollOffMode only Inverse/Linear in this vintage.

## UNKNOWN
- Where `registerSound()` gets invoked and the reflection property table lives (v8datamodel side).
