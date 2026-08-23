# microprofile/microprofilehtml.h

## Purpose
VENDORED generated data file ("start file generated from microprofile.html"): embeds the complete HTML/CSS/JS single-page viewer served by microprofile.h's web server and baked into file dumps when MICROPROFILE_EMBED_HTML=1 (default). Exposes four C string arrays — g_MicroProfileHtml_begin (1 chunk: doctype, CSS, menu markup, JS data-model helpers MakeGroup/MakeTimer/MakeTimes/MakeFrame/MakeCounter), g_MicroProfileHtml_end (3 chunks: the ~3800-line canvas application), plus *_sizes/_count tables consumed by MicroProfileDumpHtml.

## API
```cpp
extern const char*  g_MicroProfileHtml_begin[];      extern size_t g_MicroProfileHtml_begin_sizes[]; extern size_t g_MicroProfileHtml_begin_count; // == 1
extern const char*  g_MicroProfileHtml_end[];        extern size_t g_MicroProfileHtml_end_sizes[];   extern size_t g_MicroProfileHtml_end_count;   // == 3
```
The JS side expects the C++-emitted globals: DumpHost, DumpUtcCaptureTime, AggregateInfo, CategoryInfo, GroupInfo, TimerInfo, ThreadNames, ThreadGroupTimeArray, ThreadIds, MetaNames, CounterInfo, Frames (tt/ts/ti/tl arrays), CSwitchThreadInOutCpu, CSwitchTime.

## Usage
Included at the bottom of microprofile.h under #if MICROPROFILE_EMBED_HTML. The dump path writes begin chunks, printf'd JS variables, then end chunks; sizes are sizeof()-1 to trim NULs.

## Gotchas
- Chunk boundaries split mid-identifier: end_0 ends with `Stri` and end_2 begins with `ngArray...` (a StringArray.push line) — chunks are NOT independently meaningful; concatenation order matters.
- The viewer self-profiles its own draw loop (ProfileEnter/Leave, ToggleDebugMode cycles ProfileMode 0–3).
- LOD system: PreprocessLods builds NumLodSplits(10) detail levels by duration-percentile splitting; DrawDetailedView swaps LODs by zoom.
- State persists via a browser cookie named "fisk" (JSON) — mode/reference/threads/groups toggles survive reloads.
- Known quirk in MouseMove: `else if(evt.target = CanvasHistory)` uses ASSIGNMENT not comparison — history hover always "true", masks detailed-view branch ordering.
- Regenerate from microprofile.html upstream rather than hand-editing these strings.
