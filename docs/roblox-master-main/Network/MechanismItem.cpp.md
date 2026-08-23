# Network/MechanismItem.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 87 lines)

## Purpose

Implements the buffer management and interpolation math for `MechanismItem`/`AssemblyItem` (see MechanismItem.h): assembly append/reuse, consistency check, and position-velocity/motor-angle lerp between two network samples.

## API

```cpp
MechanismItem::~MechanismItem();                       // deletes all buffered AssemblyItems
void MechanismItem::reset(int numElements = 0);        // zeroes metadata; grows buffer to numElements
AssemblyItem& MechanismItem::appendAssembly();          // reuse-or-append slot, returns ref
bool MechanismItem::consistent(const MechanismItem*, const MechanismItem*);
void MechanismItem::lerp(const MechanismItem* before, const MechanismItem* after,
                         MechanismItem* out, float lerpAlpha);
```

Key math: `outA.pv = beforeA.pv.lerp(afterA.pv, lerpAlpha)`; each `CompactCFrame` motor angle lerps translation and axis-angle independently.

## Usage

Called from physics receiver/sender jobs each network tick; `consistent()` is asserted inside `lerp`.

## Gotchas

- `lerp` asserts `before->numAssemblies() == 1` — multi-assembly data must not be passed.
- `appendAssembly` asserts `buffer.size() >= currentElements`; calling it after `reset(n)` with n already appended reuses slots rather than growing.
- `RBXASSERT(before->networkTime < after->networkTime)` in `consistent` — out-of-order samples trip asserts in debug.
