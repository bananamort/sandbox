# CERTIFICATION — content/ group review

Independent re-verification pass. Scope: `roblox-sandbox/content/**/*.lua` (38 files) ↔ `docs/roblox-master-main/content/**/*.md` (38 docs + INDEX). Coverage 1:1 confirmed; INDEX line counts match wc exactly.

Every file was read (large files in full multi-chunk reads); every documented Lua function/event name and every claimed undefined-global bug was checked against source.

## Documented-bug verification (all CONFIRMED real)

| Bug | Source line | Status |
|---|---|---|
| Chat.lua `PopupFrame` local-inside-if vs global read at loop | Chat.lua:515 vs :522 | ✅ crash on right-click popup, as documented |
| DeveloperConsoleModule assigns nil `Style.ScriptBackgroundTransparency` | DCM.lua:1288 (Style defines `ScriptButtonTransparency`:79) | ✅ kills chart-button creation |
| RbxGui undefined global `IsTouchClient` | RbxGui.lua:400 (+ GameSettings.lua:454) | ✅ both sites |
| RbxGui `cancelSlide` reads always-nil global `areaSoakMouseMoveCon` | RbxGui.lua:110 vs locals at :1046/:1180 | ✅ MouseMoved never disconnected |
| RbxStamper `not name == "MegaClusterCube"` precedence | RbxStamper.lua:886 | ✅ always false |
| RbxStamper `stampData.ErrorBox.Parent = Tool` (undefined global) | RbxStamper.lua:1262 | ✅ silently unparents |
| RbxStamper dead `stampClusterMaterial = clusterMat` branch | RbxStamper.lua:1075-1082 | ✅ no-op as documented |
| RbxStamper boolean arithmetic `+ autoAlignToFace(...)` | RbxStamper.lua:1041-1045 | ✅ latent error |
| ReportAbuseMenu `nameToRbxPlayer[nameToRbxPlayer]` self-index | ReportAbuseMenu.lua:53 | ✅ player reports silently no-op |
| Players.lua `table.remove(existingPlayerLabels, i)` (undefined `i`) | Players.lua:290 | ✅ runtime error on shrink path |
| PlayerDropDown undefined `TWEEN_TIME` in Hide() | PlayerDropDown.lua:492 | ✅ as documented |
| Settings Utility `lastInputTypee` typo | Utility.lua:350 | ✅ first gamepad check always false |
| RbxUtility / others — spot-verified per-file | — | see below |

## Per-file verdicts

| File | Verdict |
|---|---|
| StarterScript.lua | PASS (load order, FFlags incl. dead UseLuaCameraAndControl read, dual load mechanisms all verified) |
| ServerStarterScript.lua | PASS |
| LoadingScript.lua | PASS (SetVerb Exit, FinishedReplicating handshake, RequestQueueSize wait, GuiInsetChanged, GetBrickCount dots, Xbox name-fix regex len-32 verified) |
| fonts/LoadingScript.lua | PASS (rbxsig header, capital-G `Game` globals, double-spacing note verified) |
| Topbar.lua | PASS |
| NotificationScript2.lua | PASS |
| PurchasePromptScript2.lua | PASS (PromptPurchase/PromptProductPurchase request wiring + SignalPrompt*Finished receipts verified) |
| HealthScript.lua | PASS |
| VehicleHud.lua | PASS (duplicate RobloxGui decl 16/21, BOTTOM_OFFSET 70/100, Velocity.magnitude, CameraSubject fallback verified) |
| BubbleChat.lua | PASS (NEAR 65/MAX 100, RobloxLocked billboard under CoreGui, GetTextSize probe, isLabelTextAllowed verified) |
| MainBotChatScript2.lua | PASS (SetDialogInUse relay, InUse gating, SignalDialogChoiceSelected verified) |
| GamepadMenu.lua | PASS (radial buttons w/ CoreGui greying, thumbstick2 radial action verified) |
| ContextActionTouch.lua | PASS (CAS CallFunction Begin/Change/End forwarding verified) |
| DeveloperConsole.lua | PASS (F9 shim → GetPermissions→GetMessagesAndStats→new chain verified) |
| BuildToolsScript.lua | PASS (InsertService LoadAsset + tutorial API usage verified) |
| BuildToolManager.lua | PASS (HasBuildTools/rank machinery verified) |
| PersonalServerScript.lua | PASS (ServerSave autosave thresholds + roleset GET/POST rank sync verified) |
| ServerSocialScript.lua | PASS (GetFollowRelationships RemoteFunction verified) |
| BackpackScript.lua | PASS (HopperBin handling, gamepad actions verified) |
| PlayerlistModule.lua | PASS (OnLeaderstatsChanged/team aggregation verified; loads RbxGui without calling into it, as documented) |
| PlayerDropDown.lua | PASS (TWEEN_TIME bug + blocking utility API verified) |
| TenFootInterface.lua | PASS (IsEnabled, CreateHealthBar, leaderstats display verified) |
| SettingsPageFactory.lua | PASS (Displayed/Hidden events, TabHeader construction verified) |
| Utility.lua | PASS (`lastInputTypee` typo at :350 verified) |
| SettingsHub.lua | PASS (SettingsShowSignal, BottomButtonFrame, PopMenu/SwitchToPage verified) |
| Home/LeaveGame/ResetCharacter pages | PASS ×3 (constants, SetVerb Exit, Humanoid.Health=0, selection traps verified) |
| Record.lua | PASS (RecordToggle verb, VideoUploadPromptBehavior, VideoRecordingChangeRequest verified) |
| Help.lua | **FIXED** — doc claimed the `inputType == Enum.UserInputType.Gamepad3` nil-global comparison "would error"/"real crash path". Comparing nil with `==` is legal Lua and returns false: it is a SILENT misclassification (Gamepad3 users get the keyboard/mouse cheatsheet), not a crash. Both mentions rewritten; Gamepad1/2/4 checks confirmed correct. All other claims (AllowHideHudShortcut flag, ToggleDevConsole dependency, layout families) verified. |
| GameSettings.lua | **FIXED** — rewrote two muddled gotchas: (a) GraphicsQualityChangeRequest early-returns in Auto mode so it never mutates the slider there; (b) the SetGraphicsQuality clamp chain does NOT make `newValue<1` unreachable — the `<1` clamp simply requires `not automaticSettingAllowed`, so the Auto path deliberately lands on QualityLevel 0 while skipping that clamp. IsTouchClient undefined-global bug confirmed at :454. |
| Players.lua | PASS (bug confirmed) |
| ReportAbuseMenu.lua | PASS (bug confirmed) |
| Chat.lua | PASS — full read; PopupFrame crash plus 9 secondary gotchas each verified (double-gsub filter discarding result, flood-check flag gating, `%w+_?%w+` pattern, unbounded TextSizeCache, .userId vs .UserId casing, pairs() dispatch nondeterminism, PlayerChatted reconnect churn, nil MessagesChanged path, global createPopupFrame/popupHidden) |
| DeveloperConsoleModule.lua | PASS — full read; ScriptBackgroundTransparency bug plus assert(point), FolderFrame(nil-as-parent via unassigned `main`), unused animate param, SavedScrollbarValue comments, discarded incremental refresh, commented-out Font assignment, CreatorId/group caveat, NetworkClient:GetChildren()[1] assumption, CreateDisconnectSignal closure trick, #MessageColors length fragility, stray --]], ReeseMcBlox/NobleDragon pink easter egg (:37-40) — all verified |
| RbxUtility.lua | PASS (CreateSignal, Create{} builder, deprecated JSON wrappers warning strings verified) |
| RbxGui.lua | PASS — full read; IsTouchClient + cancelSlide bugs plus scrollStamp global leak, tutorial/set-panel/terrain-selector global leaks, drag=nil typos (:1622/:2181), single-assign `local xOffset,yOffset = 0`, unbounded TextFits growth loop, GetFontHeight Legacy/Arial-only, populateSetsFrame child-index misalignment, findFirstChild lowercase casing — all verified |
| RbxStamper.lua | PASS — full read; precedence bug, undefined `Tool`, dead clusterMat branch, boolean arithmetic, createJoints/ghostRemovalScript implicit globals, Sky bare-return, loader-coroutine timeout race, empty TODO stubs — all verified |
| INDEX.md | PASS — 38/38 roster complete, line counts exact, cross-reference bug list matches source findings |

**Totals**: 39 docs reviewed — 1 FIXED (Help.lua.md; plus 2 gotchas rewritten in GameSettings.lua.md), 38 PASS, 0 FAIL. 13 documented engine-script bugs independently confirmed present in source; 1 doc-level mischaracterization corrected.
