# App/include/humanoid Documentation Certification — Independent Review

**Reviewer**: independent review subagent (ox-alpha).
**Scope**: all sources in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/humanoid/` vs docs in `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/humanoid/`.

## Method

- Every source header read **in full via tool calls**, doc immediately after; every concrete claim checked (signatures, enum values/orders, inline constants, verbatim comments).
- Hierarchy and behavioral claims machine-checked: full `grep 'class.*: public' App/include/humanoid/*.h` state-graph reconstruction; `setBalanceP/setBalanceD` caller harvest across all .cpp; Humanoid.cpp location (`App/humanoid/`, NOT v8datamodel); StateType/EventType enumerator counts (comment tokens excluded).
- Severity tags WRONG / UNSUPPORTED / MISSING-GOTCHA / STYLE; mechanically-certain fixes applied in docs only.

## Coverage arithmetic

- Sources: **17 `.h` files**. Docs: **17 module `.md` + `INDEX.md` = 18**. 1:1 confirmed. INDEX roster complete.

## Per-file certification

| # | Source | Doc | Verdict | Notes |
|---|--------|-----|---------|-------|
| 1 | Balancing.h | Balancing.md | FIXED (WRONG ×2) | (a) Doc claimed Balancing bases "running, jumping, swimming, flying" — Swimming derives directly from HumanoidState, not Balancing (grep-verified hierarchy). Rewrote with exact derived set (RunningBase→Running/RunningSlave/Landed/Climbing; Flying→Jumping; Freefall; GettingUp). (b) Usage note claimed gain-tuning by "GettingUp, Flying, Jumping, Swimming" — actual setter callers are Freefall(5000), Flying(5000), GettingUp(2250/50); Jumping inherits via Flying. Corrected with grep evidence. kP/kD comments + maxTorqueComponent 4000.0f verified. |
| 2 | FallingDown.h | FallingDown.md | PASS | Dead/FallingDown/Physics override sets exact ("pure simulation!" comment). |
| 3 | Flying.h | Flying.md | PASS | Verbatim header comment; onSimulatorStepImpl+onComputeForceImpl overrides; auto-jump off. |
| 4 | Freefall.h | Freefall.md | PASS | initialized-hack/friction-zero comments verbatim; ladderCheckRate 0; kTurnAccelMax = 20000·kTurnSpeed. |
| 5 | GettingUp.h | GettingUp.md | PASS | Protected inline override set exact. |
| 6 | Humanoid.h | Humanoid.md | FIXED (WRONG + STYLE) | (a) Usage note pointed to "App/v8datamodel docs where Humanoid.cpp lives" — false location: implementation is App/humanoid/Humanoid.cpp and has no docs yet; corrected. (b) "getName/setNameOcclusion" garbled pair → getNameOcclusion/setNameOcclusion. All 621 lines otherwise verified: reflected-data members/comments, AppendageType order, testWalkSpeed tripwire (>8 shadow violations or \|percent\|>1.01 → hackFlag11/HATE_SPEEDHACK), getCamearaOffset [sic], defaultCharacterCorner (2.5,2.5,2.5), autoTurnSpeed 8.0f. |
| 7 | HumanoidState.h | HumanoidState.md | FIXED (WRONG counts) | Purpose said "17 states incl. sentinel" and "28 simulation events". Re-derived: StateType = 17 states + NUM_STATE_TYPES + trailing xx (19 enumerators); EventType = 26 events + NUM_EVENT_TYPES (27). Both corrected. Everything else verified: tuning constants (0.5f/2.45f/(1000,10000,1000)/(-1000,0,-1000)/(10000,1000,10000)/all−10000/0.125f/143.0/500.0), floor-touch sentinel asserts (1e15³), getComputeEventBaseAddress _WIN32-only member-pointer trick incl. "horrible conversion" quote, kCorrectCheckValue=2. |
| 8 | Jumping.h | Jumping.md | PASS | Ceiling helpers, three collision-off overrides, filterResult [sic] comment, kJumpP=500/kJumpVelocityGrid=50. |
| 9 | MovingNoPhysicsBase.h | MovingNoPhysicsBase.md | PASS | Base getStateType→RUNNING_NO_PHYS gotcha mechanically true; headTorsoShouldCollide off. |
| 10 | Ragdoll.h | Ragdoll.md | PASS | Direct HumanoidState subclass (not Balancing); stale Flying comment correctly flagged. |
| 11 | Running.h | Running.md | PASS | Four states; RunningSlave comment verbatim; Climbing delegating ctor + ladderCheckRate 0. |
| 12 | RunningBase.h | RunningBase.md | FIXED (minor) | Purpose implied only Running derives from it; added Landed/Climbing (hierarchy-verified). Constants 7500/450/375, floor-relative velocity comments verbatim. |
| 13 | RunningNoPhysics.h | RunningNoPhysics.md | PASS | Tag-only class confirmed. |
| 14 | Seated.h | Seated.md | PASS | Seated+PlatformStanding identical override sets, non-trivial dtors. |
| 15 | StatusInstance.h | StatusInstance.md | PASS | INTERNAL descriptor; askForbidParent = ¬askSetParent inline. |
| 16 | StrafingNoPhysics.h | StrafingNoPhysics.md | PASS | Tag-only class confirmed. |
| 17 | Swimming.h | Swimming.md | PASS | kTurnSpeed 6.0 vs autoTurnSpeed 8.0 comment verbatim; direct HumanoidState base correctly stated. |
| 18 | INDEX.md | — | FIXED (WRONG) | Related-section claimed implementations live at "App/v8datamodel/Humanoid*.cpp *(pending)*" — wrong directory and wrong pending status; corrected to App/humanoid/*.cpp with no-docs-yet note. |

## Totals

- **PASS**: 12
- **FIXED**: 6 files (Balancing ×2 WRONG, Humanoid WRONG+STYLE, HumanoidState ×2 WRONG counts, RunningBase minor omission, INDEX WRONG)
- **FAIL**: 0
