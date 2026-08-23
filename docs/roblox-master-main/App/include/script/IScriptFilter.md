# App/include/script/IScriptFilter.h

## Purpose

Declares `RBX::IScriptFilter`, the protected interface Instances implement to decide whether in-game `BaseScript`s should run (the mechanism containers like `ScriptService` use to admit/remove scripts from `ScriptContext`). Also declares `RuntimeScriptService`, a non-creatable internal Service that buffers scripts waiting for the legacy "Run" flag transition and releases them once running starts.

## Declared API

- `class RBXInterface IScriptFilter` (abstract)
  - `friend class BaseScript;`
  - `protected: virtual bool scriptShouldRun(BaseScript* script) = 0;` — return true plus implicitly identify the IScriptOwner that should run it; NULL/false means don't run.
- `extern const char* const sRuntimeScriptService;`
- `class RuntimeScriptService : public DescribedNonCreatable<RuntimeScriptService, Instance, sRuntimeScriptService, Reflection::ClassDescriptor::INTERNAL_LOCAL>, public Service`
  - `RuntimeScriptService();` (sets `isRunning(false)`)
  - `void runScript(BaseScript* script);`
  - `void releaseScript(BaseScript* script);`
  - `protected: virtual void onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider);`
  - Private: `rbx::signals::scoped_connection runTransitionConnection;` `std::set<weak_ptr<BaseScript> > pendingScripts;` ("holds Scripts that are waiting for Run"), `std::set<weak_ptr<BaseScript> > runningScripts;`, `bool isRunning;`, inline `void onRunTransition(RunTransition event)` → `onRunState(event.newState);`, `void onRunState(RunState state);`

## Usage notes

- Depends on `util/RunStateOwner.h` for the `RunState`/`RunTransition` vocabulary.
- Paired implementations live in the certified App/script module.

## Gotchas

- Only `BaseScript` (friend) may invoke `scriptShouldRun` — the check is deliberately un-callable from general engine code.
- `pendingScripts`/`runningScripts` hold `weak_ptr`s: scripts destroyed elsewhere vanish from these sets without callbacks; iteration must tolerate expired entries.
- `IScriptFilter` has no virtual destructor — deleting through the interface pointer would be UB; ownership never flows through it by design.
