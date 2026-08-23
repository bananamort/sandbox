# WindowsClient/Crypt.h

## Purpose

Declares the one exported function of the module's Authenticode verification layer: `VerifyCryptSignature`, used to prove a binary on disk is genuinely signed by Roblox (program name "Roblox Application", ROBLOX Corporation cert, pinned serial + Symantec issuer).

## API

```cpp
bool VerifyCryptSignature(const std::wstring& fileName);
```

Everything else in Crypt.cpp (WinVerifyTrust wrapper, certificate detail checks) is file-local.

## Usage

Callers treat false as "do not trust this file". See Crypt.cpp.md; consumer is the release-patching flow (ReleasePatcher.cpp).

## Gotchas

- Takes a wide string even though most client code is TCHAR/MBCS.
