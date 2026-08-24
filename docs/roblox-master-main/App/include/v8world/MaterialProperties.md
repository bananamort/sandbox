# App/include/v8world/MaterialProperties.h

## Purpose

Static policy class computing how material properties merge at contacts: friction/elasticity/density defaults per `PartMaterial`, pairwise combination (weighted averages) for two primitives or primitive-vs-terrain, plus humanoid-facing friction queries.

## Declared API

- `DYNAMIC_FASTFLAG(MaterialPropertiesEnabled)` — gates the whole behavior.
- `class MaterialProperties` — all static:
  - Contact parameter updates ("between two primitives, and Primitive to Terrain"):
    - `static void updateContactParamsPrims(ContactParams& params, Primitive* prim0, Primitive* prim1);`
    - `static void updateContactParamsPrimMaterial(ContactParams& params, Primitive* prim, Primitive* otherPrim, PartMaterial otherMaterial);`
  - Density: `static float getDensity(Primitive* prim);`
  - Humanoid behavior: `frictionBetweenMaterials(PartMaterial a, PartMaterial b)`, `frictionBetweenPrimAndMaterial(Primitive*, PartMaterial)`.
  - Property defaults: `generatePhysicalMaterialFromPartMaterial(PartMaterial) → PhysicalProperties`, `getPrimitivePhysicalProperties(Primitive*) → PhysicalProperties`.
  - Private helpers: `calculateUsingWeightedAverage(weightA, coeffA, weightB, coeffB)`, per-material getters `getDefaultMaterial{Friction,FrictionWeight,Elasticity,ElasticityWeight,Density}(PartMaterial)` — "Used on PartInstance initialization and property setting".

## Gotchas

- Behavior is flag-gated (`MaterialPropertiesEnabled`) — tables/paths can differ between flag states.
- Combination uses *weighted* averages with separate friction-weight and elasticity-weight tables — not a plain average; weights come from the materials themselves.

## UNKNOWN

- Actual numeric tables (live in the .cpp).

## Cross-links

- Params written into: [v8kernel/ContactParams.md](../v8kernel/ContactParams.md). Consumers: [ContactManager.md](ContactManager.md) (`onPrimitiveContactParametersChanged` flow), [Contact.md](Contact.md).
