# App/include/script/LuaSignalBridge.h

## Purpose

Declares the Lua bindings for RBX signals/events: `RBX::Lua::EventInstance` (a descriptor + weak source pair identifying an event), `EventBridge` (exposes events to Lua with `connect`/`wait`), and `SignalConnectionBridge` (wraps a live `rbx::signals::connection` with `disconnect`).

## Declared API

- `struct RBX::Lua::EventInstance`
  - Fields: `const Reflection::EventDescriptor* descriptor;` `weak_ptr<Instance> source;`
  - Inline `bool operator==(const EventInstance& other) const;` — descriptors compared by pointer; sources compared only after both weak pointers lock successfully (either side expired → not equal).
- `template<> int Bridge<EventInstance>::on_tostring(const EventInstance& object, lua_State* L);` — specialization declaration.
- `class RBX::Lua::EventBridge : public Bridge<EventInstance>`
  - `static int connect(lua_State* L);`
  - `static int wait(lua_State* L);`
- `class RBX::Lua::SignalConnectionBridge : public Bridge<rbx::signals::connection>`
  - `friend class Bridge<rbx::signals::connection>;`
  - Private: `static int disconnect(lua_State* L);`

## Usage notes

- Includes `Lua/LuaBridge.h`, `reflection/object.h`, and `Reflection/Event.h`.
- Behavior implementations are in the certified App/script module.

## Gotchas

- The header's own comment: weak pointers are used so holding an event reference does NOT lock the event's source instance; if the source is collected, connecting returns an empty connection rather than erroring.
- `operator==` locks both weak_ptrs on every comparison — O(2 atomic refcounts) per equality check inside bridge bookkeeping.
- An expired-source EventInstance compares unequal to everything, including another expired one.
