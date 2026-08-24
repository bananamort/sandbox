# Network/Peer.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 248 lines)

## Purpose

Implements the `Peer` base shared by `Client` and `Server`: constructs a profiled `ConcurrentRakPeer` per ServiceProvider (attaching itself as the RakNet plugin so `PluginInterface2::OnReceive` lands in Client/Server), runs the `PacketReceiveJob` DataModel job that drains the RakNet receive queue under a scoped write lock, provides the AES (`DataBlockEncryptor`) encrypt/decrypt helpers for handshake payloads, installs the "Network"/"Packets Thread" stats subtree, and applies outgoing KB/s limits.

## API

```cpp
void Peer::setOutgoingKBPSLimit(int limit);
    // limit<=0 → unlimited; else SetPerConnectionOutgoingBandwidthLimit(1000 * clamp(limit,10,10000))
void Peer::encryptDataPart(RakNet::BitStream&);   // pads to 16-byte blocks (+6 bytes overhead), AES-encrypts in place after byte 0
static void Peer::decryptDataPart(RakNet::BitStream&); // throws std::runtime_error("Data error") on failure
void Peer::onCreateRakPeer();                     // seeds rnr from local GUID; SetOccasionalPing(true)
```

Reflection: `SetOutgoingKBPSLimit(limit)` (Security::Plugin).

Internal classes:
- `ProfiledRakPeer : RakNet::RakPeer` — wraps `RunUpdateCycle` with a benchmark timer, sampling `peer.rakDutyCycle`.
- `PacketReceiveJob : DataModelJob` ("Net PacketReceive", DataIn, cyclic executive at `CyclicExecutiveJobPriority_Network_ReceiveIncoming`) — each step takes `DataModel::scoped_write_request`, then `while (packet = rawPeer()->Receive()) DeallocatePacket(packet)`. Note: it only **drains** packets; actual processing happens through the plugin callbacks during Receive.
- `PeerStatsItem` — StatsService children: `Network → Packets Thread → {Rate, Activity}` plus `Physics Senders`, `Send Buffer Health`.

## Usage

- `onServiceProvider` teardown order matters: detach stats item → kill receive job → `removeAllChildren()` (Replicators point at rakPeer) → detach plugin + reset rakPeer. Attach side creates the peer, calls virtual `onCreateRakPeer()` (Client sets nothing; Server sets max incoming connections + incoming password), adds the receive job, re-installs stats.
- `Client.cpp` uses `encryptDataPart` on `ID_SUBMIT_TICKET`; server-side ticket decode uses `decryptDataPart`.

## Gotchas

- Static AES key derived as `0xFE ^ 7*i` for i=0..15 (see Peer.h) — same key for every client and server ever built; no forward secrecy.
- `encryptDataPart` assumes exactly one leading plaintext byte (the packet ID) and mutates the caller's bitstream in place; the encrypted region is `[1, length)` rounded up to 16 bytes.
- `lerp = 0.05` file-static controls duty-cycle smoothing; `receiveRate` comes from `NetworkSettings::singleton().getReceiveRate()` via an `ObscureValue<double>`.
- The commented-out `SetMTUSize(1400)` shows MTU tuning was attempted here once.
