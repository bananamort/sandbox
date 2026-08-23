# App/Lua-5.1.4/src/lzio.c

## Purpose
Implementation of the generic input stream (`$Id: lzio.c,v 1.31.1.1`): refills the `ZIO` from its reader callback and provides block reads for the undumper.

## API
- `int luaZ_fill(ZIO *z)` — calls `z->reader(L, z->data, &size)` bracketed by `lua_unlock(L)`/`lua_lock(L)`; returns first byte or `EOZ`.
- `int luaZ_lookahead(ZIO *z)` — one-byte peek (refill + un-consume).
- `void luaZ_init(lua_State*, ZIO*, lua_Reader, void*)`
- `size_t luaZ_read(ZIO *z, void *b, size_t n)` — memcpy loop; returns count of bytes NOT read.
- `char *luaZ_openspace(lua_State*, Mbuffer*, size_t n)` — ensure buffer ≥ max(n, LUA_MINBUFFER).

## Usage
- `lundump.c` reads the entire bytecode header/protos through `LoadBlock`→`luaZ_read`; `llex.c` consumes source text via `zgetc`/`luaZ_lookahead`; `lauxlib.c` sets up ZIO for `lua_load`.

## Roblox modifications (vs stock Lua 5.1.4)
None — stock 5.1.4 verbatim. Note however that in the engine pipeline the *content* flowing through these streams is plaintext source on internal-core compile VMs; keyed/obfuscated bytecode never crosses this layer at runtime (the in-tree `luaU_undump` path is compiled out under `LUAVM_SECURE` and is not dispatched by `lua_load` — see lundump.c.md).

## Gotchas
- The `lua_unlock/lua_lock` pair here is significant on Win32 non-studio builds: `lua_unlock` is redefined in `luaconf.h` to run the `_ReturnAddress()` anti-tamper check (`lua_chk_ptr_rblx`) — every buffer refill crosses that tripwire.
