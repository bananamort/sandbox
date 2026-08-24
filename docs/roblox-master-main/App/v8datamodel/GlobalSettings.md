# GlobalSettings.cpp

## Purpose

Implements the persistent settings containers: `Settings` (base — XML load/save of Item children to a file, invalid-descendant policing), `GlobalAdvancedSettings` (registered "GlobalSettings", file GlobalSettings_13.xml, instance name "Global Settings") exposing FLog/FVariable readers, and `GlobalBasicSettings` ("UserSettings", GlobalBasicSettings_13.xml) with Reset + IsUserFeatureEnabled. Both are once-per-process singletons.

## Key types and API

Descriptors:
- `fun_getFastVariable("GetFVariable", "name", Security::None)` — string; missing name throws "Flag %s does not exist".
- `fun_getFastVariables("GetFVariables", **Security::RobloxScript**)` — ValueTable of ALL fast variables (FLog::ForEachVariable ANY type).
- `func_getFFlag("GetFFlag", "name", Security::None)` — bool via case-insensitive "true" compare.
- `func_reset("Reset", Security::None)` on basic settings — resets every child Item.
- `func_isUserFeatureEnabled("IsUserFeatureEnabled", "name", Security::None)` — REQUIRES name to start with "User" else throw; then FLog lookup as bool.

Flags: `FASTFLAGVARIABLE(DisableGlobalSettingsParentChange, true)` — non-Anonymous identities need RobloxScript permission to re-parent advanced settings. Constants: sGlobalAdvancedSettings/sGlobalBasicSettings/sSettings="GenericSettings".

Behavior:
- Settings persistence: loadState parses XML with MergeBinder; saveState writes children ONLY when no invalid descendants and store not erased (eraseSettingsStore deletes the file); InvalidDescendentDetector accepts only GlobalBasic/Advanced Items + Selection — anything else under settings is illegal ("Not allowed to add that under settings").
- Singletons: static shared_ptr + boost::once; raw_singleton asserts g_sing.
- GlobalAdvancedSettings ctor creates Selection eagerly — long comment about Mac unit-test destruction ORDER avoiding SIGABRT.
- verifySetParent on both classes requires RobloxScript unless identity is Anonymous (basic version unconditional, advanced flag-gated).

## Usage / reflection touchpoints

Singletons initialized in [Game](Game.md)::globalInit; FVariables defined in [FastLogSettings](FastLogSettings.md); [Selection](Selection.md) co-resident by design.

## Gotchas

- GetFVariables exposes EVERY fast-variable value at RobloxScript security — a broad introspection surface including flags meant to be invisible.
- saveState silently SKIPS writing when any invalid descendant exists — a single stray instance under settings stops ALL preference persistence.
- IsUserFeatureEnabled's "User"-prefix gate is a naming convention, not a real namespace.
