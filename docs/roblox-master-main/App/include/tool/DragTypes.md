# App/include/tool/DragTypes.h

## Purpose

Enums shared by the drag/drop tool family, in `namespace RBX::DRAG`: how joining behaves on drop, whether the move ends with a drop, manual-joint strength, and grid snapping mode.

## Declared API

- `typedef enum {NO_UNJOIN_NO_JOIN, UNJOIN_JOIN, UNJOIN_NO_JOIN} JoinType;`
- `typedef enum {MOVE_DROP, MOVE_NO_DROP} MoveType;`
- `typedef enum {WEAK_MANUAL_JOINT, STRONG_MANUAL_JOINT, INFINITE_MANUAL_JOINT} ManualJointType;`
- `typedef enum {ONE_STUD, QUARTER_STUD, OFF} DraggerGridMode;`

## Gotchas

- C-style typedef enums — unscoped, so `UNJOIN_JOIN`, `MOVE_DROP` etc. leak into `RBX::DRAG` (and wherever a using-directive pulls it in); no prefix discipline beyond naming.
- No serialization or reflection; these are purely internal tool-state knobs consumed by Dragger/DragTool implementations ([Dragger.md](Dragger.md), [DragTool.md](DragTool.md)).
