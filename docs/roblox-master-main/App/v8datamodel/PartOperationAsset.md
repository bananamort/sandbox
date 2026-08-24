# PartOperationAsset.cpp

## Purpose

Implements `PartOperationAsset`, the serializable Instance that packages a union's CSG payloads (`ChildData` + `MeshData` BinaryStrings) for upload as a web asset ("SolidModel"). Also hosts the Studio-side publish machinery: free functions `publishPartOperations` / `setAssetOnMatchingPartOperations` plus statics `PartOperationAsset::publishAll` / `publishSelection`, which POST serialized instances to `/ide/publish/uploadnewasset` and swap in-place dictionary references for the returned asset id. This is the Team Create / save-to-web path for unions.

## Key types and API

Descriptors:
- `desc_ChildData("ChildData")` — BinaryString, category_Data, cap CLUSTER, **Security::Roblox**.
- `desc_MeshData("MeshData")` — BinaryString, category_Data, cap STREAMING, **Security::Roblox**.

Constant: `sPartOperationAsset = "PartOperationAsset"`.

Free functions:
- `setAssetOnMatchingPartOperations(descendant, url, key)`: for each `PartOperation` descendant lacking an asset whose ChildData equals `key` → `setAssetId(url)` then blank both ChildData and MeshData.
- `publishPartOperations(descendant, startTime, timeoutMills)`: respects the shared deadline (`timeoutMills == -1` = unlimited). Two modes:
  - Has asset already: pulls the stored `PartOperationAsset` via `SolidModelContentProvider::blockingRequestContent`, restores any still-hash-keyed Child/Mesh data through `NonReplicatedCSGDictionaryService`/`CSGDictionaryService::retrieve*`, blanks the local keys; GA event "RemoveLeftoverCSGData".
  - No asset: verifies both keys exist in their dictionaries (GA "PublishCSGFailure"/"HashKeyNotFound" otherwise), peeks raw data (child falls back to replicated dictionary if NR copy is empty), serializes a fresh PartOperationAsset with `SerializerBinary`, POSTs to `<baseUrl>/ide/publish/uploadnewasset?assetTypeName=SolidModel&…&isPublic=True&genreTypeId=1&allowComments=False` as application/xml, parses the integer asset id back out, sets AssetId, blanks local keys, walks ALL DataModel descendants with `setAssetOnMatchingPartOperations` (gated by FFlag CSGFixForNoChildData when child data was invalid), removes consumed dictionary entries. HTTP failure → throw `DataModel::SerializationException("Failed to upload union.  Exceeded limit.  Try again in a few minutes.")`.
- `PartOperationAsset::publishAll(dataModel, timeoutMills)`: `visitDescendants(publishPartOperations)` then `clean()` both dictionaries; GA user timing "SolidModelPublishAll". Always returns true.
- `PartOperationAsset::publishSelection(dataModel, timeoutMills)`: same over `RBX::Selection` contents; timing event "SolidModelPublishSelection". Always returns true.

Flags: `FASTFLAGVARIABLE(CSGFixForNoChildData, true)` — when true, skip the descendant-sweep and replicated-dictionary removal for publishes whose childData could not be recovered.

## Usage / reflection touchpoints

Called from Studio save/publish flows (Team Create) — nothing here is script-facing beyond the two Roblox-security data properties. Depends on `RBX::Http` (see App/util Http docs), `SerializerBinary` (V8Xml), and the dictionary services documented beside this file: `CSGDictionaryService.md`, `NonReplicatedCSGDictionaryService.md`, `SolidModelContentProvider.md`, and consumes assets produced per `PartOperation.md`.

## Gotchas

- Upload URL hardcodes `isPublic=True` — every published union becomes a public asset.
- Response parsing is bare `istream >> newAssetId`; any non-numeric prefix yields id 0 → AssetId `<baseUrl>/asset/?id=0`.
- `publishPartOperations` early-returns (silently skipping the instance) when either key is missing/unknown-hash; only the hash-miss case reports GA failure.
- ChildData recovery prefers the NonReplicated dictionary and only falls back to the replicated one; MeshData has no such fallback.
- Both `publishAll`/`publishSelection` return true unconditionally — individual failures are not reflected in the result.
- The `timeoutMills` budget is wall-clock from publish start; a slow first upload starves later selections entirely.
- UNKNOWN: numeric enum/values of anything header-side (class inherits Instance directly per includes); the awagnerTODO LRU-cache handoff was never implemented in this TU.
