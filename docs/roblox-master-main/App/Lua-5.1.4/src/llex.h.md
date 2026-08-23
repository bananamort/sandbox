# App/Lua-5.1.4/src/llex.h

## Purpose
Header for the lexical analyzer ($Id: llex.h,v 1.58.1.1). Declares the `RESERVED` token enum (ORDER RESERVED contract — order must match llex.c's `luaX_tokens[]` string array), `SemInfo`/`Token` value holders, `LexState` (scanner state over a ZIO stream), and the `luaX_*` API for token consumption, string interning, and error reporting.

## API
```c
#define FIRST_RESERVED 257
#define TOKEN_LEN (sizeof("function")/sizeof(char))
enum RESERVED { TK_AND=FIRST_RESERVED, TK_BREAK, TK_DO, TK_ELSE, TK_ELSEIF,
  TK_END, TK_FALSE, TK_FOR, TK_FUNCTION, TK_IF, TK_IN, TK_LOCAL, TK_NIL,
  TK_NOT, TK_OR, TK_REPEAT, TK_RETURN, TK_THEN, TK_TRUE, TK_UNTIL, TK_WHILE,
  TK_CONCAT, TK_DOTS, TK_EQ, TK_GE, TK_LE, TK_NE, TK_NUMBER, TK_NAME,
  TK_STRING, TK_EOS };
#define NUM_RESERVED (cast(int, TK_WHILE-FIRST_RESERVED+1))

typedef union { lua_Number r; TString *ts; } SemInfo;
typedef struct Token { int token; SemInfo seminfo; } Token;

typedef struct LexState {
  int current, linenumber, lastline;
  Token t, lookahead;
  struct FuncState *fs;  struct lua_State *L;
  ZIO *z;  Mbuffer *buff;  TString *source;  char decpoint;
} LexState;

LUAI_FUNC void        luaX_init        (lua_State *L);
LUAI_FUNC void        luaX_setinput    (lua_State *L, LexState *ls, ZIO *z, TString *source);
LUAI_FUNC TString    *luaX_newstring   (LexState *ls, const char *str, size_t l);
LUAI_FUNC void        luaX_next        (LexState *ls);
LUAI_FUNC void        luaX_lookahead   (LexState *ls);
LUAI_FUNC void        luaX_lexerror    (LexState *ls, const char *msg, int token);
LUAI_FUNC void        luaX_syntaxerror (LexState *ls, const char *s);
LUAI_FUNC const char *luaX_token2str  (luaX tokens) /* (LexState*, int token) */;
```

## Usage
- Consumed only by the parser family (lparser.c, lcode.c via ls->t). `ScriptAnalyzer.cpp` embeds its own lexer rather than reusing this one, so changes here do not affect analyzer linting.

## Roblox modifications (vs stock Lua 5.1.4)
1. Token set is stock Lua 5.1: no Luau additions (`continue`, compound-assignment ops, type-annotation tokens are absent).
2. RESOLVED (was UNKNOWN): the only llex.c body delta is `trydecpoint` switching to `getlocaledecpoint()` (`// ROBLOX`, macro from luaconf.h); no error-message scrubbing or literal-limit changes.
3. Indirect: strings interned by `luaX_newstring` become plain TStrings; Roblox obfuscation never touches source text, only compiled code arrays.

## Gotchas
- "ORDER RESERVED" contract: enum ordinal indexes directly into `luaX_tokens[]`; inserting a token without updating the string table mislabels every later token in error messages.
- `luaX_lexerror`/`luaX_syntaxerror` longjmp via `luaD_throw(LUA_ERRSYNTAX)` — caller must be inside a protected frame (`luaD_protectedparser`).
- `decpoint` is locale-derived; number lexing differs per locale (classic Lua gotcha, unchanged).

