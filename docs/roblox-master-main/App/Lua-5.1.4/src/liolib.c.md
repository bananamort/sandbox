# App/Lua-5.1.4/src/liolib.c

## Purpose
Standard I/O library ($Id: liolib.c,v 2.73.1.3): FILE*-based file handles as full userdata with `LUA_FILEHANDLE` ("FILE*") registry metatable (`__gc` closes, `__tostring` renders "file (%p)"); default input/output slots stored in the library function's environment (IO_INPUT/IO_OUTPUT indices); operations: open/popen/tmpfile/close (with per-handle `__close` dispatch via environment), read formats (`*n/*l/*a` and byte counts via luaL_Buffer chunked reads), write, lines iterator (auto-closing when the library opened the file), seek/setvbuf/flush, std stream wiring (stdin/stdout/stderr uncloseable via io_noclose).

## API
```c
LUALIB_API int luaopen_io (lua_State *L);
/* io.*: close flush input lines open output popen read tmpfile type write */
/* f:methods: close flush lines read seek setvbuf write __gc __tostring */
```

## Usage
- NOT opened into Roblox script VMs (ScriptContext selects libraries; io is excluded on client/server script states). Present for tooling builds only.

## Roblox modifications (vs stock Lua 5.1.4)
1. Byte-for-byte stock 5.1.4 — no deltas in this file.
2. Graft-relevant interaction: `io_gc` is a user-visible `__gc` on userdata — under Roblox's may_gc policy such finalization paths are exactly what lbaselib/lgc changes neutralize for user-created proxies.

## Gotchas
- Handles use the environment-table trick (`createstdfile` setfenv + `aux_close` reading `__close` from the handle's env): any change to closure environments breaks close semantics.
- `read "*a"` passes ~((size_t)0) — reads to EOF; combined with untrusted files this is a memory DoS if ever exposed.
- popen availability depends on lua_popen macro (luaconf.h); typically disabled on console targets.

