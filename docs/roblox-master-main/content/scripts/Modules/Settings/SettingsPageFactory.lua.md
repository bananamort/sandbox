# SettingsPageFactory.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/SettingsPageFactory.lua` (275 lines)

## Purpose

Base-class factory for every Settings-hub page (jeditkacheff): builds TabHeader (icon+title+selection underline), Page frame with unique gamepad-selection group, Displayed/Hidden BindableEvents, slide animations, and a row registry driving gamepad focus.

## API / Behavior

- Module surface: `moduleApiTable:CreateNewPage()` → new page instance.
- Page instance fields: HubRef, LastSelectedObject, TabPosition, Active, OpenStateChangedCount; private rows[], displayed.
- GUI: TabHeader TextButton 169px (84 small-touch / 220 ten-foot) w/ Icon ImageLabel + Title "Change Me" + TabSelection 9-slice underline (MenuSelection.png, SliceCenter 3,1,4,5); click → `HubRef:SwitchToPage(this,true)`. Page Frame 100%×100%; each page gets `GuiService:AddSelectionParent(GenerateGUID(), Page)`.
- Events:
  - `Displayed` — internal connect auto-calls SelectARow() when hub shield visible.
  - `Hidden` — clears SelectedCoreObject if it lives inside this page.
- Methods:
  - `SelectARow(forced)` — restore LastSelectedObject or first row's ValueChanger frame (SliderFrame preferred over SelectorFrame for table value-changers).
  - `Display(pageParent, skipAnimation)` — tab highlight on, page visible, 0.1s Quad tween from offscreen-right to 0; fires Displayed.
  - `Hide(direction, newPagePos, skipAnimation, delayBeforeHiding)` — inverse slide OUT by direction; parks page at `(TabPosition−newPagePos)` offset; delayed hide is generation-guarded via OpenStateChangedCount snapshot.
  - `GetDisplayed/GetVisibility(Page.Parent)/GetTabHeader/GetSize`.
  - `SetHub(hubRef)` — stores + pushes hub onto all table-type row ValueChangers.
  - `AddRow(RowFrame, RowLabel, ValueChangerInstance, ExtraRowSpacing)` — appends and GROWS Page height by row size (+extra).

## Usage

Every Settings/Pages/*.lua requires this and calls CreateNewPage(); SettingsHub drives Display/Hide.

## Gotchas
- AddRow grows Page by RowFrame.Size.Y.Offset even when nil rows pass 0 — manual layout bookkeeping, easy to desync.
- Hide's park position assumes horizontal TabPosition arithmetic — vertical pages break.
- Selection GUID never removed from GuiService (leak per page creation).
