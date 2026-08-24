# util/ProgramMemoryChecker.h

## Purpose
Anti-tamper self-integrity checker: incrementally hashes the process's own code/data sections (.text/.rdata/IAT/VMProtect sections) over stepped scans, detects API hooking of ntdll (NtQueryVirtualMemory / NtGetThreadContext), checks for "stealthedit" page-permission tricks, and exposes security tokens on failure. Windows-centric.

## Declared API
```cpp
namespace RBX::Hasher {
    enum HashSection { kGoldHashStart=0, kGoldHashEnd, kGoldHashRot, kRdataHash, kVmpPlainHash,
                       kVmpMutantHash, kIatHash, kMiscHash, kMsvcHash, kVmp0MiscHash,
                       kVmp1MiscHash, kNonGoldHashRot, kNumberOfSectionHashes /*12*/,
                       kGoldHashStruct=12, kAllHashStruct, kNumberOfHashes /*14*/ };
    // NOTE: ctor assumes this exact ordering of the items above.

    enum HashFailures {   // bitmask flags; no 1:1 relation with HashSection
        kVmp1MiscHashFail=1<<15, kVmp0MiscHashFail=1<<14, kVmpMutantHashFail=1<<13,
        kIatHashFail=1<<12, kGoldHashFail=1<<11, kNonceFail=1<<10, kAllHashStructFail=1<<9,
        kGoldHashStructFail=1<<8, kNonGoldHashRotFail=1<<7, kVmpPlainHashFail=1<<6,
        kMsvcHashFail=1<<5, kRdataHashFail=1<<4, kMiscHashFail=1<<3, kGoldHashRotFail=1<<2,
        kGoldHashEndFail=1<<1, kGoldHashStartFail=1<<0 };
    static const unsigned int kGoldHashMask = kGoldHashFail;
    static const unsigned int kDiffHashMask = /* all section-hash fail bits */;
    static const unsigned int kMovingHashMask = kNonceFail | kGoldHashRotFail | kNonGoldHashRotFail;
    static const unsigned int kPmcNonceGoodInc = 3692164867;
    static const unsigned int kPmcNonceBadInc  = 3692164869;
    static const unsigned int kPmcNonceGoodIncInv = 2880154539;
}

struct ScanRegion { char* startingAddress; unsigned int size;
    static ScanRegion getScanRegion(const char* moduleName, const char* RegionName); };

struct ScanRegionTest : ScanRegion { void* hashState; unsigned int lastHashValue;
    bool closeHash; bool useHashValueInStructHash; bool useHashAddrSizeInStructHash; };

struct PmcHashContainer { unsigned int nonce; std::vector<unsigned int> hash; ... };
extern PmcHashContainer pmcHash;

#if defined(_WIN32) && !defined(RBX_PLATFORM_DURANGO)
class NtApiCaller {   // hooked-API-safe wrappers over NtQueryVirtualMemory / NtGetThreadContext
public:
    DWORD virtualQuery(void* addr, MEMORY_BASIC_INFORMATION* info, size_t cb);
    DWORD getThreadContext(HANDLE thread, CONTEXT* ctx);
    bool isNtdllAddress(uintptr_t addr);
    NtApiCaller();
private:
    // hashes ntdll call-site bytes (5..32B window, end-token scan) into HeapValue-obscured state;
    // checkCaller() validates mov eax, imm32 prologue + byte-hash before invoking the API.
};
#endif

class ProgramMemoryChecker {
public:
    static const int kHASH_SEED_INIT = 42;
    static const int kAllDone = 0xCCCCCCCC;
    static const int kLuaLockOk = 0x1842783;
    static const int kLuaLockBad = 0;
    static const int kSteps = 30;
    static const unsigned int kBlock = 16;

    ProgramMemoryChecker();
    unsigned int bytesPerStep, currentRegion;
    const char* currentMemory;
    std::vector<ScanRegionTest> scanningRegions;
    unsigned int lastCompletedHash, lastGoldenHash;
    Time lastCompletedTime;

    unsigned int step();                       // advance incremental hashing one step
    unsigned int getLastCompletedHash() const;
    unsigned int getLastGoldenHash() const;
    Time getLastCompletedTime() const;
    void getLastHashes(PmcHashContainer::HashVector& outHashes) const;
    unsigned int hashScanningRegions(size_t regions = Hasher::kNumberOfHashes-2) const;
    unsigned int updateHsceHash();             // hash of HumanoidState::computeEvent
    unsigned int getHsceOrHash() const;   unsigned int getHsceAndHash() const;
    int isLuaLockOk() const;                   // check return code
    static bool areMemoryPagePermissionsSetupForHacking();  // stealthedit detection
};

#ifdef _WIN32
_declspec(align(8)) extern const char* const maskAddr;
_declspec(align(8)) extern const char* const goldHash;
unsigned int protectVmpSections();
#else
__attribute__((__aligned__(8))) extern const char* const maskAddr;
__attribute__((__aligned__(8))) extern const char* const goldHash;
#endif

namespace Security {
    extern volatile const size_t rbxGoldHash;
    extern volatile const uintptr_t rbxLowerBase;  extern volatile const size_t rbxLowerSize;   // lower .text
    extern volatile const uintptr_t rbxUpperBase;  extern volatile const size_t rbxUpperSize;   // upper .text
    extern volatile const uintptr_t rbxRdataBase;  extern volatile const size_t rbxRdataSize;   // .rdata
    extern volatile const uintptr_t rbxVmpBase;    extern volatile const size_t rbxVmpSize;     // vmp sections
    extern volatile const uintptr_t rbxIatBase;    extern volatile const size_t rbxIatSize;     // IAT
    extern volatile const uintptr_t rbxVmpPlainBase/Size;   // vmp plain .text
    extern volatile const uintptr_t rbxVmpMutantBase/Size;  // vmp mutation .text
    extern volatile const uintptr_t rbxVmp0MiscBase/Size;   // vmp misc 0
    extern volatile const uintptr_t rbxVmp1MiscBase/Size;   // vmp misc 1
    extern volatile const uintptr_t rbxRdataNoIatBase/Size; // .rdata sans IAT
}
```

## Gotchas
- Deeply Windows/x86-specific: reads raw instruction bytes (`mov eax, imm32` prologue check `B8 ?? ?? 00 00`), assumes ntdll calls < 32 bytes on x86/WoW64, `_declspec(align(8))`, NTAPI typedefs. Excluded for Durango (Xbox).
- HashSection ordering is load-bearing ("The PMC constructor assumes a specific ordering").
- Sensitive constants are deliberately adjacent pairs (kPmcNonceGoodInc vs BadInc differ by 2) and stored in HeapValue to resist scanning.
- The in-header comment explains stealthedit: pages set non-executable + exception-based redirect that bypasses hashing — hence `areMemoryPagePermissionsSetupForHacking`.
- `Tokens::apiToken.addFlagSafe(kNtApi*)` flags are set from inline code — see Security slice for token semantics.
- Comment credits a nonce inverse "supplied by irc user" — internal folklore, keep verbatim in mind when auditing.

## UNKNOWN
- Which binary these Security::rbx* section addresses are patched against (build-time generated constants).
