# util/IndexedMesh.h

## Purpose
Physics-sim structural graph: `IndexedMesh` extends `IndexedTree` with a second "upper/lower" linkage — the header's ASCII diagram shows Primitives stacking into Clumps into Assemblies into Mechanisms. Up = parent, Down = child; Right (upper) / Left (lower) connect sibling hierarchies so a Primitive chain can be grouped upward into progressively larger simulation structures.

## Declared API
```cpp
class IndexedMesh : public IndexedTree {
public:
    IndexedMesh();
    IndexedMesh(IndexedMesh* lower, IndexedMesh* parent);
    ~IndexedMesh();

    IndexedMesh* getIndexedMeshParent();            // like getTypedParent + bug checking
    const IndexedMesh* getConstIndexedMeshParent() const;

    void setUpper(IndexedMesh* newUpper);

    template<class Type> Type* getTypedLower();
    template<class Type> const Type* getConstTypedLower() const;
    template<class Type> Type* getTypedUpper();
    template<class Type> const Type* getConstTypedUpper() const;

    IndexedMesh* getComputedUpper();                // cached upper link
    const IndexedMesh* getConstComputedUpper() const;

    static bool isUpperRoot(const IndexedMesh* lower);

    // "hack - for iterating all assemblies in a mechanism":
    template<class Type, class Func>
    void visitMeAndChildrenWhileNoUpper(Func func);
protected:
    /*implement*/ virtual void onLowersChanged() {}
    // NOTE: header TODO says "Make these protected" but they already are:
    IndexedMesh* getUpper();     const IndexedMesh* getConstUpper() const;
    IndexedMesh* getLower();     const IndexedMesh* getConstLower() const;
private:
    IndexedMesh *upper, *lower;      // either may be null
    IndexedMesh* computedUpper;      // "should == computeUpper"
    const IndexedMesh* computeParentFromLower() const;
    void setComputedUpper(IndexedMesh*);
    void setLower(IndexedMesh*);
    void severeChildren(IndexedMesh* lowerChild);
    void attachChildren(IndexedMesh* lowerChild);
    void lowersChanged();            // cascades up: onLowersChanged + parents + upper
    static IndexedMesh* computeUpper(IndexedMesh* lower);
    static const IndexedMesh* computeConstUpper(const IndexedMesh* lower);
    void onLowerChildRemoved(IndexedMesh*);   void onLowerChildAdded(IndexedMesh*);
    /*override*/ void onParentChanged(IndexedTree* oldParent);
};
```

## Gotchas
- Dual graph invariants: `computedUpper` must equal `computeUpper(lower)`; maintained by setLower/setUpper/severe/attach plumbing — bypassing them corrupts the mesh.
- `lowersChanged()` walks recursively to parent AND upper — O(depth) on every lower-link change.
- The visitor `visitMeAndChildrenWhileNoUpper` deliberately stops descending at children that have an upper link ("hack" per comment) — semantics tied to mechanism/assembly grouping.
- Comment typo "used ad the basis" is verbatim from source.

## UNKNOWN
- Concrete subclasses (Primitive/Clump/Assembly/Mechanism live in v8world/sim slices).
