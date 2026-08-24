# App/include/v8world/EdgeBuffer.h

## Purpose

Stage base that *buffers* edges whose endpoints aren't ready: an edge is only pushed downstream when both assemblies are present and the edge passes spring/kinematic gating. Holds a debug-only bidirectional multimap of Assembly↔Edge for finding incomplete joints. [AssemblyStage.md](AssemblyStage.md) derives from it.

## Declared API

- `class EdgeBuffer : public IWorldStage`
  - Protected ctor: `EdgeBuffer(IStage* upstream, IStage* downstream, World* world);` virtual `~EdgeBuffer();`
  - Overrides: `onEdgeAdded(Edge*)`, `onEdgeRemoving(Edge*)`.
  - Protected hooks for subclasses: `afterAssemblyAdded(Assembly*)`, `beforeAssemblyRemoving(Assembly*)`.
  - Private gating: `pushEdgeIfOk(Edge*)`, `bool pushSpringOk(Edge*)`, `bool pushKinematicOk(Edge*)`, `removeEdgeIfDownstream(Edge*)`.
  - Debug-only (`// DEBUG ONLY` comment): `typedef BiMultiMap<Assembly*, Edge*> AssemblyEdgeMap;` member `assemblyEdges` ("find incomplete Joints by primitive") plus `debugPushEdgeToDownstream/debugRemoveEdgeFromDownstream/debugAddAssembly/debugRemoveAssembly` validators and `assemblyIsHere`, `assemblyPrimitiveAdded/Removed`.

## Gotchas

- Edges can be held here indefinitely — "incomplete" edges (null/self endpoints from CleanStage's contract) wait in the buffer until their assembly completes; downstream stages never see them early.
- The AssemblyEdgeMap exists to validate consistency in dev; don't rely on it being populated in ship builds.

## UNKNOWN

- Precise spring/kinematic push rules (bodies of `pushSpringOk/pushKinematicOk` are implementation-only).

## Cross-links

- Pipeline: [IWorldStage.md](IWorldStage.md), [v8kernel/IStage.md](../v8kernel/IStage.md); subclass: [AssemblyStage.md](AssemblyStage.md); edges: [Edge.md](Edge.md), [Joint.md](Joint.md).
