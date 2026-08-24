# RobloxReplicatedStorage.cpp

## Purpose

Implements `RobloxReplicatedStorage` ("RobloxReplicatedStorage"), the Roblox-engine-owned twin of ReplicatedStorage for first-party replicated content. Entire TU is a constructor that names the instance and marks it RobloxLocked — scripts cannot re-parent or delete it.

## Key types and API

- Ctor: `setName(sRobloxReplicatedStorage)` + `setRobloxLocked(true)`. Nothing else.

## Usage / reflection touchpoints

No descriptors. Engine CoreScripts use it as a trusted channel; pairs with ReplicatedStorage.md (unlocked sibling) and PlayerGui.md's CoreGuiService (same RobloxLocked pattern) in this folder.

## Gotchas

- RobloxLocked protects against script-side reparenting/destruction but this TU adds no content restrictions.
- UNKNOWN: replication direction/scope rules live replicator-side (Network docs).
