# WindowsClient/Crypt.h

## Purpose

Declares the one exported function of the module's Authenticode verification layer: `VerifyCryptSignature`, used to prove a binary on disk is genuinely signed by Roblox (program name "Roblox Application", ROBLOX Corporation cert, pinned serial + Symantec issuer).

## API

```cpp
bool VerifyCryptSignature(const std::wstring& fileName);
```

Everything else in Crypt.cpp (WinVerifyTrust wrapper, certificate detail checks) is file-local.

## Usage

Callers treat false as "do not trust this file". See Crypt.cpp.md; the sole consumer is `Application::setWindowFrame()` (Application.cpp:1108): a release-only startup self-check that responds to `false` by printing the decoy error "Important !Loading shader files" and setting `HATE_SIGNATURE`.

## Gotchas

- Takes a wide string even though most client code is TCHAR/MBCS.
