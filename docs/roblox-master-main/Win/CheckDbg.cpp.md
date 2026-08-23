# CheckDbg.cpp

Source: `roblox-sandbox/Win/CheckDbg.cpp` (70 lines)

## Purpose

Implements three hand-rolled anti-debug checks. Each walks to the PEB via inline assembly: `GetFS()` does `mov eax, fs:[0x18]` (the x86 TEB self-pointer), then `GetFlag(fs)` loads `[TEB + 0x30]` — the linear address of the PEB — and dereferences it once more to fetch the **first DWORD of the PEB**. Testing bit `0x00010000` therefore tests **byte offset 2 of the PEB: `PEB->BeingDebugged`** — i.e., these are hand-rolled `IsDebuggerPresent()` equivalents, not heap-flag probes. A volatile global `g_counter` accumulates boost::hash values of intermediates purely to add opaque, side-effectful arithmetic between the asm reads.

## API

```cpp
static volatile int g_counter = 0;

static __forceinline DWORD GetFS();   // mov eax, fs:[0x18] → TIB self pointer
static __forceinline DWORD GetFlag(DWORD f);   // *(DWORD*)(*(DWORD*)(f + 0x30)) → first DWORD of PEB

__declspec(noinline) bool isDbg1();   // flag & 0x00010000
__declspec(noinline) bool isDbg2();   // same test, extra hash mixing with rand()
__declspec(noinline) bool isDbg3();   // same test, different rand() mixing pattern
```

## Usage

Verified by tree-wide grep: no other TU includes CheckDbg.h or calls any isDbgN — dead code at baseline, a preserved primitive for tamper response. The three variants exist to present non-identical call sites/code shapes; all return true when `PEB->BeingDebugged` is set (i.e., a debugger is attached to the process — the same condition `IsDebuggerPresent()` reports).

## Gotchas

- **32-bit only**: raw `fs:` segment asm compiles under Win32/MSVC only; x64 builds need `gs:[0x30]`. Under the v143 retarget these TUs stay Win32 or must be rewritten.
- Bit 0x00010000 of the PEB's first DWORD is the low bit of the `BeingDebugged` byte (offset +2). This is *debugger-attached* detection, not debug-heap detection — managed/child debuggers, most JIT engines and any kernel-mediated attach set it; a debugger that explicitly clears `BeingDebugged` (common usermode stealth plugins) defeats it. Conversely it does NOT react to `gflags`-style heap instrumentation at all.
- The double dereference (`TEB+0x30 → PEB; [PEB] → first DWORD`) relies only on the `BeingDebugged` byte living at PEB+2 — that layout has been stable on every NT-family Windows (x86), so unlike heap-flag offsets this check does not rot across OS versions.
- The `g_counter` hash mixing has no functional role in the returned value — it only pads instruction flow; a naive decompiler pattern-match on `return (flag & 0x00010000)` still finds the check instantly.
