# App/include/v8datamodel/RobloxReplicatedStorage.h

## Purpose

`RobloxReplicatedStorage` — INTERNAL, RobloxScript-security creatable service container: engine-owned storage replicated to clients but writable only by RobloxScript-security code (core scripts' shared assets). Ctor-only header.

## Declared API

`class RobloxReplicatedStorage : public DescribedCreatable<RobloxReplicatedStorage, Instance, sRobloxReplicatedStorage, Reflection::ClassDescriptor::INTERNAL, Security::RobloxScript>, public Service`

- `RobloxReplicatedStorage();` — no members, methods, or signals declared.

## Gotchas

- The security story is entirely in the descriptor args (INTERNAL + Security::RobloxScript): game scripts cannot create/modify it even though contents replicate.
- Contrast with [ReplicatedStorage.md](ReplicatedStorage.md): same replication visibility, opposite write authority.

## UNKNOWN

- (none beyond behavior implied by descriptor flags)

## Cross-links

- Implementation: [App/v8datamodel/RobloxReplicatedStorage.md](../../v8datamodel/RobloxReplicatedStorage.md).
- Siblings: [ReplicatedStorage.md](ReplicatedStorage.md), [ReplicatedFirst.md](ReplicatedFirst.md), [ServerStorage.md](ServerStorage.md).
