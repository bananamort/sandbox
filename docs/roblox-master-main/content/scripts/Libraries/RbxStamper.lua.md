# RbxStamper.lua

Source: `roblox-sandbox/content/scripts/Libraries/RbxStamper.lua` (2207 lines; LoadLibrary("RbxStamper") implementation)

## Purpose

Client library behind the classic "stamper" building tools (PBS / build-mode stamping): fetches a model asset with InsertService, then drives a translucent "ghost" copy of it around the world grid under the mouse and stamps clones into the place — either as regular parts/models welded to the target surface, or as cells of the classic 4×4×4 `Terrain` (megacluster) grid, including drag-out line/box/volume "high-scalability" multi-cell stamps.

## API (module table `t`)

- `t.GetStampModel(assetId, terrainShape, useAssetVersionId)` → `(model, nil)` or `(nil, errorString)`.
  - Loads via `InsertService:LoadAsset(assetId)` (or `LoadAssetVersion` when `useAssetVersionId`) inside a coroutine with an 8-second wall-clock bail-out ("Load Time Fail"); other failure strings: "No Asset", "Negative Asset", "Load Asset Fail", "Load Type Fail", "Empty Model Fail".
  - Unlocks all returned BaseParts (`Locked = false`), hoists any `Team` children into the Teams service, and replaces every existing `Sky` in Lighting (early bare `return` in that case).
  - Tags the root with `RobloxModel` + `RobloxStamper` BoolValues for later origin identification by `isBlocker`.
  - If `terrainShape` is given and root is named "MegaClusterCube": shape 6 just adds an `AutoWedge` BoolValue tag; otherwise rebuilds the part as a fake-terrain piece — `WedgePart`, `CornerWedgePart` (+ inverse-corner mesh asset 66832495 for type 3), or plain Part, colored via a hardcoded terrain-material→BrickColor table, carrying material/type/orientation in a `ClusterMaterial` Vector3Value tag.
- `t.CanEditRegion(partOrModel, EditRegion)` → `(canEdit, false)`; true iff the model's world bounding box fits inside the `EditRegion` part's box. Second return value is always false.
- `t.SetupStamperDragger(modelToStamp, Mouse [, StampInModel, AllowedStampRegion, StampFailedFunc])` → `control` table. Validates args with `error()`; `StampInModel` must be a Model paired with an `AllowedStampRegion` part. Returns a dragger controller:
  - `control.Stamped` — BoolValue whose `.Value` flips true whenever a stamp lands (checked once per mouse-up).
  - `control.Paused` — boolean mirror of Pause/Resume state.
  - `control.LoadNewModel(newStampModel)` / `control.ReloadModel()` — swap the stamped asset (pause → re-clone → resume).
  - `control.Pause()` / `control.Resume()` — disconnect mouse connections, remove ghost; resume re-prepares.
  - `control.ResetRotation()` — stub; body commented out (documented as incomplete by [HotThoth] note).
  - `control.Destroy()` — disconnects everything, destroys adornments, ghost model, Dragger and Stamped BoolValue.
- `t.Help(funcNameOrFunc)` — self-documentation strings for GetStampModel and SetupStamperDragger.
- Internal machinery (all locals): `findConfigAtMouseTarget` does the 4-stud-grid snap math (surface-to-surface reference-point alignment, assumes axis-aligned box faces — explicitly will not work on wedges/angled faces); `DoStamperMouseMove/MouseDown/MouseUp` implement ghost positioning, JointsService join preview (`SetJoinAfterMoveInstance`/`ShowPermissibleJoints`), collision blocking with red-box flash, character pop-up push, and the final commit; `ResolveMegaClusterStamp` iterates up to 3 accumulated line directions ('C' key adds a dimension, 'R' rotates 90°) writing `Terrain:SetCell`/`SetWaterCell` + optional `AutowedgeCells`; `prepareModel` clones the asset, disables Scripts, saves/restores Transparency/Material/CanCollide/Anchored/Archivable/surface types, ghosts parts at 0.7 transparency with a fade-in, and disables seats by planting fake `SeatWeld` Welds; stamped Scripts are re-enabled by reparenting a clone of each.

## Usage

Loaded externally via `LoadLibrary("RbxStamper")`. There are **no consumers inside this content tree** — the classic stamper tools that call it lived as website-hosted Tool assets (their scripts run on equip and pass `Tool.Equipped`'s Mouse). Within this tree only RbxGui/RbxUtility are LoadLibrary'd. The `RobloxModel`/`RobloxStamper` tags it writes are what `isBlocker` (and sibling PBS code) uses to distinguish stamped builds from natural parts.

## Gotchas

- Real bug (line ~886): `if not stampData.CurrentParts.Name == "MegaClusterCube"` parses as `(not name) == string` — always false — so the intended early-return never fires and non-mega-cluster parts fall through to being treated as the mega cube in `DoHighScalabilityRegionSelect`.
- Real bug (line ~1262): `flashRedBox`'s delayed callback ends with `stampData.ErrorBox.Parent = Tool` where `Tool` is an undefined global (nil) — silently unparents the error box instead of restoring its intended parent.
- Dead code (lines ~1078–1081): collision branch assigns `stampClusterMaterial = clusterMat` where `clusterMat` doesn't exist yet in that scope — a no-op; the intended material restore never happens.
- Latent crash: `autoAlignToFace` returns the BoolValue's *boolean*, but `DoStamperMouseMove` adds it arithmetically (`numRotations = ... + autoAlignToFace(...)`) for models flagged `AutoAlignToFace` on non-top/bottom surfaces — arithmetic on a boolean errors if such a model hits those branches.
- Undefined-global reads that silently default: `createJoints` (line ~1903, so `CreateJoinAfterMoveJoints` always runs) and `ghostRemovalScript` (line ~1951, so ghost-cleanup-script handling never happens); `cluster` at line ~446 is written as an implicit global.
- Many assignments leak globals because `local` was omitted: `justify/two/actualBox/containingGridBox/adjustment` (getBoundingBox2), `vec1/vec2` (getBoundingBoxInWorldCoordinates), `insertRefPointInInsert` (findConfigAtMouseTarget), `planeLoc/hit` (GetTerrainForMouse), `configFound/targetCFrame/targetSurface`, `tempCFrame`, `playerIdTag/playerNameTag/tempPlayerValue`, `canStamp/checkHighScalabilityStamp`, `clone/parts` (resumeStamper).
- Top-level helpers `waitForChild`, `PlaneIntersection`, `GetTerrainForMouse` are declared without `local`, i.e. they become game globals; `waitForChild` is never used in-file.
- `t.GetStampModel` returns nothing at all (bare `return`) after installing a Sky — callers must tolerate a single-nil return there.
- The 8-second load timeout leaves the loader coroutine running; a late completion can still assign `root` after GetStampModel already failed out.
- `makeSurfaceUnjoinable` is an empty TODO stub; `control.ResetRotation` likewise does nothing.
- Grid assumption: insertion math only works for models whose extents/parts align to the 4-stud grid and axis-aligned faces (explicit "Critical Assumption" comment); wedge targets misplace stamps.
