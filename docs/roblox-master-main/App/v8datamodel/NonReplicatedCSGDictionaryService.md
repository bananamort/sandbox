# NonReplicatedCSGDictionaryService.cpp

## Purpose

Implements `NonReplicatedCSGDictionaryService` (Instance name "NonReplicatedCSGDictionaryService") — the session-local twin of `CSGDictionaryService`. It deduplicates CSG (UnionOperation/PartOperation "ChildData") mesh blobs within a single client session WITHOUT replicating them: data stored here never crosses the network, unlike the replicated dictionary. Typical use is Studio-side editing of unions.

## Key types and API

Service class whose ctor sets its name; inherits the shared instanceMap/hash machinery from the CSG dictionary base — see CSGDictionaryService.

Methods:
- `storeData(PartOperation&, bool forceIncrement=false)`: takes the operation's ChildData blob, interns it via inherited `storeStringData(tmpString, forceIncrement, "ChildData")`, writes back the (possibly replaced) ChildData on the operation. Under `FFlag::StudioCSGAssets`, empty blobs are skipped only when `FFlag::IgnoreBlankDataOnStore` (default true).
- `retrieveData(PartOperation&)`: reads the op's ChildData, resolves it through the dictionary (`retrieveStringData`), writes the expanded blob back.
- `storeAllDescendants(instance)` / `retrieveAllDescendants(instance)`: recursive pre-order walk storing/retrieving every descendant PartOperation.
- `refreshRefCountUnderInstance(Instance*)`: re-stores every PartOperation under the instance with forceIncrement=true to fix reference counts (copy/paste/duplication flows so shared blobs aren't freed prematurely).
- `reparentChildData(shared_ptr<Instance>)`: if the child is dictionary data (a BinaryStringValue holding a mesh blob), moves it under the replicated `CSGDictionaryService` and removes the local hash key from this service's instanceMap — promoting session-local data into replicated storage.

FFlags declared: `IgnoreBlankDataOnStore` (default true). FFlags consumed: `StudioCSGAssets`.

## Usage / reflection touchpoints

No REFLECTION block of its own; all behavior is inherited from the CSGDictionaryService base (hash keys via createHashKey over BinaryStringValue payloads). PartOperation save/duplicate flows call into this service; both dictionary services are hosted as DataModel services.

## Gotchas

- Blank ChildData is silently ignored when IgnoreBlankDataOnStore is on (default); with StudioCSGAssets off the legacy path stored blanks unconditionally.
- reparentChildData erases only THIS service's map entry — the key now belongs to the replicated dictionary; refcount discipline lives in the base class.
- refreshRefCountUnderInstance always force-increments; callers must guarantee matching decrements elsewhere.
- UNKNOWN: storeStringData/retrieveStringData/refcount semantics live in CSGDictionaryService.cpp (A–L scope, other agent).
