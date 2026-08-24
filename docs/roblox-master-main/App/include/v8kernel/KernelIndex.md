# App/include/v8kernel/KernelIndex.h

## Purpose

Mixin granting an object a single int "am I in the kernel" slot: −1 when outside the kernel, ≥0 (index) otherwise. Dtor asserts the owner deregistered before destruction.

## Declared API

- `class KernelIndex`
  - Protected `int kernelIndex;` init −1.
  - `bool indexInKernel() const` inline → `kernelIndex != -1`.
  - Default ctor; dtor with `RBXASSERT(!indexInKernel())`.

## Gotchas

- The dtor assert fires only in checked builds — destroying a kernel-registered object in release silently corrupts kernel arrays.
- No setter here; the kernel itself mutates `kernelIndex` (it's protected, friend/derived access expected).
