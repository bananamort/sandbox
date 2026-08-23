# Network/MechanismItem.h

**Module**: Network (root) · **Type**: header (.h, 67 lines)

## Purpose

Value-style buffers describing the physics state of a mechanism (assembly of parts) for network transmission and interpolation: `AssemblyItem` holds one assembly's root part, position/velocity (`RBX::PV`) and motor angles (`G3D::Array<CompactCFrame>`); `MechanismItem` holds an array of assemblies plus timestamp/humanoid-state metadata. Used by the physics send/receive pipeline (PhysicsSender / PhysicsReceiver families).

## API

```cpp
class AssemblyItem : public boost::noncopyable {
public:
    shared_ptr<PartInstance> rootPart;
    RBX::PV pv;
    G3D::Array<CompactCFrame> motorAngles;
    void reset();
    AssemblyItem();
};

class MechanismItem : boost::noncopyable {
public:
    RakNet::Time networkTime;
    unsigned char networkHumanoidState;
    bool hasVelocity;
    void reset(int numElements = 0);
    MechanismItem();
    ~MechanismItem();
    AssemblyItem& appendAssembly();
    int numAssemblies() const;
    AssemblyItem& getAssemblyItem(int i) const;   // asserts i < currentElements
    static bool consistent(const MechanismItem* before, const MechanismItem* after);
    static void lerp(const MechanismItem* before, const MechanismItem* after,
                     MechanismItem* out, float lerpAlpha);
};
```

## Usage

- Senders fill a `MechanismItem` per step; receivers keep before/after items and call `lerp` to blend for interpolation (see `InterpolatingPhysicsReceiver`).
- `consistent()` gates whether `lerp()` is legal: same velocity flag, exactly 1 assembly on both sides, same motorAngles count.

## Gotchas

- `MechanismItem` owns raw `AssemblyItem*` pointers in `buffer`; destructor deletes them — copy semantics disabled via `boost::noncopyable`.
- `reset(n)` grows the buffer but never shrinks it; `currentElements` just marks how many are live.
- Multi-assembly mechanisms are never lerped (`consistent` requires `numAssemblies()==1`); comment says "For now - no lerp on mechanisms (>1 assembly)".
- `lerp` sets `out->networkTime = 0` ("shouldn't be used") — do not read time off a lerp output.
