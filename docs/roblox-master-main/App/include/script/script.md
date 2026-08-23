# App/include/script/script.h

## Purpose

Declares the script class hierarchy: `BaseScript` (non-creatable; source requesting via `Code`, disabled flag, thread node, starting/stopped signals, local-player association), `Script` (creatable; embedded vs linked source, hash exposure), `LocalScript` (empty creatable subclass with historical security commentary), and `BaseScript::Slot` (signal-connection holder for script threads).

## Declared API

- `typedef ContentId ScriptId;`
- `extern const char* const sBaseScript;`
- `class BaseScript : public DescribedNonCreatable<BaseScript, LuaSourceContainer, sBaseScript>`
  - Nested: `class Slot;` (defined below)
  - Statics: `static std::string adminScriptsPath;` ("Used for development only. It allows you to load CoreScripts from your local disk"), `static bool hasCoreScriptReplacements();`
  - `void restartScript();`
  - Protected: `RuntimeScriptService* workspace;` overrides `onServiceProvider`, `onAncestorChanged`, `onScriptIdChanged`; private `static const std::string emptyString;` `weak_ptr<RBX::Network::Player> localPlayer; bool disabled; bool badLinkedScript; RuntimeScriptService* computeNewWorkspace();`
  - Nested `struct Code { bool loaded; boost::flyweight<ProtectedString> script; Code(); Code(const boost::flyweight<ProtectedString>&); }` (inline ctors — default = not loaded)
  - `BaseScript(); ~BaseScript();`
  - Descriptors: `prop_SourceCodeId` (`ScriptId`), `prop_Disabled` (bool)
  - `weak_ptr<Player> getLocalPlayer(); void setLocalPlayer(const shared_ptr<Player>&);` (inline)
  - Thread management: public member `boost::intrusive_ptr<Lua::WeakThreadRef::Node> threadNode;` signals `rbx::signal<void(lua_State*)> starting;` `rbx::signal<void()> stopped;`
  - `bool isDisabled() const; bool getDisabled() const; void setDisabled(bool value);` (getters inline)
  - `virtual Code requestCode(ScriptInformationProvider* scriptInfoProvider = NULL);`
  - `virtual void extraErrorReporting(lua_State* thread) {}` (no-op default)
  - `virtual const std::string& requestHash() const;`
- `extern const char* const sScript;`
- `class Script : public DescribedCreatable<Script, BaseScript, sScript>` ("A BaseScript is started when a containing IScriptOwner sends it to the ScriptContext service")
  - Private: `boost::flyweight<ProtectedString> embeddedSource; std::string embeddedSourceHash; std::string getHash();` (returns requestHash())
  - `Script(); ~Script();`
  - Descriptor: `static const Reflection::PropDescriptor<Script, ProtectedString> prop_EmbeddedSourceCode;`
  - Inline override `writeXml(...)` delegating to Super.
  - Inline `askSetParent` → true ("Scripts can be anywhere")
  - `bool isCodeEmbedded() const { return getScriptId().isNull(); }` (inline)
  - Overrides: `Code requestCode(...)`, `const std::string& requestHash() const`, `int getPersistentDataCost() const`, `void fireSourceChanged()`
  - Embedded code access: `void setEmbeddedCode(const ProtectedString& value); const boost::flyweight<ProtectedString>& getEmbeddedCode() const; const ProtectedString& getEmbeddedCodeSafe() const;`
  - Descriptor: `static const Reflection::BoundFuncDesc<Script, std::string()> func_GetHash;` — Lua-visible `GetHash`.
- `extern const char* const sLocalScript;`
- `class LocalScript : public DescribedCreatable<LocalScript, Script, sLocalScript>`
  - `LocalScript(); ~LocalScript() {}` (nothing added)
- `class BaseScript::Slot`
  - Private: `rbx::signals::connection connection;` ("A Slot must keep a reference to its connection, because it must be capable of disconnecting itself.")
  - Public inline `assignConnection(const rbx::signals::connection&);` protected ctor/dtor (dtor comment "TODO: Disconnect here???") and inline `disconnect()`.

## Usage notes

- Pairs with certified App/script docs (`docs/roblox-master-main/App/script/`) — Script.cpp/LocalScript.cpp behaviors (linked-source loading, hashing, embedded RSB1 handling) verified there.
- Certification note: `isCodeEmbedded` ⇔ script id is null ⇔ embeddedSource path is the live one.

## Gotchas

- The header's own LocalScript comment block admits LocalScripts are "a large security hole that will have to be addressed" and muses they should have been named GuiScript/UserScript — historical design intent, not a TODO to act on.
- `BaseScript::Slot::~Slot` has an open TODO about not disconnecting its connection — teardown ordering bugs around script threads trace here.
- `adminScriptsPath` enables disk-loaded CoreScript replacement in dev builds only (`hasCoreScriptReplacements` gates it); never assume empty in studio builds.
- `threadNode` is a PUBLIC mutable member — external code manipulates the script's thread registry directly.
