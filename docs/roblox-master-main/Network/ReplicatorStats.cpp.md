# Network/ReplicatorStats.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 164 lines)

## Purpose

Implements `ReplicatorStats`: constructor wiring for every running average (lerp 0.05, smooth 0.01, dataPing 0.25), the `kPacketTypeNames` table mapping PacketType to property-category strings (`category_Data`…`category_Control`, plus "InstanceNew"/"InstanceDelete"/"Ping"/"Events"), linear-scan category→type conversion helpers, and `resetSecurityTimes`.

## API

```cpp
static double lerp = 0.05, lerp_smooth = 0.01;
ReplicatorStats::ReplicatorStats();
void PhysicsPacketDetailedStats::CreateStatsItems(Stats::Item*) const;  // "1) character", "2) cframeOnly"...
const char* kPacketTypeNames[PACKET_TYPE_MAX];
increment/sample helpers; void resetSecurityTimes();
```

## Usage

See header. Buffer health starts optimistic at 1.0.

## Gotchas

- Unknown category strings are silently ignored by the increment/sample helpers.
