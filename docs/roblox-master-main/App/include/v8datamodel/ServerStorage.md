# App/include/v8datamodel/ServerStorage.h

## Purpose

`ServerStorage` — PERSISTENT_LOCAL_INTERNAL creatable service: server-only storage container whose contents never replicate to clients. Behavior is descriptor-flags + one child-admission override.

## Declared API

`class ServerStorage : public DescribedCreatable<ServerStorage, Instance, sServerStorage, Reflection::ClassDescriptor::PERSISTENT_LOCAL_INTERNAL>, public Service`

- Ctor; `/*override*/ bool askAddChild(const Instance* instance) const` — only override.

## Gotchas

- No explicit "don't replicate" code here — non-replication is enforced by PERSISTENT_LOCAL_INTERNAL + replicator policy, not by this class.
- askAddChild may restrict what can be parented (out-of-line).

## UNKNOWN

- Exact askAddChild rules.

## Cross-links

- Implementation: [App/v8datamodel/ServerStorage.md](../../v8datamodel/ServerStorage.md).
- Replicated counterparts: [ReplicatedStorage.md](ReplicatedStorage.md), [RobloxReplicatedStorage.md](RobloxReplicatedStorage.md); script sibling: [ServerScriptService.md](ServerScriptService.md).
