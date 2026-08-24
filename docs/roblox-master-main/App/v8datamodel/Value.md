# Value.cpp

## Purpose

Implements ALL the legacy Value objects in one TU: IntValue, BoolValue, NumberValue (class DoubleValue), StringValue, BinaryStringValue, Vector3Value, RayValue, CFrameValue, Color3Value, BrickColorValue, ObjectValue, IntConstrainedValue, DoubleConstrainedValue. Each is a DescribedCreatable holding one "Value" property + "Changed" event (+ deprecated lowercase "changed" alias). registerValueClasses() forces descriptor registration for all twelve.

## Key types and API

Common shape per class (category_Data):
- `desc_Value("Value")` — PropDescriptor or BoundProp of the value type; BinaryStringValue's cap **STREAMING**; others default.
- `desc_ValueChanged("Changed(value)")` — EventDesc; deprecated twin "changed" on all EXCEPT BinaryStringValue (no Changed event at all!).
Defaults: int 0, bool false, double 0.0, string "", BinaryString "", Vector3 zero, Ray zero-dir (degenerate), CFrame identity-ish translation-only, Color3 black, BrickColor **brick_194** (Medium stone grey), IntConstrained 0..10 default 0, DoubleConstrained 0.0..1.0.

Constrained variants add MinValue/MaxValue BoundProps and THREE value descriptors: "Value" (cap UI), deprecated "ConstrainedValue" (LEGACY_SCRIPTING), and raw lowercase "value" (STREAMING, setValueRaw).

ObjectValue: RefPropDescriptor Instance + manual get/set with an acknowledged bald-pointer TODO ("In theory… could be collected"); set raises property + fires Changed.

Free: `valueCount` global int (declared here, UNKNOWN consumers); registerValueClasses() create-and-discard each type to trigger registration.

## Usage / reflection touchpoints

The entire classic data-storage Instance family. Pairs with Remote.md/Bindables for cross-script messaging; serialization caps matter for replication (BinaryStringValue STREAMING only).

## Gotchas

- BinaryStringValue has NO Changed event — scripts must poll or use property-changed signals elsewhere.
- RayValue default has ZERO direction vector (invalid ray) not unit-z.
- ConstrainedValue classes expose three names for one datum ("Value"/"ConstrainedValue"/"value") with different caps — replication can observe UI writes but raw streaming path bypasses clamping semantics (UNKNOWN header-side).
