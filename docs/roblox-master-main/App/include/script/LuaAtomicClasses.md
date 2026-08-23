# App/include/script/LuaAtomicClasses.h

## Purpose

Declares the full family of Lua bridges for Roblox's atomic (value) datatypes — CFrame, PhysicalProperties, Rect2D, Region3, Region3int16, Vector3, Vector3int16, RbxRay, Vector2, Vector2int16, Color3, UDim, UDim2, Faces, Axes, BrickColor, CellID, NumberSequence/ColorSequence/NumberRange and their keypoints. Each bridge exposes a `new...` constructor, operator metamethods where the type supports arithmetic, a static `push<Type>` helper, and a `registerClassLibrary`.

## Declared API

All classes live in `namespace RBX::Lua`, derive from `Bridge<T>`, declare `friend class Bridge<T>;`, share the pattern `static void registerClassLibrary(lua_State* L);` + `static const luaL_reg classLibrary[];` + private `new...(lua_State*)` ctor entries:

- `CoordinateFrameBridge : Bridge<G3D::CoordinateFrame>` — inline `pushCoordinateFrame`; ctors: `newCoordinateFrame`, `fromEulerAnglesXYZ`, `fromAxisAngle`; operators on_add/on_sub/on_mul/on_inverse/on_lerp; helpers "Implementation of G3D::CoordinateFrame help functions": toWorldSpace, toObjectSpace, pointToWorldSpace, pointToObjectSpace, vectorToWorldSpace, vectorToObjectSpace, toEulerAnglesXYZ, components.
- `PhysicalPropertiesBridge : Bridge<PhysicalProperties>` — inline `pushPhysicalProperties` pushes NIL when `getCustomEnabled()` is false, else new object; ctor `newPhysicalProperties`.
- `Rect2DBridge : Bridge<G3D::Rect2D>` — inline `pushRect2D`; ctor `newRect2D`.
- `Region3Bridge : Bridge<RBX::Region3>` — inline `pushRegion3`; ctors `newRegion3`, `expandToGrid`.
- `Region3int16Bridge : Bridge<RBX::Region3int16>` — inline `pushRegion3int16`.
- `Vector3Bridge : Bridge<G3D::Vector3>` — inline `pushVector3`; ctors `newVector3`, `newVector3FromNormalId`, `newVector3FromAxis`; operators add/sub/mul/div/unm.
- `Vector3int16Bridge : Bridge<G3D::Vector3int16>` — same shape incl. all five operators.
- `RbxRayBridge : Bridge<RBX::RbxRay>` — inline `pushRay`; ctor `newRbxRay`; operator handlers commented out.
- `Vector2Bridge : Bridge<RBX::Vector2>`, `Vector2int16Bridge : Bridge<RBX::Vector2int16>` — full five-operator sets.
- `Color3Bridge : Bridge<G3D::Color3>` — non-inline `pushColor3`; ctors `newColor3`, `newRGBColor3`.
- `UDimBridge : Bridge<RBX::UDim>` / `UDim2Bridge : Bridge<RBX::UDim2>` — add/sub/unm only (no mul/div); UDim2 has no inline push helper.
- `FacesBridge : Bridge<RBX::Faces>`, `AxesBridge : Bridge<RBX::Axes>` — ctor only, no push helper.
- `BrickColorBridge : Bridge<RBX::BrickColor>` — ctors `newBrickColor`, `randomBrickColor`, `paletteBrickColor`; no push helper.
- `CellIDBridge : Bridge<CellID>` ("CellID bridge for cluster access") — inline `pushCellID`.
- Particle props: `NumberSequenceBridge`, `ColorSequenceBridge` ("Number sequence for particle props"), `NumberSequenceKeypointBridge`, `ColorSequenceKeypointBridge`, `NumberRangeBridge` — each with inline push + single ctor.

Template specializations declared at bottom ("Specialization to implement arithmatic operators" [sic] ×3): `Bridge<...>::registerClass` for G3D::Vector3int16, G3D::Vector3, RBX::Vector2, G3D::CoordinateFrame, RBX::UDim, RBX::UDim2.

## Usage notes

- Behavior implementations are in certified App/script docs (`docs/roblox-master-main/App/script/`) — LuaAtomicClasses.cpp pairs with this header.
- The six `registerClass` specializations are how operator metamethods get attached despite the generic bridge template not supporting them.

## Gotchas

- `pushPhysicalProperties` silently yields nil for default (non-custom) physical properties — scripts see nil, not an error.
- Faces/Axes/BrickColor/UDim2 lack static push helpers in this header; callers use generic `pushNewObject` paths or Color3-style non-inline variants elsewhere.
- Spelling "arithmatic" appears verbatim in three comments — grep anchor when searching.
- RbxRay deliberately has no arithmetic operators (commented-out block retained for history).
