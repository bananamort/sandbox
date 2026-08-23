# App/include/script/CoreScript.h

## Purpose

Declares `RBX::CoreScript`, a non-creatable internal `BaseScript` subclass (`INTERNAL_LOCAL` security level) used for engine-internal scripts. Its distinguishing feature is `fetchSource(name)`, which loads core script source by name rather than from the DataModel, so engine scripts can run with the same lifecycle as user scripts.

## Declared API

- `extern const char* const sCoreScript;`
- `class CoreScript : public DescribedNonCreatable<CoreScript, BaseScript, sCoreScript, RBX::Reflection::ClassDescriptor::INTERNAL_LOCAL>`
  - Private: `Code code;` member.
  - `CoreScript();`
  - `static boost::optional<ProtectedString> fetchSource(const std::string& name);` — returns empty optional when the named core script is unavailable.
  - `virtual Code requestCode(ScriptInformationProvider* scriptInfoProvider = NULL);` — override of BaseScript's request path.
  - `virtual void extraErrorReporting(lua_State* thread);`
  - `protected: virtual void onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider);`

## Usage notes

- Paired implementation documented under the certified App/script module (`docs/roblox-master-main/App/script/`) — see CoreScript.cpp there for where sources are actually fetched from.

## Gotchas

- `requestCode` ignores its `scriptInfoProvider` argument in the signature defaulting sense — behavior lives in the .cpp; do not assume provider-driven resolution.
- `boost::optional<ProtectedString>` (not `shared_ptr`) — copies carry full source strings; avoid needless copies on hot paths.
