# Network/Replicator.HashItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 61 lines)

## Purpose

Implements the hash report write under VMProtect virtualization: `[ItemTypeHash][numItems][obscured chain…]` — each entry XOR-chained with the previous (`obscuringXorValue ^= hashes.hash[i]`), nonce mixed with the last element, then the three tokens appended. Windows/Durango-off builds append `rbxTextSize`/`rbxTextBase` (read via `getIndirectly<LINE_RAND4>` scattered pointers) to the hash vector at construction.

## API

```cpp
HashItem(Replicator*, const PmcHashContainer*, fuzzyToken, apiToken, prevApiToken);
bool write(BitStream&);   // mirrors ServerReplicator::readHashItem + CheatHandling decode
```

## Usage

See header. The XOR-chain is inverted server-side in `decodeHashItem`.

## Gotchas

- `hashes.nonce ^ hashes.hash[numItems-1]` seeds the chain, so the "nonce" never appears raw on the wire.
- No read() exists here — deserialization lives entirely in ServerReplicator.
