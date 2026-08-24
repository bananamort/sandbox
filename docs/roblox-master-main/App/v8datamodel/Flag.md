# Flag.cpp

## Purpose

Implements `Flag` ("Flag") — the CTF flag as a Tool subclass with a TeamColor BrickColor property: server-side touch logic returns own-team flags to a stand (neutral players exempt), plus rigid-joint walk to find an attached FlagStand.

## Key types and API

Descriptors:
- `prop_Color("TeamColor", category_Data)` — BrickColor; setter raises UNCONDITIONALLY (no compare). No Security:: arguments.

Constants: `sFlag = "Flag"`; DescribedCreatable<Flag, Tool, sFlag>.

Behavior:
- `onServiceProvider` — on FIRST provider attach under backendProcessing, connects handle's touchedSignal to onEvent_flagTouched; disconnects when provider detaches.
- `onEvent_flagTouched(other)` — server-only; requires touching character w/ Humanoid + Player; neutral → ignore; SAME team touch + flag NOT currently in any stand → `FlagStandService::affixFlagToRandomEmptyStand(this)`.
- `canBePickedUpByPlayer(p)` — false for neutral or same-team.
- `getJoinedStand()` — walks handle primitive's RigidJoint chain looking for a part whose PARENT is a FlagStand ("ASSUME: A part's parent will be the flag").

## Usage / reflection touchpoints

Pairs with [FlagStand](FlagStand.md)/FlagStandService and [Teams](Teams.md) TeamColor matching; Tool pickup machinery in [Tool](Tool.md).

## Gotchas

- setTeamColor raises even when unchanged — spurious Changed events.
- getJoinedStand/getJoinedFlag rely on rigid-joint adjacency only — a flag welded to arbitrary geometry adjacent to a stand can fake attachment.
- Touch hook is connected ONLY when first attached while backendProcessing — flags created client-side never get return-on-touch behavior.
