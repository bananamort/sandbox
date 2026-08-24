# App/include/v8datamodel/factoryregistration.h

## Purpose

Stub header for the class-factory registration hook: declares an empty `RBX::FactoryRegistrator` with a default constructor. Ten lines total; the real registration machinery lives in its .cpp sibling (documented with the A–L implementation half).

## Declared API

- `class FactoryRegistrator { public: FactoryRegistrator(); };`

## Gotchas

- No members, no template surface — including it buys nothing by itself; the .cpp side performs descriptor registration.

## Cross-links

- Implementation: [App/v8datamodel/factoryregistration.md](../../v8datamodel/factoryregistration.md).
- Kin: [legacy.h](legacy.md) stub, reflection core under V8Tree.
