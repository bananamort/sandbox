# Network/Replicator.HashItem.h

**Module**: Network (root) · **Type**: header (.h, 24 lines)

## Purpose

Declares `Replicator::HashItem` — the client→server program-memory-hash report (`ItemTypeHash`). Carries the `PmcHashContainer` (rolling xxhash vector + nonce) plus three 64-bit security tokens (fuzzy token, api token, previous api token).

## API

```cpp
class Replicator::HashItem : public Item {
    HashItem(Replicator*, const PmcHashContainer* hashes, unsigned long long fuzzyToken,
             unsigned long long apiToken, unsigned long long prevApiToken);
    bool write(RakNet::BitStream&);   // send-only; server reads via ServerReplicator::readHashItem
private:
    PmcHashContainer hashes;          // copied at construction (+ text base/size on Windows)
    unsigned long long fuzzyToken, apiToken, prevApiToken;
};
```

## Usage

Queued from `ClientReplicator::onHashReady` (MemoryCheckerJob completion signal); consumed by `CheatHandlingServerReplicator::decodeHashItem/processHashValue/processHashValuePost/updateHashState`.

## Gotchas

- Comment mandates copying data into the item — never re-reading live memory at write time (anti-tamper determinism).
