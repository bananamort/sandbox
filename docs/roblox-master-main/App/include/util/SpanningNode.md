# util/SpanningNode.h

## Purpose
Node of the dynamic spanning tree (extends `IndexedTree` for parent/child structure): tracks its `SpanningEdge` to parent and requires subclasses to enumerate their incident spanning edges so tree walks can compare weights.

## Declared API
```cpp
class SpanningNode : public IndexedMesh {      // NOTE: inherits IndexedMesh, not IndexedTree directly
    friend class SpanningEdge;
private:
    SpanningEdge* edgeToParent;
protected:
    virtual SpanningEdge* getFirstSpanningEdge() = 0;              // subclass provides edge list
    virtual SpanningEdge* getNextSpanningEdge(SpanningEdge* edge) = 0;
    void setEdgeToParent(SpanningEdge* edge);
public:
    SpanningNode();                        // edgeToParent = NULL
    ~SpanningNode();

    SpanningNode* getParent();             // getTypedParent<SpanningNode>()
    const SpanningNode* getConstParent() const;
    SpanningNode* getChild(int i);

    SpanningEdge* getEdgeToParent();
    const SpanningEdge* getConstEdgeToParent() const;

    static int getDepth(SpanningNode* node);   // NULL=0, root=1, recursive

    bool lessThan(const IndexedTree* other) const;

    template<class Func>
    void visitEdges(Func func);            // calls func(this, edge) per incident edge
};
```

## Gotchas
- Inherits from `IndexedMesh` (which presumably extends IndexedTree) — see IndexedMesh.md; the typed parent/child helpers come from IndexedTree.md.
- Subclass MUST implement `getFirstSpanningEdge`/`getNextSpanningEdge`; `visitEdges` loops until getNext returns NULL.
- Root nodes have `edgeToParent == NULL`.
- `getDepth` is recursive — deep trees cost stack.

## UNKNOWN
- Why the intermediate IndexedMesh base rather than IndexedTree (.cpp-side design).
