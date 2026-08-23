# ThreadSafe.cpp

## Purpose
Implementations for the "concurrency catcher" debug locks declared in rbx/threadsafe.h (documented separately): atomic-flag locks that CRASH the process on double-acquire instead of blocking — they exist to surface threading violations, not to serialize. Three flavors: plain (non-reentrant), reentrant (same-thread re-entry allowed via GetCurrentThreadId), and read/write (counted readers vs single writer).

## API
```cpp
RBX::concurrency_catcher::scoped_lock::scoped_lock(concurrency_catcher&);   // swap(locked)!=unlocked -> RBXCRASH
RBX::concurrency_catcher::scoped_lock::~scoped_lock();                      // swap(unlocked)
const unsigned long RBX::reentrant_concurrency_catcher::noThreadId = 4493024;
RBX::reentrant_concurrency_catcher::scoped_lock::scoped_lock(...);          // same-thread -> isChild, no flag
RBX::reentrant_concurrency_catcher::scoped_lock::~scoped_lock();            // non-child: reset threadId + flag
RBX::readwrite_concurrency_catcher::scoped_write_request::{ctor,dtor};      // write_requested flag + read_requested==0 asserts
RBX::readwrite_concurrency_catcher::scoped_read_request::{ctor,dtor};       // ++/-- read_requested with asserts
```

## Usage
Used in DEBUG builds around DataModel/instance mutation paths to catch cross-thread access violations early (see comment "Place this code around tasks that write to a DataModel"). Not a real mutex — zero contention handling.

## Gotchas
- RBXCRASH on contention is the FEATURE: shipping this in release would crash on benign races.
- reentrant flavor: threadId is only reset by the non-child dtor; nested child dtors leave it intact — correct nesting required or the flag sticks locked.
- readwrite flavor asserts instead of crashing (comments say "should be a RBXCRASH()") — softer failure by design or by oversight (UNKNOWN).
- GetCurrentThreadId on non-Windows comes from the Boost.hpp pthread_self-truncation shim.
