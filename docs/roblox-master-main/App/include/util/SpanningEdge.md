# util/SpanningEdge.h

## Purpose
Abstract edge in a dynamically-rebalanced spanning tree (used with SpanningNode/SpanningTree): edges carry a "weight" (`isHeavierThan`) and know their two endpoint nodes. The tree swaps heavy downstream edges for light upstream ones to keep the tree balanced.

## Declared API
```cpp
class SpanningEdge {
public:
    SpanningEdge();
    virtual ~SpanningEdge();

    bool isLighterThan(const SpanningEdge* other) const;  // other->isHeavierThan(this)
    bool inSpanningTree() const;

    SpanningNode* getChildSpanningNode();
    SpanningNode* getParentSpanningNode();
    const SpanningNode* getConstChildSpanningNode() const;
    const SpanningNode* getConstParentSpanningNode() const;

    // Pure-virtual edge contract:
    virtual bool isHeavierThan(const SpanningEdge* other) const = 0;
    virtual SpanningNode* otherNode(SpanningNode* n) = 0;
    virtual const SpanningNode* otherConstNode(const SpanningNode* n) const = 0;
    virtual SpanningNode* getNode(int i) = 0;
    virtual const SpanningNode* getConstNode(int i) const = 0;

    SpanningNode* otherNode(int i);   // asserts i in {0,1}; getNode((i+1)%2)

    static bool heavierEdge(const SpanningEdge* test, const SpanningEdge* other);
        // comparator for sorting/priorities
private:
    void removeFromSpanningTree();
    void addToSpanningTree(SpanningNode* newParent);   // friend SpanningTree
};
```

## Gotchas
- Subclass must implement the 5 pure virtuals — typical concrete edge stores two node pointers and a weight.
- Tree membership mutation is private, accessible only via `friend class SpanningTree` — never add/remove manually.
- `isHeavierThan` defines the balance order; it must be a consistent strict weak ordering or tree rebalancing can loop.

## UNKNOWN
- Concrete edge subclasses (likely joint/constraint graphs in physics).
