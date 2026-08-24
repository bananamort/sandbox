# GfxPart.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/GfxPart.h` (121 lines)

## Purpose

Declares the binding layer between `PartInstance`s (data model) and graphics objects: `GfxBinding` (event-listener base that tracks one PartInstance), `GfxPart` (binding + spatial-hash primitive for renderable parts), and `GfxAttachment` (position-tracking-only attachment). This is the contract the render engine implements per part.

## API

```cpp
class RBX::GfxBinding {   // protected ctors, virtual dtor (impl in GfxPart.cpp)
protected:
    GfxBinding(const shared_ptr<PartInstance>& part);
    GfxBinding();
public:
    PartInstance* getPartInstance();      // raw from shared_ptr
    void zombify();        // unlink; "will cause delete on next updateEntity()"
    bool isBound();
    static bool isInWorkspace(RBX::Instance* part);
    // all-overridable notification hooks:
    virtual void invalidateEntity() {}
    virtual void updateEntity(bool assetsUpdated = false) {}
    virtual void updateChunk(const SpatialRegion::Id&, bool isWaterChunk) {}
    virtual void onCoordinateFrameChanged() {}
    virtual void onSizeChanged()       { invalidateEntity(); }
    virtual void onTransparencyChanged(){ invalidateEntity(); }
    virtual void onSpecialShapeChanged(){ invalidateEntity(); }
    virtual void unbind();               // disconnects listeners
    void cleanupStaleConnections();
    void bindProperties(const shared_ptr<PartInstance>& part);
protected:
    shared_ptr<PartInstance> partInstance;
    std::vector<rbx::signals::connection> connections;
private:   // internal handlers
    onPropertyChanged, onAncestorChanged, onChildAdded, onChildRemoved,
    onSpecialShapeChangedEx, onCombinedSignal, onHumanoidChanged,
    onOutfitChanged, onDecalPropertyChanged, onTexturePropertyChanged
};

class RBX::GfxPart : public GfxBinding, public RBX::BasicSpatialHashPrimitive {
public:
    GfxPart(const shared_ptr<PartInstance>&);  GfxPart();
    int lastFrustumVisibleFrameNumber;         // init −1
    virtual void updateCoordinateFrame(bool recalcLocalBounds = false) {}
    virtual unsigned int getPartCount() { return 1; }
    virtual void onSleepingChanged(bool sleeping, PartInstance*) {}
    virtual void onClumpChanged(PartInstance*) {}
    virtual Vector3 getCenter() const { return Vector3(); }
};

class RBX::GfxAttachment : public GfxBinding {
public:
    /*override*/ void unbind();                // own impl
    virtual void onSleepingChanged(bool) = 0;
    virtual void updateCoordinateFrame(bool recalcLocalBounds = false) = 0;
};
```

## Usage

Includes SpatialRegion, Instance, BasicSpatialHashPrimitive, signal, reflection/Property. Subclassed by the real render representations in GfxCore/RenderView.

## Gotchas
- `zombify` + deferred delete-on-next-update is a two-phase teardown — code must not assume zombified parts vanish instantly.
- Default hooks are EMPTY (not pure): missing overrides fail silently.
- `getCenter()` default returns origin — subclasses must override for meaningful spatial queries.
- Comment shows `virtual void bind();` commented out — binding happens via `bindProperties` + subclass logic.
