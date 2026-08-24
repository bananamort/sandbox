# App/include — Index

Header tree of the Roblox engine's shared libraries: reflection type system, Lua integration, scripting subsystem, humanoid character control, XML serialization, math/util types, tools, physics solver/world/kernel, datamodel classes, terrain voxels. One .md per header under this directory, mirrored layout, plus per-subdirectory INDEX files.

## Completion status

- [gui/](gui/INDEX.md) — COMPLETE (10/10).
- [humanoid/](humanoid/INDEX.md) — COMPLETE (18/18).
- [lua/](lua/INDEX.md) — COMPLETE (13/13).
- [reflection/](reflection/INDEX.md) — COMPLETE (11/11).
- [script/](script/INDEX.md) — COMPLETE (21/21).
- [v8tree/](v8tree/INDEX.md) — COMPLETE (6/6, from earlier pass).
- [v8xml/](v8xml/INDEX.md) — COMPLETE (8/8).
- stdafx.md — complete.
- Root-level headers previously done: [util/Http.md](util/Http.md), [util/ProtectedString.md](util/ProtectedString.md), security/*.md ×4.
- [solver/](solver/INDEX.md) — COMPLETE (10/10).
- [tool/](tool/INDEX.md) — COMPLETE (30/30).
- [v8kernel/](v8kernel/INDEX.md) — COMPLETE (19/19).
- [voxel/](voxel/INDEX.md) — COMPLETE (11/11 .h; 6 .inl folded into parents: AreaCopy←1, ChunkMap←1, Region←3, Water←1).
- [voxel2/](voxel2/INDEX.md) — COMPLETE (6/6).
- [v8world/](v8world/INDEX.md) — COMPLETE (89/89 .h; SpatialHashMultiRes.inl folded into SpatialHashMultiRes.md per orchestrator ruling, noted in roster).
- PENDING SUBDIRECTORIES (not yet documented): `util/` (~136 .h + Math.inl/Quaternion.inl; Http+ProtectedString already done above), `v8datamodel/` (~290).

## Notes

- Implementations for many headers are certified under sibling doc roots (`App/script/`, `Base/`, `WindowsClient/`, `App/Lua-5.1.4/`) — cross-linked from the per-header docs rather than re-derived.
- There is no `rbx/` subdirectory under App/include in this source drop; "rbx core types" live under `rbx/` at other include roots (e.g. Base) and `util/`.
