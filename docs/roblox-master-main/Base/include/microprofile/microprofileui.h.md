# microprofile/microprofileui.h

## Purpose
VENDORED MicroProfile on-screen UI module (public domain): declares AND implements (under MICROPROFILEUI_IMPL) the interactive overlay — Detailed timeline view (bars, context-switch lanes, zoom/pan), Timers bar view (time/avg/max/min/callcount/exclusive + meta counters), Counters tree view with limits/bars, frame-history strip, live graphs (5 slots × 128 history), menus/presets/custom groups, tooltips, and the mouse/mod-key state machine. Roblox's Profiler.cpp defines MICROPROFILEUI_IMPL and drives it via MicroProfileDraw.

## API
```cpp
void MicroProfileDraw(w,h); bool MicroProfileIsDrawing();
void MicroProfileToggleGraph(token); void MicroProfileDrawGraph(w,h); void MicroProfileClearGraph();
void MicroProfileToggleDisplayMode(); void MicroProfileSetDisplayMode(int);
void MicroProfileMousePosition(x,y,wheel); void MicroProfileMouseButton(l,r); void MicroProfileModKey(state);
void MicroProfileLoadPreset/SavePreset(suffix);   // binary ".microprofilepreset.<name>" files (magic 0x28586813 v0x102)
void MicroProfileDrawText/Box/Line2D(...);        // engine-supplied backend (Profiler.cpp bridges to Renderer)
void MicroProfileInitUI();
// Custom groups:
void MicroProfileCustomGroup(name,maxTimers,aggregateFlip,referenceTime,flags);
void MicroProfileCustomGroupAddTimer(custom,group,timer); Toggle/Enable(name|index)/Disable();
```
Knobs: TEXT_WIDTH 5/HEIGHT 8, DETAILED_BAR_HEIGHT 12, GRAPH 256×256, CUSTOM_MAX 8/64 timers.

## Usage
Called once per frame after MicroProfileFlip; all drawing funnels through the three backend callbacks. Preset auto-load happens on first Draw ("Default").

## Gotchas
- All UI state lives in global g_MicroProfileUI; every call must hold the profiler recursive mutex (MicroProfileDraw locks internally).
- Preset files are written to the PROCESS CWD via fopen(".microprofilepreset.X") — sandboxed/console environments may fail silently.
- LoadPreset alloca's the whole file size; a corrupt/huge preset file can smash the stack.
- Menu index 9 is hardwired as "Help" and menu text array caps at MICROPROFILE_MENU_MAX 16 — adding entries overflows.
- MicroProfileStringArrayFormat uses vsprintf into a shared 4 KB tooltip buffer with only an assert as bounds check.
- nHoverColor animates via a static counter (100↔245 triangle wave) — hover highlight is time-dependent, not input-driven.
