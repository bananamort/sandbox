# factoryregistration.cpp

## Purpose

The type-registry bootstrap TU: ~40 RBX_REGISTER_TYPE entries (every reflected value type), ~330 RBX_REGISTER_CLASS entries (every Instance class across v8datamodel, Script, Network, Humanoid, soundscape), ~130 RBX_REGISTER_ENUM entries, and the `FactoryRegistrator` ctor that runs one-time global setup (descriptor registration groups, signal exception handler, RNG seed, ModelInstance character hack). No behavior beyond registration.

## Key types and API

No descriptors of its own; no Security:: tiers.

Registered value TYPES include: primitives (void/bool/float/int/long/double/std::string/ProtectedString), math (Vector3/int16, Vector2/int16, Color3, CoordinateFrame, Rect2D, Region3, RbxRay), content ids (ContentId, TextureId, MeshId, AnimationId, SoundId), UI (UDim/UDim2, Faces, Axes), reflection containers (Tuple/ValueArray/ValueMap/ValueTable, Instances, DescribedBase, Instance ptr), Lua refs (WeakFunctionRef, GenericFunction/AsyncFunction), sequences (NumberSequence(+Keypoint), ColorSequence(+Keypoint), NumberRange), misc (BrickColor, SystemAddress, PhysicalProperties, CellID, Guid::Data, PropertyDescriptor*).

Registered CLASSES span: core (Instance→DataModel/Workspace/ServiceProvider/RootInstance/ModelInstance/Lighting/Camera…), parts family (PartInstance→FormFactorPart→BasicPartInstance→ExtrudedPartInstance/Wedge + conditional Prism/Pyramid/ramps/CornerWedge under _PRISM_PYRAMID_), joints (Weld/Snap/Motor/Motor6D/Rotate*/Glue/Manual*), GUI tree (GuiBase→GuiObject→Frame/labels/buttons/collectors/BillboardGui/SurfaceGui…), adornments (Handles/ArcHandles/SelectionBox/Sphere/HandleAdornment×6/SurfaceSelection), animation chain (Animation→Track/TrackState/Animator/KeyframeSequence/Pose), services (all *Service classes incl. DataStore/Http/Marketplace/Teleport…), values ×14, CSG (PartOperation/Union/Negate/Asset), lights ×3, remotes, script classes (Script/CoreScript/ModuleScript/ScriptContext/debugger quartet), network packet caches, Xbox-only PlatformService behind RBX_PLATFORM_DURANGO. Commented-out EggMesh registration.

Registered ENUMS mirror every EnumDesc across the codebase (Camera types, Humanoid states/rig types, Voxel enums, GuiService specials, TeleportState/Type, PartMaterial, CollisionFidelity, NetworkOwnership, KeyCode, etc.).

`FactoryRegistrator::FactoryRegistrator()` — initializes G3D program start time, registerSound/registerScriptDescriptors/registerBodyMovers/registerValueClasses/registerStatsClasses/Surface::registerSurfaceDescriptors, installs `onSlotException` handler ("exception while signalling"), seeds srand from randomSeed(), calls `ModelInstance::hackPhysicalCharacter()`.

## Usage / reflection touchpoints

THE linkage point for every descriptor in this folder — each class doc's REFLECTION block only exists because its class appears here ([DataModel](DataModel.md), [Instance](../../Base/) registry).

## Gotchas

- Registration ORDER in this file defines ClassDescriptor iteration order in some tooling paths.
- Conditional blocks (_PRISM_PYRAMID_, RBX_PLATFORM_DURANGO) mean those classes/enums don't exist in builds without the flags.
- The lowercase filename is intentional legacy — it sorts first-ish but registers EVERYTHING.
