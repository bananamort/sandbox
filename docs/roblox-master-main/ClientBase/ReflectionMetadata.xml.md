# ReflectionMetadata.xml

Source: `roblox-sandbox/ClientBase/ReflectionMetadata.xml` (4224 lines)

## Purpose

The data file consumed by `Metadata::Reflection::load()`. It is a Roblox XML place-format document (version 4) whose root contains two items: a `ReflectionMetadataClasses` tree and a `ReflectionMetadataEnums` tree. Each entry attaches human-facing documentation to reflection descriptors — summaries, deprecation flags, browseability, Explorer ordering/icon indices, preferred parents, insertability, and UI slider bounds (`UIMinimum`/`UIMaximum`) for numeric properties.

## Structure

- Root `<roblox version="4">`.
- One `ReflectionMetadataClasses` item containing 208 `ReflectionMetadataClass` children keyed by class `Name`: BindableFunction, BindableEvent, TouchTransmitter, ForceField, PluginManager, TeleportService, StudioTool, Plugin, PluginMouse, Glue, CollectionService, JointsService, BadgeService, LogService, AssetService, HttpService, InsertService, Hat, Accessory, Mouse, ContextActionService, PointsService, Chat, MarketplaceService, UserInputService, Humanoid, Workspace, Players, ReplicatedStorage, ReplicatedFirst, ServerStorage, ServerScriptService, Lighting, TestService, DebuggerManager family, Debris, Player, DataModel, HopperBin, Camera, Script/LocalScript/ModuleScript, Model, BasePart and its part variants, GUI classes (ScreenGui, BillboardGui, SurfaceGui, GuiObject, Frame, ScrollingFrame, ImageLabel, TextLabel, TextButton, TextBox, GuiButton, ImageButton, Handles/ArcHandles/SelectionBox family), Terrain/TerrainRegion, lights, RemoteFunction/RemoteEvent, UnionOperation/NegateOperation, and more.
- Under each class: optional `ReflectionMetadataProperties|Functions|YieldFunctions|Events|Callbacks` containers of `ReflectionMetadataMember` items with per-member `summary`, `Deprecated`, etc.
- A trailing `ReflectionMetadataEnums` item with `ReflectionMetadataEnum` entries for `Material` (terrain materials Air/Water/Rock/Glacier/Snow/Sandstone/Mud/Basalt/Ground/CrackedLava all marked Browsable=false) and deprecated `Status`.

## Usage

Loaded at first call of `RBX::Reflection::Metadata::Reflection::singleton()` from the directory of the running executable (see ReflectionMetadata.cpp). Consumers then query it per-descriptor; the API dump writer and Studio UI both read through those lookups.

## Gotchas

- Data-quality quirks baked into this file: `Mouse.Origin` is declared twice (duplicate member entries); the `Humanoid` properties block nests four property names inside one `ReflectionMetadataMember` element (only the first will be found by name lookup); several classes have commented-out ExplorerOrder lines.
- Summaries contain embedded HTML links (`<a href="http://wiki.roblox.com...">`) that are stored escaped in attribute-style string elements — they are documentation strings, not rendered markup at engine level.
- `StockSound` sets Browsable using a `<string>` element rather than `<bool>` ("false" as text). Verified harmless: the typed read path (`TypedPropertyDescriptor<bool>::readValue` → `XmlNameValuePair::getValue(bool&)`) coerces STRING values through `StringConverter<bool>::convertToValue`, which accepts `false`/`False`/`FALSE`, so it still binds to boolean false.
- The file ships next to the client executable at runtime; it is not embedded as a resource. If missing, all metadata lookups return NULL and every class appears undocumented.
