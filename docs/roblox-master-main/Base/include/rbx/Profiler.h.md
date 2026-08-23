# Profiler.h

## Purpose
Declares the RBX::Profiler facade over the vendored MicroProfile library: token-based scoped regions (RBXPROFILER_SCOPE), labels, counters, thread registration, GPU timers, and an on-screen UI driven through a pluggable Renderer interface. Active on Win32/Apple/Android (RBXPROFILER define); everything compiles to no-ops elsewhere.

## API
```cpp
namespace RBX::Profiler {
    typedef uint64_t Token;
    Token getToken(group, name, color=-1); Token getLabelToken(group); Token getCounterToken(name);
    uint64_t enterRegion(Token); void leaveRegion(Token, uint64_t enterTimestamp);
    void addLabel(Token, name); void addLabelFormat(Token, name, ...);   // printf-style
    void counterAdd(Token, long long); void counterSet(Token, long long);
    void onThreadCreate(name); void onThreadExit(); void onFrame();
    enum Flags { MouseMove=1, MouseWheel=2, MouseDown=4, MouseUp=8 };
    void gpuInit(void* context); void gpuShutdown();
    bool isCapturingMouseInput(); bool handleMouse(flags, x, y, wheel, button);
    bool toggleVisible(); bool togglePause(); bool isVisible();
    struct Renderer { virtual drawText/drawBox/drawLine = 0; };   // engine supplies impl
    void render(Renderer*, width, height);
    struct Scope { Scope(Token); ~Scope(); };                     // RAII region
}
// macros (no-op when !RBXPROFILER):
RBXPROFILER_SCOPE(group, name[, color]); RBXPROFILER_LABEL(group, label); RBXPROFILER_LABELF(...);
RBXPROFILER_COUNTER_ADD/SUB/SET(name, count);
```

## Usage
Sprinkled across hot paths engine-wide; TaskScheduler threads call Profiler::onThreadCreate/onThreadExit. FFlag::OnScreenProfiler gates all runtime cost in Profiler.cpp.

## Gotchas
- Macros create function-local `static Token` per call site — first-call initialization cost per site; tokens are never freed.
- The disabled LABELF macro still sizeof-evaluates args (`(void)sizeof(0, __VA_ARGS__)`) to keep warning-clean dead code.
- getToken's group "GPU" selects MicroProfileTokenTypeGpu — group names are semantically overloaded.
