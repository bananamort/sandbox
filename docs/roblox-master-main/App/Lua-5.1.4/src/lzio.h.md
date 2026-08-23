# App/Lua-5.1.4/src/lzio.h

## Purpose
Buffered-input stream interface used by the parser/undumper (`$Id: lzio.h,v 1.21.1.1`). `ZIO` wraps a `lua_Reader` callback; `Mbuffer` is the growable char buffer the lexer uses for tokens/strings. Stock.

## API
- `#define EOZ (-1)`; `char2int(c)`; **`zgetc(z)`** — inline fast-path: decrement count else `luaZ_fill(z)`. This macro is on the lexer's hottest path (`llex.c`).
- `struct Mbuffer { char *buffer; size_t n; size_t buffsize; }`
- Buffer macros: `luaZ_initbuffer`, `luaZ_buffer`, `luaZ_sizebuffer`, `luaZ_bufflen`, `luaZ_resetbuffer`, `luaZ_resizebuffer(L,buff,size)`, `luaZ_freebuffer`
- `struct Zio { size_t n; const char *p; lua_Reader reader; void *data; lua_State *L; }` (private part)
- Functions: `char *luaZ_openspace(lua_State*, Mbuffer*, size_t n)`, `void luaZ_init(lua_State*, ZIO*, lua_Reader, void*)`, `size_t luaZ_read(ZIO*, void* b, size_t n)`, `int luaZ_lookahead(ZIO*)`, `int luaZ_fill(ZIO*)`

## Usage
- `llex.c` (`LexState` embeds `ZIO z` + `Mbuffer buff`), `lparser.c` entry (`luaY_parser`), `lundump.c` (bytecode reader), `lauxlib.c` (`lua_load`'s reader glue via `LoadF/S`).

## Roblox modifications (vs stock Lua 5.1.4)
None — stock 5.1.4 text.

## Gotchas
- `zgetc` is a macro with side effects (mutates `z->n`/`z->p`); don't call it twice expecting one byte.
- `luaZ_read` returns number of *missing* bytes, not read bytes.
