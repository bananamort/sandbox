# Crypt.h

## Purpose
Declares `RBX::Crypt`, a small RAII wrapper around the Win32 CryptoAPI used to verify RSA signatures over messages (SHA-1 hash + imported public key). This is the client's trust anchor for verifying server-signed payloads.

## API
```cpp
namespace RBX {
class Crypt {
    HCRYPTPROV context;   // Win32 only, not Durango
    HCRYPTKEY key;
public:
    Crypt();
    ~Crypt();
    void verifySignatureBase64(std::string message, std::string signatureBase64); // throws on bad signature
};
}
```
On non-Windows or Durango the class has no members and all methods are empty stubs (see rbx/Crypt.cpp `#else` branch).

## Usage
Constructed where signature verification is needed (e.g., script-signature checks); each call to `verifySignatureBase64` throws `RBX::runtime_error` when verification fails. Includes windows.h/wincrypt.h on Win32 desktop only.

## Gotchas
- The embedded public key is hardcoded in rbx/Crypt.cpp as base64 keyblob — rotating the signing key requires shipping new binaries.
- Whole API is a no-op off Win32 desktop: non-Windows builds "verify" everything successfully.
