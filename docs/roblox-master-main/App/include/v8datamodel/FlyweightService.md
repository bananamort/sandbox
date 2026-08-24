# App/include/v8datamodel/FlyweightService.h

## Purpose

Base for string-data flyweight stores (parent of [CSGDictionaryService](CSGDictionaryService.md) and friends): interns large binary blobs as hash-keyed `BinaryStringValue` children with ref counts, so identical payloads serialize once. PERSISTENT + Security::Roblox.

## Declared API

- `struct InstanceStringData { weak_ptr<BinaryStringValue> ref; int count; ctors (str[, refCount=1]); };`
- `class FlyweightService : public DescribedCreatable<FlyweightService, Instance, sFlyweightService, ClassDescriptor::PERSISTENT, Security::Roblox>, public Service`
- Storage: `typedef boost::unordered_map<std::string, InstanceStringData> FlyweightInstanceMap; FlyweightInstanceMap instanceMap;`
- Public: `FlyweightService(); void clean(); virtual void refreshRefCount(); static std::string createHashKey(const std::string&); static std::string getHashKey(const std::string&); static bool isHashKey(const std::string&); std::string dataType(std::string str); const BinaryString peekAtData(const BinaryString& str); void removeStringData(const BinaryString& str); void printMapSizes();`
- Protected contract: `virtual void onChildAdded(shared_ptr<Instance>)`; store/retrieve `void storeStringData(BinaryString&, bool forceIncrement, const std::string& name); retrieveStringData(BinaryString&); incrementStringRefCounter(const BinaryString&);` key hashing `getLocalKeyHash(string|BinaryString)`; extension hook `virtual void refreshRefCountUnderInstance(Instance*) {}` (no-op base); `cleanChildren()`; override `onServiceProvider(old,new)`; membership probe `bool isChildData(shared_ptr<Instance>)`.
- Connections: `stringChildAddedSignal`, `stringChildRemovedSignal`.

## Gotchas

- Refcounts live in the map, not on the strings — refreshRefCount* reconciles them after tree edits.
- Hash keys are detectable via isHashKey — serialized places store hashes in place of payload.
- Security::Roblox descriptor: engine-managed service.

## UNKNOWN

- Hash algorithm and collision policy (.cpp — see [FlyweightService.md](../../v8datamodel/FlyweightService.md)).

## Cross-links

- Implementation: [App/v8datamodel/FlyweightService.md](../../v8datamodel/FlyweightService.md).
- Subclass: [CSGDictionaryService.md](CSGDictionaryService.md).
