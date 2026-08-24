# util/Guid.h

## Purpose
Roblox's instance-identity GUID system: `Guid` = (Scope, index) where Scope is an interned `RBX::Name`; plus string-GUID generators (`RBXc...`, `{...}` formats) and the `GuidItem<T>` mixin that registers objects in a per-DataModel lookup Registry keyed by Guid.

## Declared API
```cpp
class Guid : boost::noncopyable {
public:
    struct Scope {                       // interned scope name (points at RBX::Name)
        Scope();                         // null scope
        void setNull();
        bool isNull() const;
        void set(const std::string& s);
        void set(const char* s);
        const RBX::Name* getName() const;
        int compare(const Scope& other) const;
        bool operator==(const Scope&) const;   bool operator<(const Scope&) const;
        static const Scope& null();
    };

    struct Data {                        // value-type key for maps/serialization
        Scope scope;
        int index;
        bool operator==(const Data& other) const;
        bool operator<(const Data& other) const;
        std::string readableString(int scopeLength = 4) const;  // DEBUG ONLY, not unique
    };

    Guid();                              // presumably null/unassigned data
    bool operator==(const Guid&) const;  bool operator<(const Guid&) const;

    // Compare 2 pairs of Guids. a0-a1 and b0-b1 commutativity. Any item may be NULL:
    static int compare(const Guid* a, const Guid* b);
    static int compare(const Guid* a0, const Guid* a1, const Guid* b0, const Guid* b1);

    void assign(Data data);              // serialization write
    void extract(Data &data) const;      // serialization read
    void copyDataFrom(const Guid& other);
    std::string readableString(int scopeLength = 4) const;

    static const RBX::Guid::Scope& getLocalScope();

    static void generateRBXGUID(RBX::Guid::Scope& result);
    static void generateRBXGUID(std::string& result);       // e.g. RBXc200e36038c511ceae6208002b2b79ef
    static void generateStandardGUID(std::string& result);  // e.g. {c200e360-38c5-11ce-ae62-08002b2b79ef}
};

inline size_t hash_value(const Guid::Data& data);  // boost hash: scope ptr + index

// Mixin for objects addressable by Guid:
template<class T>
class RBXBaseClass GuidItem {
public:
    class Registry : public rbx::quick_intrusive_ptr_target<Registry> {
    public:
        static boost::intrusive_ptr<Registry> create();
        bool lookupByGuid(const Guid::Data& data, shared_ptr<T>& result); // true if empty guid OR found
        shared_ptr<T> getByGuid(const Guid::Data& data);
        void registerGuid(const T* item);            // thread-safe
        void assignGuid(T* item, const Guid::Data& guidData);  // NOT thread-safe; fires onGuidChanged()
        void tryUnregister(GuidItem* item);          // tolerant of double-unregister (GC races)
        void unregister(GuidItem* item);             // asserts registered here
    };
    GuidItem();                                      // dtor unregisters
    const Guid& getGuid() const;
private:
    mutable boost::intrusive_ptr<Registry> registry;
    Guid guid;
};
```

## Gotchas
- "Guid" here is **not** a random UUID by default — it's a scoped integer identity; the `generateRBXGUID`/`generateStandardGUID` strings are separate utilities.
- `readableString` is explicitly "for debugging only. A string that is not guaranteed to be unique".
- `Registry` stores `weak_ptr<T>` — registration does not keep targets alive; `lookupByGuid` returns true for null-scope guids with a reset result (distinct from unregistered, which returns false).
- `assignGuid` is documented NOT thread-safe and calls virtual-ish hook `item->onGuidChanged()` (T must provide it).
- Each instance belongs to at most one Registry (asserted).
- `hash_value(Data)` combines the **pointer** of the interned Name — stable within process only.

## UNKNOWN
- Where `onGuidChanged` is declared (T-side contract outside this header).
- Index allocation policy for new Guids (implementation-side).
