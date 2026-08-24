# Configuration.cpp

## Purpose

Implements `Configuration` ("Configuration") — a creatable folder-like holder that may contain ONLY IValue objects, may sit only under Parts or Models, at most ONE per parent, and registers itself into CollectionService's class-name buckets as it moves between providers.

## Key types and API

Descriptors: none. Constants: `sConfiguration = "Configuration"`.

Behavior:
- `askForbidChild(instance)` — forbids everything EXCEPT IValue descendants (the ValueBase family, [Value](Value.md)).
- `askSetParent(instance)` — allows PartInstance or ModelInstance-class parents ONLY (explicitly not Workspace despite ModelInstance ancestry check by descriptor compare); then rejects if the target already contains any Configuration child ("There can be only one Configuration object per part").
- `onServiceProvider` — removes self from old provider's CollectionService, adds to new one's.

## Usage / reflection touchpoints

The canonical named-values bag attached to parts/models; interacts with [CollectionService](CollectionService.md) registration and [PartInstance](PartInstance.md)/[ModelInstance](ModelInstance.md) parenting.

## Gotchas

- The Workspace exclusion relies on descriptor inequality (`instance->getDescriptor() != ModelInstance::classDescriptor()`) — anything else that ISN'T a Part or exactly-ModelInstance class is refused.
- askSetParent walks only DIRECT children for the uniqueness check — nested Configurations under sub-models are allowed.
- Children restriction means scripts storing non-value objects inside fail with the standard parenting error.
