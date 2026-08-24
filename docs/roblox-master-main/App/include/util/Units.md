# util/Units.h

## Purpose
Unit conversion between SI (kilogram-meter-second) and Roblox units: 1 Roblox stud = 0.05 m (20 studs/m), with converters for velocity, acceleration, force, torque, density, and angular stiffness/damping vectors.

## Declared API
```cpp
class Units {
public:
    static float mPerRbx();     // 0.05
    static float rbxPerM();     // 20.0
    static float rbxPerMM();    // rbxPerM() * 0.001 = 0.02

    static Vector3 kmsVelocityToRbx(const Vector3& kmsVelocity);
    static float    kmsAccelerationToRbx(float kmsAccel);
    static Vector3  kmsAccelerationToRbx(const Vector3& kmsAccel);
    static float    kmsForceToRbx(float kmsForce);
    static Vector3  kmsForceToRbx(const Vector3& kmsForce);
    static Vector3  kmsTorqueToRbx(const Vector3& kmsTorque);
    static float    kmsDensityToRbx(float kmsDensity);
    static Vector3  kmsKRotToRbx(const Vector3& kmsKRot);       // rotational spring k
    static Vector3  kmsKRotDampToRbx(const Vector3& kmsKRotDamp); // rotational damping
};
```

## Gotchas
- One-way namespace: only kms→rbx converters declared here (no rbx→kms).
- Force/torque/density conversions imply a mass unit choice (kg per stud³ etc.) — exact factors are .cpp-side.
- Header guard uses GUID macro.

## UNKNOWN
- Exact conversion factors beyond the length constants (.cpp-side).
