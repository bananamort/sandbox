# CERTIFICATION-N-Z.md — Independent Review of App/include/v8datamodel N–Z Header Docs

**Reviewer**: independent subagent (fresh eyes; writer output never trusted unread).
**Date of review pass**: this certification.
**Scope**: 97 headers in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/v8datamodel/` whose basename starts N–Z, each paired with its same-named `.md` under `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/v8datamodel/`, plus `INDEX-N-Z.md`.

## Method

- **Re-enumeration**: source dir contains 225 `.h` files; exactly 97 start with uppercase N–Z (`grep -c '^[N-Z]'`). Docs dir `.md` basenames minus `INDEX*`/cert files = same 97-name set for N–Z (`comm` diff both directions: empty). The only digit-bearing N–Z file (`Scale9Frame.h`) is enumerated and covered (digit-inclusive sweep clean); lowercase-starting headers (`factoryregistration.h`, `legacy.h`) are A–M range and out of scope.
- **Per-file verification**: EVERY header read IN FULL via tool call (no sampling), then its `.md` read in full; every declared signature, enum, macro, constant, comment quote, and gotcha checked against the source text.
- **Cross-checks against .cpp/recon** where a doc made implementation-side claims: hackFlag decoys (SurfaceSelection.cpp L46 `hackFlag0`, PhysicsInstructions.cpp L182 `hackFlag6`, TouchTransmitter.cpp L106 `hackFlag7`), Teams `getUnusedTeamColor` iterator-invalidation UB (Teams.cpp L138–156, `vec.erase(iter)` with ignored return inside loop).
- **Index audit**: mechanical link extraction from INDEX-N-Z.md vs the 97 basenames — exact set equality (0 gaps, 0 extras) after basename-normalizing dual-link rows.

## Known-trap verification (all confirmed present and precisely documented)

| Trap | Doc status | Verdict |
|---|---|---|
| NumberRange.h `#undef min`/`#undef max` (L3–4) | documented; "bitwise-equal" float-== phrasing corrected | FIXED |
| Test.h `#undef check` (`#ifdef check/#undef check/#endif`, L9–11) | documented exactly | PASS |
| Stats.h namespace-scope `static std::string countersApiKey = "76E5A40C-3AE1-4028-9F10-7C62520BD94F"` (L26) | documented verbatim incl. per-TU-copy semantics | PASS |
| ToolsPart.h class-static paint state (`static FillToolColor color` L51, `static PartMaterial material` L79) | documented as process-global CLASS STATICS, no per-doc isolation | PASS |
| Remote.h LatchedSignal replay-on-connect (fireN pushes when `empty()`; `connect()` drains queue) | documented exactly, incl. overflow message text | PASS |

## Fixes applied in place (mechanically certain only)

1. **PhysicsService.md — WRONG**: gotcha claimed "`iAmServer` is a plain bool set outside the ctor body path shown here", but the header's inline ctor explicitly assigns `iAmServer = false` (L55). Rewritten to state it is non-atomic, assigned only in the inline ctor body, later transitions out-of-line.
2. **PlatformService.md — MISSING-GOTCHA**: added the `Super` typedef mismatch — private `typedef DescribedNonCreatable<PlatformService, Instance, sPlatformService> Super;` while the class actually derives from `DescribedCreatable<..., PERSISTENT_LOCAL>`; any `Super::` use resolves against the wrong descriptor template.
3. **ScrollingFrame.md — WRONG**: "five scoped connections" corrected to four (header declares exactly four: inputEnded, guiServicePropertyChanged, selectionGained, selectionLost). Also cleaned the garbled sic-note to the real name `setScrollingInertia()`.
4. **PrismInstance.md — STYLE/typo**: "commented-out NumSides/NumSides members" → "NumSides/NumSlices members" (header L63–64).
5. **NumberRange.md — WRONG (technical)**: "bitwise-equal semantics" for float `==` corrected to strict value-equality with explicit ±0.0/NaN caveat (IEEE `==` is not bitwise comparison).
6. **INDEX-N-Z.md — roster hygiene**: removed duplicate `[Remote]` "alphabetical anchor" row (R section had listed Remote twice, yielding 98 rows for 97 entries).

## Per-file verdicts (97/97 fully read)

| # | File | Verdict |
|---|---|---|
| 1 | NonReplicatedCSGDictionaryService | PASS |
| 2 | NotificationService | PASS |
| 3 | NumberRange | FIXED (float == phrasing) |
| 4 | NumberSequence | PASS |
| 5 | ParallelRampInstance | PASS |
| 6 | ParametricPartInstance | PASS |
| 7 | PartCookie | PASS |
| 8 | PartDragger | PASS |
| 9 | PartInstance | PASS |
| 10 | PartOperation | PASS |
| 11 | PartOperationAsset | PASS |
| 12 | PathfindingService | PASS |
| 13 | PersonalServerService | PASS |
| 14 | PhysicsInstructions | PASS |
| 15 | PhysicsService | FIXED (iAmServer gotcha) |
| 16 | PhysicsSettings | PASS |
| 17 | Platform | PASS |
| 18 | PlatformService | FIXED (added Super-typedef gotcha) |
| 19 | PlayerGui | PASS |
| 20 | PlayerMouse | PASS |
| 21 | PlayerScripts | PASS |
| 22 | PluginManager | PASS |
| 23 | PluginMouse | PASS |
| 24 | PointsService | PASS |
| 25 | Pose | PASS |
| 26 | Posture | PASS |
| 27 | PrismInstance | FIXED (NumSlices typo) |
| 28 | PVInstance | PASS |
| 29 | PyramidInstance | PASS |
| 30 | Remote | PASS (LatchedSignal trap exact) |
| 31 | RenderHooksService | PASS |
| 32 | ReplicatedFirst | PASS |
| 33 | ReplicatedStorage | PASS |
| 34 | RightAngleRampInstance | PASS |
| 35 | RobloxReplicatedStorage | PASS |
| 36 | RootInstance | PASS |
| 37 | SafeChat | PASS |
| 38 | Scale9Frame | PASS |
| 39 | ScreenGui | PASS |
| 40 | ScriptMouseCommand | PASS |
| 41 | ScriptService | PASS |
| 42 | ScrollingFrame | FIXED (connection count + name note) |
| 43 | Seat | PASS |
| 44 | Selection | PASS |
| 45 | SelectionBox | PASS |
| 46 | SelectionLasso | PASS (`getHunanoid` source typo correctly flagged) |
| 47 | SelectionSphere | PASS |
| 48 | ServerScriptService | PASS |
| 49 | ServerStorage | PASS |
| 50 | SkateboardController | PASS (int-vs-float claim cross-verified on platform side) |
| 51 | SkateboardPlatform | PASS |
| 52 | Sky | PASS |
| 53 | SleepingJob | PASS |
| 54 | Smoke | PASS |
| 55 | SocialService | PASS |
| 56 | SolidModelContentProvider | PASS |
| 57 | Sparkles | PASS |
| 58 | SpawnLocation | PASS |
| 59 | SpecialMesh | PASS |
| 60 | StarterPlayerService | PASS |
| 61 | Stats | PASS (countersApiKey GUID trap exact) |
| 62 | StudioPluginHost | PASS |
| 63 | StudioTool | PASS |
| 64 | StudioToolMouseCommand | PASS |
| 65 | StudioToolVerb | PASS |
| 66 | Surface | PASS |
| 67 | SurfaceGui | PASS |
| 68 | SurfaceSelection | PASS |
| 69 | Team | PASS |
| 70 | Teams | PASS (UB claim verified in .cpp) |
| 71 | TeleportCallback | PASS |
| 72 | TeleportService | PASS |
| 73 | TerrainRegion | PASS |
| 74 | Test | PASS (#undef check trap exact) |
| 75 | TextBox | PASS |
| 76 | TextButton | PASS |
| 77 | TextLabel | PASS |
| 78 | TextService | PASS (ToTextYAlign `xalign` quirk correctly noted) |
| 79 | TextureContentProvider | PASS |
| 80 | TextureTrail | PASS |
| 81 | TimerService | PASS |
| 82 | Tool | PASS |
| 83 | ToolMouseCommand | PASS |
| 84 | ToolsModel | PASS |
| 85 | ToolsPart | PASS (class-static paint trap exact) |
| 86 | ToolsSurface | PASS |
| 87 | TouchInputService | PASS |
| 88 | TouchTransmitter | PASS |
| 89 | TweenService | PASS |
| 90 | UndoRedo | PASS |
| 91 | UserController | PASS |
| 92 | UserInputService | PASS |
| 93 | Value | PASS |
| 94 | VehicleSeat | PASS |
| 95 | VirtualUser | PASS |
| 96 | Visit | PASS |
| 97 | Workspace | PASS |

## Totals

| Verdict | Count |
|---|---|
| PASS | 92 |
| FIXED | 5 |
| FAIL | 0 |
| **Total** | **97** |

INDEX-N-Z.md: roster complete (97/97 links, exact set match, digit-inclusive sweep clean; PyramidInstance row confirmed present at P section); one duplicate anchor row removed during this review.

## Residual notes (not defects)

- A few docs carry hedged pattern-inference claims (e.g., NotificationService "methods just fire the signals", Smoke `~ChatOption() owns children`) where behavior is out-of-line; each is either explicitly hedged or covered by an UNKNOWN section, consistent with campaign conventions.
- Recon-attributed claims (Workspace deceptive kernel stats, TeleportService thread-shared `url`, TerrainRegion voxel2 material ordering) are correctly labeled "per project recon"/"certified" rather than asserted from headers, and were spot-checked where cheap (.cpp greps) without contradiction.
