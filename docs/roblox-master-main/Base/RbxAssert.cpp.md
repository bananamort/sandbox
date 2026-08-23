# RbxAssert.cpp

## Purpose
Windows-side storage for the assertion/failure hook globals declared in RbxAssert.h. The engine can redirect what happens on a failed assert or a fatal failure by installing function pointers, instead of hardcoding dialog/abort behavior. File banner credits Morgan McGuire (2001, graphics3d/G3D heritage), edited through 2006.

## API
```cpp
namespace RBX {
void setAssertionHook(AssertionHook hook);
AssertionHook assertionHook();
void setFailureHook(AssertionHook hook);
AssertionHook failureHook();
}
```
Backed by two file-scope globals `RBX::_internal::_debugHook` and `RBX::_internal::_failureHook` (type `AssertionHook`, a function-pointer type defined in RbxAssert.h).

## Usage
RbxAssert.h (documented separately) declares the FASTASSERT/RBXASSERT macros that consult these hooks when an assertion fires. Setters are called during engine startup to install platform-appropriate assert UI/logging.

## Gotchas
- Despite the banner saying "Windows implementation", this TU contains no Windows-specific code beyond including RbxPlatform.h — the hooks are plain globals.
- Hooks are non-atomic globals: setting them from one thread while asserts fire on another is racy (UNKNOWN whether any runtime does this).
- Initial value of the hooks is whatever zero-initialization gives (NULL) — consumers must null-check before invoking.
