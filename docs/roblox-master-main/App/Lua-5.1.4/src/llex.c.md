# App/Lua-5.1.4/src/llex.c

## Purpose
Lexical analyzer ($Id: llex.c,v 2.20.1.1): the token scanner over a ZIO stream — reserved-word table (`luaX_tokens`, ORDER RESERVED), buffer management (`save` doubling Mbuffer), string interning with parser-side dedup pinning (`luaX_newstring` stores into current FuncState's constant-dedup table so literals survive GC), number lexing with locale decimal-point fallback (`read_numeral`/`trydecpoint`/`buffreplace`), long strings/comments `[==[` with nesting compat (`read_long_string`/`skip_sep`, LUA_COMPAT_LSTR), quoted strings with escapes incl. `\ddd`, comment handling, single/multi-char operator tokens, lookahead discipline (`luaX_next/luaX_lookahead`), and error reporting (`luaX_lexerror/syntaxerror/token2str`).

## API
```c
const char *const luaX_tokens[];   /* ORDER RESERVED */
void        luaX_init      (lua_State*);            /* fix + reserve keywords */
void        luaX_setinput  (lua_State*, LexState*, ZIO*, TString *source);
TString    *luaX_newstring (LexState*, const char*, size_t);
void        luaX_next      (LexState*);
void        luaX_lookahead (LexState*);
void        luaX_lexerror  (LexState*, const char *msg, int token);  /* throws */
void        luaX_syntaxerror(LexState*, const char *msg);
const char *luaX_token2str (LexState*, int token);
/* internal */ static int llex (LexState *ls, SemInfo *seminfo);
```

## Usage
- Feeds lparser.c only. In this tree text compilation happens solely on internal-core VMs (client luaY_parser throws), so this lexer runs only in trusted compile contexts; ScriptAnalyzer.cpp's separate lexer handles lint-time scanning of arbitrary user text.

## Roblox modifications (vs stock Lua 5.1.4)
1. **`trydecpoint` uses `getlocaledecpoint()`** (in-source `// ROBLOX`) instead of stock's inline `localeconv()->decimal_point[0]` — a macro abstraction (defined in luaconf.h) to avoid per-call localeconv cost.
2. Token set, escapes, long-string rules: all stock 5.1.4 (no Luau additions — no `+=`, no `continue`, no hex float literals).

## Gotchas
- `luaX_newstring` writes through `ls->fs->h` — calling it before a FuncState exists crashes; it also pins every literal in the parse-time dedup table until that Proto completes.
- Errors longjmp via `luaD_throw(LUA_ERRSYNTAX)` mid-scan; Mbuffer contents are garbage after — protectedparser re-inits per attempt.
- `\ddd` accepts up to 3 digits but errors >UCHAR_MAX only after consuming them ("escape sequence too large").
- Locale decimal point affects BOTH parsing (read_numeral) and error-message rendering; cross-locale chunk sharing of source text can change semantics.

