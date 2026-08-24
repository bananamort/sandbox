# GuiBuilder.cpp

## Purpose

Implements `GuiBuilder` — the C++ constructor of the legacy (pre-Lua) client HUD. Builds every TopMenuBar debug panel (StatsHud1/2, RenderStats, NetworkStats, NetworkStats2 with its RakNet/Physics/DataTypes/Streaming pages, PhysicsStats 1+2, FPS, SummaryStats, CustomStats), the chat HUD / safe-chat menu tree, the RightPalette, and the ControlFrame skeleton parented into CoreGuiService. Owns toggle verbs for each panel, custom-stats JSON persistence, and the SummaryStats bottleneck colorizer.

## Key types and API

No reflection descriptors in this file — GuiBuilder is a plain helper owned by DataModel (`Initialize(DataModel*)`, not a service). Flags: `FFlag::DebugDisplayFPS(false)`, `FFlag::LuaBasedBubbleChat(false)`; file-static `gDebugDisplay` enum Display {DISPLAY_NONE..DISPLAY_FPS/RENDER/PHYSICS/PHYSICS_AND_OWNER/SUMMARY} set via static get/setDebugDisplay.

Builders (each returns shared_ptr<TopMenuBar>, all start hidden unless noted):
- buildStatsHud1 — world/timing/graphics/throttle/network rows as EquationDisplay("label", "metricName"); 310×22 white-on-translucent.
- buildStatsHud2 — contacts + kernel counters (comment: "Solver Iteratn"/"Matrix Size" are "for fun / deception - we don't use matrices!").
- buildRenderStats — graphics/performance/FRM/draw-pass rows (440×22).
- buildNetworkStats — HTTP queue + Replicator in/out aggregate rows.
- buildNetworkStats2(bool init) — paged: NETWORKSTATS_RAKNET (RakNet per-sec counters), NETWORKSTATS_PHYSICS (InPhysicsDetails/OutPhysicsDetails), NETWORKSTATS_DATATYPE (InDataDetails/OutDataDetails), NETWORKSTATS_STREAMING (FreeMemory/MemoryLevel/ReceivedStreamData); `nextNetworkStats()` cycles and reparents. Note: STREAMING case has NO break → falls into default (benign).
- buildFPS — single "Render" metric at font 24; visible iff DebugDisplayFPS.
- buildSummaryStats — Effective/Physics/Render/Network FPS + hidden detail blocks (13 render, 8 physics, 11 network children).
- buildCustomStats — loads ClientSettings/StatDisplaySettings.json via CustomStatsGuiJSON (SimpleJSON subclass) whose DefaultHandler creates EquationDisplay(name+" : ", valueData).
- buildPhysicsStats / buildPhysicsStats2 — physics counters and Profiling::setEnabled-gated World Step breakdown.
- buildChatHud (skipped when LuaBasedBubbleChat), buildChatMenu/buildChatMenu recursion over SafeChat::singleton().getChatRoot() producing ChatWidget codes "0 2 1" style, buildRightPalette.
- buildGui(workspace, buildInGameGui) — orchestrates all of the above; honors gDebugDisplay by force-showing panels and flipping PhysicsSettings::setShowEPhysicsOwners for DISPLAY_PHYSICS_AND_OWNER; buildLuaGui() creates RobloxLocked frames ControlFrame{BottomLeftControl,BottomRightControl,TopLeftControl} under CoreGuiService.
- Toggles: toggleGeneralStats/RenderStats/NetworkStats/PhysicsStats/SummaryStats/CustomStats flip visibility by GuiRoot child name; toggleNetworkStats also saves/restores NetworkSettings::singleton().trackDataTypes & trackPhysicsDetails around oldTrack*Value members.
- addCustomStat/removeCustomStat/saveCustomStats — runtime custom stat management; save writes JSON to GetUserDirectory(false,DirExe,"ClientSettings")/StatDisplaySettings.json.
- updateGui/updateSummaryStats — called under DM read lock (comment admits it MUTATES anyway): reads metrics ("Effective FPS","Render FPS","Physics FPS","Network Receive CPU","Received Physics Packets","Frame Time",...), hysteresis slow flags, bottleneck detection (render/physics/network >0.4×frameTime or networkReceivePercentage>0.5), colors Total/Physics/Render green≥28/yellow≥20/orange≥10 FPS and enlarges bottleneck row to font 18, reveals only the slow subsystem's detail block.
- updatePerformanceBasedStat(item,value,green,yellow,orange,isBottleneck) — shared colorizer.
- buildSimpleStatsOutput/buildNetworkStatsOutput — text dump helpers padding names to 15 chars.

## Usage / reflection touchpoints

Constructed/driven from DataModel startup ([Game](Game.md)/[DataModel](DataModel.md)); panels read Stats::Item metrics created elsewhere ([Stats](Stats.md)); depends on [SafeChat](SafeChat.md), [Workspace](Workspace.md) whitelist verbs, [PlayerGui](PlayerGui.md)/[ScreenGui](ScreenGui.md)-era Gui classes, NetworkSettings singleton.

## Gotchas

- updateSummaryStats mutates GUI state while holding a READ lock on the DataModel — flagged in a source comment as known debt ("Things that need to be addressed").
- `slowRendering/slowPhysics/slowNetworking` are function-local STATICs — global across instances/places.
- startSlowNetworkCPU=25/endSlowNetworkCPU=20 and the CPU thresholds are inverted relative to the other axes (higher CPU is worse) — easy to misread when tuning.
- WriteFile() never closes the ofstream explicitly and writes a trailing comma before "}" (non-strict JSON).
- CustomStatsGuiJSON private default ctor is declared but unused; ReadFromStream path silently ignores malformed JSON.
- RBXASSERT(fps != NULL) pattern after findFirstChildByName — panels missing from GuiRoot fail asserts in dev builds but no-op in release.
- buildNetworkStats2 STREAMING case intentionally(?) lacks break — falls to default; harmless today but a trap if cases are added after it.
