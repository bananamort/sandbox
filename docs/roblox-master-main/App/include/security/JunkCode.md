# App/include/security/JunkCode.h

## Purpose

Junk-code / code-obfuscation macro: `RBX_JUNK` expands to a call to an inline template specialization that emits only multi-byte x86 NOP instructions (canonical `0F 1F`, `lea`-based 0x8D NOPs). Its purpose is to pad and vary the instruction stream between builds so byte-pattern signatures are less stable — 17 distinct "junk" bodies selected by `(RBX_BUILDSEED%15 + 1)*__LINE__ + RBX_BUILDSEED) % 17`.

## Declared API

- `template <int N> inline void junk()` — primary template empty; specializations `junk<0..16>` emit one or two raw-NOP asm blocks.
- NOP macros: `RBX_NOP0`–`RBX_NOP6` — `_asm _emit` sequences of 3–6 bytes each.
- `#define RBX_JUNK (junk< ((RBX_BUILDSEED%15 + 1)*__LINE__ + RBX_BUILDSEED) % 17>())`
- Non-Win32 / studio / Durango builds: `#define RBX_JUNK` (expands to nothing).

## Usage notes

- Sprinkle `RBX_JUNK;` as a statement inside functions to insert build-varying no-op padding; it is a pure compile-time artifact with zero runtime effect.

## Gotchas

- Uses MSVC-specific `__asm _emit`; the entire body exists only under `_WIN32 && !RBX_STUDIO_BUILD && !RBX_PLATFORM_DURANGO`.
- Because selection depends on `__LINE__`, inserting/removing source lines silently changes which NOP bodies every later line in the file gets.
