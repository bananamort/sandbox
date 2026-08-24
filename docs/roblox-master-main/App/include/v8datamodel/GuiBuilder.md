# App/include/v8datamodel/GuiBuilder.h

## Purpose

Non-Instance builder that constructs and maintains the in-game HUD (TopMenuBar widgets): chat menu/HUD, stats overlays (FPS/summary/physics/render/network/custom), safe-chat menus, and the Lua-GUI injection path via CoreGuiService/CoreScript.

## Declared API

`class GuiBuilder`

- Enums: `Display { DISPLAY_NONE, DISPLAY_FPS, DISPLAY_SUMMARY, DISPLAY_PHYSICS, DISPLAY_PHYSICS_AND_OWNER, DISPLAY_RENDER }` with static get/set `getDebugDisplay()/setDebugDisplay(Display)`; `NetworkStats { NETWORKSTATS_INVALID=0, NETWORKSTATS_FIRST(=RAKNET), PHYSICS, DATATYPE, STREAMING, COUNT }`.
- Lifecycle: `void Initialize(DataModel* dataModel); void buildGui(Workspace*, bool buildInGameGui); void updateGui();`
- Lua GUI: `void buildLuaGui();` — "uses CoreGuiService and CoreScript to inject a lua gui into the game".
- Custom stats: `addCustomStat(name, value)`, `removeCustomStat(name)`, `saveCustomStats()`; friend class `CustomStatsGuiJSON`; storage `struct Data { std::string stat; shared_ptr<TextDisplay> item; }; map<string, Data> customStatsCont;`
- Safe chat: `removeSafeChatMenu()/addSafeChatMenu()`; private recursive chat-menu build over ChatOption codes with UnifiedWidget parents.
- Network stats cycling: `void nextNetworkStats(); NetworkStats getDisplayingNetworkStats();` statics `buildNetworkStatsOutput(shared_ptr<Instance>, std::string*)`, `buildSimpleStatsOutput(...)`.
- Stats toggles: toggle{General,Render,Network,Physics,Summary,Custom}Stats.
- Private builders: one shared_ptr<TopMenuBar> factory per HUD (right palette, chat hud/menu, stats huds 1–2, render/network/network2, FPS, physics 1–2, summary, custom).
- Static colorizer: `updatePerformanceBasedStat(shared_ptr<TextDisplay>, float value, float greenCutoff, yellowCutoff, orangeCutoff, bool isBottleneck)`; updaters for summary/custom; `Verb* getWhitelistVerb(const std::string& name);`
- Members: `DataModel* dataModel; Workspace* workspace; shared_ptr<TopMenuBar> safeChatMenu; NetworkStats networkStatsCounter; bool oldTrackDataTypesValue, oldTrackPhysicsDetailsValue;`

## Gotchas

- Static global display state (DebugDisplay) affects every instance in-process.
- oldTrack* flags imply the builder temporarily flips tracking settings while its stats windows are open.
- Stats text is built by string assembly into output pointers.

## UNKNOWN

- Which verbs are whitelisted into HUD buttons (.cpp — see [GuiBuilder.md](../../v8datamodel/GuiBuilder.md)).

## Cross-links

- Implementation: [App/v8datamodel/GuiBuilder.md](../../v8datamodel/GuiBuilder.md).
- Owner: [DataModel.md](DataModel.md); verb source [Commands.md](Commands.md)/[CommonVerbs.md](CommonVerbs.md); kin [GuiCore.h](GuiCore.md).
