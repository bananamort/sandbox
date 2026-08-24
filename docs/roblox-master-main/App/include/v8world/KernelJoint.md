# App/include/v8world/KernelJoint.h

## Purpose

Dual-identity joint that is simultaneously a world `Joint` and a kernel `Connector` ("Implements computeForce") — the base for joints realized directly as kernel constraint objects (e.g. the implicit ground connection).

## Declared API

- `class KernelJoint : public Joint, public Connector`
  - `KernelJoint(); ~KernelJoint();`
  - Joint override: `getJointType() → KERNEL_JOINT`.
  - IPipelined overrides: `putInKernel(Kernel*)`, `removeFromKernel()` (protected).
  - Connector override: `Body* getBody(BodyIndex id)` — asserts `inKernel()`; returns `getEngineBody()` when `id == body0`, else NULL.
  - Pure virtual: `protected: virtual Body* getEngineBody() = 0;`
  - `getConnectorKernelType() → Connector::KERNEL_JOINT`.

## Gotchas

- `getBody` answers only for `body0` — a KernelJoint connects exactly one engine body to the implicit world/ground body.
- Because it's also a Connector, it participates in kernel force computation; adding/removing from the kernel must go through the overridden IPipelined hooks, not raw Edge paths.

## Cross-links

- Bases: [Joint.md](Joint.md), [v8kernel/Connector.md](../v8kernel/Connector.md); consumer stage: [GroundStage.md](GroundStage.md) (`onKernelJointAdded/Removing`); kernel registry: [v8kernel/KernelData.md](../v8kernel/KernelData.md).
