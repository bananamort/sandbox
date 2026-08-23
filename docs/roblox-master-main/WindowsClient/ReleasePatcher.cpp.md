# WindowsClient/ReleasePatcher.cpp

## Purpose

Golden-hash patcher v2 — in-process rewriter of the client's own PE. Triggered only by the magic `-w` command line (Application.cpp:1046–1059: key must satisfy `(key % 0x01234567) == (0x0BADC0DE % 0x01234567)` AND `(key % 0x89ABCDEF) == (0x0BADC0DE % 0x89ABCDEF)`; then `protectVmpSections(); patchMain(); return false;`). It spawns a suspended copy of itself as a pristine `.text` reference, diffs, computes the security globals every other module consumes (`rbxTextBase/Size`, `rbxVmpBase/Size`, IAT bounds, NetPmc challenges, golden hash), plants `writecopyTrap` references in code caves, writes `goldMemHash.txt`, and emits a patched `<exe>.tmp` with the `.zero` section scrubbed. Every function is `__declspec(code_seg(".zero"))`; whole file compiled `/Os` via `#pragma optimize("s", on)` (restored at EOF). LOGGROUP `Zero`.

## API

Real signatures (anonymous namespace unless noted):

- `bool RBX::Security::patchMain()` — exported. `GetModuleFileName` → cli constant `" -w 10558381 "`; loop with `rerunCount = 2`: `CreateProcess(name, cli, ..., CREATE_SUSPENDED, ...)`; on success runs `createUpdatedExe(childInfo.hProcess)` — true ⇒ `rerunCount = 0`, false ⇒ `--rerunCount`; always `ResumeThread` + `WaitForSingleObject(childInfo.hProcess, INFINITE)`. The suspended child exists purely so its freshly-loaded `.text` can be ReadProcessMemory'd as reference.
- `bool createUpdatedExe(HANDLE hChild)` — the core:
  1. Own-section lookup: needs `.text`, `.rdata`, and `getVmpSections`. Precomputes `textEndNeg/textSizeNeg` as two's-complement negations for later obfuscated range checks.
  2. `ReadProcessMemory(hChild, textBase, textSize)` and byte-diffs against own `.text` ("WARNING — software breakpoints in .text will affect this"). Exactly ONE differing byte required: 0 ⇒ "This could actually happen and should cause a retry" (return false), >1 ⇒ fail.
  3. Splits `.text` around the diff site (`patchLoc &= ~3`, kUpperSlack=8, kLowerSlack=4) into rbxLower*/rbxUpper* ranges that exclude the one patched byte.
  4. Reads own exe file into RAM; maps `.rdata`/`.text` file offsets via `getFileOffsetOfVa`; `getImportThunkSection` locates the IAT by walking IMAGE_IMPORT_DESCRIPTORs of the **unmodified RobloxPlayerBetaRaw.exe** sibling (falls back to iatBase=rdataBase "gracefully" — that path was speculative).
  5. `VirtualProtect(.rdata, PAGE_READWRITE)`; a `SectionMapping(rdataFileRva, rdataFileBase)` then dual-writes (~20 calls to `set`) each `RBX::Security::rbx*` global BOTH into the RAM file image AND live process memory: rbxTextBase/Size, rbxLowerBase/Size, rbxUpperBase/Size, rbxRdataBase/Size, rbxIatBase/Size, rbxRdataNoIatBase/Size, rbxVmpBase/Size, rbxVmpPlain*, rbxVmpMutant*, rbxVmp0Misc*, rbxVmp1Misc*, rbxTextEndNeg, rbxTextSizeNeg.
  6. `VirtualProtect(.text, PAGE_EXECUTE_READWRITE)` + `addRefsToWcPage(...)` plants `mov [abs], eax` (opcode A3 + &RBX::writecopyTrap) into qualifying int3 caves — dual-written like step 5.
  7. NetPmc: 128 `NetPmcChallenge`s (`kNumChallenges`) built by `updateNetPmcPartial` over lower/upper/vmpPlain/vmpMutant (32 each: base/size slices, seed=i, result=`netPmcHashCheck`); indices shuffled (`std::random_shuffle`); results TEA-mixed (`updateNetPmcResult`: `teaEncrypt((uint64(key)<<32)|result)`) and XORed against `generateNetPmcKeys()` salsa stream; stored via mapping into `RBX::Security::kChallenges[randIdx[i]]`.
  8. Golden hash: `RBX::ProgramMemoryChecker pmc; rdataMapping.set(&rbxGoldHash, pmc.getLastGoldenHash());` then a second checker `pmcForFile` regenerates `RBX::pmcHash` post-edit; dumps `goldMemHash.txt` lines `"idx,value,failMask;"` for Hasher::kGoldHashStart/kGoldHashEnd/kRdataHash/kVmpPlainHash/kVmpMutantHash/kGoldHashStruct.
  9. Zeroes raw data of the `.zero` section in the file buffer and strips its CONTENT/READ/WRITE/EXECUTE characteristics flags.
  10. Rewrites extension in place: `strcpy_s(&name[nameSize-4], nameSize, ".tmp")` and `writeFile(name, fileBuffer)` ⇒ `<exe>.tmp` next to the original.
- Helpers: `getSections(void* pImageBase, SectionPtrVector&)` (-1 bad DOS, -2 bad NT); `getSectionInfo(sections,name,&base,&size)` (strncmp within 9-char PE name limit; VirtualAddress+module base; VirtualSize); `isStartOfSection(addr)` (32-zero heuristic over preceding 1–2 pages); `getVmpSections(sections,ranges,vmpBase,vmpSize)` (finds `.vmp0`; splits kVmpPlain at first page containing `"EncodePointer"` string; extends through `.vmp1`; second split at trailing-zeros page into kVmp0Misc+kVmpMutant; kVmp1Misc=.vmp1 whole; degenerate MemRange(base,4) fallbacks with FASTLOG "failed first/second split"); `readFile/writeFile` (binary ifstream/ofstream; writeFile returns −1 on failure); `getFileOffsetOfVa(sections,addr)`; `getImportThunkSection(sections,&iatBase,&iatSize)`; `updateNetPmcPartial(uintptr_t,size,NetPmcChallenge*)`; `updateNetPmcResult(uint32_t key, NetPmcChallenge*)`; `addRefsToWcPage(uintptr_t textBase, size_t textSize, uintptr_t textFileBase)` (scans for 8×CC padding preceded by C2/C3 function-end and not followed by hot-patch 0x8B, backs up 5 bytes, plants A3+abs both in file image and live memory); `class SectionMapping { SectionMapping(size_t loadedRva, size_t fileOffset); template<typename T> void set(const volatile T* virtualAddr, T& value); }` (comment on the live write: `T* evilAddr = const_cast<T*>(virtualAddr); *evilAddr = value;`).
- `struct MemRange { uintptr_t base; size_t size; MemRange(); MemRange(uintptr_t,size); static bool sizeCmpGreater(a,b); }`; `enum VmpRangeIdx { kVmpPlain=0, kVmp0Misc=1, kVmpMutant=2, kVmp1Misc=3 }`.

## Usage

This is the baseline provider for the binary-security constants used across the client: robloxHooks.cpp's AV-range checks read `rbxTextBase/rbxTextSize`; main.cpp's shutdown `VirtualProtect(RBX::Security::rbxVmpBase, rbxVmpSize, PAGE_EXECUTE_READWRITE, ...)` depends on this file having filled them; ClientReplicator.cpp queries `virtualQuery(&RBX::writecopyTrap, ...)` against the trap page planted here. In an unpatched Raw exe all these globals are meaningless.

## Gotchas

- The magic `-w 10558381` in patchMain satisfies the same congruence gate it runs under — the patcher re-launches itself in patch mode recursively until createUpdatedExe succeeds twice-attempted.
- Exactly-one-byte diff assumption ties the whole design to VMProtect's runtime self-modification pattern; any additional .text mutation (breakpoints, instrumentation!) aborts patching.
- `goldMemHash.txt` is written to the CURRENT DIRECTORY unconditionally — side artifact of every patch run.
- The child process created CREATE_SUSPENDED is resumed and waited on even after successful patching — it runs the full game-startup path briefly? No: it was launched with the same `-w` magic so it exits quickly after its own gate check returns false; still, WaitForSingleObject INFINITE means patching latency includes a full child lifetime.
- All pointer arithmetic is 32-bit (DWORD casts, A3 mov eax→moffs encoding): x86-only.
- Header TODO (verbatim): "determine if the PE can be modified after write to remove .zero entirely" — the current answer implemented here is zeroing raw bytes + clearing characteristics rather than removing the section header.
