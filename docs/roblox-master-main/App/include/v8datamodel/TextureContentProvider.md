# App/include/v8datamodel/TextureContentProvider.h

## Purpose

`TextureContentProvider` — RUNTIME_LOCAL non-creatable `CacheableContentProvider` for image content: decodes downloaded bytes into an `RBX::Image` via an injectable allocator function and publishes into the cache. No certified implementation doc exists for this header.

## Declared API

`class TextureContentProvider : public DescribedNonCreatable<TextureContentProvider, CacheableContentProvider, sTextureContentProvider, RBX::Reflection::ClassDescriptor::RUNTIME_LOCAL>`

- Non-Windows guard: `#ifndef _WIN32 #define HASH_STRING_DO_NOT_IMPLEMENT #endif`.
- Private member: `boost::function<RBX::Image*(std::istream&, const std::string&)> mTextureAllocator;`
- Ctor; empty dtor.
- Public: `void setTextureAllocator(boost::function<RBX::Image*(std::istream&, const std::string&)>)`.
- Private overrides: `virtual TaskScheduler::StepResult ProcessTask(const std::string& id, shared_ptr<const std::string> data)` (decode); `virtual void updateContent(const std::string& id, boost::shared_ptr<CacheableContentProvider::CachedItem> item)` (cache publish).

## Gotchas

- The allocator is raw `Image*` from a factory function — ownership transfers to the CachedItem presumably; leak risk if ProcessTask fails after allocation.
- No certified doc: behavior claims rely on the base provider contract ([CacheableContentProvider.md](CacheableContentProvider.md)).

## UNKNOWN

- Default allocator before setTextureAllocator is called (set in ctor? out-of-line).

## Cross-links

- Base: [CacheableContentProvider.md](CacheableContentProvider.md) (implementation: [App/v8datamodel/CacheableContentProvider.md](../../v8datamodel/CacheableContentProvider.md)).
- Siblings: [MeshContentProvider.md](MeshContentProvider.md), [SolidModelContentProvider.md](SolidModelContentProvider.md).
