# App/script/Script.cpp

## Purpose

Implements the script instance classes `BaseScript` → `Script` → `LocalScript`: the DataModel objects that carry Lua source (embedded `ProtectedString`) or a `LinkedSource` (`ScriptId`) and negotiate their own execution by finding/leaving a `RuntimeScriptService` "workspace" whenever their code, Disabled flag, ancestry, or provider changes. This is the top of the execution pipeline: property change → `restartScript()` → `RuntimeScriptService::runScript/releaseScript` → (in App/script/ScriptContext.cpp) `ScriptContext::addScript/removeScript`.

## API

- Constants: `const char* const RBX::sBaseScript = "BaseScript"`, `sScript = "Script"`, `sLocalScript = "LocalScript"`; static `std::string BaseScript::adminScriptsPath` (set via `ScriptContext::setAdminScriptPath`).
- Reflection: `Script::prop_EmbeddedSourceCode` — property `"Source"` (category_Data, STANDARD, Security::Plugin) backed by `getEmbeddedCodeSafe`/`setEmbeddedCode`; `BaseScript::prop_SourceCodeId` — `"LinkedSource"` backed by `getScriptId`/`setScriptId`; `BaseScript::prop_Disabled` — `"Disabled"` (category_Behavior) backed by `getDisabled`/`setDisabled`; `Script::func_GetHash` — bound func `"GetHash"` (Security::RobloxPlace) → `getHash`.
- Constructors: `BaseScript::BaseScript()` (workspace=NULL, disabled=false, badLinkedScript=false, named BaseScript); `Script::Script()` via `DescribedCreatable<Script, BaseScript, sScript>`; `LocalScript::LocalScript()` via `DescribedCreatable<LocalScript, Script, sLocalScript>`.
- Source access: `const boost::flyweight<ProtectedString>& Script::getEmbeddedCode() const`; `const ProtectedString& Script::getEmbeddedCodeSafe() const`; `void Script::setEmbeddedCode(const ProtectedString& value)` (updates `embeddedSourceHash` via `ComputeMd5Hash(value.getSource())`, then `restartScript()` and raisePropertyChanged).
- `static bool BaseScript::hasCoreScriptReplacements()` — checks `<adminScriptsPath>/StarterScript.lua` (`XStarterScript.lua` under ENABLE_XBOX_STUDIO_BUILD) existence with boost::filesystem.
- `void BaseScript::setDisabled(bool value)` — restart + raisePropertyChanged.
- `void BaseScript::onScriptIdChanged()` — clears `badLinkedScript`, restart, raisePropertyChanged.
- `RuntimeScriptService* BaseScript::computeNewWorkspace()` — NULL if disabled; otherwise walks up parents looking for an `IScriptFilter` whose `scriptShouldRun(this)` approves; if approved returns `ServiceProvider::create<RuntimeScriptService>(this)` (may be NULL while shutting down).
- `void BaseScript::restartScript()` / `void BaseScript::onAncestorChanged(const AncestorChanged&)` / `void BaseScript::onServiceProvider(ServiceProvider*, ServiceProvider*)` — all three re-evaluate `computeNewWorkspace()` and migrate: release from old workspace (`temp->releaseScript(this)`) then `workspace->runScript(this)`.
- Code fetch: `BaseScript::Code BaseScript::requestCode(ScriptInformationProvider* scriptInfoProvider)` — asserts cached remote load state != NotAttemptedToLoad; returns `Code(flyweight(getCachedRemoteSource()))` only when state == Loaded, else empty `Code()`; `Script::requestCode(...)` override prefers embedded source when `isCodeEmbedded()`, else defers to Super.
- Hashing: `virtual const std::string& BaseScript::requestHash() const` returns static `emptyString`; `const std::string& Script::requestHash() const` returns `embeddedSourceHash` when code is embedded.
- Misc: `/*override*/ int Script::getPersistentDataCost() const` adds `Instance::computeStringCost(source)` for embedded code; `void Script::fireSourceChanged()` raises prop_EmbeddedSourceCode.

## Usage

Upstream callers are the DataModel machinery: ancestor/provider changes drive `restartScript` automatically; Studio/serialization touches the `Source` and `LinkedSource` properties. Downstream it hands scripts to `RuntimeScriptService` (`runScript`/`releaseScript`, implemented in App/script/ScriptContext.cpp) and supplies `BaseScript::Code` to `ScriptContext::startScript`, which calls `script->requestCode()`, `requestHash()`, `starting(thread)`, `stopped()`, `extraErrorReporting(thread)` and reads/writes `script->threadNode`. `hasCoreScriptReplacements` is consumed by core-script loading paths to swap in admin replacement starter scripts.

## Gotchas

- A script does not run merely by existing: some ancestor must implement `IScriptFilter::scriptShouldRun` approving it, and `ServiceProvider::create<RuntimeScriptService>(this)` must succeed; otherwise `workspace` stays NULL and the script is inert. `ScriptContext::scriptShouldRun(BaseScript*)` (returns true only for CoreScript) is one such filter used elsewhere in the chain.
- Every mutation path (`Source` set, `Disabled` set, `LinkedSource` changed, reparent, provider switch) tears down and recreates the run association — meaning editing source mid-run kills and respawns the thread rather than hot-patching.
- `requestHash()` is the identity key for script stats aggregation (`ScriptContext::scriptHashInfo`, `ScriptStats`): empty for non-embedded code, MD5 of the source text for embedded code — identical sources across scripts aggregate together.
- `BaseScript::requestCode` will return no code unless the linked source has finished async download (`getCachedRemoteSourceLoadState() == Loaded`); `startScript` treats unloaded code as "try again next heartbeat".
- The embedded source is stored as `boost::flyweight<ProtectedString>` — identical sources share storage; the hash update happens only when the value actually differs.
- UNKNOWN: where `getHash` (GetHash bound func body) and `isCodeEmbedded` are implemented — they are declared/used here but their bodies were not found in this file (likely App/include/script/script.h inline or another TU outside this module).
