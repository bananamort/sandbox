# App/include/v8datamodel/JointInstance.h

## Purpose

The Instance-side joint family bridging to V8World joints: abstract `JointInstance` (Part0/Part1, C0/C1 frames, engine Joint* handle, adorn rendering), concrete creatables `Snap`, `Weld`, `Glue` (with F0–F3 id vectors), `Rotate`, `DynamicRotate`→`RotateP`/`RotateV`, surface-based `ManualSurfaceJointInstance`→`ManualWeld`/`ManualGlue`, and animation-capable `Motor` → `Motor6D`.

## Declared API

`class JointInstance : public DescribedNonCreatable<JointInstance, Instance, sJointInstance>, public IAdornable, public IJointOwner`

- Comment: "Part* is master, Primitive*'s in the Joint are slaves."
- Props: `prop_Part0/prop_Part1` (RefProps); accessors getPart0/getPart1 (+Dangerous twins "only for reflection"), setPart0/setPart1; offsets `getC0/getC1/setC0/setC1` (CoordinateFrame).
- Engine link: `Joint* getJoint(); Joint::JointType getJointType() const; bool inEngine(); bool isAligned() const; void onCoParentChanged();`
- Overrides: askSetParent, onAncestorChanged, shouldRender3dAdorn/render3dAdorn, setName override, writeXml custom serializer, getPersistentDataCost +4.
- Ctors: protected default ("if you want to build one, you need a Joint") and `(Joint*)` "Created from Within World - by autojoiner"; private part[2] weak storage + setPart/setPartNull/setPrimitiveFromPart/computeWorld/handleWorldChanged; friend JointsService.

Creatables:
- `Snap` (sSnap): default + joint ctors.
- `Weld` (sWeld): same + own render3dAdorn via WeldJoint.
- `ManualSurfaceJointInstance` (non-creatable): surface ids `getSurface0/1(void)`/setSurface0/1(int).
- `ManualWeld` (shouldRender3dAdorn false) and `ManualGlue` (true) over it.
- `Glue` (sGlue): rig id vectors F0..F3 get/set (Vector3).
- `Rotate` (sRotate); `DynamicRotate` (non-creatable) with `getBaseAngle/setBaseAngle(float)`; `RotateP`/`RotateV` creatables.
- `Motor` (sMotor, also IAnimatableJoint): `getMaxVelocity/setMaxVelocity`, `getDesiredAngle/setDesiredAngle` + non-replicating setDesiredAngleUi, `getCurrentAngle` + setCurrentAngleUi ("current angle doesn't replicate - it is a command. Physics for the joint angle replicates"); IAnimatableJoint implements getParentName/getPartName/applyPose(CachedPose)/setIsAnimatedJoint; special protected ctor `(Joint*, int)` for Motor6D; renders joint cylinders.
- `Motor6D` (sMotor6D, derives Motor — comment: "derive from Motor, so that and script doing a ::IsA(Motor) should still work" [sic]): overrides the full angle/velocity surface + applyPose.

## Gotchas

- Two parallel motor classes: Motor6D is an IsA-compatible specialization with its own joint type — code must not assume Motor == 6D.
- CurrentAngle setter named *Ui replicates nothing; plain setters replicate commands.
- Joints constructed by the autojoiner arrive pre-wired via the (Joint*) ctors.
- setName triggers engine re-registration (per override presence).

## UNKNOWN

- Exact writeXml delta vs default serialization (.cpp — see [JointInstance.md](../../v8datamodel/JointInstance.md)).

## Cross-links

- Implementation: [App/v8datamodel/JointInstance.md](../../v8datamodel/JointInstance.md).
- Engine side: v8world Joint family docs; service: [JointsService.md](JointsService.md); kin [ManualJointHelper.md](ManualJointHelper.md), [Feature.md](Feature.md).
