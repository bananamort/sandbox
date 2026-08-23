# WindowsClient/RandomPadding.cpp

## Purpose

Per-week binary-layout jitter. The opening comment states the whole rationale: "We moved to non-ASLR at some point to get consistent hashes. Exploiters quickly moved to hardcoding fixed addresses each week. This is only here to move the code around a little bit each week." It force-links an exported no-op function whose body expands into a template-generated junk-code block sized by `RBX_BUILDSEED`, shifting surrounding code addresses each build.

## API

Real symbols:

- `template <int N> __forceinline void useless()` — recursive binary expansion: emits `junk<(N*(RBX_BUILDSEED%16) + __LINE__*N*(RBX_BUILDSEED%15) + N*N) % 17>()` then recurses `useless<N-1>()` twice ⇒ 2^N−1 instantiations of compile-time `junk<M>` (Security/JunkCode.h). Explicit termination `useless<0>` is empty.
- `extern "C" void unusedPadding()` — exported via `#pragma comment (linker, "/export:_unusedPadding")` (the underscore = x86 cdecl decoration) so the linker cannot strip it ("VS2012 really doesn't get why a function that is unused should exist"); body: `useless<9>();` ⇒ ~511 junk instantiations.

No runtime behavior; everything happens at compile/link time.

## Usage

Nothing calls `unusedPadding`; the /export directive is the keep-alive. RBX_BUILDSEED (build pipeline constant, Security/RandomConstant.h) is what changes weekly.

## Gotchas

- Depends on Security/JunkCode.h (`junk<N>`) and RBX_BUILDSEED — both must survive pruning for this TU to compile.
- Pure x86 assumption again (export name decoration).
- Effect is cosmetic obfuscation only: offsets shift, content does not.
