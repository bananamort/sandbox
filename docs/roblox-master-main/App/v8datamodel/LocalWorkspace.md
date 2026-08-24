# LocalWorkspace.cpp

## Purpose

Implements `LocalWorkspace` ("LocalWorkspace") — an empty marker container class, direct Instance subclass via `DescribedNonCreatable<..., Reflection::ClassDescriptor::INTERNAL_LOCAL>`. Header comment states intent verbatim: "A structure class whose contents will never be replicated". 17-line TU; the ctor only calls `Super()` and `setName`.

## Key types and API

No descriptors of its own; no Security:: tiers.

- `const char* const sLocalWorkspace = "LocalWorkspace"` — class-name constant.
- `LocalWorkspace::LocalWorkspace()` — sole member; no state, no overrides, no child/property hooks.
- Class registration lives in [factoryregistration](factoryregistration.md) (`RBX_REGISTER_CLASS(LocalWorkspace)`); the INTERNAL_LOCAL descriptor tag is what marks contents non-replicating.

## Usage / reflection touchpoints

Registered but unreferenced in the kept tree: grep finds consumers ONLY in build manifests (App.vcxproj/CMakeLists/Xcode project) plus the registration include — no engine code instantiates, parents, or type-checks against it. Present as a schema slot for client-local world content that must never serialize to the server.

## Gotchas

- Despite the name it derives from `Instance`, NOT from [Workspace](Workspace.md) — no physics/camera/query behavior of the real workspace applies.
- Non-creatable + INTERNAL_LOCAL means scripts can neither construct it nor expect it to replicate; anything parented under one stays machine-local.
