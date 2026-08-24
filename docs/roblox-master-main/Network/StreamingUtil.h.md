# Network/StreamingUtil.h

**Module**: Network (root) · **Type**: header (.h, 84 lines)

## Purpose

Declares the RakNet `BitStream` `operator<<` overload family for every RBX wire type (chars/ints/floats, bool, strings, BinaryString, ContentId, Guid::Scope, StreamRegion::Id, Vector2/3(int16), Color3, CoordinateFrame, Velocity, SystemAddress, BrickColor, UDim/UDim2, RbxRay, Faces/Axes, Number/Color sequences+keypoints, NumberRange, Rect2D, PhysicalProperties). These are the primitive serializers underlying property replication.

## API

```cpp
template<class T> RakNet::BitStream& operator>>(RakNet::BitStream& stream, T& value);
RakNet::BitStream& operator<<(RakNet::BitStream&, <each type above>);
```

## Usage

Included by Replicator/physics code; implementations live in a corresponding .cpp outside this header (UNKNOWN location — likely Util or RakNet glue).

## Gotchas

- The generic `operator>>` template plus specific `operator<<` set is asymmetric: reads rely on RakNet built-ins for PODs and RBX overloads elsewhere.
