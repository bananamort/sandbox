# App/include/v8datamodel/GlobalSettings.h

## Purpose

Settings framework root: `Settings` (a ServiceProvider persisting a settings file) with `GlobalBasicSettings`/`GlobalAdvancedSettings` singletons beneath it, per-item base classes (`Item`), and the templated singleton CRTP helpers `GlobalAdvancedSettingsItem`/`GlobalBasicSettingsItem` that auto-create and parent items on first access.

## Declared API

Descriptors: `sSettings`, `sSettingsItem`, `sGlobalBasicSettings`, `sGlobalAdvancedSettings`.

`class Settings : public DescribedNonCreatable<Settings, ServiceProvider, sSettings>`

- Ctor `(const std::string& settingsFile)`; `void setSaveTarget(const std::string&)`; `loadState(file)`, `saveState()`, `eraseSettingsStore()`, `removeInvalidChildren()`; protected `settingsFile`, `settingsErased`; override `verifyAddDescendant(...)`; override `bool useSubmitTaskForLuaListeners() const { return true; }`
- Private visitor structs: `InvalidDescendentDetector { bool anyInvalid; ctor; static bool invalid(const Instance*); operator()(shared_ptr<Instance>); }` and `InvalidDescendentCollector { std::vector<shared_ptr<Instance>> invalidInstances; operator()(shared_ptr<Instance>); }`.

`class GlobalBasicSettings : public DescribedNonCreatable<GlobalBasicSettings, Settings, sGlobalBasicSettings>`

- Nested `class Item : public NonFactoryProduct<Instance, sSettingsItem>` — virtual `reset() {}` (no-op), submit-task-for-Lua true, askAddChild allows only Item children.
- Members: `boost::mutex mutex; static shared_ptr<GlobalBasicSettings> singleton(); void reset(); bool isUserFeatureEnabled(std::string name); verifySetParent(...) const override;`

`class GlobalAdvancedSettings : public DescribedNonCreatable<..., Settings, sGlobalAdvancedSettings>`

- Same nested Item pattern (no reset()).
- FastVar surface: `shared_ptr<const Reflection::ValueTable> getFVariables(); std::string getFVariable(std::string flag); bool getFFlag(std::string name);`
- `boost::mutex mutex; static shared_ptr<GlobalAdvancedSettings> singleton(); static GlobalAdvancedSettings* raw_singleton(); verifySetParent override;`

Templates:
- `template<class Class, const char* const& sClassName> class GlobalAdvancedSettingsItem : public DescribedCreatable<Class, GlobalAdvancedSettings::Item, sClassName>, public Service` — protected ctor names itself and enforces one instance ("singleton %s already exists" throw), static `sing`; `static Class& singleton()` shortcut-or-create: locks the Global settings mutex, constructs via `Class::createInstance()`, parents to the global settings.
- `GlobalBasicSettingsItem<Class, sClassName>` — identical shape under GlobalBasicSettings plus `virtual void resetSettings() {}`.
- Both templates define their static `sing` in the header (per-class null init).

## Gotchas

- Items are lazily created and *parented into the settings ServiceProvider* on first singleton() access — thread-safe only through the global's mutex after the shortcut path (first check is unsynchronized).
- Item children restricted to other Items — flat namespace by design.
- getFFlag/getFVariable expose the FastLog variable registry through Lua-facing settings.

## UNKNOWN

- Settings file format/serialization (.cpp — see [GlobalSettings.md](../../v8datamodel/GlobalSettings.md)).

## Cross-links

- Implementation: [App/v8datamodel/GlobalSettings.md](../../v8datamodel/GlobalSettings.md).
- Items: [GameBasicSettings.md](GameBasicSettings.md), [GameSettings.md](GameSettings.md), [DebugSettings.md](DebugSettings.md), [FastLogSettings.md](FastLogSettings.md).
