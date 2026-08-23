# WindowsClient/RobloxGoldenHashPatcher/main.cpp

## Purpose

The golden-hash patcher **version 1** — a standalone console tool (own .sln/.vcxproj) that ReleasePatcher.cpp's header calls "an external program". It bootstraps the then-unpatched client: runs the exe with the magic `-w 195936478` option (comment: "the magic number = 0x0BADC0DE") plus `--globalBasicSettingsPath <dumpfile>` to make the client dump its own `.text` section + trailing golden-hash pair to disk, locates the VMProtect-varying DWORD and the obfuscated magic-string anchors inside the PE, patches them in-place, then verifies the recomputed golden hash round-trips. Version 2 (WindowsClient/ReleasePatcher.cpp) superseded this by doing everything in-process.

## API

Real signatures:

- `int main(int argc, char** argv)` — usage `Patcher <Dir of exe> <Name of exe>`. Six steps:
  1. `system(<exe> -w 195936478 --globalBasicSettingsPath buffer1.bin)`; read buffer1.bin. Layout: raw `.text` bytes followed by two ints — "Golden Hash, calculated" (offset codeLen) and "Golden Hash to compare" (codeLen+4); `kPadLen = sizeof(int)+sizeof(int)`.
  2. Repeat up to 3× with buffer2.bin, byte-diffing against buffer1 across codeLen: more than one differing site (beyond 4 bytes) ⇒ "Multiple places have differences." (comment: "make sure ASLR is disabled"); zero differences after 3 tries ⇒ fail. Records `diffLocation = i & 0xFFFFFFFC`.
  3. Read the exe file itself; scan for four unique magic anchor strings: `"1(m$n9.[?y\`z+f : a&Rn5<d*nGD9.@93Dr7&"` → maskAddr, `"1N9S6,*%D-&m8sH%/~m _qvZ=&be*db elI^s"` → goldHash, plus two 23-byte binary arrays → imageBase/imageSize ("Added the base/size to the patcher"). Non-unique or missing anchors fail (image info failure only downgrades `useImageInfo=false`). Anchors are aligned up: `(offset | 7) + 1` — "VC++ doesn't align strings in all cases"; image offsets back up by sizeof(size_t).
  4. Patch pass 1: write diffLocation into the aligned maskAddr slot; if useImageInfo also write `imageBase = 0x00401000` and `imageSize = codeLen`; rewrite the exe.
  5. Re-run with buffer2.bin; read the freshly calculated goldHashValue from codeLen offset.
  6. Patch pass 2: write goldHashValue into the aligned goldHash slot, rewrite, run again dumping buffer3.bin; require `goldHashValue == cmpBufferGold[codeLen..]` AND `== cmpBufferGold[codeLen+4..]` else "Error, golden hash didn't work!". Exit 0.
- Helpers: `int readFile(const char*, std::vector<char>&)` (−1 on open failure); `int writeFile(const char*, const std::vector<char>&)` (opens with `std::ifstream::binary` mode flag on an ofstream — verbatim bug that happens to work since the value equals the desired ios_base::binary bit pattern... actually it compiles because the numeric constant matches; flagged as quirk); `std::string getFileName(sysPath, fileName)` joins with `\`; `std::string setCommand(...)` builds `<path>\<exe> -w 195936478 --globalBasicSettingsPath <file>`; `size_t findAndSetOffset(const std::vector<char>&, size_t idx, const char* search, size_t& location)` — strcmp-at-offset uniqueness tracker (returns −1 on duplicate).

## Usage

Build-system context: separate RobloxGoldenHashPatcher.sln/vcxproj; retarget_v143 touched its vcxproj too but it is not part of the main client build. Historically run once per release before shipping; today it documents how the magic `-w` gate and the dump path (`--globalBasicSettingsPath`) were consumed by the shipped client.

## Gotchas

- The `-w 195936478` literal here is a DIFFERENT magic than ReleasePatcher's self-relaunch (` -w 10558381 `) — both satisfy Application.cpp's congruence test mod 0x01234567/0x89ABCDEF (0x0BADC0DE family), i.e., multiple valid keys exist.
- Requires the target build to still contain the dump-mode handler for `--globalBasicSettingsPath` writing `<file>` = `.text` + 2 ints — UNKNOWN whether that code path survived pruning in App/ sources; if pruned, this tool cannot work against the sandbox tree.
- `writeFile` uses `std::ifstream::binary` as the ofstream openmode constant — same numeric value as ios_base::binary so behavior is accidentally correct.
- All writes go through `system()` — the patched exe is executed up to 5 times per patch session; each run must exit quickly via the magic-key branch.
- Assumes non-ASLR image base 0x00401000 and 32-bit size_t.
