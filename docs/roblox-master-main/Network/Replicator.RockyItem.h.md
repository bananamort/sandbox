# Network/Replicator.RockyItem.h

**Module**: Network (root) · **Type**: header (.h, 92 lines)

## Purpose

Declares the "Rocky" anti-cheat item family sharing `ItemTypeRocky` with a subtype byte: client→server `MccReport` (memory-checker timing + GF(2)-encoded local check bits), server→client `NetPmcChallengeItem` (RCC), client→server `NetPmcResponseItem` and `RockyDbgItem` (call-chain debug, non-studio). Also defines the shared `MccReport` struct and `RockySubtype` enum.

## API

```cpp
struct MccReport { uint32_t memcheckRunTime, memcheckDoneTime, mccRunTime, badAppRunTime, localChecksEncoded; };
enum RockySubtype { RockeyMccReportClient=0, RockeyNetPmcChallenge, RockeyNetPmcResponse, RockeyCallInfo };

class Replicator::RockyItem : public Item {          // MccReport upload (from MemoryCheckerCheckerJob)
    RockyItem(Replicator*, MccReport&);
    bool write(BitStream&);
    static shared_ptr<DeserializedItem> read(Replicator&, BitStream&);   // client side: challenge intake
};

class DeserializedRockyItem : public DeserializedItem {
    uint8_t idx; RBX::Security::NetPmcChallenge challenge;
    void process(Replicator&);   // submits ClientReplicator::doNetPmcCheck write task
};

#ifndef RBX_STUDIO_BUILD
class Replicator::NetPmcResponseItem : public Item { uint32_t response; uint64_t correct; uint8_t idx; bool write(BitStream&); };
class Replicator::RockyDbgItem : public Item { std::vector<CallChainInfo> info; bool write(BitStream&); };
#endif
#ifdef RBX_RCC_SECURITY
class Replicator::NetPmcChallengeItem : public Item { uint8_t idx; bool write(BitStream&); };
#endif
```

## Usage

- MCC reports: queued by `ClientReplicator::onMccReady`; validated in `CheatHandlingServerReplicator::processRockyMccReport`.
- Challenges: sent by `CheatHandlingServerReplicator::sendNetPmcChallenge` (from PingJob); responses verified via `netPmc.checkResult`.

## Gotchas

- `RockyItem::read` hard-casts to `ClientReplicator` — only clients receive challenges on this path; server-side reading of MccReports goes through `ServerReplicator::readRockyItem` instead.
- Note the misspelling preserved from source: `Rockey*` enum values.
