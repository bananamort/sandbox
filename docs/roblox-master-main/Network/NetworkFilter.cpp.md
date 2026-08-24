# Network/NetworkFilter.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 421 lines)

## Purpose

Implements both filters. `NetworkFilter` (basic): rejects property changes/new/delete/parent inside StarterGuiService, StarterPackService, StarterPlayerService, Teams; accepts `NetworkIsSleeping`, own-Player `SimulationRadius`, and legal Humanoid props of the target player's character; parent rules additionally allow a fresh Player only into Players and honor parent locks; events unfiltered. `StrictNetworkFilter`: whitelist-only for scriptable descriptors, accepts all non-scriptable ones; new instances accepted only for local Player, StarterGear, and Welds under the player character; deletes only within the player's character/player subtree; terrain always rejected; reparenting restricted to Tool/Weld/Accoutrement/Seat/SkateboardPlatform moving to/from the player or their character (`RightGrip` weld special-cased to Reject).

## API

```cpp
EnumDesc<FilterResult> {"Rejected","Accepted"} + StringConverter registered here.
template<class T, FilterResult R> static bool filterInside(Instance*, FilterResult&); // ancestor walk
static bool isOrUnderAncestor(instance, newParent, ancestor);
FilterResult StrictNetworkFilter::{filterChangedProperty|filterParent|filterEvent|filterNew|filterDelete|filterTerrainCellChange}(...);
void StrictNetworkFilter::onChildRemoved(removed, oldParent);   // sets instanceBeingRemovedFromLocalPlayer
```

## Usage

Called from ServerReplicator filter chain (strict → basic → Lua callbacks) and ClientReplicator send-side checks.

## Gotchas

- `filterParent` consumes-and-resets `instanceBeingRemovedFromLocalPlayer` after one use — the flag must be set by `onChildRemoved` immediately before.
- A Weld reparent is rejected if named anything but "RightGrip" while Part0 belongs to the player's character (tool-grip protection).
- The DE3665 NetworkOwner rejection block is `#if 0`'d out.
