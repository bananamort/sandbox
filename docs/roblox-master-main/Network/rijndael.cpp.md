# Network/rijndael.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 812 lines)

## Purpose

The AES (Rijndael) reference implementation ("Roblox: Moved here from RakNet 3.x", aescrypt rijndael-alg-fst v2.0, Aug '99) backing `DataBlockEncryptor` — i.e. the cipher behind the join-ticket encryption (`Peer::encryptDataPart`). Provides key scheduling, single-block and multi-block ECB/CBC/CFB1 encrypt/decrypt, plus intermediate-round hooks for KATs. Roblox additions: `randomMT()`-generated IV when none supplied (KevinJ) and noinline XOR helpers.

## API

```cpp
// algorithm layer
int rijndaelKeySched(word8 k[MAXKC][4], int keyBits, word8 rk[MAXROUNDS+1][4][4]);
int rijndaelKeyEnctoDec(int keyBits, word8 rk[...]);      // InvMixColumn rounds for decrypt schedule
int rijndaelEncrypt/rijndaelDecrypt(word8 a[16], word8 b[16], word8 rk[...]);
int rijndaelEncryptRound/DecryptRound(word8 a[4][4], rk, int rounds);   // KAT only
word8 mul(word8, word8);                                   // GF(2^8) multiply via log tables
void KeyAddition/ShiftRow/Substitution/MixColumn/InvMixColumn(...);
static void MAGIC(tk, KC, rconpointer);                    // key-expansion step

// AES API layer
int makeKey(keyInstance*, BYTE direction, int keyByteLen, char* keyMaterial); // 128/192/256-bit
int cipherInit(cipherInstance*, BYTE mode /*ECB|CBC|CFB1*/, char* IV);        // NULL IV → randomMT()
int blockEncrypt/blockDecrypt(cipherInstance*, keyInstance*, BYTE* in, int inByteLen, BYTE* out);
int cipherUpdateRounds(...);
```

## Usage

Only consumer in this module is `DataBlockEncryptor` (SetKey→makeKey; Encrypt/Decrypt→blockEncrypt/blockDecrypt in CBC mode with PKCS-style length handling inside DataBlockEncryptor).

## Gotchas

- Global mutable `static int ROUNDS` set by `makeKey` — not thread-safe across keys.
- Only x86 assumptions avoided, but STRICT_ALIGN paths exist; block ops reinterpret buffers as word32.
- CFB1 path is bit-at-a-time and extremely slow — unused by Roblox networking (CBC only).
