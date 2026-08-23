# App/include/security/SecurityContext.h

## Purpose

Declares the engine's privilege model: `RBX::Security::Identities` (who is executing — Anonymous, LocalGUI, GameScript, RobloxGameScript, CmdLine, StudioPlugin, COM, WebService, Replicator…), `Permissions` (what they may do — None → Plugin → RobloxPlace → LocalUser → WritePlayer → RobloxScript → Roblox), `VMClasses` (which Lua VM sandbox a script runs in), plus the thread-local `Context` singleton accessor and an RAII `Impersonator` to temporarily raise/lower identity.

## Declared API

- `enum Identities { Anonymous=0, LocalGUI_, GameScript_, GameScriptInRobloxPlace_, RobloxGameScript_, CmdLine_, [StudioPlugin if RBX_STUDIO_BUILD], COM, WebService, Replicator_, COUNT_Identities }`.
- `enum Permissions { None=0, Plugin=1, RobloxPlace=2, LocalUser=3, WritePlayer=4, RobloxScript=5, Roblox=6, TestLocalUser=(LocalUser, or None in RBX_TEST_BUILD) }`.
- `enum VMClasses { VM_Default=0, [VM_StudioPlugin if studio], VM_RobloxScriptPlus, COUNT_VM_Classes }` — VM classes derived from permission level.
- `class Context`
  - `const Identities identity` (public const member).
  - `static Context& current()` — thread-local context lookup (`boost::thread_specific_ptr<Context>& ptr()`, forward-declared).
  - `void requirePermission(Permissions, const char* operation = 0) const` — throws unless `isInRole(identity, permission)`; release builds throw an obfuscated empty `std::runtime_error("")`, debug builds include identity/operation/permission in the message.
  - `bool hasPermission(Permissions)`; `static bool isInRole(Identities, Permissions)`; `static void tssCleanup(Context*)`.
  - Private ctor `Context(Identities)` — only `Impersonator` is a friend.
- `class Impersonator` — RAII: ctor `Impersonator(Identities)` swaps in a new Context for this thread, dtor restores previous.

## Usage notes

- Privileged C++ entry points call `Security::Context::current().requirePermission(Permission::X, "operation")` as their first action; engine-internal code that must act with elevated rights wraps itself in `Impersonator impersonate(Security::RobloxScript_)` style scopes.

## Gotchas

- Release-mode failures throw an *empty* runtime_error by design ("obfuscate error string") — debugging permission denials requires a debug build.
- Identity enum values shift when `RBX_STUDIO_BUILD` is defined (StudioPlugin inserted before COM); never persist numeric identities.
- The trailing underscore convention (`LocalGUI_`, `Replicator_`) dodges macro/name collisions.
- `TestLocalUser` maps to `None` in test builds specifically to expose Lua functions there.
- `Impersonator` copies the current `Context` object (identity snapshot) rather than referencing it.
