# App/script/LuaVM.cpp

## Purpose

Small anti-tamper translation unit for the Lua VM: defines `lua_vmhooked_handler`, the callback invoked when the patched VM detects that a `lua_*` API entry point has been patched/hooked at runtime, and (under RBX_SECURE_DOUBLE) the XOR-mask initialization for obfuscated doubles. Also declares the .text-section scan bounds used by the security patch-detection machinery.

## API

- `void lua_vmhooked_handler(lua_State* L)` — wraps `VMProtectBeginVirtualization(NULL)` / `VMProtectEnd()`, sets fast flag `RBX::Tokens::sendStatsToken.addFlagFast(HATE_LUA_VM_HOOKED)` and, if a DataModel is reachable via `RobloxExtraSpace::get(L)->context()`, adds hack flag `HATE_LUA_VM_HOOKED`.
- `#ifdef RBX_SECURE_DOUBLE`: `RBX_ALIGN(16) int LuaSecureDouble::luaXorMask[4];` and `void LuaSecureDouble::initDouble()` — generates a random 32-bit mask (`(rand() << 16) | rand()`, retried until at least one of the top 7 exponent bits would flip) and fills all four mask ints with it.
- `#ifdef _WIN32`: `namespace RBX { namespace Security { volatile const uintptr_t rbxTextBase = 0x00400000; volatile const size_t rbxTextSize = 0xFFFFFFFF; } }` — patch-scan defaults over "All of the .text".

## Usage

`lua_vmhooked_handler` is wired up by the patched VM internals (the custom luaconf.h/VM layer referenced via `#include "luaconf.h"`), not by anything else in this directory; the comment notes it fires if someone sets a breakpoint-patched lua_ call inside VM-protected sections. `rbxTextBase/rbxTextSize` are consumed by the security scanning code (security/ApiSecurity.h is included here).

## Gotchas

- A Luau graft that removes or rewrites these patched-5.1 hooks must decide what replaces `lua_vmhooked_handler`; per project rules, VM-internal anti-tamper may be dropped, but any remaining code referencing the handler symbol needs updating.
- `rbxTextSize = 0xFFFFFFFF` on a 32-bit build effectively means "scan to end of address space" — an x64 port cannot keep this value.
- `initDouble` relies on C `rand()` without seeding here; mask quality is intentionally weak — its purpose is defeating naive pattern scans of double constants, not cryptography.
