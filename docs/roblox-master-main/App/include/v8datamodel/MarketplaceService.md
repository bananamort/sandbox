# App/include/v8datamodel/MarketplaceService.h

## Purpose

`MarketplaceService` (INTERNAL service) — in-game purchase coordination (per header comment: most work happens in a client Lua script; this service relays signals and exposes Lua calls incl. GetProductInfo): prompt/finished flows for product, asset, native, and third-party purchases; receipt processing; dev-product info; response caching; Lua-dialog bridge.

## Declared API

`class MarketplaceService : public DescribedCreatable<..., Instance, sMarketplaceService, ClassDescriptor::INTERNAL>, public Service`

- Enums: `CurrencyType {CURRENCY_DEFAULT=0, CURRENCY_ROBUX=1, CURRENCY_TIX=2}`; `InfoType {INFO_ASSET, INFO_PRODUCT, INFO_NONE}`; `ProductPurchaseDecision {DECISION_NOT_PROCESSED_YET=0, DECISION_PURCHASE_GRANTED=1}`. `static const char* urlApiPath() { return "marketplace"; }`
- Remote signals: native pair (`promptNativePurchaseRequested`, `nativePurchaseFinished`), third-party pair (+receipt string), product pair (`promptProductPurchaseRequested(player, assetId, equipIfPurchased, currency)` / `...Finished(userId, assetId, isPurchased)`), legacy asset pair (`promptPurchaseRequested` / `promptPurchaseFinished`), verification pair (`clientPurchaseSuccess(response, userId, productId)`, `serverPurchaseVerification(ValueTable)`), dialog pair (`clientLuaDialogRequested(Tuple)`, `luaDialogCallbackSignal(bool, Instance)`).
- Receipts: public member callback `ReceiptCallback receiptCallback` (ValueTable + resume/error typedef); `processReceiptsCallbackChanged(oldValue)`; backend-only setup `setupBackendOnlyReceiptHandling()`, fetch paths for joining player and post-purchase, static processReceipt + success continuation.
- Purchase flow API: `signalPromptProductPurchaseFinished(userId, productId, success)`, `promptProductPurchase(player, productId, equipIfPurchased, currency)`, legacy `signalPromptPurchaseFinished(player, assetId, isPurchased)` + `promptPurchase(...)`, `signalClientPurchaseSuccess(ticket, userId, productId)`, third-party/native prompt+finished signalers.
- Info: `void getProductInfo(int assetId, InfoType, resume(ValueTable), error)` with raw-success/error handlers taking weak DataModel; `void getDeveloperProductsAsync(resume(shared_ptr<Instance>), error)`; URL members devProductInfoUrl/productInfoUrl/playerOwnsAssetUrl; TTL cache `struct ResponseCache { Time lastFetch; shared_ptr<const ValueTable> values; }` in `UrlToResponseMap mMap`.
- Ownership: `void playerOwnsAsset(player, assetId, resume(bool), error)` + response processors.
- Dialog: `launchClientLuaDialog(message, accept, decline, player, callback(bool, Instance))`, `signalServerLuaDialogClosed(bool)`, `executeClientDialogCallback(bool, Instance)`; pending callbacks map keyed by shared_ptr<Instance> (`callbackFunctionMap`) cleaned on player removing.
- Ticket verify: `verifyPurchaseTicket(ticket, userId, productId)` + NoDMLock handlers.
- Overrides: onServiceProvider, `processRemoteEvent(descriptor, args, SystemAddress)` with static purchase-finished/error processors.
- Misc: template dispatchRequest<ResultType>; isValidPlayer(player, funcName, errorFn = 0).

## Gotchas

- Purchase completion arrives via remote events processed under custom processRemoteEvent — ordering vs DataModel lock matters (NoDMLock variants exist).
- Product-info cache is unbounded per-URL map with time-based staleness only.
- Legacy asset purchase path (TIX era) coexists with product/native/third-party paths — four parallel flows.

## UNKNOWN

- Exact receipt ValueTable schema expected of ProcessReceipt (.cpp/Lua contract — see [MarketplaceService.md](../../v8datamodel/MarketplaceService.md)).

## Cross-links

- Implementation: [App/v8datamodel/MarketplaceService.md](../../v8datamodel/MarketplaceService.md).
- Commerce kin: [GamePassService.md](GamePassService.md), [BadgeService.md](BadgeService.md), [HttpRbxApiService.md](HttpRbxApiService.md).
