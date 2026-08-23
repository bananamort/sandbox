# Profiler.cpp

## Purpose
Implements RBX::Profiler by compiling the vendored MicroProfile + MicroProfileUI implementations directly into this TU (MICROPROFILE_IMPL / MICROPROFILEUI_IMPL), bridging its drawing hooks to the engine's Renderer, and gating every entry point on FFlag::OnScreenProfiler. Non-RBXPROFILER platforms get a stub namespace at the bottom.

## API
All RBX::Profiler functions per Profiler.h. Notables:
- enterRegion returns MICROPROFILE_INVALID_TICK immediately when flag off — leaveRegion then no-ops.
- handleMouse caches InputState globals and forwards to MicroProfileMousePosition/Button; profiler captures mouse only when drawing && !nRunning.
- toggleVisible cycles MP_DRAW_OFF ↔ MP_DRAW_FRAME; togglePause toggles running + FRAME↔DETAILED.
- render() lazily MicroProfileInitUI()s, sets background opacity 0x40<<24, draws via gProfileRenderer global (set/restored around MicroProfileDraw).
Platform shims: MICROPROFILE_PRINTF → OutputDebugStringA (Win) / __android_log_print (Android); Apple gets an in-file C++11-less std::atomic/std::thread emulation (MICROPROFILE_NOCXX11); Durango pins webserver port 4600 and neuters getenv.

## Usage
Linked wherever Profiler.h macros are used; the render path is driven by the client's frame loop passing its Renderer.

## Gotchas
- On Apple this file INJECTS classes into namespace std (`using boost::thread`, hand-rolled std::atomic with __sync builtins) before including microprofile — fragile with any real C++11 stdlib leak-in.
- gProfileRenderer is a raw global used by MicroProfileDraw callbacks; rendering from two threads concurrently would race it.
- GPU timers: D3D11 on Windows (MICROPROFILE_GPU_TIMERS_D3D11=1), GL macro defined 0 on Mac (!iOS) despite including gl3.h — GL timing effectively disabled there.
- Durango defines getenv(name) NULL — environment-based MicroProfile config impossible on Xbox.
- Every public function begins `if (!FFlag::OnScreenProfiler) return ...` — flag flips at runtime are safe-ish but tokens/labels created while off are dropped.
