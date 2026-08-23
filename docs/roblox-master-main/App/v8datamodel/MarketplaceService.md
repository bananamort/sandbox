# MarketplaceService.cpp

## Purpose

Implements `MarketplaceService` (name "MarketplaceService"), the Instance service backing all in-experience commerce: prompting asset/developer-product purchases, querying product info and ownership from the Roblox web API, third-party/native (app-store) purchase prompts, server-side receipt processing (`ProcessReceipt`), and the Lua-dialog handshake used by core scripts to render purchase UI.

## Key types and API

Reflection-registered members (real script-facing names):

Functions: `SignalPromptProductPurchaseFinished(userId, productId, success)` (RobloxScript), `SignalPromptPurchaseFinished(player, assetId, success)` (RobloxScript), `SignalClientPurchaseSuccess(ticket, playerId, productId)` (RobloxScript), `PromptNativePurchase(player, productId)` (RobloxScript), `PromptThirdPartyPurchase(player, productId)` (RobloxPlace), `GetProductInfo(assetId, infoType) [yields]` (Security::None, returns ValueTable), `PlayerOwnsAsset(player, assetId) [yields]` (None, bool), `PromptPurchase(player, assetId, equipIfPurchased=true, currencyType=Default)` (None), `PromptProductPurchase(player, productId, equipIfPurchased=true, currencyType=Default)` (None), `SignalServerLuaDialogClosed(value)` (RobloxScript), `GetDeveloperProductsAsync() [yields]` (None, returns a StandardPages instance).

Events: `PromptPurchaseRequested(player, assetId, equipIfPurchased, currencyType)`, `PromptProductPurchaseRequested(...)`, `ClientPurchaseSuccess(ticket, playerId, productId)` (CLIENT_SERVER), `ServerPurchaseVerification(serverResponseTable)`, `PromptThirdPartyPurchaseRequested` / `PromptNativePurchaseRequested` (REPLICATE_ONLY + BROADCAST, Security::Roblox), `NativePurchaseFinished`, `ThirdPartyPurchaseFinished`, `PromptPurchaseFinished`, `PromptProductPurchaseFinished` (marked deprecated via attributes), `ClientLuaDialogRequested(arguments)` (CLIENT_SERVER), `LuaDialogCallbackSignal(value, player)` (REPLICATE_ONLY).

Callback: `ProcessReceipt(receiptInfo)` registered as a `BoundAsyncCallbackDesc` returning `ProductPurchaseDecision` ("NotProcessedYet" | "PurchaseGranted"); setting it off-server throws "Can only register ProcessReceipt callback on server".

Enums defined here: `CurrencyType` {Default, Robux, Tix}, `InfoType` {Asset, Product}, `ProductPurchaseDecision` — each with EnumDescriptor + Variant conversion + StringConverter specializations for XML serialization.

Non-reflection machinery: URL templates built in ctor — `productinfo?assetId=%d`, `ownership/hasasset?userId=%d&assetId=%d`, `/productDetails?productId=%d`; response cache `mMap` keyed by formatted path with TTL `DFInt::ExpireMarketPlaceServiceCacheSeconds` (default 60 s); `processRemoteEvent()` override that, under `DFFlag::DoubleCheckPurchase` (default true), re-verifies claimed purchases server-side by calling PlayerOwnsAsset and only forwarding the event when claim==ownership (mismatches reported to InfluxDB as `purchaseVerificationMismatch`; web errors fall through when `DFFlag::AllowClientFallback`, default true); spoof guard `DFFlag::IgnoreDifferentPlayer` drops events whose source address differs from the player's real remote address; `launchClientLuaDialog(message, accept, decline, player, callback)` + `callbackFunctionMap` + `executeClientDialogCallback` implement the dialog round trip; backend receipt pipeline `onServiceProvider` → `setupBackendOnlyReceiptHandling` (auto-approve until user sets ProcessReceipt) → `getReceiptsForJoiningPlayer`/`getReceiptsAfterPurchase` → `fetchAndProcessTransactions(userId)` GETs `gametransactions/getpendingtransactions/?PlaceId=&PlayerId=` → `buildReceiptInfoFromJson` maps keys playerId/placeId/receipt/actionArgs{productId,currencyTypeId,unitPrice} into receipt table fields PlayerId/PlaceIdWherePurchased/PurchaseId/ProductId/CurrencyType/CurrencySpent → `processReceipt` invokes user callback → on PurchaseGranted POSTs `gametransactions/settransactionstatuscomplete` and fires Google Analytics `BuyDeveloperProduct`.

FFlags/DFlags declared here: CheckMarketplaceAvailable, Order66, ExpireMarketPlaceServiceCacheSeconds(60), RestrictSales, UseNewPromptEndHandling, DoubleCheckPurchase(true), AllowClientFallback(true), IgnoreDifferentPlayer(true), PurchaseMismatchReportRate(100), PurchaseErrorReportRate(100).

## Usage / reflection touchpoints

All script-facing surface goes through descriptors in one REFLECTION_BEGIN/END block; prompt calls validate the target is a Network::Player (guest userId<=0 warns except PromptPurchase/PromptProductPurchase), reject non-local-player targets under frontend processing, require assetId/productId > 0 (throwing runtime_error), and require Studio API access enabled via LuaWebService::isApiAccessEnabled before firing `fireAndReplicateEvent`. Server→client events use raiseEventInvocation with the player's SystemAddress when a server is present, else local fireEvent. GetDeveloperProductsAsync returns a `StandardPages` over `developerproducts/list?placeid=%i`.

## Gotchas

- Client-reported purchases are re-verified against ownership; a mismatched report is dropped AND reported to analytics — game logic that bans on fake purchases cannot be triggered by spoofing another player because of the SystemAddress check.
- If the ownership web call errors, the client message PASSES by default (AllowClientFallback=true) — trust-the-client fallback.
- Setting ProcessReceipt on a non-server silently reverts and throws; before any user assignment the backend auto-grants every receipt (alwaysApproveReceiptsCallback).
- Guest players (userId<=0) fail most calls with just a warning; PromptPurchase/PromptProductPurchase are exempted from the guest warning but still need valid ids.
- PromptPurchase/PromptProductPurchase throw if Studio API access is disabled — error text points at Game Settings.
- The product-info cache serves stale data up to 60 s (DFInt-tunable) and errors on InfoType NONE.
- UNKNOWN: behavior gated behind DFFlag::CheckMarketplaceAvailable / Order66 / RestrictSales — no code in this file reads them (consumed elsewhere).
