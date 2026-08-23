# App/script/LuaGenCS.inl

## Purpose

Machine-generated data blob embedded by the client build (included from App/script/LuaVMClient.cpp): 37 static byte arrays (`a0000`–`a0036`) holding RSB1-encrypted, pre-compiled bytecode for every Roblox core script and core module script, plus the two index tables `gCoreScripts[]` and `gCoreModuleScripts[]` of `CoreScriptBytecode { const char* name; const unsigned char* value; size_t dataSize; }` entries. This is how desktop clients ship privileged scripts without any Lua source or compilable text on disk.

## API

- 37 arrays `static const unsigned char aNNNN[] = { 0x.., ... };` spanning lines 1–21979 (sizes range from ~1 KB to ~86 KB; largest blobs are a0013 "Libraries/RbxGui" at 86493 bytes and a0014 "Libraries/RbxStamper" at 45328 bytes per the index tables).
- `static const CoreScriptBytecode gCoreScripts[]` (lines 21980–22001) — core scripts run via CoreScript::fetchSource/getBytecodeCore path: entries include rot13 names such as "PberFpevcgf/IruvpyrUhq" (= CoreScripts/VehicleHud), "Yvoenevrf/EokThv" (= Libraries/RbxGui), "Yvoenevrf/EokFgnzcre" (= Libraries/RbxStamper), "Yvoenevrf/EokHgvyvgl" (= Libraries/RbxUtility), "YbnqvatFpevcg" (= LoadingScript), "FreirePberFpevcgf/FreireFbpvnyFpevcg" (= ServerCoreScripts/ServerSocialScript), "FreireFgnegreFpevcg" (= ServerStarterScript), "FgnegreFpevcg" (= StarterScript).
- `static const CoreScriptBytecode gCoreModuleScripts[]` (lines 22003–22021) — modules surfaced through getBytecodeCoreModules(): rot13 names decode to BackpackScript, Chat, DeveloperConsoleModule, PlayerDropDown, PlayerlistModule, Settings/Pages/GameSettings, Settings/Pages/Help, Settings/Pages/Home, Settings/Pages/LeaveGame, Settings/Pages/Players, Settings/Pages/Record, Settings/Pages/ReportAbuseMenu, Settings/Pages/ResetCharacter, Settings/SettingsHub, Settings/SettingsPageFactory, Settings/Utility, TenFeetInterface.

## Usage

Consumed only by App/script/LuaVMClient.cpp: `getBytecodeCore(name)` compares `RBX::rot13(name)` against `gCoreScripts[i].name`; `getBytecodeCoreModules()` flattens `gCoreModuleScripts`. The returned bytes flow through `ProtectedString::fromBytecode` → `LuaVM::load` → `LuaDeserializer::deserialize` (App/script/LuaSerializer.inl).

## Gotchas

- Names in the tables are pre-rot13'd — lookups must apply rot13 to the requested name (double-rot13 = identity, so the stored names ARE readable after one transform).
- The bytecode payloads are keyed by the ckey/modkey scheme documented in ScriptContext.md/LuaVMServer.cpp; they are useless without the server-delivered key state, and regenerating this file requires running the SERVER build's `LuaVM::compile*` over each script with the DAX encoder.
- File is fully static const data (~22k lines); it contributes directly to binary size and contains no code. A Luau graft replaces this entire file with its own compiled-script blob table.
- UNKNOWN: which exact tool generated this file (name/format of the generator) — not determinable from the working copy; only the output shape is verifiable here.
