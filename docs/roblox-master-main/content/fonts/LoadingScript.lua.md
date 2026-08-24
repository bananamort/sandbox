# LoadingScript.lua (fonts/)

Source: `roblox-sandbox/content/fonts/LoadingScript.lua` (814 wc-lines / 1629 read-lines — file is double-spaced; header carries `--rbxsig%…%` Roblox script SIGNATURE and `--rbxassetid%158948138%`)

## Purpose

The OLDER, signed 2014 loading screen (ArceusInator & Ben Tkacheff) kept under content/fonts/: game-thumbnail showcase with "You're on your way to <Game> By <Creator>" bottom banner, live Instances/Bricks/Connectors/Voxels counters, and a looping blue-block animation. Uses LEGACY capital globals (`Game`, `Spawn`, `Delay`) throughout.

## API / Behavior

- `InfoProvider:LoadAssets()` — Spawn: waits PlaceId>0, appends it to GAME_THUMBNAIL thumb URL (`Thumbs/Asset.ashx?...assetId=`), coroutine GetProductInfo, waits for gui then sets Thumbnail.Image, Preloads all IMAGES.
- `MainGui:GenerateMain()` — nested `create` builder (numeric keys = children): MainBackgroundContainer (#232326 DARK) with rotated −10° TopBar (1000×220) carrying RobloxLogo + "Powered By", CloseButton (verb Exit), ErrorFrame, BottomBar (BottomBarActual → TextContainer with OnYourWay / GameName / CreatorName / 'By' prefix labels, all Size48 stroke), vignette + 1.5× overscan BackgroundThumbnail; ThumbnailContainer 420×230 centered (Thumbnail + LoadingInfoContainer strip with Instances/Voxels/Connectors/Bricks label+value pairs); parented to Game.CoreGui then RecalculateSizes.
- Responsive: RecalculateTextSize picks from VALID_TEXT_SIZES {12,14,18,24,36,48} via screen-y/800 scale (comment: "next can't take a 0 because it's a total wuss"), repositions stacked labels by TextBounds, scales bottom bar 300×(size/48). RecalculateSizes scales thumbnail clamp(y/630, 50/230..1), hides counter strip below y=500, spawns name-wait loop.
- RenderStepped: GuiService GetInstanceCount/GetVoxelCount/GetBrickCount/GetConnectorCount → counter labels (voxels suffixed " million").
- Teardown: RemoveDefaultLoadingGuiSignal OR Game.Loaded→gameIsLoaded→ if default already removed remove immediately else FORCE after 5 s (forceRemovalTime). removeLoadingScreen destroys gui AND script.
- Animation: six 10px blocks cycle left-entrance→center-pile (sizes ×1.5 steps)→right-exit forever (Sine tweens at 1500 px/s), plus 20 s linear pan of the background thumbnail.

## Usage

Legacy/decorative variant — the active loader is content/scripts/LoadingScript.lua; this copy is retained under fonts/ (likely for its historical rbxsig + asset binding).

## Gotchas
- Capital-G `Game`, `Spawn`, `Delay`, `wait` globals — dead under Luau strict mode; would need shims to ever run again.
- Signature line means byte edits break the rbxsig hash (if anything still verifies it).
- VoxelsValue shows raw count + " million" label regardless of magnitude.
