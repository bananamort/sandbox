# util/UserInputBase.h

## Purpose
Base abstraction for platform user-input devices (the "TODO: Rename HardwareDevice" note suggests it outgrew its name): cursor management (current/fallback TextureProxy + ContentId), real-time key queries, NavKeys aggregation, modifier-key helpers, and virtual key injection so GUI buttons can "press" keys.

## Declared API
```cpp
LOGGROUP(UserInputProfile)

class RBXBaseClass UserInputBase {
public:
    UserInputBase();
    ~UserInputBase();

    rbx::signal<void()> cursorIdChangedSignal;

    // purely for debugging/diagnostics:
    Vector2 getCursorPositionForDebugging();

    virtual void removeJobs() {}

    // Mouse wrapping:
    virtual void centerCursor() = 0;

    // Real-time key handling:
    virtual bool keyDown(KeyCode code) const = 0;
    void getNavKeys(NavKeys& navKeys, const bool shouldSuppressNavKeys) const;

    bool altKeyDown()   const;   // RALT || LALT
    bool shiftKeyDown() const;   // RSHIFT || LSHIFT
    bool ctrlKeyDown()  const;   // RCTRL || LCTRL

    // allows Gui Key buttons to "press" keys:
    virtual void setKeyState(RBX::KeyCode code, RBX::ModCode modCode,
                             char modifiedKey, bool isDown) = 0;

    // Cursor handling:
    ContentId getCurrentCursorId();
    virtual bool setCursorId(RBX::Adorn* adorn, const RBX::TextureId& id);
    virtual void renderGameCursor(Adorn* adorn);

protected:
    virtual Vector2 getCursorPosition() = 0;                 // platform impl
    virtual TextureProxyBaseRef getGameCursor(Adorn* adorn);
    TextureProxyBaseRef getCurrentCursor();
    TextureProxyBaseRef getFallbackCursor();
private:
    ContentId currentCursorId;
    TextureProxyBaseRef currentCursor;
    TextureProxyBaseRef fallbackCursor;
    rbx::signals::scoped_connection unbindResourceSignal;
    void onUnbindResourceSignal();
};
```

## Gotchas
- Three pure virtuals per platform backend: `getCursorPosition`, `centerCursor`, `keyDown`, plus `setKeyState`.
- Cursor texture lifecycle is tied to an `unbindResourceSignal` connection (content unbind events reset the cached proxy).
- `getNavKeys(navKeys, shouldSuppressNavKeys)` fills the struct (see NavKeys.md); suppression flag semantics .cpp-side.
- Non-const getters return members by value here.

## UNKNOWN
- Which platforms subclass this (win/mac/mobile input layers outside this slice).
