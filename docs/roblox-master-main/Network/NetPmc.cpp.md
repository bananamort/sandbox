# Network/NetPmc.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 280 lines)

## Purpose

Implements the "Networked Program Memory Checker" (NetPmc): a build-time-patched table of 128 `NetPmcChallenge`s (salsa20-encrypted keys, tea-encrypted expected results, per the in-file design notes dated 2015-12-04) plus the client-side hash routine and the RCC server-side challenge manager (`NetPmcServer`), with a vendored salsa20 implementation for key generation. The client hashes raw memory ranges with a multiply-rotate mixer and answers; the server verifies response == tea-decrypted correct value **and** that the embedded index matches (anti-replay).

## API

```cpp
DFInt::HashConfigP3(4)=players, P4(1000)=parts, P5(1)/P6(1)=KB/s activity, P8(64)=pending limit
namespace RBX::Security {
    std::vector<uint32_t> hackFlagVector;   // defined here
    extern const volatile NetPmcChallenge kChallenges[kNumChallenges];   // patched at build (zeros in source)
    uint32_t netPmcHashCheck(const NetPmcChallenge&);   // 4-lane rot17/multiply mixer over base[0..size) words,
                                                        // returns v1^v2+v3-v4 (note operator precedence!)
    std::vector<NetPmcChallenge> netPmcKeys = generateNetPmcKeys();  // RCC builds
}
class NetPmcServer {           // RCC only
    bool canSendChallenge(const Replicator*);   // only in real games: not creator, >P3 players, >P4 parts, active traffic
    unsigned int generateDebugInfo(rep, sent&, recv&, pending&) const;
    bool tooManyPending();                      // > DFInt::HashConfigP8
    uint8_t getRandomChallenge();               // shuffled deck, reshuffled when exhausted
    bool sendChallenge(idx); bool removeFromList(idx); bool checkResult(idx, response, correct);
};
void salsa20(uint8_t* msg, len, key[32], nonce);  // + salsa20_words/block helpers (public-domain style)
```

## Usage

Server pump: `CheatHandlingServerReplicator::sendNetPmcChallenge` (called from PingJob). Client solve: `ClientReplicator::doNetPmcCheck` → `netPmcHashCheck` → `NetPmcResponseItem`.

## Gotchas

- `kChallenges` is all-zero bytes in this source tree — real values are injected by the release patcher post-build.
- Challenge gating deliberately avoids Studio-like contexts ("make it much harder to detect this mechanism by making it only work in places that are actually games").
- `checkResult` binds the challenge idx into the upper 32 bits of the encrypted answer to defeat replay.
