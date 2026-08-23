# Crypt.cpp

## Purpose
Win32-desktop implementation of RBX::Crypt: acquires the MS_DEF_PROV RSA context (CRYPT_VERIFYCONTEXT), imports a hardcoded 1024-bit-ish public-key blob from base64 (per Microsoft KB 238187 pattern), and verifies base64-encoded RSA signatures over SHA-1 message hashes. Non-Windows/Durango builds compile an all-stub version at the bottom of this same file.

## API
```cpp
RBX::Crypt::Crypt();      // acquire context + import key; throws RBX::runtime_error on failure
RBX::Crypt::~Crypt();     // CryptDestroyKey + CryptReleaseContext
void RBX::Crypt::verifySignatureBase64(std::string message, std::string signatureBase64);
     // SHA1(message) vs reversed(signature bytes); throws runtime_error on any step failing
```

## Usage
Declared in include/rbx/Crypt.h. Uses ATL (`atlenc.h`) Base64Decode/Base64DecodeGetRequiredLength and rbx/Debug.h. Callers wrap construction in try/catch since the constructor throws.

## Gotchas
- Signature byte reversal before CryptVerifySignature: .NET produces big-endian signatures, CryptoAPI expects little-endian (in-file comment quotes MSDN).
- `signatureRev[10240]` is a fixed stack buffer with NO bounds check against `signatureLen` from base64 decode — oversized signatures smash the stack.
- Uses `alloca()` for the decoded signature — another stack-size hazard for large inputs.
- In release builds the thrown error strings are EMPTY (`runtime_error("")`) — deliberately hides crypto errors from end users; debug builds include GetLastError, sig, and full message text.
- Hardcoded public key (base64 `BgIAAACkAABSU0Ex...`) is Roblox's 2016 script/content signing key.
