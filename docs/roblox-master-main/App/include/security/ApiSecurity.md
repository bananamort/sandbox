# App/include/security/ApiSecurity.h

## Purpose

Anti-tamper "secure caller" machinery: header-only inline checks that verify sensitive API functions are being called from inside the Roblox `.text` section rather than from injected DLLs. Provides return-address/call-site inspection (`checkRbxCaller`), SEH exception-chain walking to detect foreign modules (`detectDllByExceptionChain*`), ntdll discovery that bypasses `GetModuleHandle` (`rbxGetNtdll` via PEB walk), export-table lookup by filter (`rbxNtdllProcAddress`), and the flag-bit vocabulary (`kNtApi*`, `kVeh*`, `kLuaHooked`, …) used to report what failed.

## Declared API

- Macros: `FORCEINLINE` / `NOINLINE` defined per platform; on Windows pulls in `windows.h`/`winternl.h`.
- `namespace RBX::Security { extern volatile const uintptr_t rbxTextBase, rbxTextEndNeg, rbxVmpBase; extern volatile const size_t rbxTextSize, rbxTextSizeNeg, rbxVmpSize; }` (Win32 only) — bounds of own `.text`/VMP sections.
- `bool isRbxTextAddr(const void* ptr)` — range check against `.text`; unconditionally `true` on non-Win32/studio builds.
- Flag constants (bit offsets/masks): `kNameApiOffset=0`, `kRbxLockedApiOffset=3`, `kChangeStateApiOffset=4`, `kNtApiNoNtDll/NoText/NoApi/NoSyscall/NoTemplate/Early/Hash/NoCall` (bits 8–15), `kVehWpmFail/VehPrologFail/VehNoNtdll` (16–18), `kPingItem`, `kScriptContextCopy`, `kLuaHooked` (19–21).
- `template<unsigned value> void callCheckSetBasicFlag(unsigned flags)` — ORs into `Tokens::sendStatsToken.addFlagFast` + `Tokens::simpleToken`; note: template parameter `value` is ignored, `flags` is used directly.
- `template<unsigned offset> void callCheckSetApiFlag(unsigned flags)` — `Tokens::apiToken.addFlagSafe(flags << offset)`.
- `void callCheckNop(unsigned flags)` — no-op sink.
- Check levels: `kCallCheckCodeOnly=1`, `kCallCheckCallArg=2`, `kCallCheckCallersCode=3`, `kCallCheckRegCall=4`.
- `template<int level, void(*action)(unsigned)> unsigned checkRbxCaller(const void* funcAddress)` — validates `_ReturnAddress()` in `.text`, then per level: exact `call imm32` relative-offset match, caller-of-caller in `.text` (falls through), or 2-byte `call r32` opcode heuristic (`0xD7FF` mask). Returns flag bits; invokes `action(flags)` on failure. Compiles to `return 0` outside optimized Win32 client builds.
- `namespace Security`: mode flags `kCheckDefault/kCheckReturnAddr/kCheckNoThreadInit/kAllowVmpAll`.
- `struct CallChainInfo { uint32_t handler; uint32_t ret; }`.
- Win32-only templates: `detectDllByExceptionChain<kMaxDepth>(addrOfChain, kFlags)` — walks SEH chain (documented stack layouts for C++ EH and SEH3), sets bit triples `(init-in-rbx | handler-in-rbx | ret-not-in-text)` per depth; `generateCallInfo<kMaxDepth>` collects `(handler, ret)` pairs; `detectDllByExceptionChainStack<...>` (from first-arg address) and `detectDllByExceptionChainTeb<...>` (from `fs:[0]`). Non-Win32 stubs return 0/nothing.
- Helpers: `getUnicodeDllName(const UNICODE_STRING&)`, `HMODULE rbxGetNtdll()` — PEB walk with name comparison obfuscated through `RBX_BUILDSEED`; `void* rbxNtdllProcAddress(HMODULE, bool filter(const char*))` — raw PE export-table scan.

## Usage notes

- Everything here is header-inline and FORCEINLINE'd deliberately so check code is woven into callers rather than sitting at a findable single address.
- The long block comment is candid about limits: a return-address check alone can be spoofed with a `ret` byte; callbacks can point at `int3`; none of it works under VM protection; all checks touch the same globals so they are easy to locate.

## Gotchas

- Active only under `_WIN32 && !_NOOPT && !LOVE_ALL_ACCESS && !RBX_STUDIO_BUILD && !RBX_PLATFORM_DURANGO` (for `checkRbxCaller`) — in studio/test builds everything degrades to no-op success.
- `callCheckSetBasicFlag` ignores its template parameter — call sites pass the bit as the runtime `flags` argument instead.
- `rbxGetNtdll` reads `__readfsdword(0x30)` (x86-only fs-based PEB fetch) and caps the module walk at 256 entries.
- `detectDllByExceptionChain` packs 3 bits per depth level, so `kMaxDepth` above ~10 overflows a 32-bit result.
- `case kCallCheckCallersCode` intentionally falls through into `kCallCheckCallArg` (missing `break`, commented "// continue").
