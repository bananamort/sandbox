# App/include/v8datamodel/PlatformService.h

## Purpose

`PlatformService` — PERSISTENT_LOCAL creatable service that is the C++↔console-platform bridge (Xbox-era): defines the join/start/award/auth/purchase result enums, the pure-virtual `IPlatformAPI` the platform layer implements (auth, startGame3, friends/party UI, Xbox keyboards, catalog/inventory fetch, achievements, voice chat), and a service wrapper exposing async `begin*` methods + lifecycle signals. Also carries screen post-process values ("kinda hacked in for now").

## Declared API

Free enums (namespace RBX):
- `enum GameJoinType { GameJoin_Normal, GameJoin_Instance, GameJoin_Follow, GameJoin_PMPCreator, GameJoin_PartyLeader, GameJoin_Party, GameJoin__MaxCnt }` — "used for startGame2()".
- `enum GameStartResult { GameStart_Weird=-1 ... GameStart_NoPlayer=6 }` (OK/Already/WebError/NoAccess/NoInstance/Full).
- `enum AwardResult { Award_OK=0, Award_Fail=1, Award_NotFound=2, Award_NoUser=3 }`.
- `enum AccountAuthResult { Error=-1, Success=0, InProgress=1, AccountUnlinked, MissingGamePad, NoUserDetected, HttpErrorDetected, SignUpDisabled, Flooded, LeaseLocked, AccountLinkingDisabled, InvalidRobloxUser, RobloxUserAlreadyLinked, XboxUserAlreadyLinked, IllegalChildAccountLinking, InvalidPassword, UsernamePasswordNotSet, UsernameAlreadyTaken, InvalidCredentials }`.
- `enum ReturnToEngageScreenStatus { Unknown..AccountReselect }` (SignOut/Removed/InvalidSession/UnlinkSuccess/DisplayInfoChange/ControllerChange).
- `enum PlatformDatamodelType { AppShellDatamodel=0, GameDatamodel=1 }`.
- `enum PlatformPurchaseResult { PurchaseResult_Error=-1, Success=0, UserCancelled=1, ConsumeRequestFail=2, RobuxUpdated=3, PurcahseResult_NoActionNeeded }` — note misspelled enumerator `PurcahseResult_NoActionNeeded`, no explicit value.
- `enum XboxKeyBoardType { xbKeyBoard_Default, _EmailSmtpAddress, _Number, _Password, _Search, _TelephoneNumber, _Url }`.
- `enum VoiceChatState { voiceChatState_Available, _Muted, _NotInChat, _UnknownUser }`.

`struct IPlatformAPI` (pure virtual; comment: "Most functions are called from a separate thread and thus may be blocking"):
- `performAuthorization(InputObject::UserInputType gamepadId, bool unLinkedCheck) → AccountAuthResult`; `performAccountLink(name, password, std::string* response) → int`; `performUnlinkAccount(std::string*)`; `performSetRobloxCredentials(...)`; `performHasRobloxCredentials()/performHasLinkedAccount() → AccountAuthResult`.
- `startGame3(GameJoinType, int id) → GameStartResult`; `requestGameShutdown(bool)` ("parameter must always be set to false"); `netConnectionCheck() → int`.
- UI/friends: `fetchFriends(gamepadId, std::string*)`, `popupHelpUI()`, `launchPlatformUri(baseUri)`, `popupPartyUI/popupProfileUI(gamepadId[, uid])`, `popupAccountPickerUI`, `popupGameInviteUI()`, `showKeyBoard(title&, description&, defaultText&, unsigned keyboardType, DataModel*)`, `setScreenResolution(double px, double py)` (percentages 0.1–1.0).
- Commerce/data: `fetchCatalogInfo(shared_ptr<ValueArray>)` / `fetchInventoryInfo(...)` (documented JSON shapes in comments), `getPlatformPartyMembers/getInGamePlayers(shared_ptr<ValueArray>)`, `requestPurchase(productId) → PlatformPurchaseResult`, `getPMPCreatorId()`, `getTitleId()`, `getVersionIdInfo()/getPlatformUserInfo() → shared_ptr<const Reflection::ValueTable>`.
- Telemetry/voice: `awardAchievement(eventName) → AwardResult` (comment points to XboxClient/xdpevents.h ~L60), `setHeroStat(eventName, double* value)`, `voiceChatSetMuteState(int userId, bool)`, `voiceChatGetState(int userId) → unsigned`.

`class PlatformService : public DescribedCreatable<PlatformService, Instance, sPlatformService, Reflection::ClassDescriptor::PERSISTENT_LOCAL>, public Service`
- Static BoundProps: `desc_Brightness/desc_Contrast/desc_GrayscaleLevel(float)`, `desc_TintColor(Color3)`, `desc_BlurIntensity(float)`; `static PropDescriptor<PlatformService,int> prop_DatamodelType`.
- Signals: `viewChanged(int)`, `gameJoinedSignal(int)`, `userAuthCompleteSignal()`, `userAccountChangeSignal(int)`, `robuxAmountChangedSignal(int)`, `networkStatusChangedSignal(std::string)`, `keyboardClosedSignal(std::string)`, `lostActiveUser/gainedActiveUser/lostUserGamepad/gainedUserGamepad(std::string)`, `voiceChatUserTalkingStart/EndSignal(int)`, `suspendSignal()`.
- Async wrappers (`begin*` with resume/error fns): beginAuthorization/beginAuthUnlinkCheck(gamepadId,...), beginStartGame3(mode, placeId,...), beginFetchFriends, beginGetPartyMembers/beginGetInGamePlayers, beginAccountLink/beginUnlinkAccount/beginSetRobloxCredentials/beginHasLinkedAccount/beginHasRobloxCredentials, beginGetPMPCreatorId, beginGetInventoryInfo/beginGetCatalogInfo, beginPlatformStorePurchase(productId), beginAwardAchievement/beginHeroStat(eventName, value). Sync: requestGameShutdown(), popupPartyUI/popupProfileUI, popupHelpUI(), launchPlatformUri, popupGameInviteUI(), popupAccountPickerUI, showKeyBoard(title, desc, defaultText, XboxKeyBoardType), getTitleId(), getVersionIdInfo/getPlatformUserInfo, changeScreenResolution(px, py), setPlatform(IPlatformAPI*, PlatformDatamodelType), getPlatformDatamodelType(), voiceChatSetMuteState/voiceChatGetState.
- Public data members: `float blurIntensity/brightness/contrast/grayscaleLevel; Color3 tintColor;` (comment: "image post process, kinda hacked in for now").
- Private: raw `IPlatformAPI* platform`; `PlatformDatamodelType datamodelType`; a dozen `volatile long` reentrancy flags (`baFlag, bnccFlag, bsgFlag, bffFlag, ppuiFlag, ppruiFlag, bgiiFlag, bgciFlag, bpspFlag, alFlag, bgpmFlag, bgigpFlag`) — "flags for reenterancy prevention".

## Gotchas

- IPlatformAPI calls are expected to BLOCK on other threads — the service's volatile-long reentrancy flags are hand-rolled guards, not atomics-with-fences (volatile long ≠ thread-safe flag on all memory models).
- `platform` is an unowned raw pointer set via setPlatform — lifetime managed entirely by the embedder.
- Enum quirks: misspelled `PurcahseResult_NoActionNeeded`; GameJoin__MaxCnt sentinel; GameStart_Weird=-1 with "talk to Max ASAP" comment.
- Post-process fields are PUBLIC and mirrored by BoundProps — two write paths for the same values.

## UNKNOWN

- Which concrete IPlatformAPI implementation ships (per-platform code outside v8datamodel).

## Cross-links

- Implementation: [App/v8datamodel/PlatformService.md](../../v8datamodel/PlatformService.md).
- Input plumbing: [InputObject.md](InputObject.md); game lifecycle: [Game.md](Game.md), [DataModel.md](DataModel.md); commerce Lua surface: [MarketplaceService.md](MarketplaceService.md).
