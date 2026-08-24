# App/include/v8kernel — Index

Kernel-side rigid body physics: Body/SimBody assembly model, the IStage pipeline ending in Kernel, KernelData registries, connectors (contact/joint/buoyancy/Bullet bridge), and supporting math/constants.

| File | Doc | Notes |
|---|---|---|
| Body.h | [Body.md](Body.md) | Rigid-body tree node; PV access ladder (Fast/Unsafe/SpinLock); mass properties; BodyPvSetter-guarded setters. |
| SimBody.h | [SimBody.md](SimBody.md) | Integration master per assembly root; accumulators; kernel list indices; symmetric-contact detection. |
| Kernel.h | [Kernel.md](Kernel.md) | Terminal IStage; step(); owns KernelData + public PGSSolver; fakeDeceptive* anti-tamper telemetry. |
| KernelData.h | [KernelData.md](KernelData.md) | IndexArray registries + connector→list routing (pgsOn-dependent), dt assignment. |
| IStage.h | [IStage.md](IStage.md) | 16-stage pipeline enum + linked-list ownership (dtor deletes downstream). |
| Connector.h | [Connector.md](Connector.md) | Base + JointConnector/RotateConnector/PointToPointBreakConnector/NormalBreakConnector. |
| ContactConnector.h | [ContactConnector.md](ContactConnector.md) | Contact base (impulse math, resting contact) + GeoPairConnector/BallBallConnector/BallBlockConnector. |
| PolyConnectors.h | [PolyConnectors.md](PolyConnectors.md) | Face/FaceEdge/EdgeEdge + Ball vertex/edge/plane geometric connectors. |
| BuoyancyConnector.h | [BuoyancyConnector.md](BuoyancyConnector.md) | Water buoyancy force connector with float/sink bands. |
| BulletShapeConnectors.h | [BulletShapeConnectors.md](BulletShapeConnectors.md) | Bullet-manifold bridge connectors (+Cell variant for terrain). |
| Pair.h | [Pair.md](Pair.md) | GeoPair defining data + PairParams computed output; polarity rules in-header. |
| Point.h | [Point.md](Point.md) | Attachment point: world pos + force accumulator, kernel-owned. |
| Link.h | [Link.md](Link.md) | Parent↔child transform cache; RevoluteLink/D6Link. |
| Cofm.h | [Cofm.md](Cofm.md) | Lazy center-of-mass/mass/moment cache per body branch. |
| KernelIndex.h | [KernelIndex.md](KernelIndex.md) | int index mixin (−1 = outside kernel). |
| BodyPvSetter.h | [BodyPvSetter.md](BodyPvSetter.md) | Empty capability tag gating Body::setCoordinateFrame to Primitive. |
| ContactParams.h | [ContactParams.md](ContactParams.md) | kSpring/kNeg/kFriction (stored ×−0.5!)/kElasticity + GeoPairType enum. |
| Constants.h | [Constants.md](Constants.md) | Step hierarchy (30 long-UI steps → 60 UI), gravity −9.81, joint K tables. |
| Debug.h | [Debug.md](Debug.md) | RBX_ENGINE_ASSERT no-op unless RBX_DEBUGENGINE (off by default). |

19 of 19 headers documented. No .inl files in this directory.
