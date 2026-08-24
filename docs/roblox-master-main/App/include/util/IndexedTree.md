# util/IndexedTree.h

## Purpose
Intrusive parent/child tree mixin: each node tracks its parent and an `IndexArray` of children (using its own index member), giving O(1) child add/remove plus typed traversal helpers (parent, root, depth, visitors). Protected virtual hooks fire on every reparent event.

## Declared API
```cpp
class RBXBaseClass IndexedTree {
public:
    IndexedTree();
    virtual ~IndexedTree();

    int numChildren() const { return children.size(); }

    template<class Type> Type* getTypedChild(int i);
    template<class Type> const Type* getConstTypedChild(int i) const;
    template<class Type> Type* getTypedParent();
    template<class Type> const Type* getConstTypedParent() const;
    template<class Type> Type* getRoot();                    // walks to top, casts
    template<class Type> const Type* getRoot() const;
    template<class Type> Type* getOneBelowRoot();            // asserts has parent
    int getDepth() const;                                    // root == 1

    template<class Type, class Func> void visitMeAndChildren(Func func);
    template<class Type, class Func> void visitConstMeAndChildren(Func func) const;
    template<class Type, class Func> void visitDescendents(Func func);       // excludes self
    template<class Type, class Func> void visitConstDescendents(Func func) const;

protected:
    virtual void onParentChanging() {}
    virtual void onParentChanged(IndexedTree* oldParent) {}
    virtual void onChildAdding(IndexedTree* child) {}
    virtual void onChildAdded(IndexedTree* child) {}
    virtual void onChildRemoving(IndexedTree* child) {}
    virtual void onChildRemoved(IndexedTree* child) {}
    virtual void onAncestorChanged() {}

    void setIndexedTreeParent(IndexedTree* newParent);
private:
    IndexedTree* parent;
    int index;
    int& getIndex();
    IndexArray<IndexedTree, &IndexedTree::getIndex> children;
    bool circularReference(IndexedTree* newAncestor, IndexedTree* child);
};
```

## Gotchas
- Reparenting goes through `setIndexedTreeParent(newParent)` only — it fires the full hook cascade (`onParentChanging`, removal hooks on old parent, add hooks on new, `onAncestorChanged`) and guards against circular references.
- `getTypedChild/getTypedParent/getRoot<Type>` use `rbx_static_cast` — caller guarantees the actual dynamic type; no checks.
- `visitMeAndChildren` is pre-order (self first). `visitDescendents` skips self. Recursive — deep trees can stack overflow.
- Destructor removes itself from its parent (via IndexArray bookkeeping).
- `getOneBelowRoot` asserts this node has a parent.

## UNKNOWN
- Relationship to the V8Tree Instance hierarchy (this looks like the generic core that Instance-like trees build on).
