# InsertService.cpp

## Purpose

Implements `InsertService` ("InsertService") — asset insertion pipeline: client→server replicated insert requests (InsertRequestAsset/AssetVersion → server loads via ContentProvider → InsertReady/InsertError back), free-model/decal/set/collection catalog queries over LuaWebService, LoadAsset/LoadAssetVersion public API, latest-version lookup through [HttpRbxApiService](HttpRbxApiService.md), and the deprecated legacy Insert() that parents an instance into Workspace. Loaded instances collect under a non-archivable holder Folder.

## Key types and API

Flags/DFStrings: AssetUrlPiece "/Asset/?id=", AssetVersionUrlPiece "/Asset/?assetversionid=", BaseSetsUrlPiece, CollectionUrlPiece "…sid=", FreeModelUrlPiece "…type=fm&rs=21&q=", FreeDecalUrlPiece "…type=fd&rs=21&q=", UserSetsUrlPiece, AssetVersionsUrl "/assets/%i/versions?placeId=%i". DFFlag::GetLastestAssetVersionEnabled(false), DisableBackendInsertConnection(false), GASendInsertRequestFail(true), InfluxSendInsertRequestFail(true), InsertServiceLoadModelErrorDoNotCreateEmpty(true), InsertServiceLoadModelErrorNoLuaExceptionReturnNull(false), DisableInsertServiceForTeamCreate(false); FFlag UseBuildGenericGameUrl(extern), AllowInsertFreeModels(false), InsertUnderFolder(true) ("minor data loss if false").

Descriptors:
- REPLICATE_ONLY remote events (CLIENT_SERVER, Security::None): InsertRequest(key,contentId ContentId)/InsertRequestAsset(key,assetId,userId)/InsertRequestAssetVersion(key,assetVersionId,userId); InsertReady(key,instance)/InsertError(key,message)/InternalDelete(instance).
- Lua funcs Security::None: yield GetFreeModels(searchText,pageNum)/GetFreeDecals/GetBaseSets()/GetUserSets(userId) (+deprecated GetBaseCategories/GetUserCategories aliases), GetCollection(categoryId), LoadAsset(assetId) (+deprecated lowercase `loadAsset`), LoadAssetVersion(assetVersionId), `GetLatestAssetVersionAsync(assetId)` — note descriptor name has the "t" typo "GetLastestAssetVersion" in the C++ symbol but the LUA NAME is "GetLatestAssetVersionAsync"; Insert(instance) deprecated with empty Attributes::deprecated(). ApproveAssetId/ApproveAssetVersionId are NO-OP bodies (Security::None).
- LocalUser setters, ALL EMPTY-BODIED stubs: SetBaseCategoryUrl/SetUserCategoryUrl/SetBaseSetsUrl/SetUserSetUrl/SetFreeModelUrl/SetFreeDecalUrl/SetCollectionUrl/SetAssetUrl/SetAssetVersionUrl/SetTrustLevel(float)/SetAdvancedResults(bool,bool) — legacy URL-override surface now inert.
- Prop: AllowInsertFreeModels (STANDARD_NO_REPLICATE, category_Behavior).

Behavior:
- ctor: under InsertUnderFolder creates non-archivable child Folder `holder`; else marks the SERVICE itself non-archivable.
- privateLoadAsset(id,isAssetVersion): request key = "<localUserId>+<id>+<loadCount++>"; registers resume/error in mutex-guarded callbackLibrary; lazily connects frontend InsertReady/InsertError listeners; clients replicate the request event to server, servers/local call backendInsert*Requested directly.
- backend path: safeInsert builds final URL = baseUrl + urlPiece + id + populateExtraInsertUrlParams (`&serverplaceid=` omitted when AllowInsertFreeModels&&server-side to disable the model-must-be-taken web check; always `&clientinsert=`), then ContentProvider::loadContent(PRIORITY_INSERT) → remoteInsertItemsLoaded repackages Instances under a fresh ModelInstance pseudoRoot (+MaterialPropertiesEnabled physical-prop conversion) → loadLinkedScripts → callback. DFFlag::DisableBackendInsertConnection switches from ContentId URLs to typed (ASSET/ASSET_VERSION) requests.
- backendInsertReady write-task: on error honors DoNotCreateEmpty (skip entirely + GA PlaceID event + InfluxDb reportPointsV2 "InsertServiceFailure") else still inserts a fallback ModelInstance on setParent failure; NoLuaExceptionReturnNull sends nil instance via InsertReady instead of InsertError text.
- TeamCreate guard: DisableInsertServiceForTeamCreate && Players::isCloudEdit → silently drop.
- getLatestAssetVersion gated by its DF flag ("currently disabled" error otherwise); parses JSON array [{Id:int}].
- internalDelete: server unparents directly; clients replicate InternalDelete for server-side unparent.
- writeXml scope rule inherited pattern: joint XML suppressed unless BOTH parts in scope.

## Usage / reflection touchpoints

ContentProvider::loadContent/PRIORITY_INSERT; LuaWebService::asyncRequest for catalogs; HttpRbxApiService for versions; Network::Players::backendProcessing/frontendProcessing/isCloudEdit; [Workspace](Workspace.md)::publicInsertRaw for deprecated Insert(); Selection service for ManualWeld adorn overlap rendering is JointInstance's; RobloxServicesTools/BuildGenericGameUrl helpers.

## Gotchas

- Nearly every Set*Url function is a documented no-op — scripts calling them get success with zero effect.
- ApproveAssetId/ApproveAssetVersionId also empty bodies despite being exposed.
- Insert() requires Plugin security only when the instance is RobloxLocked; normal instances insert with None security into Workspace root.
- loadCount/userId keying means duplicate concurrent LoadAsset calls are distinct; a lost InsertError leaves callbacks parked in callbackLibrary forever (no timeout sweep).
- AllowInsertFreeModels=true omits serverplaceid — deliberately weakens the web-side "model must be owned/taken" check (comment documents this).
- GetLatestAssetVersionAsync is flag-gated OFF by default and double-flagged typo'd internally.
- UNKNOWN: consumers of the InsertRequest (legacy key-based ContentId variant) — connect guarded by DisableBackendInsertConnection, default ON meaning the OLD event IS connected while asset events are ALSO connected.
