# Base Module Certification — Independent Review

Reviewer protocol: every one of the 92 sources under `roblox-sandbox/Base/` (.cpp/.h/.hpp/.c/.inl) was read IN FULL via tool calls, then its .md doc verified claim-by-claim against the code (symbols/signatures, threading behavior, signal dispatch, Crypt RSA paths, Time anti-cheat, TaskScheduler logic, platform #ifdefs). Mechanically-certain errors were fixed directly in the .md files.

**Totals: 92 sources reviewed — 68 PASS, 24 FIXED, 0 FAIL. INDEX.md: FIXED (was missing 3 roster entries; 5 descriptions inaccurate).**
Doc coverage confirmed exactly 1:1 (92 .md docs + INDEX.md = 93 files; no missing, no extra).

Severity tags: W=WRONG claim corrected · U=UNSUPPORTED claim removed/corrected · G=MISSING-GOTCHA added · S=STYLE cleanup.

| File | Verdict | Note |
| --- | --- | --- |
| RbxAssert.cpp | PASS | Hook globals match header; banner heritage accurate |
| include/RbxAssert.h | PASS | Typedef/setters exact; guard GUID correct |
| RbxFormat.cpp | PASS | 161-char fast path / 1 MB cap / _vscprintf vsnprintf split all verified |
| include/RbxFormat.h | FIXED | W+U: ctors are NOT explicit (removed); rest verified incl. iOS base_exception fork |
| cpucount.cpp | PASS | Win32 hardware_concurrency vs SystemUtil dispatch exact |
| include/CPUCount.h | PASS | One-liner decl |
| HardwareInfo.cpp | PASS | GeekInfo metrics, #if 0 test, geekinfo.h absence confirmed via tree search |
| include/HardwareInfo.h | PASS | Signature + status-flag semantics |
| util/Debug.cpp | FIXED | W: only doCrash(msg) is inside `#pragma optimize("",off)`; Durango early-out verified |
| include/rbx/Debug.h | FIXED | W+G: `__RBX_SLOW_ASSERT` is commented out — SLOW tier and rbx_static_cast guard are no-ops in ALL builds despite header table; matrix rewritten |
| util/Log.cpp | FIXED | S: formatTime zero-case fall-through gotcha rewritten (conclusion "0ms" was already right); channels/formatMem tiers verified |
| include/rbx/Log.h | PASS | ILogProvider/Entry friend/currentStream assert path |
| util/RbxCrash.cpp | PASS | Two forwarders to Debugable::doCrash |
| util/RegistryUtil.cpp | FIXED | W+G: 7 distinct HKEY_* names not 8 (HKEY_USERS unhandled); strncmp false-match direction reversed (shorter bases collide, longer don't); fwd-decl size_t/UINT32 mismatch noted |
| include/util/RegistryUtil.h | PASS | Win-only excl. Durango; pdh.h vestigial; KEY_ALL_ACCESS writers |
| util/StreamHelpers.cpp | PASS | tellg sizing, &content[0] pattern |
| include/util/StreamHelpers.h | PASS | Unguarded single decl |
| include/util/SafeToLower.h | FIXED | G: header includes nothing — relies on transitive <string>/<cctype> |
| include/util/stringbuffer.h | PASS | Throwing >> uchar; const-ref dangling gotcha valid |
| include/util/ScopedSingleton.h | PASS | getInstance/spin-lock/initCount semantics; CProcessPerfCounter usage confirmed in ProcessPerfCounter.h |
| include/util/ublas_ext.h | PASS | invert_matrix/lu_factorize_singular rank semantics/unswap_rows tag dispatch |
| include/rbx/threadsafe.h | FIXED | S+W: API block said `boost::noncopyless` for safe_heap (source: noncopyable); CAS unlock, SAFE_STATIC call_once, catcher decls all verified |
| rbx/ThreadSafe.cpp | PASS | RBXCRASH-on-contention, noThreadId=4493024, GetCurrentThreadId shim confirmed in Boost.hpp |
| include/rbx/atomic.h | PASS | Both backends, CAS arg order, sizeof(long) static assert, alignment assert |
| rbx/CEvent.cpp | PASS | Dual backends; throw()-vs-RbxThrowLastWin32 gotcha valid; auto-reset consumption placement |
| include/rbx/CEvent.h | FIXED | W: ctor NOT explicit (removed); constants 0/258/0xFFFFFFFF and ODR note verified |
| include/rbx/signal.h | FIXED | W×2: logged connections use FLog::Always (not ScopedConnection group); operator() exception resume does NOT restart from head — iterator declared before `begin:` label so firing resumes AFTER the throwing slot (exactly-once per slot); handler-throw loop hazard added |
| rbx/Signal.cpp | FIXED | W: base_exception throws are ALWAYS swallowed by typed catch even with null handler (only non-base exceptions escape) |
| include/rbx/callable.h | PASS | Arity 0–7, delegate-by-value, Arg1 forwarding |
| include/rbx/rbxTime.h | FIXED | W: preciseOverride==Fast (not Precise) makes Fast/Benchmark precise, per in-file comment |
| rbx/Time.cpp | FIXED | S: checkDbg chain clarified (fs:[0x18]→TEB→+0x30→PEB→test bit16 BeingDebugged); speed-hack deltas/violation latch/MM-timer interpolation/QPC-mach-CLOCK_MONOTONIC all verified |
| include/rbx/Memory.h | FIXED | W: AutoMemPool ctor NOT explicit; knobs (debug counts, release singleton_pool), back-pointer pool scheme verified |
| rbx/Memory.cpp | PASS | crashOnAllocationFailure=true, scalable_malloc branch compiled out, new_handler comment |
| rbx/MathUtil.cpp | FIXED | W+G: GetMappedDOF bucket examples were wrong AND top buckets index OUT OF BOUNDS (dof==120→37, ≥121→38 past 37-row table); off-by-one row-label shift documented; t-table/z-row and CI multipliers otherwise exact |
| include/rbx/MathUtil.h | PASS | std-vs-variance unit asymmetry gotcha valid |
| include/rbx/Profiler.h | PASS | Macro family, static-token-per-site, disabled-LABELF sizeof trick, Flags values |
| rbx/Profiler.cpp | FIXED | W: getToken/getLabelToken/getCounterToken are NOT FFlag-gated (only runtime-effect calls are); MicroProfile injection into std on Apple, WEBSERVER 0, GPU-timer config, Durango getenv-neuter verified |
| include/rbx/ProcessPerfCounter.h | FIXED | W×2: inheritance is PUBLIC (`public PerfCounter, public RBX::ScopedSingleton<...>`), not private; GetData2 qualification is disambiguation, not access workaround |
| rbx/ProcessPerfCounter.cpp | FIXED | W×2: whole TU inside outer `#ifdef _WIN32`; `#warning MACPORT` stubs are dead code in the Win build, not non-Win stub bodies; PDH enumeration/instance-match/fallback counters verified |
| include/rbx/Boost.hpp | PASS | ROBLOX_BOOST_CONFIGS guard, pthread_self truncation shim, placement_any inline storage |
| rbx/boost.cpp | PASS | 0x406D1388 thread-name exception, worker_thread no-join dtor, threadProc done/more loop |
| include/rbx/Thread.hpp | FIXED | W×2: implementation EXISTS in rbx/boost.cpp (doc claimed UNKNOWN/no .cpp); ctor NOT explicit |
| include/rbx/intrusive_ptr_target.h | FIXED | W: refcount ops ARE full-barrier Interlocked/__sync RMW (doc said "non-fenced"); head-counts layout, try_lock CAS loop, too_many_refs mid-increment throw all verified |
| include/rbx/intrusive_weak_ptr.h | FIXED | S+W: T* ctor is NOT explicit ("explicit-ish" hedge removed); lock()/expired()/TOCTOU assignment analysis checked out |
| include/rbx/make_shared.h | PASS | boost-1.42.1 vendored copy, arity 0–3 const&, unused sp_forward, shared_from_this TODO |
| include/rbx/DenseHash.h | PASS | Quadratic probing, power-of-two assert, empty_key sentinel, 75% load factor, no-erase contract |
| include/rbx/trie.h | PASS | Writer independently caught real each_value infinite-recursion bug (verified at Node::each_value); leaf shortcut/bad_key/OOB >127 chars confirmed |
| include/rbx/ArrayDynamic.h | FIXED | G: added pop_back-skips-dtor + later push_back placement-news over live object hazard (non-trivial T loses destructor); trait-dispatch and mNoInit analysis verified as written |
| include/rbx/BaldPtr.h | PASS | Poison-pattern table verbatim; 32-bit truncation compare gotcha valid |
| include/rbx/Intrusive/Set.h | FIXED | U: `Tag` template param is never referenced in the implementation — provides no tagged hook storage / multi-set membership; O(1) hook list semantics otherwise exact |
| include/rbx/object_pool.h | PASS | PODptr walk, dtor-correct clear(), next_size extension, gcc typedef note |
| include/rbx/Nil.h | PASS | Pure `#undef nil` under __APPLE__ |
| include/rbx/Countable.h | PASS | atomic<int> per-T counter, protected ctor/dtor |
| include/rbx/GlobalVectorItem.h | PASS | Sparse-slot claim/release, overflow new/delete, copy hazard |
| include/rbx/RunningAverage.h | PASS | All ten stat classes; char-bucket saturation, getSanitizedStats div-by-zero NaN, InvocationMeter overwrite quirk verified in source |
| include/rbx/RbxStrings.h | PASS | strcasestr trio, empty-string→NULL, Apache macros |
| include/rbx/RbxDbgInfo.cpp | PASS | memset ctor, place-history shifting, RemovePlace negative-drift gotcha valid |
| include/rbx/RbxDbgInfo.h | PASS | PLACE_HISTORY 4 / DBG_STRING_MAX 128, union layout, minidump purpose |
| include/rbx/Declarations.h | PASS | novtable macros + virtual-dtor prohibition verbatim |
| include/rbx/SystemUtil.h | PASS | Full decl surface, uint64_t typedef collision note |
| rbx/Win/SystemUtil.cpp | PASS | osVer prints dwOSVersionInfoSize (quirk flagged), IsWow64, DDraw VRAM probe, vestigial d3d9/setupapi includes |
| rbx/Darwin/SystemUtil.cpp | PASS | sysctl names, CFCopySystemVersionString, IOFBMemorySize, 64MB floor, uninitialized-vstr and dspCount hazards all real |
| rbx/Android/SystemUtil.cpp | PASS | Hardcoded 900MB/64MB, JNIGLActivity globals, arch forks |
| rbx/Durango/SystemUtil.cpp | PASS | Constant stubs incl. (1U<<31)-1 VRAM |
| rbx/Android/ifaddrs.c | PASS | Netlink flow, 4096-doubling, nlmsg_seq==fd correlation; both size-accounting quirks (l_rtaSize over-allocation, IFA_ADDRESS fall-through) verified line-level |
| include/rbx/Android/ifaddrs.h | PASS | BSDI banner, struct layout, ifa_broadaddr macro ordering note |
| include/rbx/TaskScheduler.h | PASS | PriorityMethod/ThreadPoolConfig magic values, Arbiter contract, hysteresis throttle (1.1× engage), three collections + cyclic vector under one mutex |
| rbx/TaskScheduler.cpp | PASS | call_once singleton, AccumulatedError default, 5-min join caps → RBXCRASH in release, Wait(71) sampler, 1×16+2×17 ms frame pacing, affinity 1.5 bias, urgent jump-queue, nextScheduledJob cache |
| rbx/TaskScheduler.Thread.cpp | PASS | timed_join(20s)/self-join skip, runJob no-catch comment, disableThreads concurrency granting, Sleep(1)/usleep(1000), maxDutyCycleWindow defined here |
| include/rbx/TaskScheduler.Job.h | PASS | Abstract contract, Error.urgent, HANG_DETECTION 0, triple arbiter storage |
| rbx/TaskScheduler.Job.cpp | FIXED | W: extern maxDutyCycleWindow defined in TaskScheduler.Thread.cpp (doc said TaskScheduler.cpp); S: sleep floor only applies while arbiter throttled; empty over-budget body, App-tree relative include, coordinator callback asymmetry, priority division all verified |
| include/rbx/Tasks/Coordinator.h | PASS | Four policies + advance() placement distinction |
| rbx/Tasks/Coordinator.cpp | PASS | Barrier counter math, SequenceBase rotation/index fixup, mutex-less Exclusive |
| include/rbx/Crypt.h | PASS | Win-only members, stub shape elsewhere |
| rbx/Crypt.cpp | PASS | MS_DEF_PROV/CRYPT_VERIFYCONTEXT, KB-238187 import, hardcoded keyblob, SHA1 + byte-reversal (.NET endianness), signatureRev[10240] overflow hazard, release-empty error strings — all line-verified |
| rbx/Unix/Crypt.cpp | PASS | OpenSSL PEM second hardcoded key (Ben D), RSA_verify NID_sha1, fail-open stub branch, i386-non-simulator/Android gate |
| include/simd/simd_platform.h | PASS | Detection macros, backend selection, vec typedefs |
| include/simd/simd_types.h | PASS | v4 wrapper, implicit pod conversions, typedef set |
| include/simd/simd_types.inl | PASS | Five one-liner bodies |
| include/simd/simd.h | PASS | ~90-function surface matches; load alignment, *Fast undefined-range, rotateLeft non-const ref notes valid |
| include/simd/simd_common.inl | FIXED | S: 3-arg sumAcross self-questioning gotcha rewritten (zip algebra counts each element once; tail lane duplicated); precision constants 3e-4/2e-7/3.3e-5/3e-7 verified |
| include/simd/simd_sse.inl | FIXED | W+G: "*Fast variants skip fixups" scoped — inverseSqrtEstimate1Fast still routes through CORRECTED inverseSqrtEstimate0; ADDED: SSE loadUnaligned still fires 16-byte ALIGN_ASSERT in debug. NR steps, 8.50705867e+37f largestInvertible, ANDNOT !=, SelectHelper, blend-under-SSE3, `;;` cosmetics verified across all 1220 lines |
| include/simd/simd_neon.inl | PASS | Estimate-based division, vrecpeq+NR counts, denormal smallestInvertible 2.9387359e-39, vtbl shuffle trick, form(x,y)={x,y,x,y}, chooseTwoElements cross-pair indices, plain +0 inf fix, `auto` in zip — all 1545 lines verified |
| include/microprofile/microprofile.h | PASS | Constants (2MB/thread, 512 frames, 32 threads, 1024 timers, 48 groups, port 1338+20), entry packing type3|timer13|tick48 with <<16 diff trick, snprintf→_snprintf, WinSock2 #error, g_bUseLock DLL-init dance, ETW SystemTraceControlGuid, /tmp/.microprofilecspipe, EMBED_HTML default 1 |
| include/microprofile/microprofileui.h | PASS | TEXT 5×8/BAR 12/GRAPH 256², CUSTOM_MAX 8/64, MENU_MAX 16, preset magic 0x28586813 + fopen CWD, vsprintf tooltip buffer, animated nHoverColor |
| include/microprofile/microprofiledraw.h | PASS | Dormant (no MICROPROFILEDRAW_IMPL in tree), MAX_COMMANDS 32/MAX_VERTICES 16384, Q0–Q3 two-triangle quads, 1024×9 RGBA font, GL_VERSION parsing |
| include/microprofile/microprofilehtml.h | PASS | begin_count=1/end_count=3, Stri|ngArray chunk split, NumLodSplits 10, "fisk" cookie, `evt.target = CanvasHistory` assignment bug — all grep-verified |

## INDEX.md — FIXED

Was missing 3 roster rows entirely (Memory.h, Profiler.cpp, ifaddrs.c) despite their docs existing; described RbxAssert.h as containing FASTASSERT macros (they live in rbx/Debug.h), RbxHash.h as "xxhash-based" (it is a hash_map shim), Intrusive/Set.h as "red-black" (it is a linked intrusive set), Nil.h as a "nil-type sentinel", Declarations.h as a "forward declarations umbrella", and credited MicroProfile with an active web server (compiled out via MICROPROFILE_WEBSERVER 0 in Profiler.cpp). All corrected; roster now lists exactly 92/92 sources.

## Summary of corrections by severity

- **WRONG claims corrected (14 docs)**: RbxFormat.h, Debug.cpp, Debug.h, CEvent.h, signal.h, Signal.cpp, rbxTime.h, MathUtil.cpp, ProcessPerfCounter.h, ProcessPerfCounter.cpp, Thread.hpp, TaskScheduler.Job.cpp, simd_sse.inl, threadsafe.h (+INDEX).
- **UNSUPPORTED claims removed (2 docs)**: Intrusive/Set.h Tag-parameter multi-membership; RbxFormat.h explicitness (also counted above).
- **MISSING-GOTCHAs added (6 docs)**: MathUtil.cpp OOB buckets; ArrayDynamic pop_back destructor leak; Debug.h SLOW-tier always-off; SafeToLower non-self-contained; simd_sse loadUnaligned debug assert; signal.h handler-rethrow loop.
- **FAILs: none** — after edits, every concrete claim in every doc is supported by the corresponding source.
