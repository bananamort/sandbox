# RbxGui.lua

Source: `roblox-sandbox/content/scripts/Libraries/RbxGui.lua` (4266 lines; LoadLibrary("RbxGui") implementation)

## Purpose

Grab-bag client GUI widget library of the pre-SettingsHub era: message dialogs, drop-down menus, stepped sliders, two generations of custom scrolling frames, auto-truncating text labels, the one-time tutorial framework, the stamper "set panel" asset browser (with water-force and terrain-shape pickers), a classic-terrain material selector, a progress/loading frame, and plugin-window chrome.

## API (module table `t`)

- `t.CreateMessageDialog(title, message, buttons)` / `t.CreateStyledMessageDialog(..., style, ...)` — RobloxRound dialog frames; buttons = array of `{Text=..., Function=...}` tables laid out 1/2/N-across by the internal CreateButtons helper; style is "error"/"notify"/"confirm" with icon assets 42565285/42604978/42557901, anything else falls through to the plain dialog.
- `t.CreateDropDownMenu(items, onSelect[, forRoblox, whiteSkin, baseZ])` → `(frame, updateSelection)`; shows max 6 entries with scroll buttons beyond that, hover highlight, "Choose One" placeholder; `updateSelection(text)` errors "Invalid Selection Update" for unknown text. `forRoblox` sets RobloxLocked on cloned choice buttons.
- `t.CreateScrollingDropDownMenu(onSelectedCallback, size, position, baseZ)` — newer animated dropdown for the settings menu (arrow flip, tweened list, max 6 visible rows).
- `t.CreatePropertyDropDownMenu(instance, property, enum)` — dropdown two-way-bound to an enum-typed property via ScopedConnect.
- `t.GetFontHeight(font, fontSize)` — hardcoded pixel-height tables for Legacy/Arial/ArialBold; errors on any other font.
- `t.LayoutGuiObjects(frame, guiObjects, settingsTable)` — vertical stack layouter with per-type padding keys (TextLabelSizePadY etc.), hiding objects that no longer fit.
- `t.CreateSlider(steps, width, position)` / `t.CreateSliderNew(...)` → `(sliderGui, sliderPosition IntValue, sliderSteps IntValue)`; step-snapped dragging via an AreaSoak overlay button; SliderNew adds fill bar + capped image-bar art.
- `t.CreateTrueScrollingFrame()` → `(scrollingFrame, controlFrame)`; pixel-scrolling frame that repositions children from measured high/low Y bounds; controlFrame holds up/down buttons, drag bar, ScrollBottom/scrollUp BoolValues (used by SetPanel infinite paging).
- `t.CreateScrollingFrame(orderList, scrollStyle)` → `(frame, scrollUpButton, scrollDownButton, recalculate, scrollbar)`; row-based scroller ("simple" or "grid") with repeat-on-hold buttons and a draggable ScrollDrag handle.
- `t.AutoTruncateTextObject(textLabel)` → `(textLabel, changeText)`; binary-searches the largest fitting prefix + "~", spawns a hidden full-text rollover label on hover.
- Tutorial framework: `t.CreateTutorial(name, tutorialKey, createButtons)` → `(frame, showTutorial, dismissTutorial, gotoPage)`, persisting seen-state via `UserSettings().GameSettings:{Get,Set}TutorialState`; `t.AddTutorialPage(tutorial, page)` wires Next/Prev transitions (TransitionTutorialPages tween); `t.CreateTextTutorialPage` / `t.CreateImageTutorialPage` binary-shrink their content to fit.
- `t.CreateSetPanel(userIdsForSets, objectSelected, dialogClosed, size, position, showAdminCategories, useAssetVersionId)` → `(setGui, setVisibilityFunction, getVisibilityFunction, waterTypeChangedEvent)`; builds category/set lists from `InsertService:GetUserSets`/`GetCollection` (cached), 64px thumbnail grid paged on scroll-bottom, large preview via ThumbnailAsset.ashx URLs, skips "My Decals"/"My Models" and optionally "Beta" sets, special-cases the "High Scalability" set with a terrain-shape dropdown (Block..Auto-Wedge mapped to cell types incl. 6) and a Water force/direction sub-panel.
- `t.CreateTerrainMaterialSelector(size, position)` → `(frame, terrainMaterialSelectionChanged BindableEvent, forceTerrainMaterialSelection)`; icon grid for classic CellMaterials 1–17 (Grass..Water) with name↔enum mapping helpers.
- `t.CreateLoadingFrame(name, size, position)` → `(loadingFrame, updateLoadingGuiPercent(percent[, tween, length]), cancelButtonClicked BindableEvent)`.
- `t.CreatePluginFrame(name, size, position, scrollable, parent)` → `(dragBar, frameOrWidgetContainer, helpFrame, closeEvent BindableEvent)`; draggable title bar with close/?/minimize buttons and optional TrueScrollingFrame body + vertical resize dragger.
- `t.Help(funcNameOrFunc)` — self-documentation strings (LayoutGuiObjects entry exists but returns nothing).

## Usage

Loaded via `LoadLibrary("RbxGui")`. In this tree: `BuildToolsScript.lua` uses the tutorial API (CreateTutorial/CreateImageTutorialPage/AddTutorialPage) for its one-time PBS walkthrough; `PlayerlistModule.lua` loads it behind `if LoadLibrary then` but never calls into it. Everything else (sliders, set panel, material selector, dialogs) served the website-hosted classic build/stamper tool assets. The file has no core-script privileges requirement except where callers parent under CoreGui.

## Gotchas

- Real bug (~line 400): `if IsTouchClient then` inside `CreateScrollingDropDownMenu` reads an undefined global (same pattern as the GameSettings bug found earlier) — always nil, so touch users get mouse-only handlers and never receive TouchTap selection.
- Real bug: top-level `cancelSlide` (used by both sliders) references `areaSoakMouseMoveCon`, which only exists as a local *inside* the CreateSlider factories — cancelSlide actually reads an always-nil global, so ending a slide never disconnects the MouseMoved handler (stale connection until the next press replaces it).
- `scrollStamp` in `CreateTrueScrollingFrame` is never declared local, so all concurrent instances share one global holding stamp — simultaneous scrolling frames can terminate each other's repeat-scroll loops.
- Global leaks from missing `local`: `size` in both tutorial-page handleResize closures, `rows`/`columns`/`insertPanelCloseCon` in CreateSetPanel, plus `getEnumFromName`/`getNameFromEnum` are declared as plain globals on every CreateTerrainMaterialSelector call; `drag = nil` typos (~lines 1622/2181) should be `upCon = nil`.
- `local xOffset,yOffset = 0` assigns only xOffset; yOffset stays nil until recomputed (safe only because guiObjects[1] was already proven non-nil).
- Grid layout comment admits varying X/Y object sizes "can rarely cause minor errors"; recalculate() swallows layout exceptions with print(err).
- LayoutGuiObjects' `while not child.TextFits` growth loop has no upper bound — pathological text could spin forever.
- GetFontHeight rejects SourceSans-family fonts entirely (Legacy/Arial only).
- CreateSetPanel default-selection block indexes `userCategoryButtons[i].SetId` while iterating raw SetsLists children, so any non-button child would misalign selection; Beta-set skipping also shifts filtered indices relative to unfiltered assumptions elsewhere.
- `insertFrame:findFirstChild(...)` (lowercase) deprecated casing survives in setInsertButtonImageBehavior.
- Plugin-frame areaSoak parents to `getScreenGuiAncestor(parent)` which returns nil if the caller's parent chain isn't under a ScreenGui yet, silently disabling vertical-resize drag capture.
