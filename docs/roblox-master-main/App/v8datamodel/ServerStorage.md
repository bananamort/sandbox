# ServerStorage.cpp

## Purpose

Implements `ServerStorage` ("ServerStorage"), the server-only content container. Constructor names the instance; the single behavioral rule forbids adding children on the CLIENT outside Studio.

## Key types and API

No descriptors.
- Ctor: `setName(sServerStorage)`.
- `askAddChild(instance)`: allowed only when `Network::Players::backendProcessing(this)` OR `GameBasicSettings::singleton().inStudioMode()` — clients can never parent anything into ServerStorage at runtime.

## Usage / reflection touchpoints

No script surface beyond container semantics; contents are invisible/absent client-side by replicator policy (UNKNOWN exact filter location header-side). Pairs with ReplicatedStorage.md / RobloxReplicatedStorage.md in this folder.

## Gotchas

- The gate is on CHILD ADDITION only — nothing prevents scripts from READING or reparenting out on the client if replication ever delivered content there.
