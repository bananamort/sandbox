# App/include/v8tree/Instance.h

## Purpose

Declares `RBX::Instance`, the root of the entire datamodel object tree (every Workspace, Part, Script, GuiObject derives from it). Provides parent/child ownership (`copy_on_write_ptr<Instances> children`), GUID identity via `GuidItem`, reflection integration through `Reflection::Described`, lifecycle management (`destroy` instead of `delete`), XML (de)serialization entry points, hierarchical queries, parenting rules (`canAddChild` / `verifySetParent` / `ask*` hooks), plus the family of hierarchy event structs (`ChildAdded`, `ChildRemoved`, `DescendantAdded`, `DescendantRemoving`, `AncestorChanged`) and an opt-in `OnDemandInstance` payload holding rarely-used signals.

## Declared API

- Template convenience bases for subclasses: `DescribedCreatable<Class, BaseClass, sClassName, functionality=PERSISTENT, security=None>` (factory-registered) and `DescribedNonCreatable<...>` (not constructible by name).
- Event structs: `ChildAdded{child}`, `ChildRemoved{child}`, `DescendantAdded{instance, parent}` (private ctors, friend `Instance`), `DescendantRemoving{instance, parent}`, `AncestorChanged{child, oldParent, newParent}`.
- `typedef std::vector<shared_ptr<Instance>> Instances`; `extern const char* const sInstance`.
- `class OnDemandInstance : public Allocator<...>` — lazily attached per-instance blob: signals `childAddedSignal/childRemovedSignal/descendantAddedSignal/descendantRemovingSignal/instanceClonedSignal` and `threadsWaitingForChildren` (name + resume callback pairs).
- `class Instance : Reflection::Described<Instance, sInstance>, GuidItem<Instance>, Diagnostics::Countable<Instance>, boost::noncopyable`
  - Lifecycle: protected ctors `Instance()` / `Instance(const char* name)`; protected virtual dtor — call `virtual void destroy()` or `void remove()`; static/private `predelete`.
  - On-demand: `onDemandRead()`, `onDemandWrite()`, `virtual OnDemandInstance* initOnDemand()`.
  - Properties: `propArchivable`, `getIsArchivable/setIsArchivable`, `desc_Name`, `propParent`, `propRobloxLocked` + `getRobloxLocked/setRobloxLocked`.
  - Parenting: `getParent()`, `getRootAncestor()` (+statics), `setParent(Instance*)`, `setParent2(shared_ptr)`, `setLockedParent`, `setAndLockParent`, `promoteChildren`, `lockParent/unlockParent/getIsParentLocked`, private `setParentInternal(instance, ignoreLock)`; `securityCheck()` overloads; `contains(child)` recursive.
  - Hierarchy predicates: `isAncestorOf/isDescendantOf`, template `findFirstAncestorOfType<Type>()`, static `findCommonNode(i1,i2)`.
  - Children: `numChildren()`, `getChild(index)`, `findChildIndex`, `removeAllChildren()`, `destroyAllChildrenLua()` (security-checked), `visitChildren(func)`, `visitDescendants(func)`, `countDescendantsOfType<C>()`, typed accessors `queryTypedChild/getTypedChild/queryTypedParent/getTypedParent/getTypedRoot<C>()`, `findFirstChildOfType<C>()` / `(className string)`, `findFirstDescendantOfType<C>()`, `findConstFirst*` variants, name lookup `findFirstChildByName` (+`Dangerous`, `Recursive`, `findConstFirstChildByName`, `findFirstChildByName2(name, recursive)`), `waitForChild(name, resumeFunction, errorFunction)` + `checkParentWaitingForChildren()`.
  - Cloning/XML: `clone(CreatorRole)`, `virtual luaClone()` (enforces Instance limits), `static XmlElement* toNewXmlRoot(...)`, `readProperties/read/readChildren/readChild`, `virtual writeXml(isInScope, creatorRole)`, `writeChildren(...)` ×2 with `SaveFilter {SAVE_WORLD=0, SAVE_GAME=1, SAVE_ALL=2}`, `virtual createChild(Name, CreatorRole)`.
  - Signals: on-demand childAdded/Removed/descendantAdded/RemovingSignal + `getOrCreate*Signal(create=true)`; always-present `ancestryChangedSignal`, `propertyChangedSignal`, and memory-saving `combinedSignal(CombinedSignalType, ICombinedSignalData*)` with types `{CHILD_ADDED, CHILD_REMOVED, PROPERTY_CHANGED, EVENT_INVOCATION, OUTFIT_CHANGED, ANCESTRY_CHANGED, CLUMP_CHANGED, SLEEPING_CHANGED, HUMANOID_CHANGED}` and payload classes `ChildAddedSignalData/ChildRemovedSignalData/AncestryChangedSignalData/OutfitChangedSignalData/PropertyChangedSignalData/EventInvocationSignalData/HumanoidChangedSignalData`.
  - Raising: `raisePropertyChanged(descriptor)`, `raiseEventInvocation(descriptor, args, target)`, `virtual humanoidChanged()`.
  - Rules/hooks: `canAddChild(instance, checkParent=true)` (no cycles, no dupes, consults virtual `askAddChild/askForbidChild/askForbidParent/askSetParent`), `canSetParent`, `canSetChildren(first,last)`, `setChildren(first,last)`; protected overrides `verifySetParent/verifySetAncestor/verifyAddChild/verifyAddDescendant`, callbacks `onAncestorChanged/onDescendantAdded/onDescendantRemoving/onChildAdded/onChildRemoving/onChildRemoved/onChildChanged/onPropertyChanged/readProperty`, `raiseChanged`.
  - Misc: `getName/setName` (flyweight string), `getFullName()`, `getClassNameStr()`, `getReadableDebugId([scopeLength])`, `virtual getPersistentDataCost()`, `static computeStringCost(len/100 min 1)`, `virtual canClientCreate()` (false), `virtual onServiceProvider(oldProvider, newProvider)`, `virtual onGuidChanged()`, `static getSetParentAddr()`.

## Usage notes

- Subclasses declare themselves via `DescribedCreatable/DescribedNonCreatable` and override the `on*`/`verify*`/`ask*` virtuals to control hierarchy semantics.
- The header comment on `combinedSignal`: it exists as an optimization — one subscription instead of many per-signal subscriptions saves memory when listening broadly.
- `parent` is a raw pointer while children are shared_ptrs: the parent does not own-count its children's parent link upward; lifetime flows downward.

## Gotchas

- Never `delete` an Instance — the destructor is protected; use `destroy()`. `predelete` runs before the dtor.
- `isDescendantOf(NULL-ancestor)` returns false, but a top-level instance is documented as "descendant of NULL" quirk in comment: returns true if ancestor==parent even when parent==NULL comparison semantics matter.
- `visitChildren/visitDescendants` take const functors but `const_cast` them callable — the API looks const-safe but your functor can mutate captured state.
- `getTypedChild/getTypedParent/getTypedRoot` are static casts (assert only); `queryTyped*` are dynamic casts returning NULL.
- `findFirstChildByNameDangerous` intentionally breaks const to serve reflection.
- `setName` is virtual but `name` uses boost::flyweight — copies share storage until modified.
