# App/include/v8datamodel/IModelModifier.h

## Purpose

Empty marker interface (16 lines) implemented by appearance objects that modify a model ([CharacterAppearance](CharacterAppearance.md) derives from it). No methods.

## Declared API

`class RBXInterface IModelModifier` — inline trivial ctor + virtual dtor; entire surface.

## Gotchas

- Pure tag type: useful only for `dynamic_cast<IModelModifier*>`-style discovery.

## Cross-links

- Implementer: [CharacterAppearance.md](CharacterAppearance.md).
