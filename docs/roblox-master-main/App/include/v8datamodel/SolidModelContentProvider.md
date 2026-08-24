# App/include/v8datamodel/SolidModelContentProvider.h

## Purpose

`SolidModelContentProvider` — RUNTIME_LOCAL non-creatable `CacheableContentProvider` specialization for SolidModel (legacy union/mesh) content: overrides the fetch-completion and cache-update hooks; empty inline dtor.

## Declared API

`class SolidModelContentProvider : public DescribedNonCreatable<SolidModelContentProvider, CacheableContentProvider, sSolidModelContentProvider, RBX::Reflection::ClassDescriptor::RUNTIME_LOCAL>`

- Ctor; `~SolidModelContentProvider() {}`.
- Private overrides: `virtual TaskScheduler::StepResult ProcessTask(const std::string& id, shared_ptr<const std::string> data)` — decode downloaded bytes; `virtual void updateContent(const std::string& id, boost::shared_ptr<CacheableContentProvider::CachedItem> mesh)` — publish decoded item into cache.

## Gotchas

- No public API: everything flows through the base provider's async queue ([CacheableContentProvider.md](CacheableContentProvider.md)).
- RUNTIME_LOCAL descriptor = per-session service, not persisted.

## UNKNOWN

- Decoded CachedItem payload type details (base-class nested type, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/SolidModelContentProvider.md](../../v8datamodel/SolidModelContentProvider.md).
- Base: [CacheableContentProvider.md](CacheableContentProvider.md); siblings: [MeshContentProvider.md](MeshContentProvider.md), [TextureContentProvider.md](TextureContentProvider.md); consumers: [PartOperation.md](PartOperation.md).
