# util/Object.h

## Purpose
The class-factory backbone of the old RBX object model: shared_ptr cast helpers, `ICreator` interface, `Creatable<>` utility (create-by-name registry keyed by interned `Name`), `FactoryProduct<>` (self-registering creator mixin), and `NonFactoryProduct<>` (className without factory). Also drags in anti-tamper caller checks (`checkRbxCaller`) around every `create()`.

## Declared API
```cpp
enum CreatorRole { ReplicationCreator, SerializationCreator, ScriptingCreator, EngineCreator };

// shared_ptr cast helpers:
template<class T, class U> shared_ptr<T> shared_polymorphic_downcast(const shared_ptr<U>& r);
    // asserts dynamic_cast<T*>(r.get()) == r.get(), then static_pointer_cast
template<class T, class U> shared_ptr<T> shared_dynamic_cast(const shared_ptr<U>& r);
template<class T, class U> shared_ptr<T> shared_static_cast(const shared_ptr<U>& r);
template<class T> shared_ptr<T> shared_from(T* r);       // via r->shared_from_this()
template<class T> weak_ptr<T>   weak_from(T* r);
template<class T, class U> shared_ptr<T> shared_from_polymorphic_downcast(enable_shared_from_this<U>* r);
template<class T, class U> shared_ptr<T> shared_from_static_cast(enable_shared_from_this<U>* r);
template<class T, class U> shared_ptr<T> shared_from_dynamic_cast(enable_shared_from_this<U>* r);
template<class T> bool weak_equal(const weak_ptr<T>& lhs, const weak_ptr<T>& rhs);

class RBXInterface ICreator {
public:
    virtual shared_ptr<Reflection::DescribedBase> create() const = 0;
};

template<class Class>
class Creatable {   // utility class, unconstructible
public:
    class Deleter { public: void operator()(Class* instance) { Class::predelete(instance); delete instance; } };
    template<class T> static shared_ptr<T> create();                       // 0..7 args overloads
    template<class T, typename P1..P7> static shared_ptr<T> create(P1..P7);
    static std::map<const Name*, const ICreator*>& getCreators();
    static shared_ptr<Class> createByName(const Name& name, CreatorRole creatorRole);
        // Serialization/Scripting roles gate on descriptor isSerializable()/isScriptCreatable()
    static const ICreator* getCreator(const Name& name);
};

template <class Class, class BaseClass, const char* const& sClassName, class FactoryClass>
class FactoryProduct : public BaseClass {
protected:
    FactoryProduct();                       // + 1- and 2-arg forwarding ctors
    virtual ~FactoryProduct();
public:
    const ICreator& getCreator();
    static const RBX::Name& className();
    static bool isNullClassName();          // always false (asserts)
    const RBX::Name& getClassName() const;
    static shared_ptr<Class> createInstance();          // 0..4 args overloads
private:
    static Creator creatorPrivate;          // self-registering in ctor; erases in dtor
};

// For objects that should NOT be creatable by a factory:
template <class BaseClass, const char* const& sClassName>
class NonFactoryProduct : public BaseClass {
public:
    NonFactoryProduct();                    // + 1..4 arg forwarding ctors
    static const RBX::Name& className();
    static bool isNullClassName();          // sClassName == NULL
    const RBX::Name& getClassName() const;
};
```

## Gotchas
- Every `create()` runs `checkRbxCaller<kCallCheckCallersCode,...>` — an anti-cheat/tamper check on the calling code; failures are handled by the Security layer.
- `Deleter` invokes `Class::predelete(instance)` before delete — classes created through this path MUST provide a static `predelete`.
- `createByName` returns NULL shared_ptr for unknown names or when role gating rejects (serialization of non-serializable etc.).
- Creator registration happens in **static initialization** (`creatorPrivate`) — order-of-static-init hazards apply; `wasConstructed()` (magic 666) exists to debug it.
- `shared_polymorphic_downcast` assert only holds in debug; release relies on the caller being right.
- Requires T to derive from `boost::enable_shared_from_this` for the `*_from_*` helpers.

## UNKNOWN
- Semantics of HATE_RETURN_CHECK / callCheckSetBasicFlag (Security/FuzzyTokens + HackDefines slices).
