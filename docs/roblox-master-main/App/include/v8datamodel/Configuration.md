# App/include/v8datamodel/Configuration.h

## Purpose

`Configuration` Instance ("Configuration") — a plain named container Instance used for organizing children (e.g. under players/services); adds only tree-placement policy to base Instance.

## Declared API

`class Configuration : public DescribedCreatable<Configuration, Instance, sConfiguration>`

- `Configuration();`
- Overrides: `bool askForbidChild(const Instance* instance) const;` `bool askSetParent(const Instance* instance) const;` `void onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider);`

## Gotchas

- No state or properties of its own — all behavior is the three overrides (.cpp decides what children/parents are legal).

## UNKNOWN

- The exact child/parent allow-lists (.cpp — see [Configuration.md](../../v8datamodel/Configuration.md)).

## Cross-links

- Implementation: [App/v8datamodel/Configuration.md](../../v8datamodel/Configuration.md).
