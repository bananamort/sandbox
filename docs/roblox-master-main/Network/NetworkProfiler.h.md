# Network/NetworkProfiler.h

**Module**: Network (root) · **Type**: header (.h, 128 lines)

## Purpose

Declares the optional network profiler (compiled only when `NETWORK_PROFILER` is defined — Windows non-optimized/debug/test builds, see Util.h): a singleton that streams per-bitfield wire-size measurements and packet logs to a RakNet `SQLiteClientLoggerPlugin` server (`roblox.db3`), plus an in-process CPU step profiler for streaming GC tags. All `NETPROFILE_*`/`CPUPROFILER_*` macros compile to no-ops otherwise.

## API

```cpp
class NetworkProfiler {
    static NetworkProfiler* singleton();
    void logPacket(const std::string& type, const RakNet::Packet*);   // rakSqlLog("general", ...)
    void startProfiling(name, const BitStream*);  void endProfiling(name, const BitStream*);
    enum ProfilerTags { PROFILER_streamOutPart, PROFILER_jointRemoval, PROFILER_gcStep, ..._COUNT };
    void startCpuProfiling(int); void stepCpuProfiling(int); void outputCpuProfiling();
private:
    RakNet::PacketizedTCP packetizedTCP; SQLiteClientLoggerPlugin* loggerPlugin;
    std::vector<DataBlobInfo> dataBlobStack; std::size_t deepestLayer;
    bool Connect(); void Disconnect(); bool CanProfile();   // honors profiling flag + ProfilerTimedSeconds
};
```

Macros: `NETPROFILE_LOG/START/END`, `CPUPROFILER_START/STEP/OUTPUT`.

## Usage

Wrapped around dictionary learns, item reads, cluster decode etc. (see Replicator.cpp) to attribute bit counts to nested "layers".

## Gotchas

- Connection target comes from `NetworkSettings::profilerServerIp/Port` (default 127.0.0.1:38123); failed connect disables `networkSettings->profiling`.
- Only leaf layers are logged (`deepestLayer` trick).
