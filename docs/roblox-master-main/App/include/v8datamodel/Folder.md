# App/include/v8datamodel/Folder.h

## Purpose

`Folder` Instance — a plain organizational container with permissive tree rules; adds only placement-policy overrides to Instance.

## Declared API

`class Folder : public DescribedCreatable<Folder, Instance, sFolder>`

- `Folder();`
- Overrides: `bool askAddChild(const Instance*) const; bool askForbidChild(const Instance*) const; bool askSetParent(const Instance*) const; bool askForbidParent(const Instance*) const;`

## Gotchas

- No state/properties — the four ask* overrides (bodies in .cpp) define what can live where.

## UNKNOWN

- Exact allow/deny lists (.cpp — see [Folder.md](../../v8datamodel/Folder.md)).

## Cross-links

- Implementation: [App/v8datamodel/Folder.md](../../v8datamodel/Folder.md).
- Container kin: [Configuration.md](Configuration.md), [ModelInstance.md](ModelInstance.md).
