# FlyweightService.cpp

## Purpose

Implements `FlyweightService` ("FlyweightService") — the base content-deduplication service behind the CSG dictionaries: interns BinaryString blobs as MD5-keyed BinaryStringValue children with refcounts, rewrites PartOperation data fields into "CSGK"+hash local keys, resolves them back, cleans unreferenced entries, and (StudioCSGAssets flag) treats http(s) URLs as hash-keys too.

## Key types and API

Descriptors: none. Constants: internal `localKeyTag("CSGK")`, `minKeySize(4)`; `sFlyweightService`. Flags: consumed StudioCSGAssets; `DYNAMIC_FASTFLAGVARIABLE(DoNotCleanCSGDictionaryOnPublishInCloudEdit, true)`.

State: `instanceMap: MD5hash → InstanceStringData{weak_ptr<BinaryStringValue> ref, int count}`; lazy childAddedSignal hookup in onServiceProvider (first child also fires GA "UsingCSG" once per process).

Core operations:
- `storeStringData(BinaryString&, forceIncrement, name)` — non-hash data → createHashKey(MD5); reuse existing live child (count++) or create named BinaryStringValue child under this service; rewrite str to "CSGK"+hash. Already-hashed + forceIncrement → count++ (possibly creating count-only map entry).
- `retrieveStringData` — "CSGK" key → swap in child's real bytes, count--.
- `peekAtData` — resolve without consuming.
- `removeStringData` — unparent + erase entry; SKIPPED in Cloud Edit under DoNotClean flag.
- `clean()` — drop entries with count≤0 OR dead weak-ref (nulling refs first so cleanChildren keeps exactly one survivor per hash), then `cleanChildren()` deletes orphan/duplicate children. All cleaning no-ops in Cloud Edit.
- `refreshRefCount()` — clear map, walk whole DataModel via refreshRefCountUnderInstance (virtual, subclass supplies), cleanChildren.
- Key helpers: `isHashKey` (flag on: CSGK prefix OR http:// / https:// prefix; else CSGK only), `getLocalKeyHash` (strip tag), `getHashKey`, `createHashKey` = MD5 hex.
- Diagnostics: dataType(key) → "C"(child/xml "<roblox"), "P"(CSGPH physics), "M"(mesh), "-"; printMapSizes dumps to output.

## Usage / reflection touchpoints

Base of [CSGDictionaryService](CSGDictionaryService.md)/[NonReplicatedCSGDictionaryService](NonReplicatedCSGDictionaryService.md); ChangeHistory requests clean() on both ([ChangeHistory](ChangeHistory.md)).

## Gotchas

- retrieveStringData decrements count even when the SAME blob is retrieved repeatedly — store/forceIncrement/retrieve bookkeeping must stay balanced or entries die early.
- isHashKey treating http URLs as keys means CDN-backed unions flow through the same code paths without local storage (peek returns empty).
- clean() nulls ALL live refs before cleanChildren — a concurrent reader between those steps sees empty dictionary.
