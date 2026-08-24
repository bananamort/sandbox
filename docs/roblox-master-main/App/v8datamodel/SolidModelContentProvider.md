# SolidModelContentProvider.cpp

## Purpose

Implements `SolidModelContentProvider`, a RUNTIME_LOCAL CacheableContentProvider (32 MB LRU, CACHE_ENFORCE_MEMORY_SIZE) that fetches serialized `PartOperationAsset` blobs for union assets and pre-parses their render mesh (`CSGMesh`) before caching — the client side of the PartOperationAsset publish pipeline.

## Key types and API

- Ctor: DescribedNonCreatable<…, CacheableContentProvider, …>(CACHE_ENFORCE_MEMORY_SIZE, 32×1024×1024).
- `ProcessTask(id, data)` (TaskScheduler step): deserialize binary instances stream via SerializerBinary; first instance must be PartOperationAsset → build CSGMesh from its MeshData binary string, attach via setRenderMesh, cache under id; empty instance list or null data → MESSAGE_ERROR "failed to process %s because 'could not fetch'" + markContentFailed. Decrements pendingRequests only on the success path.
- `updateContent(id, item)`: cache insert sized by mesh index+vertex byte footprint when a mesh exists, else zero-size insert.

## Usage / reflection touchpoints

No script surface. Consumers: PartOperation.md / PartOperationAsset.md blockingRequestContent paths in this folder; FlyweightService/CSGDictionaryService ecosystem.

## Gotchas

- pendingRequests is decremented ONLY after successful updateContent — failures leak the pending count (UNKNOWN downstream effect of drift).
- A deserialized asset whose front instance ISN'T a PartOperationAsset silently caches an EMPTY item (data null path inserts size 0) without failing the request.
- Mesh parse happens synchronously inside the task step — huge unions stall this scheduler slice.
