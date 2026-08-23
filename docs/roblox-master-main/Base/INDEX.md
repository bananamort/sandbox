# Base Module Index

Base is the engine's foundation library: everything above it links against it and almost every other module includes it first. It contains the platform abstraction and time sources (`RBX::Time` over QPC/mach/CLOCK_MONOTONIC plus the Windows multimedia-timer Fast clock with speed-hack/debugger detection), the cooperative job scheduler (`TaskScheduler`/`Job`/`Thread`, arbiters, `Tasks::Coordinator` policies, cyclic-executive frame pacing), concurrency primitives (`rbx::signal` slots-and-slots events built on intrusive refcounts, atomics, `CEvent`, spin mutexes, debug-only "concurrency catcher" crash locks), memory utilities (custom allocators, object pools, dense hash/intrusive containers), diagnostics (FastLog channels, `RBXASSERT` hooks, `RbxDbgInfo` crash metadata, PDH perf counters), trust anchors for content verification (`RBX::Crypt` — two hardcoded RSA public keys, CryptoAPI on Win32 and OpenSSL on Apple/Android), and vendored support libraries: boost glue (`Boost.hpp` umbrella with global `shared_ptr` usings, `placement_any`, thread-naming shims), a hand-written SSE/NEON SIMD layer, MicroProfile (in-engine profiler with web server, ETW/DTrace context-switch tracing, GPU timers), and small BSD/Android shims (`ifaddrs`). Recurring patterns: `RBX::base_exception` as the base caught by signal slot dispatch; `SAFE_STATIC`/`SAFE_HEAP_STATIC` lazy statics to survive shutdown-order; platform forks via per-OS directories (`rbx/{Win,Darwin,Android,Durango}/`); UNKNOWN-marker discipline applies where behavior could not be verified from source alone.

## Roster

| File | Purpose |
| --- | --- |
| Base/RbxAssert.cpp | Storage for assertion/failure hook globals (G3D heritage) |
| Base/RbxFormat.cpp | printf-family formatting core (`RBX::format`) |
| Base/HardwareInfo.cpp | CPU topology via GeekInfo lib (geekinfo.h missing from tree) |
| Base/cpucount.cpp | `RbxTotalUsableCoreCount` — Win32 hardware_concurrency vs SystemUtil |
| Base/include/CPUCount.h | Declares RbxTotalUsableCoreCount |
| Base/include/HardwareInfo.h | Declares RBX::CPUCount topology query |
| Base/include/RbxAssert.h | FASTASSERT macros + AssertionHook type |
| Base/include/RbxBase.h | stdint include + MSVC _DEBUG/release build guards |
| Base/include/RbxFormat.h | RBX::format declarations |
| Base/include/RbxHash.h | xxhash-based hashing helpers |
| Base/include/RbxPlatform.h | windows.h hygiene umbrella |
| Base/include/SelectState.h | selection-state enum helper |
| Base/include/XStudioBuild.h | studio build configuration flags |
| Base/rbx/Time.cpp | Time implementation: tick sources, MM-timer Fast clock, anti-cheat checks |
| Base/rbx/ThreadSafe.cpp | Concurrency-catcher crash locks implementations |
| Base/rbx/CEvent.cpp | Win32/event cross-platform condition event |
| Base/rbx/TaskScheduler.cpp | Scheduler singleton: add/remove/join, findJobToRun, cyclic executive |
| Base/rbx/TaskScheduler.Job.cpp | Job state machine, cadence math, priority computation |
| Base/rbx/TaskScheduler.Thread.cpp | Worker Thread class, main loop, thread pool management |
| Base/rbx/Darwin/SystemUtil.cpp | macOS/iOS sysctl/Mach/IOKit hardware inventory |
| Base/rbx/Android/SystemUtil.cpp | Android sysconf + hardcoded RAM/GPU values |
| Base/rbx/Win/SystemUtil.cpp | Windows GetVersionEx/IsWow64/DDirect video memory |
| Base/rbx/Durango/SystemUtil.cpp | Xbox One constant stubs |
| Base/rbx/ProcessPerfCounter.cpp | PDH process counters (CPU/mem/pagefaults) |
| Base/rbx/boost.cpp | isFinite, thread naming, worker_thread |
| Base/rbx/Signal.cpp | connection impls + slot_exception_handler global |
| Base/rbx/MathUtil.cpp | t-distribution outlier table + confidence intervals |
| Base/rbx/Crypt.cpp | Win32 CryptoAPI RSA signature verification (hardcoded key) |
| Base/rbx/Unix/Crypt.cpp | OpenSSL RSA signature verification (second hardcoded key) |
| Base/rbx/Memory.cpp | Custom allocator hooks/tracking |
| Base/rbx/Tasks/Coordinator.cpp | Barrier/Sequence/Exclusive coordinator policies |
| Base/include/rbx/rbxTime.h | RBX::Time/Interval/Timer/RemoteTime API |
| Base/include/rbx/Thread.hpp | worker_thread + thread_specific_reference decls |
| Base/include/rbx/threadsafe.h | spin mutex, concurrency catchers, SAFE_STATIC macros |
| Base/include/rbx/CEvent.h | CEvent condition-event class |
| Base/include/rbx/atomic.h | rbx::atomic<T> primitives |
| Base/include/rbx/trie.h | trie container |
| Base/include/rbx/DenseHash.h | open-addressing hash map |
| Base/include/rbx/BaldPtr.h | non-owning raw pointer wrapper |
| Base/include/rbx/ArrayDynamic.h | dynamic array container |
| Base/include/rbx/Intrusive/Set.h | intrusive red-black set |
| Base/include/rbx/Nil.h | nil-type sentinel |
| Base/include/rbx/make_shared.h | boost make_shared shim |
| Base/include/rbx/intrusive_weak_ptr.h | lock-free weak pointer |
| Base/include/rbx/intrusive_ptr_target.h | refcounted base template |
| Base/include/rbx/object_pool.h | fixed-size object pool |
| Base/include/rbx/Countable.h | Diagnostics::Countable instance tracking |
| Base/include/rbx/GlobalVectorItem.h | global vector registry item |
| Base/include/rbx/Log.h | ILogProvider + Log channel declarations |
| Base/include/rbx/Debug.h | RBXASSERT/RBXCRASH/FASTLOG-facing debug decls |
| Base/include/rbx/RbxDbgInfo.h | crash-dump debug info struct (place IDs, HW strings) |
| Base/include/rbx/Declarations.h | forward declarations umbrella |
| Base/include/rbx/MathUtil.h | Confidence enum + outlier/interval decls |
| Base/include/rbx/Crypt.h | RBX::Crypt RAII signature verifier decl |
| Base/include/rbx/SystemUtil.h | SystemUtil hardware/OS inventory decls |
| Base/include/rbx/Android/ifaddrs.h | BSD struct ifaddrs shim header |
| Base/include/rbx/signal.h | rbx::signal/remote_signal/connection event system |
| Base/include/rbx/callable.h | icallable/callable delegate mixins for signals |
| Base/include/rbx/Boost.hpp | boost umbrella, portability shims, placement_any |
| Base/include/rbx/TaskScheduler.h | TaskScheduler singleton + Arbiters decl |
| Base/include/rbx/TaskScheduler.Job.h | Abstract Job unit of scheduler work |
| Base/include/rbx/Tasks/Coordinator.h | Coordinator policies decl |
| Base/include/rbx/Profiler.h | Profiler facade + RBXPROFILER_* macros |
| Base/include/rbx/ProcessPerfCounter.h | PDH wrapper classes decl |
| Base/include/rbx/RunningAverage.h | lerp/window averages, duty cycles, throttlers, meters |
| Base/include/rbx/RbxStrings.h | Rbx_strcasestr case-insensitive search |
| Base/include/rbx/RbxDbgInfo.cpp | RbxDbgInfo singleton implementation |
| Base/util/RbxCrash.cpp | Crash handler/dumper entry points |
| Base/util/Debug.cpp | Debug assert/report implementations |
| Base/util/StreamHelpers.cpp | readStreamIntoString slurp helper |
| Base/util/Log.cpp | Text log file impl + FLog channel definitions |
| Base/util/RegistryUtil.cpp | Windows registry string-key facade |
| Base/include/util/StreamHelpers.h | readStreamIntoString decl |
| Base/include/util/SafeToLower.h | byte-wise in-place lowercase |
| Base/include/util/RegistryUtil.h | RegistryUtil decl |
| Base/include/util/ScopedSingleton.h | weak_ptr-scoped lazy singleton |
| Base/include/util/stringbuffer.h | StringRead/StringWriteBuffer byte codecs |
| Base/include/util/ublas_ext.h | uBLAS LU inversion + rank-revealing factorization |
| Base/include/simd/simd_platform.h | Arch detection + intrinsic typedefs |
| Base/include/simd/simd_types.h | v4<ElemType> wrapper + typedefs |
| Base/include/simd/simd_types.inl | v4 inline bodies |
| Base/include/simd/simd_common.inl | Backend-independent transposes/gathers/sums |
| Base/include/simd/simd_sse.inl | SSE2(-SSE4) backend |
| Base/include/simd/simd_neon.inl | ARM NEON backend |
| Base/include/simd/simd.h | Full SIMD API surface |
| Base/include/microprofile/microprofile.h | Vendored profiler core (impl host) |
| Base/include/microprofile/microprofileui.h | Vendored on-screen UI (impl host) |
| Base/include/microprofile/microprofiledraw.h | Optional GL3 renderer (unused by Roblox bridge) |
| Base/include/microprofile/microprofilehtml.h | Embedded HTML/JS viewer data |

REMAINING: none
