# WindowsClient/functionHooks.cpp

## Purpose

Implementation of the classic Microsoft hot-patchable-API hook (the `mov edi,edi` / 5-byte prelude trampoline, cf. Raymond Chen blog referenced in a comment: http://blogs.msdn.com/b/oldnewthing/archive/2011/09/21/10214405.aspx). Provides `hotpatchHook`/`hotpatchUnhook` used by robloxHooks.cpp to intercept `FindWindowA`, plus `hookingApiHooked`, an environment sanity check that decides whether this security layer should arm at all.

## API

Real signatures:

- `void* RBX::hotpatchHook(void* origFunction, void* hookFunction)` —
  1. `hasHotpatchProlog(origFunction)` must pass: first WORD at entry == `0xFF8B` (`mov edi,edi`) and the FIVE bytes *before* entry are all `0xCC` or `0x90`.
  2. Computes resume pointer = orig + 2 and write point = orig − 5.
  3. Writes one 7-byte buffer at `orig − 5`: `E9 rel32` fills the 5-byte prelude cave (rel32 = dst − (cave+5)) and vectors to `hookFunction`; immediately after it, `EB F9` overwrites `mov edi,edi` at entry — a short jmp whose displacement `F9` (−7) targets `(entry+2) − 7 = entry − 5`, i.e. back onto the just-written `E9`, chaining entry → cave → hookFunction. One `WriteProcessMemory(GetCurrentProcess(), pfnWriteEntry, patchBuffer, sizeof(patchBuffer), &bytesWritten)` call installs both.
  4. Returns orig + 2 on success; 0 if prolog invalid or WPM failed.
- `void* RBX::hotpatchUnhook(void* pfn)` — inverse, in two ordered steps ("change the patch jump to be a nop first", then restore). `pfn` is the resume pointer (entry+2); writes go to `writePfn = pfn − 7 = entry − 5`: first `8B FF` at `writePfn+5` (= entry, restoring `mov edi,edi`), then `CC CC CC CC CC` at `writePfn` (refilling the 5-byte cave with INT3s). Returns `writePfn+5` — the API's true entry (`pfn − 2`) — or 0 per failed WPM.
- `bool RBX::hookingApiHooked()` — returns **true (= hostile/already-hooked, do not arm)** when:
  - `GetModuleInformation` on "Kernel32" fails;
  - the address of `WriteProcessMemory` (as resolved through this module's IAT) falls outside Kernel32's base+SizeOfImage — i.e., IAT redirection detected;
  - WriteProcessMemory's entry WORD is not `0xFF8B` — hot-patch cave already consumed by someone else.
  Comment notes hardware-breakpoint or AV hooks could still exist undetected. Returns false only when environment looks clean.

### Internals

- Constants: `kLenHotpatchNop=2`; `kLenLongJumpWin32=5`; opcode table `kInt3=0xCC, kNop=0x90, kJmp8=0xEB, kJmp32=0xE9, kPushByte=0x6A, kPushDword=0x68, kCallDword=0xE8, kHotpatchJmp=0xF9`.
- `bool hasHotpatchProlog(void* pfn)` — checks entry WORD + 5 preceding bytes ∈ {CC,90}.
- `DWORD getLongJmpArg(void* src, void* dst)` — standard rel32 math for a jump placed at src.

## Usage

Single consumer pair: `RBX::hookApi()` (robloxHooks.cpp) calls `hotpatchHook(&FindWindowA, findWindowHook)` after gate-checking `hookingApiHooked()`, and stores the returned resume pointer for `resumeFindWindow(...)` forwarding and later `hotpatchUnhook`. The primitives are generic enough for any hot-patchable kernel32/user32 export.

## Gotchas

- Failure convention is overloaded: 0 means both "not patchable" and "WPM refused"; callers cannot distinguish.
- The 7-byte single WPM call is not atomic from other threads that may already be inside FindWindowA's first bytes mid-patch — installed once at startup before UI activity, which is why ordering matters.
- Unhook order matters exactly because the trampoline is live: restore `mov edi,edi` at the entry first, then refill the cave with INT3s.
- x86-only: assumes 32-bit rel32 encoding and the Win32 hot-patch layout; no /SAFESEH or DEP-specific handling.
