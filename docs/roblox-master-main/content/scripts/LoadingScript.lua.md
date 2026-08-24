# LoadingScript.lua

Source: `roblox-sandbox/content/scripts/LoadingScript.lua` (775 lines)

## Purpose

The generic ROBLOX loading screen (ArceusInator & Ben Tkacheff, 2014): full-screen dark tiled background, spinning loading circle + animated dots, place/creator info from MarketplaceService, error banner wiring, console cancel-B shutdown, and the teardown handshake with ReplicatedFirst.

## API / Behavior

- `InfoProvider:LoadAssets()` — async GetProductInfo(PlaceId) (busy-waits PlaceId>0); GetGameName/GetCreatorName read it; Xbox `ConvertMyPlaceNameInXboxApp` flag swaps hex-temp-username place names ("^([0-9a-fA-F]+)'s Place$", len 32) for creator name.
- `MainGui:GenerateMain()` — ScreenGui "RobloxLoadingGui" → BlackFrame (#2D2D2D) with CloseButton (verb Exit after 5 s fade-in), GraphicsFrame (rotating circle + "Loading..." text; hidden on ten-foot), UiMessageFrame (engine SetUiMessage), InfoFrame (PlaceLabel TextScaled + CreatorLabel; ten-foot adds ByLabel/CreatorIcon gated by ShowDevNameInXboxApp), BackgroundTextureFrame (512² tile grid re-tiled on resize), ErrorFrame (red banner; ten-foot restyle w/ icon + Leave button self-cycling selection).
- RenderStepped loop: rotation 360°/2 s, dot animation every .2 s while creator unknown else on brick-count deltas (GuiService:GetBrickCount), close-button fade after 5 s.
- Ten-foot: createTenfootCancelGui binds B → PlatformService:RequestGameShutdown (only pre-replication).
- GuiInsetChanged BindableEvent (created under RobloxGui) offsets BlackFrame for mobile insets.
- Teardown: ReplicatedFirst.FinishedReplicating → if game has ReplicatedFirst elements wait 5 s max then remove; else wait for `game.Loaded` (flag UseGameLoadedInLoadelingScript) or ContentProvider.RequestQueueSize==0. RemoveDefaultLoadingGuiSignal also triggers. destroyLoadingElements keeps ErrorFrame alive for late connection errors; fadeAndDestroyBlackFrame manual 1.8/s transparency ramp then stop render loop.

## Usage

Runs as the FIRST client script (ReplicatedFirst domain). Pairs with content/fonts/LoadingScript.lua variant.

## Gotchas
- Typo in comments only; but note `useGameLoadedToWait` flag name mismatch risk ("UseGameLoadedInLoadingScript").
- CloseButton uses SetVerb("Exit") — engine verb.
- destroyLoadingElements destroys non-BlackFrame children EXCEPT ErrorFrame — anything else parented later is destroyed too.
- Busy-wait loops throughout (CoreGui wait, viewport waits).
