# App/include/reflection/Descriptor.h

## Purpose

Declares `RBX::Reflection::Descriptor`, the abstract base of every reflection descriptor (classes, properties, functions, events, enums): a declared `RBX::Name`, deprecation attributes, replicable/outdated flags, and the engine-wide `lockedDown` guard that crashes (`RBXCRASH`) if anyone tries to mutate the reflection database after the first described instance exists.

## Declared API

- `class RBX::Reflection::Descriptor : public boost::noncopyable`
  - Private static inline: `static void checkLockedDown()` — comment: "If this following assertion fails then you need to put your class into FactoryRegistrator::FactoryRegistrator() or somewhere else. Failure of this test is so severe that we want to catch it in production, too." Fires RBXCRASH when `lockedDown`.
  - Nested `struct Attributes { bool isDeprecated; const Descriptor* preferred; Attributes(); static Attributes deprecated(const Descriptor& preferred); static Attributes deprecated(); }` (all inline).
  - Public: `static bool lockedDown;` ("After the first instance of a described class is created we cannot modify the reflection database"); `const RBX::Name& name;` `scoped_ptr<bool> isReplicable; scoped_ptr<bool> isOutdated; const Attributes attributes;`
  - Ctors `(const char*, Attributes)` / `(const RBX::Name&, Attributes)` — both declare the name, default flags false, call checkLockedDown, assert non-empty name. Virtual dtor.

## Usage notes

- Base for Type (ClassDescriptor), PropertyDescriptor, FunctionDescriptor, EventDescriptor, EnumDescriptor — see sibling docs.
- Registration must happen before first Instance creation (FactoryRegistrator pattern).

## Gotchas

- Post-lockdown registration = intentional production crash, not just a debug assert.
- `isReplicable`/`isOutdated` are scoped_ptr<bool> — late-bound by subclasses via reset(), because the value isn't known at base-ctor time.
