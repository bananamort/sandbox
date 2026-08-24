# App/include/v8datamodel/TeleportService.h

## Purpose

`TeleportService` — non-creatable service for cross-place player teleports: static embedder hooks (`SetCallback(TeleportCallback*)`, base URL, browser tracker id), server-side teleport entry points (to place/instance/reserved server, by spawn name), grant-access and reserve-server web plumbing, teleport settings table, custom loading GUI handling, arrival signal, and a dedicated teleport thread.

## Declared API

- Enums: `TeleportState {RequestedFromServer=0, Started, WaitingForServer, Failed, InProgress, NumStates}`; `TeleportType {ToPlace=0, ToInstance, ToReservedServer}`.
- Public members (yes, public): `boost::function<bool(std::string,int,std::string)> confirmationCallback; boost::function<void(std::string)> showErrorCallback; bool customizedTeleportUI;`
- Static embedder config: `static void SetCallback(TeleportCallback*)`, `static void SetBaseUrl(const char*)`, `static void SetBrowserTrackerId(const std::string&)`.
- Core flow: `void TeleportImpl(shared_ptr<const Reflection::ValueTable> teleportInfo, shared_ptr<Instance> customLoadingGUI = shared_ptr<Instance>())`; `void TeleportCancel()`; `void TeleportThreadImpl(teleportInfo)` (runs on private `boost::scoped_ptr<boost::thread> teleportThread`).
- Server API: `ServerTeleport(characterOrPlayerInstance, teleportInfo, customLoadingGUI)`; `Teleport(int placeId, characterOrPlayerInstance, Variant teleportData, customLoadingGUI)`; `TeleportToSpawnByName(placeId, spawnName, ...)`; `TeleportToPrivateServer(placeId, reservedServerAccessCode, players, spawnName, teleportData, customLoadingGUI)`; `TeleportToPlaceInstance(placeId, instanceId, ...)`.
- Web result processors (public): `ProcessGrantAccessSuccess/Error(...)`, `ReserveServer(placeId, resume(std::string), error)` + `ProcessReserveServerResultsSuccess/Error`, `ProcessGetPlayerPlaceInstanceResultsSuccess/Error`, `GetPlayerPlaceInstanceAsync(playerId, resume(Tuple), error)`.
- Spawn name statics: `static std::string& GetSpawnName()`, `static void ResetSpawnName()`.
- Settings: `void SetTeleportSetting(std::string key, Variant value)`, `Reflection::Variant GetTeleportSetting(std::string key)` over static `SettingsMap settingsTable`.
- State queries: inline `bool attemptingTeleport() {return requestingTeleport;}`; statics `getPreviousPlaceId/getPreviousCreatorType/getPreviousCreatorId()` (HeapValue<int> statics), `didTeleport()`, `getDataTable()`, `get/setCustomTeleportLoadingGui(shared_ptr<Instance>)`; instance-level temp GUI pair `get/setTempCustomTeleportLoadingGui`; `Reflection::Variant getLocalPlayerTeleportData()`.
- Arrival: `static EventDesc<...> event_playerArrivedFromTeleport<void(shared_ptr<Instance>, Variant)>`; inline sender `sendPlayerArrivedFromTeleportSignal(loadingGui, teleportDataTable)` fires member `playerArrivedFromTeleportSignal`.
- Private state: static `_callback/_spawnName/_baseUrl/_browserTrackerId/_waitingForUserInput/teleported/customTeleportLoadingGui/dataTable/settingsTable`; instance `requestingTeleport`, `std::string url`, Fast retry timer, thread ptr, temp GUI.
- Commented-out DEBUG_TELEPORT macro block for _NOOPT/_DEBUG/RBX_TEST_BUILD Win32.

## Gotchas

- Per project recon: **thread-shared `url` member** — the std::string url is touched from the teleport thread AND main threads without visible locking in the header; data-race hazard documented in certified findings.
- Nearly ALL interesting state is static — previous place ids, teleported flag, data table, loading GUI are PROCESS-global, not per-session.
- confirmationCallback/showErrorCallback/customizedTeleportUI are public mutable members.
- TeleportCallback holds the join ticket path (see [TeleportCallback.md](TeleportCallback.md)).

## UNKNOWN

- Which states drive retryTimer (retry policy out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/TeleportService.md](../../v8datamodel/TeleportService.md).
- Interface: [TeleportCallback.md](TeleportCallback.md); join flow context: Network docs (CharacterFetch/ServerReplicator), [DataModel.md](DataModel.md).
