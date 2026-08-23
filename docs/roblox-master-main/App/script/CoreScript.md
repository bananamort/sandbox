# App/script/CoreScript.cpp

## Purpose

Implements the `CoreScript` instance class — Roblox's own privileged scripts (`setRobloxLocked(true)`), which run with identity `RobloxGameScript_` in the `VM_RobloxScriptPlus` VM (see ScriptContext::startScript). Provides the source-resolution policy for core scripts: on-the-fly `.lua` files from disk when compilation is enabled, or embedded pre-serialized bytecode via `LuaVM::getBytecodeCore` otherwise; plus dedicated error reporting that writes a `.cse` crash-support file per failing core script.

## API

- `const char* const RBX::sCoreScript = "CoreScript"`.
- `CoreScript::CoreScript()` — names itself CoreScript and calls `setRobloxLocked(true)`.
- `void CoreScript::onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider)` — teardown special case: if there was an old provider but this script never got a run workspace ("used to make sure corescripts not in the workspace still get removed properly"), finds `ScriptContext` under the old provider, asserts `sc->hasScript(this)` and removes itself.
- `static boost::optional<ProtectedString> CoreScript::fetchSource(const std::string& name)`:
  - `LuaVM::canCompileScripts()` true → reads `<path>/<name>.lua` from disk where path = `BaseScript::adminScriptsPath` when `BaseScript::hasCoreScriptReplacements()` else `ContentProvider::assetFolder() + "scripts"`; returns `ProtectedString::fromTrustedSource(contents)`, or empty optional when unreadable.
  - else → `std::string bytecode = LuaVM::getBytecodeCore(name);` empty → empty optional; otherwise `ProtectedString::fromBytecode(bytecode)` (the RSB1 container).
- `BaseScript::Code CoreScript::requestCode(ScriptInformationProvider* scriptInfoProvider)` — fetchSource(getName()) wrapped in a flyweight `Code`, or throws "Error loading core script %s".
- `void CoreScript::extraErrorReporting(lua_State *thread)` — collects top-of-stack error text (fallback "Error occurred, no output from Lua."), call stack via `ScriptContext::extractCallStack`, PlaceID via `DataModel::getPlaceIDOrZeroInStudio()`; writes to `<userDir>/logs/<name>_ln<line>_.cse` with comment "create cse file, later to be uploaded to s3 (same place as .dmp)".

## Usage

Consumed by the script-start pipeline: `ScriptContext::startScript` detects CoreScript instances to grant RobloxGameScript_ identity and bypass ScriptsDisabled; `ScriptContext::loadLibrary` calls `CoreScript::fetchSource("Libraries/"+name)` for LoadLibrary resolution; `RuntimeScriptService::runScript/releaseScript` treat CoreScripts as start-and-forget outside the pending/running sets. `addCoreScriptLocal` creates CoreScripts directly. Fetch source feeds `LuaVM::load(thread, ProtectedString, chunkname, modkey)`.

## Gotchas

- Two disjoint core-script distribution modes keyed on `LuaVM::canCompileScripts()`: desktop clients use embedded rot13-keyed bytecode arrays from LuaGenCS.inl; server/studio-style builds read loose .lua files from the content assets folder (or admin replacement folder). A Luau graft must produce its own bytecode format for the first mode or force the second.
- fetchSource returns boost::optional rather than throwing; requestCode converts absence into an exception — callers like loadLibrary rely on the optional semantics to report "Unknown library".
- extraErrorReporting asserts `source.get() == this` after extracting the call stack, i.e., errors are attributed only if the thread still maps back to this exact script instance.
- The `.cse` filename embeds name + line but no timestamp in the name itself; RBX::Log::timeStamp stamps content. Files accumulate under logs/ until upload/cleanup.
