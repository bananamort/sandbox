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
- PENDING SUBDIRECTORIES (not yet documented): `solver/` (10 headers), `tool/` (29), `util/` (~138 incl. .inl), `v8datamodel/` (~290), `v8kernel/` (20), `v8world/` (~90), `voxel/` (17 incl. .inl), `voxel2/` (6).

## Notes

- Implementations for many headers are certified under sibling doc roots (`App/script/`, `Base/`, `WindowsClient/`, `App/Lua-5.1.4/`) — cross-linked from the per-header docs rather than re-derived.
- There is no `rbx/` subdirectory under App/include in this source drop; "rbx core types" live under `rbx/` at other include roots (e.g. Base) and `util/`.
