# App/v8datamodel/AdService.cpp

## Purpose

Implements `AdService` — the video-ads Instance service ("AdService"). Client calls `ShowVideoAd`, the server validates eligibility via an HTTP call to the Roblox web API (`adimpression/validate-request`), the result replicates back to the client which plays the ad, and on close an impression is recorded server-side via `adimpression/record-impression`. Gated by fast flag `EnableVideoAds` (default true).

## API

Reflection (between REFLECTION_BEGIN/END):
- `RemoteEventDesc event_sendServerRecordImpression` — `"SendServerRecordImpression"` (userId:int, platform:UserInputService::Platform, wasSuccessful:bool), Security::Roblox, REPLICATE_ONLY, CLIENT_SERVER.
- `event_sendClientAdVerificationResults` — `"ClientAdVerificationResults"` (canShowAd:bool, userId:int, errorMessage:string), Security::Roblox, REPLICATE_ONLY, BROADCAST (server→client).
- `event_serverAdVerification` — `"ServerAdVerification"` (userId:int, platform), Security::Roblox, REPLICATE_ONLY, CLIENT_SERVER (client→server).
- `BoundFuncDesc func_showVideoAd` — `"ShowVideoAd"()` with Security::None.
- `EventDesc event_videoClosed` — `"VideoAdClosed"(adShown:bool)`.

Methods: `bool canUseService()` (= FFlag::EnableVideoAds); `void showVideoAd()`; `void receivedServerShowAdMessage(bool success, int userId, const std::string& errorMessage)`; `verifyCanPlayVideoAdReceivedResponseNoDMLock(response, userId)` / `...Error(...)` / `...ErrorNoDMLock(...)`; `std::string platformToWebString(Platform)` ("ios"/"android"/"unknown"); `void checkCanPlayVideoAd(int userId, Platform)`; `void videoAdClosed(bool didPlay)`; `void sendAdImpression(int userId, Platform, bool didPlay)`; `void onServiceProvider(old, new)`.

## Usage

Full client→server→web round trip scripts depend on:
1. Client `ShowVideoAd()`: refuses unless flag on, not already showing, **touch-enabled device only** (`UserInputService::getTouchEnabled`), caller is frontend/local context (`Network::Players::frontendProcessing`), and a LocalPlayer exists. Then fires `event_serverAdVerification.fireAndReplicateEvent(this, player->getUserID(), UserInputService::getPlatform())`.
2. Server `checkCanPlayVideoAd`: requires `Network::Players::serverIsPresent`; builds query `userId=%d&placeId=%d&deviceOSType=%s` and calls `HttpRbxApiService::postAsync("adimpression/validate-request?<data>", "ServerCanPlayAd", true, PRIORITY_DEFAULT, HttpService::TEXT_PLAIN, onSuccessBind, onErrorBind)`.
3. Response JSON parsed by `WebParser::parseJSONTable`; reads `"success"` and optional `"errorMessage"` keys; result replicated via `ClientAdVerificationResults`.
4. Client-side hook installed in `onServiceProvider`: when provider is the frontend, `sendClientVideoAdVerificationResults.connect(receivedServerShowAdMessage)` — on success sets `showingVideoAd=true` and fires internal `playVideoAdSignal()` (UI picks it up); on failure fires `videoAdClosedSignal(false)`.
5. `videoAdClosed(didPlay)` resets state, fires `VideoAdClosed`, and client replicates `SendServerRecordImpression`; server `sendAdImpression` posts `adimpression/record-impression?userId=..&placeId=..&deviceOSType=..&wasSuccessful=..` fire-and-forget (both callbacks are the no-op static `ForgetResponse`).

## Gotchas

- Touch-only: on non-touch platforms ShowVideoAd always fails with warning "only works on touch devices currently" and VideoAdClosed(false).
- The verification/impression HTTP endpoints go through `HttpRbxApiService::postAsync` with the apiBaseUrl from ContentProvider — environment fidelity: sandbox must stub or expect these two POSTs.
- `platformToWebString` maps only iOS/Android; everything else becomes "unknown".
- Error-path variants differ in locking: `verifyCanPlayVideoAdReceivedError` takes `DataModel::LegacyLock(Write)` before firing, the `NoDMLock` versions do not (they run on HTTP callback threads).
- `receivedServerShowAdMessage` silently ignores messages whose userId doesn't match the local player's.
