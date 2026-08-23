# App/include/v8tree — Index

The `v8tree` subsystem is the root of Roblox's datamodel object system: every object that can exist in a place hierarchy (`Instance`) lives here, along with the service-locator pattern (`Service`/`ServiceProvider`/`ServiceClient`), property-change plumbing (`PropertyChanged`, category macros), and the legacy menu-command ("verb") framework. Implementations are mostly in `App/v8datamodel` and reflection glue in `App/reflection`; this header set defines the contracts all other engine modules build on.

## Files

- [EnumProperty.md](EnumProperty.md) — empty placeholder header aggregating reflection enum-converter includes.
- [Instance.md](Instance.md) — `RBX::Instance`: root base class of the object tree; parent/children, GUID identity, lifecycle (`destroy`), XML I/O, signals, parenting rules.
- [Property.md](Property.md) — `RBX::PropertyChanged` notification wrapper plus standard property-category string macros.
- [Service.md](Service.md) — `Service` tag mixin, `ServiceProvider` singleton-per-scope registry with Find/GetService semantics, lazy `ServiceClient<S>` wrapper.
- [Verb.md](Verb.md) — named command objects (`Verb`/`BoundVerb`/`NullVerb`), their registry `VerbContainer`, and security-gated execution via `doItWithChecks`.
