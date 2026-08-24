# Network/Rijndael.h

**Module**: Network (root) · **Type**: header (.h, 127 lines)

## Purpose

Combined header for the AES/Rijndael implementation ("Roblox: Moved here from RakNet 3.x", aescrypt rijndael-alg-fst v2.0 + rijndael-api-fst v2.0): algorithm prototypes, block/mode constants, error codes, and the classic `keyInstance`/`cipherInstance` structs.

## API

```cpp
#define MAXKC (256/32)  #define MAXROUNDS 14
typedef unsigned char word8; unsigned short word16; unsigned int word32;

int rijndaelKeySched(word8 k[MAXKC][4], int keyBits, word8 rk[MAXROUNDS+1][4][4]);
int rijndaelKeyEnctoDec(int keyBits, word8 rk[...]);
int rijndaelEncrypt/rijndaelDecrypt(word8 a[16], word8 b[16], word8 rk[...]);
int rijndaelEncryptRound/DecryptRound(word8 a[4][4], word8 rk[...], int rounds);

// API layer
DIR_ENCRYPT/DIR_DECRYPT; MODE_ECB/MODE_CBC/MODE_CFB1; BITSPERBLOCK 128;
BAD_KEY_DIR/-MAT/-INSTANCE, BAD_CIPHER_MODE/-STATE, BAD_BLOCK_LENGTH, BAD_CIPHER_INSTANCE;
MAX_KEY_SIZE 32; MAX_IV_SIZE 16; typedef unsigned char BYTE;
typedef struct { BYTE direction; int keyLen; char keyMaterial[MAX_KEY_SIZE+1]; int blockLen;
                 word8 keySched[MAXROUNDS+1][4][4]; } keyInstance;
typedef struct { BYTE mode; BYTE IV[MAX_IV_SIZE]; int blockLen; } cipherInstance;

int makeKey(keyInstance*, BYTE direction, int keyLen, char* keyMaterial);
int cipherInit(cipherInstance*, BYTE mode, char* IV);
int blockEncrypt/blockDecrypt(cipherInstance*, keyInstance*, BYTE* in, int inputLen, BYTE* out);
int cipherUpdateRounds(...);
```

## Usage

Included by `rijndael.cpp` and `DataBlockEncryptor.h/cpp`.

## Gotchas

- Cirilo's 2005 note: keys are raw unsigned chars now, not hex ASCII.
- Header comment warns to stick to 128-bit blocks unless tested.
