# App/include/v8datamodel/MeshContentProvider.h

## Purpose

`MeshContentProvider` (RUNTIME_LOCAL service) — [CacheableContentProvider](CacheableContentProvider.md) specialization that fetches mesh binaries and hands decoded meshes to the render side via ProcessTask/updateContent. Header-only override surface; all logic in the .cpp.

## Declared API

`class MeshContentProvider : public DescribedNonCreatable<MeshContentProvider, CacheableContentProvider, sMeshContentProvider, ClassDescriptor::RUNTIME_LOCAL>`

- `MeshContentProvider(); ~MeshContentProvider() {}`
- Overrides: `TaskScheduler::StepResult ProcessTask(const std::string& id, shared_ptr<const std::string> data);` `void updateContent(const std::string& id, shared_ptr<CachedItem> mesh);`

## Gotchas

- No additional API: cache/throttle behavior is entirely inherited (see base doc).

## UNKNOWN

- Decoded-mesh destination registry keyed by id (.cpp — no implementation doc exists at time of writing).

## Cross-links

- Base contract: [CacheableContentProvider.md](CacheableContentProvider.md); siblings [TextureContentProvider.md] (T–Z half), [SolidModelContentProvider.md] (S–Z half).
