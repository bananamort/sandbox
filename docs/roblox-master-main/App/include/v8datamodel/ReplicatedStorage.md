# App/include/v8datamodel/ReplicatedStorage.h

## Purpose

`ReplicatedStorage` — PERSISTENT_HIDDEN creatable service container replicated to both server and clients but hidden from Explorer by default; pure storage node (ctor only).

## Declared API

`class ReplicatedStorage : public DescribedCreatable<ReplicatedStorage, Instance, sReplicatedStorage, Reflection::ClassDescriptor::PERSISTENT_HIDDEN>, public Service`

- `ReplicatedStorage();` — no members, methods, or signals declared.

## Gotchas

- All behavior (replication scoping) comes from the class descriptor flags, not code.
- Hidden ≠ secure: contents replicate to clients; secrets belong in [ServerStorage.md](ServerStorage.md).

## UNKNOWN

- (none beyond behavior implied by descriptor flags)

## Cross-links

- Implementation: [App/v8datamodel/ReplicatedStorage.md](../../v8datamodel/ReplicatedStorage.md).
- Siblings: [ReplicatedFirst.md](ReplicatedFirst.md), [RobloxReplicatedStorage.md](RobloxReplicatedStorage.md), [ServerStorage.md](ServerStorage.md).
