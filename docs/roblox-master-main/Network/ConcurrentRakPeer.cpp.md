# Network/ConcurrentRakPeer.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 285 lines)

## Purpose

Implements the two internal DataModel jobs: `PacketJob` ("Net Peer Send", RaknetPeer task type, cyclic at Network_ReceiveIncoming priority) drains a `timestamped_safe_queue<SendData>` into the real peer; `StatsUpdateJob` ("Net Peer Stats", 30 Hz) polls per-address ping/MTU/statistics, samples buffer health globally and per connection, and invokes registered update callbacks (feeding Replicator/ReplicatorStats).

## API

```cpp
class PacketJob { rbx::timestamped_safe_queue<SendData> sendQueue; step → peer->Send(...) while queue non-empty };
class StatsUpdateJob {
    StatsMap statsMap; UpdateCallbackMap updateCallbackMap;   // mutex-guarded
    void updateStats(entry, peer);   // GetMTUSize/pings/GetStatistics + running averages
    void calcBufferHealth(int totalBufferedMessages);
};
void ConcurrentRakPeer::Send(...)  // enqueue + reschedule(packetJob)
```

## Usage

See header. `addStats` performs one immediate `updateStats` and fires the callback once so Diagnostics never sees uninitialized data.

## Gotchas

- Error metric for PacketJob scales head-wait ×100 ×min(10,size+1)/2 when queue-error computed — sends lagging >0.1 s dominate scheduling.
- `GetStatistics` is const but mutates the map via `operator[]` under lock (default-inserts an entry for unknown addresses).
- Send failures only RBXASSERT — dropped silently in release.
