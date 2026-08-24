# util/CameraSubject.h

## Purpose
Abstract interface for objects the camera can follow (characters, vehicles, parts). Provides camera-heartbeat hooks, render-location/size queries, and primitive ignore-lists for camera collision and selection. Header itself notes: "TODO - move to datamodel, out of UTIL".

## Declared API
```cpp
class RBXBaseClass CameraSubject : public virtual IHasLocation {
public:
    CameraSubject();
    virtual ~CameraSubject();

    /*implement*/ virtual void onCameraHeartbeat(const Vector3& cameraLocation, const Vector3& focusPoint) {}
    /*implement*/ virtual const CoordinateFrame getRenderLocation() = 0;  // RENDER location, not logical location
    /*implement*/ virtual const Vector3 getRenderSize() = 0;
    /*implement*/ virtual void onCameraNear(float distance) {}
    /*implement*/ virtual void getCameraIgnorePrimitives(std::vector<const Primitive*>& primitives) {}
    /*implement*/ virtual void getSelectionIgnorePrimitives(std::vector<const Primitive*>& primitives) {}
    /*implement*/ virtual void stepRotationalVelocity(Vector3& cameraLocation, Vector3& focusLocation) {}

protected:
    class ContactManager* getContactManager();   // convenience accessor
};
```

## Gotchas
- `getRenderLocation()`/`getRenderSize()` are pure virtual — subclasses MUST implement them; all other hooks default to no-ops.
- Inherits `IHasLocation` **virtually** (diamond-safe mixin).
- `stepRotationalVelocity` mutates its in/out location parameters — it is a simulation step, not a query.
- Forward declares `Primitive`, `Camera`, `ContactManager`; heavy types are not included here.
- RBXBaseClass marker implies shared-library visibility conventions.

## UNKNOWN
- Concrete implementers (Humanoid, VehicleSeat etc. live outside util/).
