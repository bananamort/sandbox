# util/Handle.h

## Purpose
`InstanceHandle`: a shared_ptr-based reference to an `RBX::Reflection::DescribedBase`, created "to reference DescribedBase in the XmlElement class" — i.e., a serializable/late-bound object handle for the XML pipeline.

## Declared API
```cpp
class InstanceHandle {
public:
    InstanceHandle();
    InstanceHandle(Reflection::DescribedBase* target);
    InstanceHandle(shared_ptr<Reflection::DescribedBase> target);
    InstanceHandle(const InstanceHandle& other);

    InstanceHandle& operator=(const InstanceHandle& value);
    InstanceHandle& operator=(shared_ptr<Reflection::DescribedBase> value);

    bool empty() const;
    shared_ptr<Reflection::DescribedBase> getTarget() const;
    void linkTo(shared_ptr<Reflection::DescribedBase> target);

    bool operator==(const InstanceHandle& other) const;  // via protected helpers
    bool operator!=(const InstanceHandle& other) const;
    bool operator< (const InstanceHandle& other) const;
    bool operator> (const InstanceHandle& other) const;
protected:
    bool operatorEqual(const InstanceHandle& other) const;
    bool operatorLess(const InstanceHandle& other) const;
    bool operatorGreater(const InstanceHandle& other) const;
private:
    shared_ptr<Reflection::DescribedBase> target;
};
```

## Gotchas
- Comparison operators are implemented by out-of-line helpers (`operatorEqual/Less/Greater`) — likely pointer-identity based, but semantics live in the .cpp (UNKNOWN exact ordering).
- Holds a **strong** shared_ptr to a DescribedBase — unlike Guid's Registry this keeps the target alive.
- `linkTo` vs assignment distinction (if any) is implementation-side.

## UNKNOWN
- Whether comparison uses raw pointer or some identity token (.cpp not under App/include).
