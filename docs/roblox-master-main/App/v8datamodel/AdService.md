# AdService.cpp

## Purpose

Implements `AdService` ("AdService"), the touch-device video-ad pipeline: a client `ShowVideoAd` call triggers server-side verification against the web API (`adimpression/validate-request`), the verdict replicates back to the client which actually plays the ad, and close/impression events report back (`adimpression/record-impression`, fire-and-forget).

## Key types and API

Descriptors:
- `event_serverAdVerification("ServerAdVerification", "userId", "platform")` — **Security::Roblox**, REPLICATE_ONLY, CLIENT_SERVER → `sendServerVideoAdVerification`.
- `event_sendClientAdVerificationResults("ClientAdVerificationResults", "canShowAd", "userId", "errorMessage")` — **Security::Roblox**, REPLICATE_ONLY, BROADCAST → `sendClientVideoAdVerificationResults`.
- `event_sendServerRecordImpression("SendServerRecordImpression", "userId", "platform", "wasSuccessful")` — **Security::Roblox**, REPLICATE_ONLY, CLIENT_SERVER → `sendServerRecordImpression`.
- `func_showVideoAd("ShowVideoAd", Security::None)` — BoundFunc, no args.
- `event_videoClosed("VideoAdClosed", "adShown")` — plain script-visible Event on `videoAdClosedSignal`.

Flag: `FASTFLAGVARIABLE(EnableVideoAds, true)` gates everything via `canUseService()`.

Flow:
- `showVideoAd()` (client) — rejects when flag off / already showing / device not touch-enabled (`UserInputService::getTouchEnabled`) / not frontendProcessing / no local player; else fires ServerAdVerification.
- `checkCanPlayVideoAd(userId, platform)` (server) — POSTs `adimpression/validate-request?userId=…&placeId=…&deviceOSType=…` via [HttpRbxApiService](HttpRbxApiService.md); response parsed as JSON by `WebParser::parseJSONTable`.
- `verifyCanPlayVideoAdReceivedResponseNoDMLock(...)`/`...Error[NoDMLock]` — replicate ClientAdVerificationResults back (error path takes DataModel LegacyLock Write in one variant).
- `receivedServerShowAdMessage(success, userId, errorMessage)` — connected in `onServiceProvider` only under frontendProcessing; validates caller is the local player, then `playVideoAdSignal()` + `showingVideoAd = true`, or VideoAdClosed(false).
- `videoAdClosed(didPlay)` — clears showing flag, raises VideoAdClosed, fires SendServerRecordImpression.
- `sendAdImpression(userId, platform, didPlay)` (server) — POSTs `adimpression/record-impression` with `ForgetResponse` no-op callbacks. Platform mapping: IOS→"ios", ANDROID→"android", default→"unknown".

## Usage / reflection touchpoints

Script-facing surface is ShowVideoAd + VideoAdClosed (Security::None event); verification/impression remotes are Roblox-security plumbing. Depends on UserInputService platform/touch state and ContentProvider apiBaseUrl.

## Gotchas

- Every ShowVideoAd rejection path still fires VideoAdClosed(false) — scripts must treat closed-without-show as normal.
- The userId round-trip is trusted from the replicated event; receivedServerShowAdMessage checks it equals the LOCAL player's id but the server-side checkCanPlayVideoAd re-verifies with the web backend.
- `sendAdImpression` ignores both HTTP callbacks entirely ("fire and forget").
- EnableVideoAds defaults TRUE — ads are on unless flagged off.
