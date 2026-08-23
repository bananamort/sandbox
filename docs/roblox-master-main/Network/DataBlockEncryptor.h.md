# Network/DataBlockEncryptor.h

**Module**: Network (root) · **Type**: header (.h, 73 lines) · **Origin**: "Roblox: Moved here from RakNet 3.x" (RakNet copyright 2003 Jenkins Software LLC) — Roblox-integrated, documented as in-scope root file.

## Purpose

Declares `DataBlockEncryptor`, a block-cipher wrapper (AES-128 via root `Rijndael.h`) used for secure connections. Encrypt adds a checksum + randomized padding and manually chains AES blocks (ECB mode with manual chaining); Decrypt verifies and strips.

## API

```cpp
class DataBlockEncryptor {
public:
    DataBlockEncryptor();
    ~DataBlockEncryptor();
    bool IsKeySet(void) const;
    void SetKey(const unsigned char key[16]);
    void UnsetKey(void);
    // output can alias input; output grows by >= 6 bytes, padded to 16-byte multiple
    void Encrypt(unsigned char *input, unsigned int inputLength,
                 unsigned char *output, unsigned int *outputLength,
                 RakNet::RakNetRandom *rnr);
    // returns false on bad checksum/input; shrinks accordingly
    bool Decrypt(unsigned char *input, unsigned int inputLength,
                 unsigned char *output, unsigned int *outputLength);
protected:
    keyInstance keyEncrypt, keyDecrypt;
    cipherInstance cipherInst;
    bool keySet;
};
```

## Usage

Instantiated where connection-level payload encryption is required (see callers via `grep DataBlockEncryptor` across the tree — e.g. secure replication paths). Depends on RakNet's `RakNetRandom` for pad randomization.

## Gotchas

- Uses `MODE_ECB` deliberately ("ECB is not secure except that I chain manually farther down") — the chaining is a homegrown CBC-like scheme done back-to-front.
- Header marked `\internal` in original RakNet docs.
