# Hopper.cpp

## Purpose

Implements the legacy tool-bin family in one TU: `BackpackItem` ("BackpackItem" — profanity-filtered renaming, TextureId, bin slot id), `HopperBin` ("HopperBin") — the script/command bin with BinType enum, Active state, Selected/Deselected events and client↔server replication shims, plus containers `Hopper`, `StarterGear`, `StarterPackService` ("StarterPack") and self-deleting `LegacyHopperService` ("Hopper").

## Key types and API

Descriptors:
- BackpackItem: `desc_TextureId("TextureId", category_Data)`.
- HopperBin: `desc_BinType("BinType", category_Data)` — enum "BinType" {Script, GameTool, Grab, Clone, Hammer + legacy numeric 5/6/7 "Slingshot"/"Rocket"/"Laser"→SCRIPT_BIN}; `desc_Active("Active")` BoundProp; `desc_Selected("Selected","mouse")` plain event; `desc_ReplicatedSelected("ReplicatedSelected", Security::None, REPLICATE_ONLY, CLIENT_SERVER)`; `desc_Deselected("Deselected")`; funcs `ToggleSelect`/`Disable` (**Security::RobloxScript**); LEGACY write-only Command + TextureName string props.
- Constants: sBackpackItem, sHopperBin, sStarterPackService="StarterPack", sLegacyHopperService="Hopper", sStarterGear.

Behavior:
- BackpackItem::setName SILENTLY IGNORES profane names (no error); getBinId = child index in parent; getSize = 10-stud square.
- HopperBin replication shim: server connects replicatedSelectedSignal→local select flow; CLIENT connects selectedSignal→replicateEvent — one-time via replicationInitialized on first ancestor-with-provider.
- onSelectScript creates ScriptMouseCommand, installs as workspace mouse command, fires Selected(mouse); onSelectCommand maps non-Script BinType to "<Name>Tool" verb and executes it.
- onLocalClicked toggles: inactive→activate+select; active→disable() (Deselected only for SCRIPT_BIN; restores default mouse command).
- Legacy setters: Command string → BinType (unparseable → SCRIPT_BIN); TextureName → Textures/<name>.png asset.
- Containers: Hopper/StarterGear accept ONLY BackpackItem children; StarterGear::askSetParent returns FALSE (commented-out player parenting); LegacyHopperService migrates ALL children to StarterPack then setParent(NULL) ("delete myself").

## Usage / reflection touchpoints

Superseded by [Tool](Tool.md) (same BackpackItem base); containers interact with [Backpack](Backpack.md) and [PlayerGui](PlayerGui.md)-adjacent StarterPack flows.

## Gotchas

- Profanity-filtered setName silently no-ops — scripts assigning a flagged name see NO change and NO error.
- The Selected/Deselected pair is asymmetric on disable: Deselected doesn't replicate for SCRIPT bins beyond local signal.
- StarterGear can never be re-parented anywhere (askSetParent false) despite living under players historically.
- BinType legacy numeric aliases map everything to Script — old Slingshot/Rocket/Laser bins load as empty script bins.
