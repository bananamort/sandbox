# PlayerScripts.cpp

## Purpose

Implements THREE classes forming the per-player script bootstrap chain: `PlayerScripts` ("PlayerScripts", container cloned into each local Player that runs client LocalScripts), `StarterPlayerScripts` ("StarterPlayerScripts", template under StarterPlayer that lazily loads default ControlScript/CameraScript .rbxmx content and confirms replication to clients), and `StarterCharacterScripts` ("StarterCharacterScripts", same template pattern additionally accepting plain Scripts for per-character cloning).

## Key types and API

### PlayerScripts
No descriptors. Parenting rules: `askSetParent` allows only Network::Player parents; `askAddChild` allows Folder / ModuleScript / LocalScript only. `scriptShouldRun(LocalScript)`: runs iff this container sits directly under the LOCAL player (`findLocalPlayer`; also sets script->setLocalPlayer) — non-LocalScripts never run here. `CopyStarterPlayerScripts(StarterPlayerScripts*)`: clones each child with archivable temporarily forced true (non-archivable objects can't clone), reparenting into `this`. `onServiceProvider`: CLIENT-side, when ancestor Player == local player, finds StarterPlayerScripts and calls `requestDefaultScripts()`; missing StarterPlayerService → MESSAGE_ERROR.

### StarterPlayerScripts (DescribedCreatable, PERSISTENT)
Descriptors:
- `event_requestDefaultScripts("RequestDefaultScripts(root)")` — RemoteEventDesc, **Security::None**, REPLICATE_ONLY, CLIENT_SERVER.
- `event_confirmDefaultScripts("ConfirmDefaultScripts(root:int)")` — same tiers/flags (Lua arg still named "root" though a int confirm value is passed at invocation).
Parenting: only under StarterPlayerService; children restricted to Folder/ModuleScript/LocalScript. State flags defaultScriptsLoadRequested/Loaded/Requested.
- Default-script loading: `InitializeDefaultScripts()` — if ControlScript/CameraScript missing, ContentProvider::loadContent of `fonts/characterControlScript.rbxmx` / `characterCameraScript.rbxmx` (PRIORITY_SCRIPT); loaded instances force-set non-archivable then parented; `checkDefaultScriptsLoaded()` fires one-shot `defaultScriptsLoadedSignal` (disconnectAll after fire) once BOTH exist. Run-gated variant connects runTransitionSignal (STOPPED→RUNNING) when server not yet running.
- Handshake: client `requestDefaultScripts()` fires RequestDefaultScripts once (local-player guarded); server `requestDefaultScriptsServer(player)` replies immediately if loaded else initializes + hooks loaded signal → `defaultScriptsSend(player)` which raises ConfirmDefaultScripts targeted at that client's remote address (play-solo shortcut: direct `defaultScriptsReceived(1)`); client `defaultScriptsReceived(confirm==1)` copies StarterPlayerScripts children into its own PlayerScripts.

### StarterCharacterScripts
Ctor names instance; `askAddChild` extends parent rule to accept plain `Script` too; onServiceProvider explicitly re-invokes the StarterPlayerScripts templated base (note: hardcodes sStarterPlayerScripts descriptor rather than Super call).

## Usage / reflection touchpoints

Core of client-side script delivery; pairs with Script docs at [App/script](../../script/) (LocalScript/ModuleScript semantics), StarterPlayerService.md in this folder, replication machinery at [Network](../../Network/) (raiseEventInvocation targeting).

## Gotchas

- The two RemoteEventDesc events are Security::None REPLICATE_ONLY CLIENT_SERVER — pure engine handshake, but any client can fire RequestDefaultScripts repeatedly (guarded locally once by defaultScriptsRequested flag only).
- copyChildrenToPlayerScripts temporarily flips Archivable on source children — a concurrent save during join could capture them as archivable.
- checkDefaultScriptsLoaded disconnects ALL listeners of defaultScriptsLoadedSignal after first fire — later subscribers never learn.
- StarterCharacterScripts::onServiceProvider bypasses virtual dispatch style by naming the full templated base — fragile if hierarchy changes.
- ConfirmDefaultScripts event declares parameter "root" but receives an int confirm flag — misleading signature.
