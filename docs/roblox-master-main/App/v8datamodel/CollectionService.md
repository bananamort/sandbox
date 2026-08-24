# CollectionService.cpp

## Purpose

Implements `CollectionService` ("CollectionService") — an EARLY, class-name-keyed variant: instances are bucketed by their descriptor class name into copy-on-write instance lists, with GetCollection plus ItemAdded/ItemRemoved signals. This is NOT the tag-based CollectionService of later eras — no AddTag/GetTagged here.

## Key types and API

Descriptors:
- `func_GetCollection("GetCollection", "class", Security::None)` — BoundFunc returning Instances.
- `event_collectionItemAdded("ItemAdded", "instance")`, `event_collectionItemRemoved("ItemRemoved", "instance")` — plain Events. No other Security:: tiers.

Constants: `sCollectionService = "CollectionService"`; DescribedNonCreatable (service, not creatable).

Behavior:
- `getCollection(Name/string)` — lookup by exact class-descriptor name; missing → empty shared_ptr.
- `addInstance` / `removeInstance` — maintain `collections[className] = copy_on_write_ptr<Instances>`; removal uses swap-with-back "fast-remove" (ORDER NOT PRESERVED) then raises signal; add appends and raises.

## Usage / reflection touchpoints

Header includes Configuration.h (legacy pairing); modern tag API lives elsewhere; consumers iterate returned Instances like [Selection](Selection.md)-style lists.

## Gotchas

- Keying is by CLASS NAME (e.g. all "Part"s), not arbitrary tags — every instance of a registered class lands in the same bucket.
- removeInstance asserts the collection exists; removing an unregistered instance trips RBXASSERT in debug.
- Fast-remove scrambles ordering between GetCollection calls — never rely on list stability.
