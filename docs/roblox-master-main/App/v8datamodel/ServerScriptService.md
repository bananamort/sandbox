# ServerScriptService.cpp

## Purpose

Implements `ServerScriptService` ("ServerScriptService"), the server-side script container: accepts only Folders, server Scripts (never LocalScripts), and ModuleScripts; runs contained Scripts only under backend processing; exposes the LoadStringEnabled flag consumed by services like PointsService that refuse to operate when loadstring is on.

## Key types and API

Descriptor:
- `desc_loadStringEnabled("LoadStringEnabled")` — bool, category_Behavior, cap PUBLIC_SERIALIZED (no security tier ⇒ default); default false.
  - Setter raises change ONLY when value changed AND `Network::Players::isCloudEdit` — local edits don't fire the property-changed signal.

Rules:
- `askAddChild`: Folder always OK; Script AND NOT LocalScript OK; ModuleScript OK. Plain LocalScript rejected (expression `(Script && !LocalScript) || ModuleScript`).
- `scriptShouldRun`: ancestor check → backendProcessing required → only non-LocalScript Scripts run.

## Usage / reflection touchpoints

Pairs with PointsService.md (canUseService reads LoadStringEnabled), PlayerScripts.md (client mirror), script docs at [App/script](../../script/).

## Gotchas

- A LocalScript passes the first cast test (it IS a Script subclass) but is excluded by the second — order matters if anyone rewrites this.
- CloudEdit-only change notification means Studio-local LoadStringEnabled toggles are invisible to listeners until replicated.
- UNKNOWN: where loadStringEnabled gates actual loadstring bytecode execution (ScriptContext side).
