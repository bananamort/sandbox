# util/PartMaterial.h

## Purpose
The `RBX::PartMaterial` enum — material families for parts/terrain with hex-coded values grouped by family (plastic 0x01xx, wood 0x02xx, stone/concrete 0x03xx, metal/rust 0x04xx, ground 0x05xx, ice 0x06xx, air 0x07xx, water 0x08xx).

## Declared API
```cpp
enum PartMaterial {
    PLASTIC_MATERIAL = 0x0100, SMOOTH_PLASTIC_MATERIAL = 0x0110, NEON_MATERIAL = 0x0120,
    WOOD_MATERIAL = 0x0200, WOODPLANKS_MATERIAL = 0x0210,
    MARBLE_MATERIAL = 0x0310, SLATE_MATERIAL = 0x0320, CONCRETE_MATERIAL = 0x0330,
    GRANITE_MATERIAL = 0x0340, BRICK_MATERIAL = 0x0350, PEBBLE_MATERIAL = 0x0360,
    COBBLESTONE_MATERIAL = 0x0370, ROCK_MATERIAL = 0x0380, SANDSTONE_MATERIAL = 0x0390,
    BASALT_MATERIAL = 0x0314, CRACKED_LAVA_MATERIAL = 0x0324,   // note: overlap 0x03xx low byte!
    RUST_MATERIAL = 0x0410, DIAMONDPLATE_MATERIAL = 0x0420, ALUMINUM_MATERIAL = 0x0430,
    METAL_MATERIAL = 0x0440,
    GRASS_MATERIAL = 0x0500, SAND_MATERIAL = 0x0510, FABRIC_MATERIAL = 0x0520,
    SNOW_MATERIAL = 0x0530, MUD_MATERIAL = 0x0540, GROUND_MATERIAL = 0x0550,
    ICE_MATERIAL = 0x0600, GLACIER_MATERIAL = 0x0610,
    AIR_MATERIAL = 0x0700,
    WATER_MATERIAL = 0x0800,
    LEGACY_MATERIAL = 0xFFFF   // should not be serialized
};
```

## Gotchas
- Values are NOT contiguous and NOT unique-decade: `BASALT=0x0314` and `CRACKED_LAVA=0x0324` collide with the x1/x2 decade pattern of other stone materials (e.g., MARBLE 0x0310) if you try to derive family from `(v & 0xF0)`; treat the full value as opaque.
- `LEGACY_MATERIAL` is a marker for "old/unspecified" and must not be serialized.
- No zero sentinel: PLASTIC is 0x0100, so zero-initialized variables are invalid material codes.

## UNKNOWN
- Where physical properties per material live (likely PhysicalProperties.cpp or terrain code).
