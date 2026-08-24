# App/humanoid — Review Certification

Independent re-review. Every source (.cpp) was read in full via tool calls; every .md was read in full and each concrete claim checked against source (plus headers under `App/include/humanoid/` where docs cite header-inline facts). STATE_TABLE transition claims were verified by mechanical parsing of the table from HumanoidState.cpp, not by eye.

Coverage: **17 .cpp sources ↔ 17 .md + INDEX.md — exactly 1:1** (6,999 lines total, matching the writer's claim).

## Per-file verdicts

| File | Verdict | Notes |
|---|---|---|
| Balancing.cpp | **FIXED** | All controller mechanics verified (2250/50 defaults, tick throttle, X/Z-only clamp at `i+=2`). Gotcha claimed `balanceRate` goes negative ">400k"; algebra gives negative above ~240k (20 − t/12000 < 0) — corrected. |
| FallingDown.cpp | **PASS** | Dead/FallingDown/Physics bodies, backendProcessing health zeroing, breakJointsOnDeath = hadNeck && hadHealth (Humanoid.h:479), all table transitions confirmed by parse. |
| Flying.cpp | **FIXED** | Empty hooks + setBalanceP(5000) dead tuning CONFIRMED. But doc claimed the dead-tuning caveat "applies to Flying only" — WRONG: Jumping's `Super::onComputeForceImpl()` resolves to Flying's empty stub (Jumping.h typedef), so Balancing PD never runs during JUMPING either. Corrected. |
| Freefall.cpp | **PASS** | kP=5000 with kD untouched (=Balancing default 50) CONFIRMED as task-flagged; commented-out deferred init; friction save/restore; kTurnAccelMax = 20000×legacy-6 regardless of solver (Freefall.h:46); transitions confirmed. |
| GettingUp.cpp | **PASS** | Legacy 5000/300 via gain-passing ctor vs PGS-only override to 2250/50 CONFIRMED as task-flagged; UPRIGHT threshold 0.90; header-inline overrides verified in GettingUp.h. |
| Humanoid.cpp | **FIXED** | testWalkSpeed tripwire CONFIRMED precisely (Humanoid.h:371–382; single call site Humanoid.cpp:1174 in calcDesiredWalkVelocity; shadow-mirroring + [0,1] clamp make legit writes safe). Two fixes: first-person "<0.1 rad go to walkAngleError" wording (they are zeroed first), and StringConverter gotcha extended with the exact-token inversions ("None" fails outright; "OccludeAll"→ENEMY, "NoOcclusion"/"EnemyOcclusion"→ALL, "Poison"→CONFUSION, "Confusion"→POISON — all forced by npos truthiness). |
| HumanoidState.cpp | **FIXED** | Drivers/events/factory/anti-exploit all verified (incl. kCorrectCheckValue=2 and 1e15 sentinel). Two WRONG cells fixed: CLIMBING row listed TOUCHED as a self-loop (it is xx); blanket claim that every non-DEAD state exits on SIT_CMD/PLATFORM_STAND_CMD omitted RAGDOLL (both columns xx for RAGDOLL). |
| Jumping.cpp | **FIXED** | Impulse/reaction/ceiling/filter logic and PGS 0.52 factor all verified. Added MISSING-GOTCHA: no balancing torque during JUMPING because Super::onComputeForceImpl() lands on Flying's empty stub; Purpose/API wording corrected accordingly. |
| MovingNoPhysicsBase.cpp | **PASS** | Engine-type swap, kinematic integration, friction branches, caps (maxLinearMoveForce 143 / ground 500), tickle, half-gravity impulse — all verified. |
| Ragdoll.cpp | **PASS** | dtor touchedHard clearing CONFIRMED load-bearing as task-flagged (Running::onComputeForceImpl returns immediately while touchedHard is set, lines 33–34). 8 s timer, ≤7.0 rest-detection window, TIMER_UP→GETTING_UP, slave-side early ragdoll comment verbatim — verified. |
| Running.cpp | **PASS** | touchedHard short-circuit, ragdollCriteria×6000 gate, computeHitByHighImpactObject handoff, Landed 7500/50 + 0.05 s, Climbing signed/abs — verified; transitions confirmed by parse. |
| RunningBase.cpp | **PASS** | kAltitudeP/D, infinity sentinel (vs header's stale "ignored if 0.0"), solver turn gains 7500/450, hover clamps ±1e7/±1e5, reaction conventions, "omg hax" friction squaring — all verified against source and RunningBase.h. |
| RunningNoPhysics.cpp | **PASS** | Flag-gated ctor signal, fireMovementSignal min-clamp (0.5) + ±5% deadband semantics, transitions — verified. |
| Seated.cpp | **FIXED** | Ctor/dtor bodies and throttle claims verified (six primitives; HumanoidState.h:260 comment). One WRONG fixed: PLATFORM_STAND_CMD sources described as "any non-DEAD/PHYSICS state" — RAGDOLL's column is also xx. |
| StatusInstance.cpp | **PASS** | Name lock, unconditional askSetParent false, askForbidParent exact negation (StatusInstance.h:21), buildJoints privileged creation with propArchivable=false, status signal translation — verified. |
| StrafingNoPhysics.cpp | **PASS** | Tag-only subclass; STRAFE_CMD only from RUNNING_NO_PHYS; running-signal-per-step behavior of base — verified. |
| Swimming.cpp | **FIXED** | Straight-HumanoidState derivation CONFIRMED as task-flagged (#if 0'd turn block, custom pitch PD, full-3D length swim signal). Two fixes: HAS_BUOYANCY entry list wrongly implied JUMPING routes to SWIMMING (its cell is xx); pPitch gotcha corrected (effective values only 500/2000 — the 7500 initializer is always overwritten before use). |

INDEX.md: **PASS** — file list complete, line count accurate, summaries consistent with reviewed content.

## Totals

- Sources: 17/17 enumerated and read in full; .md coverage exactly 1:1.
- **PASS: 10 · FIXED: 7 · FAIL: 0** (plus INDEX.md PASS).
- Task-flagged items: all eight verified and documented — Freefall kP=5000/kD-inherits-50 ✓, Flying dead tuning ✓ (extended to Jumping), GettingUp PGS-only 2250/50 vs legacy 5000/300 ✓, Swimming straight HumanoidState derivation ✓, testWalkSpeed tripwire at Humanoid.h:371–382 / Humanoid.cpp:1174 ✓, StringConverters npos-truthiness ✓ (with inversions added), Balancing X/Z-only clamp ✓ (`for i=0; i<3; i+=2`), Ragdoll dtor touchedHard load-bearing ✓.
- Residual risk: none known. Docs-only changes; roblox-sandbox untouched.
