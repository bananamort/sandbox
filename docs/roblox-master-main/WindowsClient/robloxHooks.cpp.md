# WindowsClient/robloxHooks.cpp

## Purpose

The client's binary-patching baseline (precision target). Two independent anti-tamper patches installed from `Application::Initialize` (`#if !defined(RBX_STUDIO_BUILD)`, Application.cpp:646):

1. **FindWindowA hot-patch** — detects foreign DLLs that scan for the "ROBLOX" window name (classic injection recon) and permanently unhooks itself while raising `HATE_DLL_INJECTION`.
2. **ntdll KiUserExceptionDispatcher call-site patch** (`hookPreVeh`) — rewrites the rel32 operand of the `call RtlDispatchException` inside ntdll so every exception first flows through a naked stub `RtlDispatchExceptionHook`, which inspects access violations / breakpoints landing inside the client's own `.text` (`Security::rbxTextBase/Size`) and flags `HATE_VEH_HOOK` — i.e., VEH-based cheat hooks that register handlers for Roblox code pages.

Both are wrapped in VMProtect mutation regions and feed `RBX::Tokens` stat/API tokens on success or failure.

## API

Real signatures (file uses an anonymous namespace for internals, `namespace RBX` for exports):

### Exports

- `void RBX::hookApi()` — idempotent via `hookingApiHooked()` (functionHooks.h). Captures own module range with `GetModuleInformation(GetCurrentProcess(), GetModuleHandle(NULL), &info, sizeof(MODULEINFO))` into file-statics `moduleStart/moduleSize`; then `resumeFindWindow = hotpatchHook(&FindWindowA, findWindowHook)`; finally `hookPreVeh()`.
- `void RBX::unhookApi()` — `hotpatchUnhook(resumeFindWindow)` only ("In case something goes wrong or we need to be stealthy"). Does NOT undo the ntdll patch.
- `bool RBX::hookPreVeh()` — returns true when the WriteProcessMemory patch succeeded. Algorithm:
  1. `GetModuleHandleA("ntdll")`, then locate `KiUserExceptionDispatcher` WITHOUT GetProcAddress: `rbxNtdllProcAddress(ntdll, cmpKiUserExceptionDispatcher)` scans the export table matching names through the obfuscated comparator.
  2. OS discrimination: if the 10-byte prolog memcmp fails at `loc`, retry at `loc+1` (win7/8 prefix the prolog with a 1-byte `cld`; first-try hit ⇒ WinXP).
  3. `vehHookLocation = loc + sizeof(prolog)` — exactly the E8 rel32 operand. Compute `newOffset = &RtlDispatchExceptionHook - vehHookLocation - 4`; save `vehHookContinue = (vehHookLocation + 4) + *vehHookLocation` (original dispatch target); `WriteProcessMemory(GetCurrentProcess(), vehHookLocation, &newOffset, 4, &bytesWritten)`.
  4. Failure telemetry: `Tokens::apiToken.addFlagSafe(kVehNoNtdll | kVehPrologFail | kVehWpmFail)` respectively. Quirk: `result = result; // vmprotect workaround.` before `VMProtectEnd()`.
- `BOOLEAN RBX::RtlDispatchExceptionHook(PEXCEPTION_RECORD exRec, PCONTEXT ctx)` — `__declspec(naked)`; hand-written asm prologue (`push ebp; mov ebp,esp; sub esp,__LOCAL_SIZE; push ebx; push ecx`) so the C++ helper can be called without compiler frame noise, calls `RtlDispatchExceptionCheck(exRec, ctx)`, restores registers, then `cld; jmp vehHookContinue;` — a tail-jump to the real dispatcher so this frame never appears as a normal return on exception callstacks.

### Internals (anonymous namespace)

- `HWND WINAPI findWindowHook(LPCTSTR className, LPCSTR windowName)` — under `VMProtectBeginMutation("35")`: reads `_ReturnAddress()`; `argDiff = windowName - returnAddress`. Conservative detector: caller outside our module AND `windowName` within ±8 MB of the call site (`(argDiff+kHalf) < kFull`, kHalf=1<<23, kFull=1<<24 — "probably .rdata") AND `_strnicmp(windowName,"ROBLOX",6)==0` ⇒ `RBX::hotpatchUnhook(resumeFindWindow)` (self-unhook so subsequent FindWindow calls are pristine) + `Tokens::simpleToken |= HATE_DLL_INJECTION`. Always forwards via `return resumeFindWindow(className, windowName);`.
- `void RtlDispatchExceptionCheck(PEXCEPTION_RECORD exRec, PCONTEXT ctx)` — pure flag-setter, never swallows exceptions: for `EXCEPTION_ACCESS_VIOLATION` tests `exRec->ExceptionInformation[1]` (faulting address); for `EXCEPTION_BREAKPOINT/_SINGLE_STEP/_ILLEGAL_INSTRUCTION/_PRIV_INSTRUCTION` tests `exRec->ExceptionAddress`; in-range test is `(addr - rbxTextBase) <= rbxTextSize` (unsigned wraparound trick). On hit: `Security::setHackFlagVs<LINE_RAND1>(Security::hackFlag6, HATE_VEH_HOOK)` plus `Tokens::sendStatsToken.addFlagFast(HATE_VEH_HOOK)`.
- `bool cmpKiUserExceptionDispatcher(const char* inString)` — decodes the obfuscated export name byte-by-byte: `(unsigned char)((inString[i]+i)*227) == cmpString[i]` against a hardcoded 26-byte table; NUL handling distinguishes exact-length match (`i==25`).
- `const unsigned char kiUserExceptionDispatcherProlog[10] = {8B 4C 24 04, 8B 1C 24, 51, 53, E8}` — `mov ecx,[esp+4]; mov ebx,[esp]; push ecx; push ebx; call rel32(RtlDispatchException)`.
- File statics: `size_t moduleStart=0; size_t moduleSize=0xFFFFFFFF;` and `FindWindowSplice resumeFindWindow` where `typedef HWND (WINAPI *FindWindowSplice)(LPCTSTR, LPCSTR);` (mixed LPCTSTR/LPCSTR because it binds the ANSI FindWindowA).

## Usage

Startup order inside `Application::Initialize`: after GlobalBasicSettings load, `hookApi()` → record `vehHookLocationHv = reinterpret_cast<uintptr_t>(vehHookLocation)` and `vehStubLocationHv = reinterpret_cast<uintptr_t>(&RtlDispatchExceptionHook)` → `setupCeLogWatcher()`. For the sandbox logger this file defines the baseline of what binary state must hold before any instrumentation graft: FindWindowA's first bytes are a jmp, and ntdll's KiUserExceptionDispatcher contains one rewritten rel32 whose original target is cached in `vehHookContinue` (defined in App/util/Win/CheatEngine.cpp:36).

## Gotchas

- The ntdll patch has no un-patch path: `unhookApi()` removes only the FindWindowA hook. Once `hookPreVeh` succeeds, every process exception pays the stub until exit.
- Prolog matching is byte-exact against XP/win7/win8-era ntdll; any newer Windows build fails the memcmp ⇒ `kVehPrologFail`, no VEH hook — behavior silently differs by OS.
- All pointer math is 32-bit (`DWORD` casts); x64 builds cannot link this file's logic as-is.
- `findWindowHook` self-unhooks on first detection — the detector is single-shot per process.
- `RtlDispatchExceptionCheck` flags but does not suppress: comment warns "If the user was not hacking, there will be a crash" — the kick happens later via token upload, letting a genuine AV crash normally.
- In-range checks rely on unsigned `(addr - base) <= size` wraparound; `rbxTextBase/rbxTextSize` are filled by ReleasePatcher/security init and are meaningless in an unpatched Raw exe.
- Includes reference v8datamodel/HackDefines.h (HATE_* flags), security/FuzzyTokens.h (Tokens), security/ApiSecurity.h, util/CheatEngine.h, VMProtect/VMProtectSDK.h — UNKNOWN which of these remain functional after pruning; treat missing headers as prune casualties, not source errors.
