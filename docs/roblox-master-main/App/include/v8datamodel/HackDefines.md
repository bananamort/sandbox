# App/include/v8datamodel/HackDefines.h

## Purpose

Anti-tamper constants and helpers: HATE_* exploit-report bit flags, SCORN_* extensions, obfuscated hack-flag setters (setHackFlagVs/setHackFlagVmp templates blending with VMProtect), GF(2) encode/decode LUTs for packing flag indices, MCC_* index constants, and the thirteen scattered `RBX::Security::hackFlag0..12` storage globals ("spread ... out in the linking phase ... can't be an array").

## Declared API

- `//#define LOVE_ALL_ACCESS` — commented debug backdoor; header warns never to ship enabled.
- `#include "Security/RandomConstant.h"` + line-noise macros `LINE_RAND4 ((RBX_BUILDSEED&0x3FFFF)*__LINE__)`, `LINE_RAND1 (((RBX_BUILDSEED&0xFF)*(__COUNTER__+1))&0xFC)` (VS2012 __LINE__ workaround noted).
- HATE flags 0x1–0x80000000: CHEATENGINE old/new, XXHASH_BROKEN, NEW_HWBP, SIGNATURE, ILLEGAL_SCRIPTS, MEMORY_HASH_CHANGED, INVALID_BYTECODE, CONST_CHANGED, CATCH_EXECUTABLE_ACCESS_VIOLATION, LUA_SCRIPT_HASH_CHANGED, DEBUGGER, HOOKED_GTX, SEH_CHECK, DESTROY_ALL, LUA_HASH_CHANGED, WEAK_DM_POINTER_BROKEN, HSCE_EBX, CHEATENGINE_NEW, UNHOOKED_VEH, OSX_MEMORY_HASH_CHANGED, LUA_VM_HOOKED, SPEEDHACK, INVALID_ENVIRONMENT, DLL_INJECTION, HSCE_HASH_CHANGED, VEH_HOOK, VERB_SNATCH, RETURN_CHECK, HASH_FUNCTION_CHANGED, NEW_AV_CHECK, CE_ASM, IMPOSSIBLE_ERROR.
- SCORN flags: SCORN_IMPOSSIBLE_ERROR = 0xFFFFF000, SCORN_REPLICATE_PROP = 0xFFF; `kNoScornFlags = 0`.
- GF(2) basis LUTs (32×uint each, "generated from a sage script"): `kGf2EncodeLut[32]`, `kGf2DecodeLut[32]` with inner-product = parity(a & b) documented by example.
- MCC index defines: TEXT=0, VMP=1, RDATA=2, HWBP=3, GTX=4, VEH=5, NULL0=6, NULL1=7, INIT=8, BAD=9, PMC=10, MCC=11, SPEED=12, FREECONSOLE=13, FAKE_FFLAG_IDX=14.

`namespace RBX::Security`

- Win32-only obfuscation templates (`_WIN32 && !RBX_PLATFORM_DURANGO`): `setHackFlagVs<unsigned key>(y, x)` (rot-11 blend), `setHackFlagVmp<unsigned key>(y, x)` (_bittestandset / bts-style, rot-17), `getHackFlag<key>(flag)`, `getIndirectly<key>(void*)`; non-Windows fallbacks are plain `|=`/read.
- Storage: `extern unsigned int hackFlag0 .. hackFlag12;`

## Gotchas

- The LOVE_ALL_ACCESS debug define disables protections if uncommented — audit before release builds.
- Flag bits feed DataModel::addHackFlag/sendStats telemetry (see [DataModel.md](DataModel.md)); decoy flags live in unrelated classes (certified M–Z findings).
- Header-only inline templates rely on volatile writes to resist optimization; semantics are still plain OR.

## UNKNOWN

- Which detection sites write each specific bit (spread across the tree; see implementation notes in checkpoint facts).

## Cross-links

- Consumers: [DataModel.md](DataModel.md) hack-flag API; Security/RandomConstant.h (App/include/security slice).
