# App/include/v8kernel/BuoyancyConnector.h

## Purpose

Water buoyancy force connector ([ContactConnector.md](ContactConnector.md) subclass, kernel type `Connector::BUOYANCY`): holds the object-space application point and the water band (float distance / sink depth) plus submerge ratio; `computeForce` turns those into the applied force/torque.

## Declared API

- `class BuoyancyConnector : public RBX::ContactConnector`
  - `BuoyancyConnector(Body* b0, Body* b1, const Vector3& pos)`.
  - Private state: `Vector3 position;` ("force application point in object space"), `Vector3 force, torque;` `float floatDistance, sinkDistance, submergeRatio;`
  - Protected: `void computeForce(bool throttling)` override; `KernelType getConnectorKernelType()` → `Connector::BUOYANCY`.
  - Public: `void updateContactPoint();` ("Only for debug rendering now"); `const Vector3& getPosition();` `const Vector3 getWorldPosition();` (returns by value); `setForce(f)`/`setTorque(t)` inline setters; water band pair `getWaterBand(float& up, float& down)` / `setWaterBand(const float& up, const float& down)` mapping to floatDistance/sinkDistance; `float getSubMergeRatio()` / `setSubMergeRatio(const float&)` (sic — "SubMerge").

## Gotchas

- Force/torque are set externally (`setForce/setTorque`) then consumed by `computeForce` during throttled/unthrottled passes — order matters within a step.
- `getWorldPosition()` is declared returning `const Vector3` by value while `getPosition()` returns a reference to object-space data.
- Spelling is API surface: `getSubMergeRatio/setSubMergeRatio`.
- Water-band semantics: `floatDistance` = distance above surface where buoyancy starts pushing up; `sinkDistance` = allowed sink depth before full submersion force.

## UNKNOWN

- Where the caller computes band values from terrain water level (v8world/Terrain side).
