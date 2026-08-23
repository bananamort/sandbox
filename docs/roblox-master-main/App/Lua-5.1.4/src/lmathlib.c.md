# App/Lua-5.1.4/src/lmathlib.c

## Purpose
Standard math library ($Id: lmathlib.c,v 1.67.1.1): trigonometry/hyperbolics (sin/cos/tan + h variants, asin/acos/atan/atan2), rounding (ceil/floor/modf/frexp/ldexp), arithmetic helpers (abs/sqrt/pow/fmod/log/log10/exp/min/max), degree/radian conversion with local `RADIANS_PER_DEGREE` constant, and PRNG (`math.random` over libc `rand()` with %-clamping; `math.randomseed`). `luaopen_math` registers the table plus `pi` and `huge`, and compat-aliases `mod`→`fmod` under LUA_COMPAT_MOD.

## API
```c
LUALIB_API int luaopen_math (lua_State *L);
/* registered: abs acos asin atan atan2 ceil cosh cos deg exp floor fmod
   frexp ldexp log log10 max min modf pow rad random randomseed sinh sin
   sqrt tanh tan ; fields pi, huge */
```

## Usage
- Opened by ScriptContext into script VMs; all functions are pure over the C runtime — no engine coupling.

## Roblox modifications (vs stock Lua 5.1.4)
1. Byte-for-byte stock 5.1.4 — no deltas.
2. Behavioral note for graft comparisons: `math.random` uses per-process libc rand() state shared across ALL VMs and scripts in this tree (no per-VM seeding) — a known Roblox quirk vs Luau's per-VM PCG.

## Gotchas
- `random(n)` returns floats formatted as integers via floor(r*u)+1 — precision degrades above 2^53 like stock.
- `math.huge` is HUGE_VAL (inf); NaN never folds at compile time (see lcode.c).

