# util/SpanningTree.h

## Purpose
Controller for a weight-balanced spanning tree over SpanningNode/SpanningEdge graphs: inserting an edge triggers a cascade that finds the heaviest edge downstream and the lightest upstream path and **swaps** them, keeping tree depth/weight balanced as edges come and go. Subclasses receive add/remove hooks.

## Declared API
```cpp
class SpanningTree {
public:
    SpanningTree();
    ~SpanningTree();

    void insertSpanningTreeEdge(SpanningEdge* insertEdge);   // links two nodes; rebalances
    void removeSpanningTreeEdge(SpanningEdge* removeEdge);   // unlinks + reattaches subtree

protected:
    /*implement*/ virtual void onSpanningEdgeAdding(SpanningEdge* edge, SpanningNode* child) {}
    /*implement*/ virtual void onSpanningEdgeAdded(SpanningEdge* edge) {}
    /*implement*/ virtual void onSpanningEdgeRemoving(SpanningEdge* edge) {}
    /*implement*/ virtual void onSpanningEdgeRemoved(SpanningEdge* edge, SpanningNode* child) {}
    /*implement*/ virtual bool validateTree(SpanningNode* root) { return true; }
private:
    G3D::Array<SpanningEdge*> tempEdges;
    int size;
    // internals: lightParent / testEdgeToParent / findLightestUpstream (node- and edge-flavored)
    // buildDownstreamTree / removeEdge / addEdge / findAndDeactivateEdges / activateEdges
    // findHeaviestDownstream / swapTree / swap
};
```

## Gotchas
- All mutation must flow through `insertSpanningTreeEdge`/`removeSpanningTreeEdge` — they own the hook cascade and rebalance (`swapTree` deactivates one edge while activating another to re-root a subtree).
- The balance invariant depends on each edge's `isHeavierThan`; inconsistent comparators produce oscillating swaps.
- Hooks fire around every structural change — subclass side effects must tolerate being called during rebalance cascades.
- `validateTree` is a debug/validation override point (default true).

## UNKNOWN
- Concrete users (likely physics constraint graph keeping assemblies rooted).
