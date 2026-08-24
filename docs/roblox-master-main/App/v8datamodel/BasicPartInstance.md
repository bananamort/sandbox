# BasicPartInstance.cpp

## Purpose

Implements TWO part classes: `FormFactorPart` ("FormFactorPart") — the FormFactor enum owner with its three-way legacy property split — and `BasicPartInstance` ("Part" via `sBasicPart`) — the legacy Shape (Block/Cylinder/Ball) owner that maps to render geometry. Together they form the layer between PartInstance and concrete parts.

## Key types and API

FormFactorPart descriptors (category "Part " via `category_BasicPart`):
- `prop_formFactorUi("FormFactor", LEGACY_SCRIPTING)` and `prop_FormFactorLegacy("formFactor", LEGACY_SCRIPTING)` — both EnumPropDescriptor to `setFormFactorUi`.
- `prop_FormFactorData("formFactorRaw", STREAMING)` — raw XML setter `setFormFactorXml`.
- Source comment explains the trio: "Unfortunately, we have 3 FormFactor properties… For a while 'FormFactor' was the STREAMING version and 'formFactor' was the scriptable version."

BasicPartInstance descriptors:
- `prop_shapXml("shap", LEGACY)` — write-only typo'd alias "Used to prepare for TA14264".
- `BasicPartInstance::prop_shapeXml("shape", STREAMING)` — get/set legacy type.
- `prop_shapeUi("Shape", UI)` — script-facing.

Flags: `DYNAMIC_FASTFLAGVARIABLE(SpheresAllowedCustom, false)`, declared `DYNAMIC_FASTFLAG(FormFactorDeprecated)` (consumed here). Constants: `sFormFactorPart`, `sBasicPart = "Part"`. No Security:: arguments.

Behavior:
- `readProperty(XmlElement*)` — redirects legacy file tag "FormFactor" into `prop_FormFactorData.readValue` (raw XML set path).
- `setFormFactorUi` — `validateFormFactor` then deprecation WARNING ("FormFactor is deprecated. You should no longer use this property."), destroyJoints → set → non-CUSTOM snaps Y size up to integer ≥1 → join().
- `setLegacyPartTypeXml` — remaps Primitive geometry (BLOCK/CYLINDER/BALL); unless FormFactorDeprecated, forces SYMETRIC form factor for non-3D shapes; raises shape props + render dirty.
- `setLegacyPartTypeUi` — destroy joints, set type, uniformize size for balls/cylinders (`hasThreeDimensionalSize()` is literally `legacyPartType != BALL_LEGACY_PART`), safeMove, rejoin.
- `getPartType` — LegacyPartType → PartType switch (default asserts BLOCK_PART).

## Usage / reflection touchpoints

Base of [PartInstance](PartInstance.md)'s class hierarchy; geometry lands in V8World primitives ([Base](../../Base/)).

## Gotchas

- THREE registered FormFactor names with different persistence semantics; writing "FormFactor"/"formFactor" from scripts hits the deprecated warning + joint-rebuild path every change.
- hasThreeDimensionalSize only special-cases BALL — cylinders DO have 3D size but still get size-uniformized by the Ui setter.
- validateFormFactor coerces non-CUSTOM to SYMETRIC for ball parts unless SpheresAllowedCustom allows CUSTOM spheres.
