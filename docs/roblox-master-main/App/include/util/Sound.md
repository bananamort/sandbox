# util/Sound.h

## Purpose
Soundscape layer over FMOD: `SoundId` (a typed ContentId exposed to Lua) and `Sound` — a reference-counted wrapper for an `FMOD::Sound` with its owning FMOD system, 3D flag, and streaming state. Manual refcounting because "we can't use shared_ptr logic to manage the lifetime of fmod_sound".

## Declared API
```cpp
#define FMOD_RESOURCES_FREED_STRING "FMOD System already closed.  Resources previously freed."

namespace RBX::Soundscape {

class SoundId : public ContentId {          // Lua-visible type wrapper
public:
    SoundId();
    SoundId(const ContentId& id);
    SoundId(const char* id);
    SoundId(const std::string& id);
};

class Sound : boost::noncopyable {          // wrapper for FMOD::Sound + extra info
public:
    SoundId const id;
    bool const is3D;

    Sound(shared_ptr<FMOD::System>& system, SoundId id, bool is3D);   // not loaded yet
    ~Sound();                                  // release()

    FMOD::Sound* get();                        // may be NULL until tryLoad succeeds
    FMOD::Sound* tryLoad(const RBX::Instance* context);
    void detatch();                            // forget the FMOD sound without releasing
    void release();

    bool isReferenced() const;                 // refCount > 0
    void acquire();                            // ++refCount
    void unacquire();                          // refCount = max(0, refCount-1)

    bool getIsStreaming() const;
private:
    FMOD::Sound* fmod_sound;
    shared_ptr<FMOD::System> const system;
    int refCount;
    bool isStreaming;
};
}
```

## Gotchas
- Manual acquire/unacquire protocol — unbalanced calls leak or prematurely free FMOD resources.
- `unacquire` clamps at 0 (extra unacquires silently ignored).
- `detatch()` drops the pointer WITHOUT releasing — used when FMOD itself freed the resource (see FMOD_RESOURCES_FREED_STRING).
- `tryLoad` needs an Instance context (probably for content resolution/permissions).
- Const members (`id`, `is3D`, `system`) make Sound non-assignable on top of noncopyable.

## UNKNOWN
- Where the refcount registry lives that pairs acquire/release across channels (Soundscape .cpp files).
