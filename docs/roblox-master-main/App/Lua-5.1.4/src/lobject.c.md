# App/Lua-5.1.4/src/lobject.c

## Purpose
Generic object helpers ($Id: lobject.c,v 2.22.1.1): the canonical `luaO_nilobject` singleton, the floating-point-byte size encoding used by OP_SETLIST (`luaO_int2fb`/`luaO_fb2int`), `luaO_log2`, raw equality without metamethods (`luaO_rawequalObj`), string→number conversion incl. hex literals (`luaO_str2d`), printf-style message building on the Lua stack (`luaO_pushvfstring/pushfstring`) used by all error paths, and `luaO_chunkid` (source-name pretty-printing for error messages).

## API
```c
const TValue luaO_nilobject_ = {{NULL}, LUA_TNIL};

int luaO_int2fb (unsigned int x);          /* int -> (eeeeexxx) fp byte */
int luaO_fb2int  (int x);                  /* inverse */
int luaO_log2    (unsigned int x);         /* floor(log2), table-driven */
int luaO_rawequalObj (const TValue *t1, const TValue *t2);
int luaO_str2d   (const char *s, lua_Number *result);
const char *luaO_pushvfstring (lua_State *L, const char *fmt, va_list argp);
const char *luaO_pushfstring  (lua_State *L, const char *fmt, ...);
void luaO_chunkid (char *out, const char *source, size_t bufflen);
```

## Usage
- `luaO_pushfstring` is the backbone of every `luaG_runerror`/`luaG_typeerror`/lexer error message — Roblox's error scrubbing in ScriptContext therefore sees strings built here.
- `luaO_str2d` backs string coercion in arithmetic VM paths and `tonumber`.
- `luaO_chunkid` formats the chunkname passed by ScriptContext (`[string "..."]`) seen in script errors.

## Roblox modifications (vs stock Lua 5.1.4)
1. File is byte-for-byte stock 5.1.4 — no deltas.
2. Interaction: because `luaV_concat` is called from `luaO_pushvfstring`, metamethod-bearing environments could theoretically run `__concat` during error construction; core messages use plain C strings so this never fires in practice.

## Gotchas
- `luaO_pushvfstring` supports ONLY `%d %c %f %p %s %%`; other specifiers pass through literally (documented in comment).
- It temporarily grows the Lua stack with n intermediate strings — calling it on a nearly-full stack inside a C function can trigger reallocation; callers must tolerate `savestack` invalidation.
- `luaO_chunkid` truncates with `strncpy`-style semantics; output buffer must be at least `bufflen` bytes.

