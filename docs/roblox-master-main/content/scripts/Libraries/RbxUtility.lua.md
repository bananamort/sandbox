# RbxUtility.lua

Source: `roblox-sandbox/content/scripts/Libraries/RbxUtility.lua` (1117 lines; LoadLibrary("RbxUtility") implementation)

## Purpose

Legacy client utility library: a full Lua JSON encoder/decoder (Shaun Brown's Chipmunk port), deprecated EncodeJSON/DecodeJSON wrappers, classic-terrain helpers (MakeWedge, SelectTerrainRegion), a BindableEvent-backed Signal class, the famous `Create'Type'{props}` declarative builder with `Create.E` event syntax and constructor slots, plus a self-documenting Help() function.

## API (module table `t`)

- `t.DecodeJSON(jsonString)` / `t.EncodeJSON(jsonTable)` — warn-deprecated in favor of HttpService:JSON{De,en}code (warn itself wrapped in pcall — pre-warn environments).
  - Encoder quirks: boolean/number go through WriteString→tostring (UNQUOTED — invalid JSON for bools!); strings escape %z%c\\"/ to \uXXXX; IsArray treats positive-integral keys as array; functions encode only if `== Null` sentinel else error; threads/userdata error.
  - Decoder: supports //, /* */ comments INSIDE whitespace skip; \uXXXX → string.char(tonumber(m,16)) (latin-1 only, pattern "u%x%x(%x%x)"); strict reserved words, object keys must be strings.
- `t.MakeWedge(x,y,z,[material])` — thin pass-through to `Terrain:AutoWedgeCell` (classic 4×4×4 terrain).
- `t.SelectTerrainRegion(regionToSelect(R3), color(BrickColor), selectEmptyCells, selectionParent)` → `(updateSelection(newRegion,color), destroyFunc)`:
  - Adorns each non-empty cell with pooled SelectionBox+invisible anchored Part (4.2³ default, cells 4³) under non-Archivable Model "SelectionContainer"; keep-alive tag counter (wraps at 1e6) reaps stale adorns into reusable pool.
  - selectEmptyCells=true path = ONE box covering whole region instead.
  - Type checks are broken (`if not type(x) == "Region3"` — always false) so asserts never fire.
- `t.CreateSignal()` — RBXScriptSignal-alike over one BindableEvent: connect/disconnect-all/wait/fire with `:`-call enforcement errors.
- `t.Create` — metatable __call functor: `Create'Class'{ strKey=prop, [n]=childInstance, [Create.E'Event']=handler, [Create]=ctorFn }`; ctor runs last synchronously, exactly one allowed; numeric keys must be userdata children.
- `t.Help(funcNameOrFunc)` — returns doc strings for all of the above incl. per-method Signal docs.

## Usage

Loaded via `LoadLibrary("RbxUtility")` — consumers in this tree: PersonalServerScript (DecodeJSON), BuildToolsScript (CreateTutorial via RbxGui though). The Create{} idiom is used across settings pages via their own local copies.

## Gotchas
- Encoder emits bare `true`/numbers without quotes — output is NOT strictly valid JSON for those types.
- \u decoding collapses to single bytes — no UTF-8.
- Region3 type validation inverted-comparison bug.
- DecodeJSON warns on EVERY call (deprecated shims still on hot paths in 2014-era scripts).
