# PurchasePromptScript2.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/PurchasePromptScript2.lua` (1506 lines; jeditkacheff/jmargh, Release 186)

## Purpose

The in-game purchase dialog (asset + developer-product prompts): validates economy state/ownership/funds/membership/age rating, shows Buy/Cancel/Free/Buy-R$ /Upgrade flows incl. native platform purchasing upsell, spinner animation, gamepad A/B handling, and the legacy Tix currency.

## API / Behavior

- State machine `purchaseState` ∈ {DEFAULT, FAILED, SUCCEEDED, BUYITEM, BUYROBUX, BUYINGROBUX, BUYBC}; guards IsCurrentlyPrompting/Purchasing/CheckingPlayerFunds.
- GUI: Modal.png dialog 324×180 (×3 ten-foot) sliding from top, item thumb via thumbs/asset.ashx URL, name truncated to 20 chars, ASSET_TO_STRING map for 34 asset type names, Robux/Tix icons + green/tan cost text, post-balance line; PurchaseFrame w/ 3 bouncing color-tweened loading dots.
- Validation pipeline `canPurchase(disableUpsell)`: guest (<0 userId) → FFlag Order66 kill-switch → optional economy-status API check → GetProductInfo → isForSale/isPublicDomain → ownership via `ownership/hasAsset` ("Already own" OK path returns TRUE with state FAILED) → third-party restriction (RestrictServices flag × workspace.AllowThirdPartySales vs CreatorId∈{game.CreatorId,1}) → balance (`currency/balance`, xbox platform-currency variant) → price resolution Default→Robux→Tix fallback → funds check (insufficient R$ → BuyRobux upsell dialog computing smallest BC/NON_BC product {80..2000} covering need; native platforms map to store product ids `com.roblox.client.robuxN[bc]` / iOS `...RobuxBC`; Xbox via PlatformCatalogData) → MinimumMembershipLevel → under-13 content rating → limited-sold-out.
- Accept: POSTs `marketplace/purchase` (assets: purchasePrice+locationType=Game) or `marketplace/submitpurchase` (products: expectedUnitPrice+placeId+GUID requestId, 3×1 s retries + GA report); ≥1 s artificial spinner; handles status AlreadyOwned/EconomyDisabled; EquipOnPurchase gear (AssetTypeId 19) InsertService-loaded into Backpack; products require receipt → SignalClientPurchaseSuccess.
- Completion: SignalPrompt{Product}PurchaseFinished(userId/Player, id, didPurchase); ServerPurchaseVerification event also triggers success; BrowserWindowClosed → retry(4) then DID_NOT_BUY_ROBUX failure; NativePurchaseFinished drives retry+accept or fail.
- Gamepad: A confirm mapped per purchaseState, B cancel; thumbstick wiggle toggles A/B overlay badges; controller movement frozen while open.

## Usage

Loaded always by StarterScript. MarketplaceService prompts route here.

## Gotchas
- Capital-G `Game:GetService` at line 1338 (Xbox branch).
- `hasEnoughMoneyForPurchase`/`retryPurchase`/`enableControllerInput` etc. are globals.
- formatNumber = reverse-gsub comma trick (breaks on decimals — prices are ints here).
- Tix paths are dead-but-present (currency retired).
