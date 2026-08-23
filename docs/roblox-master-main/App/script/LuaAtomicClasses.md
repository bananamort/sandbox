# App/script/LuaAtomicClasses.cpp

## Purpose

Defines every atomic (non-Instance) value-type userdata bridge: shared string helpers (`safe_lua_tostring`, `throwable_lua_tostring`, `lua_checkstring_secure`, `lua_resetstack`, `lua_tofloat`) and the full Color3/Ray/Region3/Region3int16/PhysicalProperties/Rect/Vector3/Vector3int16/Vector2int16/Vector2/BrickColor/CFrame/UDim/UDim2/Faces/Axes/CellId/NumberSequence/ColorSequence/NumberSequenceKeypoint/ColorSequenceKeypoint/NumberRange set — constructors (`X.new`), member tables, `on_index` property surfaces, arithmetic metamethods, and per-class `registerClass` specializations that attach `__add/__sub/__mul/__div/__unm`.

## API

Shared helpers:
- `const char* safe_lua_tostring(lua_State*, int)` — never NULL ("").
- `const char* throwable_lua_tostring(lua_State*, int)` — `luaL_checkstring` plus a 200000-char cap ("String too long"), noted to stay in sync with networking length limits.
- `const char* lua_checkstring_secure(lua_State*, int)` — via patched `lua_tolstringsecure`, typerror otherwise.
- `void lua_resetstack(lua_State*, int idx)` — runs `luaF_close(L, L->base + idx)` (closing upvalues!) before `lua_settop`; asserts range.
- `float lua_tofloat(lua_State*, int)` — double→float with explicit inf/NaN/clamp-to-float-max handling.
- `FASTFLAGVARIABLE(PhysPropConstructFromMaterial, false)`.

Per class (each has `className`, `classLibrary[]` with `new` (+extras), `registerClassLibrary` doing `luaL_register` + `lua_setreadonly(-1,true)` + pop, push/getObject/getValue wrappers from the header, and throwing on_newindex):
- Color3 ("Color3"): `new`, `fromRGB` (/255); r/g/b read-only.
- Ray ("Ray"): `new(origin, direction)`; Origin/Direction/unit|Unit props; ClosestPoint/Distance methods.
- Region3 ("Region3"): `new(min,max)`; CFrame/Size props; ExpandToGrid(resolution) validates positive non-NaN resolution.
- Region3int16 ("Region3int16"): `new(min,max)`; Min/Max.
- PhysicalProperties ("PhysicalProperties"): `new` accepts 1 Enum.Material arg (under FFlag::PhysPropConstructFromMaterial, via MaterialProperties::generatePhysicalMaterialFromPartMaterial), 3 numbers (density/friction/elasticity), or 5 (+weights); Density/Friction/Elasticity/FrictionWeight/ElasticityWeight read-only.
- Rect ("Rect", G3D::Rect2D): `new()` empty / 2 Vector2 / 4 numbers; Min/Max/Width/Height; its registerClass includes __gc.
- Vector3: `new`, `FromNormalId(Enum.NormalId)`, `FromAxis(Enum.Axis)` (via normalIdToVector3/Axes::axisToNormalId); x|X,y|Y,z|Z, unit|Unit, magnitude|Magnitude, lerp|Lerp, Cross, Dot, isClose (optional epsilon → Math::fuzzyEq); full __add/__sub/__mul/__div/__unm with number-vs-vector dispatch and "attempt to multiply/divide a Vector3 with an incompatible value type or nil" errors.
- Vector3int16 / Vector2int16: integer components; arithmetic with explicit divide-by-zero exceptions ("Divide by zero exception"); Vector3int16 registerClass adds all five operators + __eq.
- Vector2: x|X/y|Y, unit (direction), magnitude (length), lerp; operator set like Vector3.
- BrickColor: `new` (0 args default; 1 number = palette number, 1 string = BrickColor::parse, 1 Color3 = closest; 2-3 floats = closest Color4), `random`, `palette(index)` bounds-checked against colorPalette(), named colors White/Gray/DarkGray/Black/Red/Yellow/Green/Blue plus New/Random capitalized aliases; members number|Number, Color, r/g/b, name|Name.
- CFrame ("CFrame"): `new` overloads 0/1(Vector3)/2(translation+lookAt)/3/7(+quat xyzw)/12(matrix) args; library `fromEulerAnglesXYZ` + alias `Angles`, `fromAxisAngle`; methods inverse, lerp, toWorldSpace/toObjectSpace (multi-value: n args → n results), pointToWorldSpace/pointToObjectSpace/vectorToWorldSpace/vectorToObjectSpace, toEulerAnglesXYZ, components (returns 12 numbers); properties p, lookVector, x|X/y|Y/z|Z; note the method closures are created with `lua_pushvalue(L,-1); lua_pushcclosure(L, fn, 1)` (pushing whatever was below as upvalue) and CoordinateFrame's registerClass stores "inverse" as a plain metatable field alongside __add/__sub/__mul.
- UDim: `new(scale[,offset])`; Scale/Offset; lowercase-first-letter misses get a hint error "...did you forget to capitalize the first letter?".
- UDim2: `new(sx,ox,sy,oy)` with fallthrough switch; X|Width/Y|Height return UDims; same capitalization hint.
- Faces: `new` of up to 6 Enum.NormalId items OR'd into a mask (NORM_NONE_MASK base); boolean Top/Bottom/Back/Front/Right/Left via getNormalId.
- Axes: `new` mixing Enum.Axis/Enum.NormalId into axisMask; booleans X/Y/Z and Top/Bottom/Back/Front/Right/Left.
- CellId ("CellId"): `new(IsNil,x,y,z)` — NOTE bug: reads `lua_toboolean(L, 0)` (index 0!) for IsNil; members IsNil/Location/TerrainPart (pushes Instance).
- NumberSequence: `new(number | table of NumberSequenceKeypoint)` iterated by rawgeti until nil (with "NOTE: untrusted?" on lua_objlen); Keypoints array out.
- ColorSequence: `new(Color3[,Color3])` only — the keypoint-table path is dead code behind a throw ("This will do until I implement an editor"); Keypoints array out.
- NumberSequenceKeypoint: `new(time,value[,envelope])`; Time/Value/Envelope.
- ColorSequenceKeypoint: `new(time, Color3)`; Time/Value (Envelope disabled in source).
- NumberRange: `new(a[,b])`, b<a throws "NumberRange: invalid range"; Min/Max.

registerClass specializations defined here (beyond LuaBridge.cpp defaults): Vector3int16, Vector2int16, Vector3, Vector2, CoordinateFrame, Rect2D, PhysicalProperties, UDim, UDim2 — all follow the standard layout (protect_metatable, __type, __index/__newindex/__eq/__tostring, optional __gc for Rect, operator fields) ending with lua_setreadonly + pop.

## Usage

Registered per VM in `ScriptContext::openState` (registerClass + registerClassLibrary for each). Consumed as marshaling targets by `LuaArguments::getRec`'s bridge chain and `LuaInstanceBridge.cpp:pushLuaValue/assignLuaValue`; EnumItem interop via `EnumItem::getItem/push` (App/script/LuaEnum.cpp); instance marshaling via ObjectBridge (CellID.TerrainPart). These classes are also what `LuaBridge.cpp` instantiates templates for.

## Gotchas

- `lua_resetstack` closes upvalues above the cut via `luaF_close` before truncating — plain `lua_settop` would leak open upvalues; any graft reimplementing stack resets must keep this.
- `throwable_lua_tostring` enforces a 200k string cap tied to networking limits — engine-side DoS guard scripts can trip.
- CellIdBridge::newCellID reads IsNil from stack index **0** instead of 1 — IsNil is effectively always false; latent bug preserved here as documentation.
- newVector3int16/newVector2int16/newFaces etc. silently zero-fill missing args ("Following Lua conventions ignore others"); UDim2's count uses min(5,...) though only 4 args are meaningful.
- ColorSequence.new rejects keypoint tables outright; NumberSequence accepts them — asymmetric API surface.
- All classLibrary tables are made readonly right after luaL_register; the repeated comment cites the lua-l post about popping after register.
- CFrame multi-target methods (toWorldSpace etc.) return n results for n arguments — unusual calling convention scripts may rely on.
