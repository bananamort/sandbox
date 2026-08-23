# Network/DataBlockEncryptor.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 200 lines) · **Origin**: RakNet 3.x code moved into the Roblox tree.

## Purpose

Implements `DataBlockEncryptor` (see DataBlockEncryptor.h): AES-128 (Rijndael) with a hand-rolled chained-block mode, 4-byte `CheckSum`, one random byte, and a pad-size byte whose high nibble is random.

## API / behavior

- `SetKey`: `makeKey` for both directions + `cipherInit(MODE_ECB)`; comment acknowledges ECB and manual chaining.
- `Encrypt` layout: `[4B checksum][1B random][1B encodedPad][padding…][payload]`; padding count = `16 - (((len+6-1) % 16)+1)`; first block encrypted, then each subsequent block XORed with previous ciphertext block **from back to front** and encrypted.
- `Decrypt`: validates `inputLength >= 16 && inputLength % 16 == 0`; unchains forward using next ciphertext block as the XOR mask; decrypts first block last; checksum mismatch → `return false`; payload memmoved to front. Note: Decrypt's memmove is unconditional (in-place assumption), the commented-out branch for distinct in/out buffers was removed.
- Random bytes come from `rnr->RandomMT()` (Mersenne Twister).

## Usage

Secure-connection payload path; caller must supply a seeded `RakNet::RakNetRandom`.

## Gotchas

- In debug builds `RakAssert(keySet)` fires on Encrypt/Decrypt without a key; release builds proceed with an unset key (Rijndael on zeroed keyInstance).
- The chaining direction (encrypt back-to-front, decrypt front-to-back) means a corrupted block poisons everything before it — integrity relies entirely on the trailing checksum check.
- `encodedPad & 0x0F` allows only 0–15 padding bytes; layout math assumes sizeof(checksum)=4.
