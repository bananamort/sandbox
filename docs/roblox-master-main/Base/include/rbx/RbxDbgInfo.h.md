# rbx/RbxDbgInfo.h / RbxDbgInfo.cpp

## Purpose
A single global struct (`RBX::RbxDbgInfo::s_instance`) laid out specifically to be readable from minidumps: GPU/CPU/audio identifiers, video memory, commit/physical memory stats, handle/process/thread counts, server IP, and a 4-deep place-visit history. Populated at runtime by engine subsystems; consumed by crash-analysis tooling.

## API
```cpp
#define PLACE_HISTORY 4
#define DBG_STRING_MAX 128

struct RBX::RbxDbgInfo {
    static RbxDbgInfo s_instance;
    RbxDbgInfo();                                   // memset zero
    // POD fields: cbMaterials/cbTextures/cbMeshes/cbEstFreeTextureMem, cCommitTotal/Limit,
    // cPhysicalTotal/Available, cbPageSize, cKernelPaged/NonPaged, cSystemCache,
    // HandleCount/ProcessCount/ThreadCount, GfxCardName/DriverVersion/VendorName[128],
    // TotalVideoMemory, CPUName[128], NumCores, AudioDeviceName[128], ServerIP[128],
    // union { long PlaceIDs[4]; struct{Place0..3}; }, PlaceCounter, PlayerID
    static void SetGfxCardName(const char*); static void SetGfxCardDriverVersion(const char*);
    static void SetGfxCardVendor(const char*);      static void SetCPUName(const char*);
    static void SetServerIP(const char*);
    static void AddPlace(long ID);                  // push-front history ring + counter++
    static void RemovePlace(long ID);               // shift-out match + counter--
};
```
RbxDbgInfo.cpp: strncpy-with-explicit-NUL setters (MSVC 4996 suppressed), place-history shifting.

## Usage
Graphics init writes card name/driver/VRAM; network writes ServerIP; game join/leave calls AddPlace/RemovePlace. Crash dumps are then self-describing.

## Gotchas
- Plain global mutable state — no synchronization whatsoever; concurrent Set*/AddPlace can tear (acceptable because values are diagnostic).
- `RemovePlace` decrements PlaceCounter even if the ID is absent.
- Layout is ABI-frozen by the dump tooling: reordering/typing fields changes minidump interpretation.
