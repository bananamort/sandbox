// Security/RandomConstant.h -- RECONSTRUCTED SEED-ONLY SHIM
//
// The original file was stripped from the source drop entirely. An
// exhaustive survey of every surviving consumer (JunkCode.h, ApiSecurity.h,
// HackDefines.h, util/ProgramMemoryChecker.h, WindowsClient/RandomPadding.cpp,
// script/ScriptContext.h) shows they reference exactly ONE symbol from it:
// the per-build obfuscation seed RBX_BUILDSEED. No other identifier from
// this header is referenced anywhere in kept sources.
//
// This shim intentionally supplies ONLY that seed, as a fixed arbitrary
// literal. The original value was randomized per build; any value satisfies
// the consumers' semantics (compile-time selection of junk-NOP bodies and
// arithmetic mixing). NO cryptographic material is fabricated here: under
// architecture decision 4 (AGENTS.md) VM-internal anti-tamper is sanctioned
// for removal, so nothing in this header claims or provides tamper
// resistance -- it exists to keep feature-bearing translation units
// compiling unmodified.
//
// 0x5EED2016 is chosen arbitrarily (distinct from any special-case value
// such as 0); all consumer expressions keep their documented ranges:
//   JunkCode.h:      ((S%15 + 1)*__LINE__ + S) % 17            -> [0,16]
//   RandomPadding:   (N*(S%16) + __LINE__*N*(S%15) + N*N)%17   -> [0,16]
//   HackDefines.h:   LINE_RAND4 = (S&0x3FFFF)*__LINE__, LINE_RAND1 = ((S&0xFF)*(__COUNTER__+1))&0xFC

#ifndef RBX_SECURITY_RANDOM_CONSTANT_H
#define RBX_SECURITY_RANDOM_CONSTANT_H

#define RBX_BUILDSEED 0x5EED2016

#endif // RBX_SECURITY_RANDOM_CONSTANT_H
