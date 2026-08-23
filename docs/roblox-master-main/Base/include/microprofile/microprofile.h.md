# microprofile/microprofile.h

## Purpose
VENDORED third-party profiler "MicroProfile" (public-domain / unlicense.org, single-header C/C++ library). Declares AND implements (under MICROPROFILE_IMPL) the whole engine: token registry (groups/timers/categories with 48-group bit-mask limit), per-thread ring-buffer log of enter/leave/meta/label events, per-frame aggregation (MicroProfileFlip), HTML/CSV dumps, an embedded HTTP web server (port scan 1338+20), ETW/DTrace context-switch tracing, and D3D11/GL GPU timestamp queries.

## API
Core (see in-file Howto comment): MICROPROFILE_SCOPE/SCOPEI/SCOPEGPU(I), MICROPROFILE_DEFINE/DECLARE(_GPU), MICROPROFILE_LABEL(F), MICROPROFILE_COUNTER_ADD/SET/SET_LIMIT/CONFIG, MICROPROFILE_META_CPU/GPU. Functions: MicroProfileGetToken/FindToken/GetLabelToken/GetCounterToken, MicroProfileEnter/Leave (RAII via MicroProfileScopeHandler), MicroProfileFlip (once per frame), MicroProfileOnThreadCreate/Exit, MicroProfileGetTime, MicroProfileDumpFile(html|csv, frames), MicroProfileSetEnableAllGroups/EnableCategory/ForceEnableGroup, MicroProfileStartContextSwitchTrace, GPU: MicroProfileGpuInit(context)/InsertTimer/GetTimeStamp/TicksPerSecondGpu/GetGpuTickReference. Key knobs: MICROPROFILE_PER_THREAD_BUFFER_SIZE 2 MB, MAX_FRAME_HISTORY 512, MAX_THREADS 32, MAX_TIMERS 1024, MAX_GROUPS 48 ("dont bump!"), WEBSERVER_PORT 1338.

## Usage
Roblox wraps it via rbx/Profiler.h/cpp; Profiler.cpp defines MICROPROFILE_IMPL + MICROPROFILEUI_IMPL and includes this header — that TU carries the entire implementation (g_MicroProfile global state).

## Gotchas
- Log entry encoding packs type(3b)|timer-index(13b)|tick(48b) into uint64; tick wrap handled by <<16 shift-diff trick (MicroProfileLogTickDifference).
- Web server #errors if WinSock.h was already included (needs WinSock2) — include-order landmine on Windows.
- Context-switch trace on Windows uses the kernel ETW logger (SystemTraceControlGuid) — requires admin rights; StartTrace failure silently disables tracing.
- Apple context-switch path reads a NAMED PIPE /tmp/.microprofilecspipe fed by an external DTrace script — trace silently no-ops without it.
- g_bUseLock dance exists because Windows DLL-init can't use mutexes; before first OnThreadCreate the global state is mutated lock-free.
- MICROPROFILE_EMBED_HTML pulls microprofilehtml.h's giant string arrays at the bottom.
- snprintf is #defined to _snprintf on Win32 — old MSVC non-conforming semantics.
