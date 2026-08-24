# ReplicatedStorage.cpp

## Purpose

Implements `ReplicatedStorage` ("ReplicatedStorage"), the standard server↔client shared-content container. The entire TU is a constructor: names the instance. All behavior (replication scope filtering, parenting rules) lives in base classes / replicator logic keyed off the class identity.

## Key types and API

- `ReplicatedStorage::ReplicatedStorage(void)` → `setName(sReplicatedStorage)`. Nothing else.

## Usage / reflection touchpoints

No descriptors, no methods. Consumers: [Network](../../Network/) replicator decides copy direction; scripts traverse it at runtime for shared assets. Companion containers documented beside this file: RobloxReplicatedStorage.md (RobloxLocked variant), ServerStorage.md, ReplicatedFirst.md.

## Gotchas

- No askAddChild/parenting restrictions here — anything parentable goes in; content policy is enforced nowhere in this TU.
- UNKNOWN: which replicator path special-cases this class name vs. a virtual marker (header-side).
