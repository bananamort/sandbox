# PlatformService.cpp

## Purpose

Implements `PlatformService`, the console (Xbox/Durango-era) bridge between the DataModel and an injected `IPlatformAPI*` platform layer. Wraps every console capability — gamepad authorization, account link/unlink, friends/party/profile/account-picker UI, catalog/inventory/purchases, achievements, hero stats, voice chat mute state, screen keyboard, title/version info — as reflection-exposed functions/events that marshal blocking platform calls onto detached boost threads and resume scripts via DataModel tasks.

## Key types and API

All BoundFunc/BoundYieldFunc/EventDesc below are **Security::RobloxScript** except where noted:

Yield funcs ("Begin*" pattern): BeginAuthorization(gamepadId:UserInputType):int; BeginAuthUnlinkCheck(gamepadId):int; BeginStartGame3(mode:int, id:int):int (mode validated against GameJoinType range, error "…bad 'mode' parameter"); BeginFetchFriends(gamepadId):string; BeginAccountLink(accountName, password):int; BeginUnlinkAccount():int; BeginSetRobloxCredentials(accountName, password):int; BeginHasLinkedAccount():int; BeginHasRobloxCredentials():int; BeginGetCatalogInfo():ValueArray; BeginGetInventoryInfo():ValueArray; BeginPlatformStorePurchase(productId):int (returns PlatformPurchaseResult); BeginAwardAchievement(eventName):int; BeginHeroStat(eventName, value=DBL_MIN sentinel → NULL stat pointer):int; BeginGetPMPCreatorId():int (error "GetPMPCreatorId Timed Out" on negative); GetPlatformPartyMembers():ValueArray; GetInGamePlayers():ValueArray; PopupPartyUI(gamepadId); PopupProfileUI(gamepadId, uid).

Plain funcs: RequestGameShutdown(); PopupHelpUI(); LaunchPlatformUri(baseUri); PopupAccountPickerUI(gamepadId); PopupGameInviteUI(); ShowKeyboard(title, description, defaultText, keyboardType:XboxKeyBoardType) (passes DataModel to platform); changeScreenResolution(px, py) — prints "NOTE: …deprecated"; VoiceChatSetMuteState(userID, muted); VoiceChatGetState(userId):VoiceChatState; GetTitleId():int; GetVersionIdInfo():ValueTable; GetPlatformUserInfo():ValueTable.

Events: GameJoined(joinResult:int); ViewChanged(viewType:int); UserAuthComplete(); UserAccountChanged(accountChangeStatus:int); RobuxAmountChanged(robuxChangeStatus:int); **NetworkStatusChanged(statusJSON:string) — NO security tier argument** (descriptor default); KeyboardClosed(text:string); GainedActiveUser/LostActiveUser(userDisplayName); LostUserGamepad/GainedUserGamepad(userDisplayName); Suspended(); VoiceChatUserTalkingStart(userId:int); **VoiceChatUserTalkingEndSignal** — Lua event name literally ends in "Signal" unlike its Start twin; both Security::RobloxScript.

Bound props (cap SCRIPTING, **Security::RobloxScript**, category_Appearance unless noted): Brightness, Contrast, GrayscaleLevel, BlurIntensity (floats, all default 0), TintColor (Color3 default white); "DatamodelType" int read-only (category_Data) → PlatformDatamodelType set by `setPlatform(iface, newDatamodelType)`.

Enums: `XboxKeyBoardType` (Default/EmailSmtpAddress/Number/Password/Search/TelephoneNumber/Url); `VoiceChatState` (Available/Muted/NotInChat/UnknownUser). Both with Variant/StringConverter plumbing.

Concurrency idiom: `makeClosure(resume,error)` heap struct captured by detached boost::thread; per-operation InterlockedCompareExchange guard flags (baFlag shared by BOTH auth entries, alFlag shared by link/unlink/setCredentials, bsgFlag, bffFlag, ppuiFlag, ppruiFlag, bgpmFlag, bgiiFlag, bgciFlag, bpspFlag); busy → error("… already in progress"). Results delivered via `endTask` → `DataModel::submitTask(…, DataModelJob::Write)`. Local `dprintf` defined here (StandardOut MESSAGE_OUTPUT) except under RBX_PLATFORM_DURANGO.

## Usage / reflection touchpoints

Console-only service (RBXASSERT(platform) everywhere — NULL until some host calls setPlatform). Consumers: console CoreScripts (RobloxScript tier), Xbox shell integration. Cross-links: InputObject/UserInputService docs in this folder; [Network](../../Network/) for join flow context.

## Gotchas

- baFlag serializes BeginAuthorization AND BeginAuthUnlinkCheck against each other but NOT against account ops; alFlag likewise groups three different credential operations.
- beginHasLinkedAccount/beginHasRobloxCredentials have NO busy-guard — unguarded concurrent platform calls possible.
- Success conventions are inconsistent across wrappers: fetchFriends errors on r<0, party/profile require r==0 / r>=0 respectively, purchase/achievements always resume with raw enum cast.
- NetworkStatusChanged and KeyboardClosed events omit the security tier (unlike every sibling) — they inherit descriptor-default security.
- changeScreenResolution is deprecated yet still bound at RobloxScript.
- Detached threads outlive invocation: closures capture `this`; service teardown mid-flight would be use-after-free territory (UNKNOWN: lifetime guarantees header-side).
