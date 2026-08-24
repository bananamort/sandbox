# util/PhysicalProperties.h

## Purpose
Per-part physics material values: density, friction, elasticity plus their "weights" (how much each surface dominates a contact), with clamping at construction and a custom-vs-inherited flag.

## Declared API
```cpp
enum PhysicalPropertiesMode {
    PhysicalPropertiesMode_Legacy,
    PhysicalPropertiesMode_Default,
    PhysicalPropertiesMode_NewPartProperties
};

class PhysicalProperties {
public:
    PhysicalProperties();  // customEnabled=false; all floats 0
    // Custom ctor — CLAMPS inputs to legal ranges:
    PhysicalProperties(float density_, float friction_, float elasticity_,
                       float frictionWeight_ = 1.0f, float elasticityWeight_ = 1.0f);

    size_t hashCode() const;
    bool getCustomEnabled() const;   void setCustomEnabled(bool value);
    float getDensity() const;
    float getFriction() const;
    float getElasticity() const;
    float getFrictionWeight() const;
    float getElasticityWeight() const;

    bool operator==(const PhysicalProperties& other) const;   // all 6 fields
    bool operator!=(const PhysicalProperties& other) const;
private:
    static float minDen()/maxDen();   // 0.01 .. 100.0
    static float minFri()/maxFri();   // 0.0  .. 2.0   ("negative friction generates energy")
    static float minFrW()/maxFrW();   // 0.0  .. 100.0
    static float minEla()/maxEla();   // 0.0  .. 1.0   ("elasticity > 1 causes energy gain")
    static float minElW()/maxElW();   // 0.0  .. 100.0

    bool customEnabled;
    float density, elasticity, friction, frictionWeight, elasticityWeight;
};

size_t hash_value(const PhysicalProperties& properties);   // boost hash support
```

## Gotchas
- Default-constructed object is NOT valid physics input (all zeros, custom disabled) — it's the "inherit from material" state.
- Clamping happens only in the value ctor; direct field mutation isn't possible (no setters except `setCustomEnabled`) so stored values always in range.
- Equality is exact float comparison — beware of comparing after different computation paths.
- Weights default to 1.0: they control per-surface dominance when two parts contact.
- Comments document the physics rationale for the clamps (negative friction/elasticity > 1 create energy).

## UNKNOWN
- Where PhysicalPropertiesMode selects between legacy/default/new serialization behavior (reflection layer).
