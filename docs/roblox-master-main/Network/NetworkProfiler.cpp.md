# Network/NetworkProfiler.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 218 lines)

## Purpose

Implements the profiler body (entire file inside `#ifdef NETWORK_PROFILER`): lazy TCP connect to the SQLite log server, timed-session cutoff, `rakSqlLog` writes to three tables — `"general"` (tag, packetType, packetBitSize), `"report"` (leaf layer path "a.b.c", offset, bitsize), `"details"` (per-layer columns 1..9 with a hand-unrolled switch) — and CPU profiling output printing per-step cumulative/delta timings for each tag.

## API

```cpp
const char* const columnNames = "tag, offset, bitSize, layer1..layer9";
bool CanProfile(); void Connect(); void Disconnect();
void logPacket / startProfiling / endProfiling / startCpuProfiling / stepCpuProfiling / outputCpuProfiling;
```

## Usage

See header; `outputCpuProfiling` is bound to reflection `PrintProfilingResult` on NetworkSettings.

## Gotchas

- `endProfiling` asserts start/end name pairing and pops after logging; >9 nesting layers trip an assert.
- `CpuProfilingStat::reset()` loops `for (i=0; i<numSample; i++) stepDelta[i]=0` — only clears sampled prefix (fine, but subtle).
