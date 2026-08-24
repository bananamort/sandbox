# Network/Rijndael-Boxes.h

**Module**: Network (root) · **Type**: header (.h, 951 lines, data tables only)

## Purpose

The AES/Rijndael lookup tables ("boxes"), moved from RakNet 3.x ("Roblox: Moved here from RakNet 3.x", aescrypt v2.0 Aug '99 public-domain code). Provides the precomputed S-boxes and MixColumns tables used by `rijndael.cpp`/`DataBlockEncryptor`.

## API (tables defined here)

```cpp
word8 Logtable[256], Alogtable[256];   // GF(2^8) log/antilog
word8 S[256], Si[256];                 // forward/inverse S-box
word8 T1..T4[256][4];                  // encryption round tables (byte-rotated variants)
word8 T5..T8[256][4];                  // decryption round tables
word8 S5[256];                         // inverse S-box variant
word8 U1..U4[256][4];                  // decryption MixColumns tables
word32 rcon[30];                       // round constants 0x01,0x02,...0x91
```

## Usage

Included by `rijndael.cpp` only; not meant to be included elsewhere (defines arrays — single inclusion assumed).

## Gotchas

- Header note: although 192/256-bit blocks are claimed, stick to 128-bit blocks unless tested.
- These are plain non-static globals in a header — including it from two TUs would duplicate symbols.
