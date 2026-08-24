# HealthScript.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/HealthScript.lua` (316 lines)

## Purpose

Legacy health-bar GUI (Ben Tkacheff, 2014): bottom-center capped green/red health bar with damage flash overlay. Runs ONLY if the engine core health bar is enabled (`GetUseCoreScriptHealthBar`); can be disabled per-game via `StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health,false)`.

## API / Behavior

- Early-outs: busy-waits for game/Players service; returns immediately unless `GetUseCoreScriptHealthBar()` succeeds AND is true (this script is the FALLBACK when the C++ core bar isn't used... actually inverse: it bails when that getter says the CORE bar handles it — either way gated by pcall).
- Globals: `CreateGui` (HurtOverlay ImageLabel 20×20 offscreen + HealthFrame with 3-piece background images and clipping HealthBar holding green-tinted center/cap ImageLabels; re-parents existing gui), `UpdateGui(health)` (NaN-guarded percent; color: >25% green else red; yellow when NaN; width clamp; narrow-bar visibility ladder <7px / <15px; hurt overlay when single delta ≥ MaxHealth×5%), `AnimateHurtOverlay` (cancel-then-flash tween: linear 0s in, Quad 10s out — note 10 SECOND fade), `humanoidDied`, `disconnectPlayerConnections`, `newPlayerCharacter`, `startGui` (binds CharacterAdded, WaitForChild Humanoid, checks GetCoreGuiEnabled(Health), binds HealthChanged/Died).
- Tail: creates root Frame "HealthGui" (unparented until CreateGui); subscribes StarterGui.CoreGuiChangedSignal for Health/All toggles (parent nil ↔ startGui); initial state from GetCoreGuiEnabled.
- Textures: local Health-BKG pngs + web asset id=34854607 overlay (Preloaded).

## Usage

StarterScript loads it only when NOT UseInGameTopBar — it's the pre-topbar HUD generation.

## Gotchas
- Hurt-overlay hide tween runs 10 s — a fresh hit inside that window restarts via 0-duration cancel tween.
- UpdateGui indexes `healthBar.healthBarCenter` directly (dot syntax) — throws if children were renamed/destroyed mid-frame.
- guiEnabled starts false even when core-gui enabled; only set true on the initial branch before startGui().
