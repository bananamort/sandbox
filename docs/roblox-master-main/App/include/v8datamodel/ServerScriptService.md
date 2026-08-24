# App/include/v8datamodel/ServerScriptService.h

## Purpose

`ServerScriptService` — PERSISTENT_LOCAL_INTERNAL creatable service: server-side script container. Gates which scripts run via IScriptFilter, exposes the legacy `LoadStringEnabled` toggle, and refuses all reparenting (root-only service).

## Declared API

`class ServerScriptService : public DescribedCreatable<ServerScriptService, Instance, sServerScriptService, Reflection::ClassDescriptor::PERSISTENT_LOCAL_INTERNAL>, public Service, public IScriptFilter`

- `static Reflection::PropDescriptor<ServerScriptService, bool> desc_loadStringEnabled;`
- Ctor; IScriptFilter `/*override*/ bool scriptShouldRun(BaseScript* script)`.
- Inline `bool getLoadStringEnabled() const` / `setLoadStringEnabled(bool)` over private `bool loadStringEnabled`.
- Parenting inline-locked: `askSetParent {return false}`, `askForbidParent = !askSetParent`; real `askAddChild`; `askForbidChild = !askAddChild`.

## Gotchas

- Cannot be reparented (askSetParent=false) — root service only.
- LoadStringEnabled is a security-relevant legacy switch (allows loadstring in server scripts); default set out-of-line.

## UNKNOWN

- What askAddChild permits/rejects (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/ServerScriptService.md](../../v8datamodel/ServerScriptService.md).
- Client twin: [PlayerScripts.md](PlayerScripts.md); storage sibling: [ServerStorage.md](ServerStorage.md); marker service: [ScriptService.md](ScriptService.md).
