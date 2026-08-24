# App/include/v8datamodel/LocalWorkspace.h

## Purpose

`LocalWorkspace` Instance (INTERNAL_LOCAL) — "A structure class whose contents will never be replicated" (per the file comment): a per-machine container for non-replicated objects.

## Declared API

`class LocalWorkspace : public DescribedNonCreatable<LocalWorkspace, Instance, sLocalWorkspace, ClassDescriptor::INTERNAL_LOCAL>`

- `LocalWorkspace();` — entire surface; no members or overrides.

## Gotchas

- Non-replication is a property of the descriptor class (INTERNAL_LOCAL) plus placement conventions, not enforced by code in this header.

## UNKNOWN

- What the engine places inside it at runtime (.cpp — see [LocalWorkspace.md](../../v8datamodel/LocalWorkspace.md)).

## Cross-links

- Implementation: [App/v8datamodel/LocalWorkspace.md](../../v8datamodel/LocalWorkspace.md).
- Kin: [RobloxReplicatedStorage.md] / [ReplicatedStorage.md] (R–Z half) for the replicated counterpart.
