# util/RbxCrash.cpp

## Purpose
Two-line translation unit defining the global crash entry points `RBXCRASH()` / `RBXCRASH(const char*)` as forwarders to `RBX::Debugable::doCrash`.

## API
```cpp
void RBXCRASH();                       // -> Debugable::doCrash()
void RBXCRASH(const char* message);    // -> Debugable::doCrash(message)
```

## Usage
Called from allocator OOM paths, concurrency catchers, task scheduler invariant violations — anywhere the process must stop immediately for diagnosability.

## Gotchas
- Actual behavior (DebugBreak vs abort vs Durango no-op) is decided in util/Debug.cpp; see that doc.
