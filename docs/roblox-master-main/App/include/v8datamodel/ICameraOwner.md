# App/include/v8datamodel/ICameraOwner.h

## Purpose

Minimal interface for Instances that own a [Camera](Camera.md) ("assumed to be descended from Instance when used... RootInstance is descended from this"): expose the camera and the owning model.

## Declared API

`class RBXBaseClass ICameraOwner`

- `virtual Camera* getCamera() = 0;`
- `virtual const Camera* getConstCamera() const = 0;`
- `virtual const ModelInstance* getCameraOwnerModel() const = 0;`
- Inline trivial ctor/dtor (virtual dtor present).

## Gotchas

- Three pure virtuals, nothing else — implementers must always have a live Camera pointer or handle null.

## Cross-links

- Consumer: [Camera.md](Camera.md) (`ICameraOwner* getCameraOwner()` private accessor); sibling interfaces: [ICharacterSubject.md](ICharacterSubject.md).
