# RbxAssert.h

## Purpose
Declares Roblox's pluggable assertion-failure hook mechanism (`AssertionHook`), adapted from Morgan McGuire's G3D debugAssert design. The macros themselves live elsewhere (see `Debug.h`); this header defines the function-pointer type and the setter/getter pair used to customize what happens when a debug assert or a release-mode `alwaysAssertM` fails.

## API
```cpp
namespace RBX {
typedef bool (*AssertionHook)(const char* _expression, const char* filename, int lineNumber);

void setAssertionHook(AssertionHook hook);   // invoked on debugAssert failure; return true -> rawBreak
AssertionHook assertionHook();
void setFailureHook(AssertionHook hook);     // invoked by alwaysAssertM failure in release mode; true -> exit(-1)
AssertionHook failureHook();

namespace _internal {
    extern AssertionHook _debugHook;
    extern AssertionHook _failureHook;
}
}
```

## Usage
Engine bootstrap installs custom hooks via `setAssertionHook`/`setFailureHook` (e.g. crash reporting instead of raw break). Storage of the two globals lives in `RbxAssert.cpp`.

## Gotchas
- Header comment says "If NULL, assertions are not handled" — callers must null-check the hook before invoking; the hook itself never checks.
- Include guard is a GUID-style token (`x68BFA40003704acb85BC500AEC18DCA7`), not the filename.
- Return-value semantics differ per hook: assertion-hook `true` triggers `rawBreak`; failure-hook `true` exits with -1.
