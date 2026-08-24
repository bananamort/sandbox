# App/include/v8datamodel/PlayerScripts.h

## Purpose

Three-class header for per-player script copying: `PlayerScripts` — INTERNAL_LOCAL creatable container copied from StarterPlayerScripts at spawn (IScriptFilter gate); `StarterPlayerScripts` — PERSISTENT creatable source container with default-script fetch/load handshake over remote signals; `StarterCharacterScripts` — PERSISTENT subclass scoped to character copies.

## Declared API

`class PlayerScripts : public DescribedCreatable<PlayerScripts, Instance, sPlayerScripts, Reflection::ClassDescriptor::INTERNAL_LOCAL>, public IScriptFilter`
- `void CopyStarterPlayerScripts(StarterPlayerScripts* scripts)`.
- Overrides: `askSetParent/askForbidParent/askAddChild/askForbidChild`, `onServiceProvider`, `bool scriptShouldRun(BaseScript*)`.

`class StarterPlayerScripts : public DescribedCreatable<StarterPlayerScripts, Instance, sStarterPlayerScripts, Reflection::ClassDescriptor::PERSISTENT>`
- Private: `InitializeDefaultScripts()`, `InitializeDefaultScriptsRunService(RunTransition transition)`, scoped_connection, `rbx::signal<void()> defaultScriptsLoadedSignal`, three bools `defaultScriptsLoadRequested/defaultScriptsLoaded/defaultScriptsRequested`.
- Public: ctor; inline `bool areDefaultScriptsLoaded()`; `bool checkDefaultScriptsLoaded()`; `void requestDefaultScripts()`; `void requestDefaultScriptsServer(shared_ptr<Instance> player)`; `void defaultScriptsSend(weak_ptr<RBX::Network::Player> p)`; `void defaultScriptsReceived(int confirm)`.
- Remote signals: `requestDefaultScriptsSignal<void(shared_ptr<Instance>)>`, `confirmDefaultScriptsSignal<void(int)>`.
- Same four ask* overrides + onServiceProvider.

`class StarterCharacterScripts : public DescribedCreatable<StarterCharacterScripts, StarterPlayerScripts, sStarterCharacterScripts, Reflection::ClassDescriptor::PERSISTENT>`
- Ctor only + `askAddChild` / `onServiceProvider` overrides.

## Gotchas

- Default-script delivery is a client↔server request/confirm handshake (`defaultScriptsSend` takes weak_ptr<Player>; `defaultScriptsReceived(int confirm)` is the ack) — replication of scripts is manual here.
- PlayerScripts itself is INTERNAL_LOCAL: exists only client-side per player; server-side twin is StarterPlayerScripts.
- StarterCharacterScripts inherits ALL StarterPlayerScripts behavior including the default-scripts handshake unless overridden — only askAddChild/onServiceProvider are specialized.

## UNKNOWN

- What the int in confirmDefaultScriptsSignal/defaultScriptsReceived encodes (version? checksum?) — out-of-line.

## Cross-links

- Implementation: [App/v8datamodel/PlayerScripts.md](../../v8datamodel/PlayerScripts.md).
- Sibling per-player containers: [PlayerGui.md](PlayerGui.md); script infra under App/v8datamodel Script docs; service context: [StarterPlayerService.md](StarterPlayerService.md).
