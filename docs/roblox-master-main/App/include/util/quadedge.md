# util/quadedge.h

## Purpose
Guibas–Stolfi quad-edge data structure + Delaunay subdivision primitives (from Graphics Gems IV / Lischinski's notes, per header references): 2D points/vectors/lines with epsilon classification, the four-edge QuadEdge algebra (Rot/Sym/Onext/...), and a `Subdivision` supporting site insertion and generic traversal.

## Declared API
```cpp
namespace GEMS {
    #define GEMS_EPS 1e-6
    typedef float Real;

    class Vector2d { Real x, y;  norm(); normalize(); + - scalar* dot(); };
    class Point2d  { Real x, y;  operator+(Vector2d); operator-(Point2d)->Vector2d;
                     operator== (epsilon compare via GEMS_EPS); };
    class Line     { Line(const Point2d&, const Point2d&);   // normalized line eq a*x+b*y+c
                     Real eval(const Point2d&) const;
                     int classify(const Point2d&) const; };  // -1 left / 0 on / 1 right

    class Edge {                    // one of 4 directed edges of a QuadEdge
    public:
        Edge* Rot();      // dual, right->left        (pointer arithmetic over e[4])
        Edge* invRot();   // dual, left->right
        Edge* Sym();      // reversed edge
        Edge* Onext();    // next ccw around origin
        Edge* Oprev();    // next cw around origin
        Edge* Dnext();    // ccw around destination
        Edge* Dprev();
        Edge* Lnext();    // ccw around left face
        Edge* Lprev();
        Edge* Rnext();    // ccw around right face
        Edge* Rprev();
        Point2d* Org();   Point2d* Dest();
        const Point2d& Org2d() const;  const Point2d& Dest2d() const;
        void EndPoints(Point2d*, Point2d*);
        QuadEdge* Qedge();               // (QuadEdge*)(this - num)
        template<class Func> void visit(Func func);
    };

    class QuadEdge {
    public:
        QuadEdge();                       // initializes e[0..3] ring pointers
        static void incrementVisitId();
        bool visited();                   // per-traversal mark via global id
    private:
        Edge e[4];
        static unsigned int globalVisitId;
        unsigned int myVisitId;
    };

    Edge* MakeEdge();                     // friend allocation (in .cpp)

    class Subdivision {
    public:
        Subdivision(const Point2d&, const Point2d&, const Point2d&); // bounding triangle
        void InsertSite(const Point2d&);  // Delaunay insert
        template<class Func> void visit(Func func);  // traverse all edges w/ visit-id trick
    private:
        Edge* startingEdge;
        Edge* Locate(const Point2d&);
    };
}
```

## Gotchas
- Classic quad-edge relies on **pointer arithmetic** within `QuadEdge::e[4]` (`this ± num`) — QuadEdge must stay a POD-like aggregate of exactly 4 contiguous Edges.
- Traversal marking uses a process-global visit counter — not thread-safe; run traversals single-threaded.
- `Point2d::operator==` is epsilon-based (GEMS_EPS), so it's not a strict weak ordering — cannot key maps by point.
- All `Real` are `float`: precision-sensitive Delaunay code; degenerate inputs rely on EPS heuristics.
- `MakeEdge`, `DeleteEdge`(if any), `Subdivision` ctor/InsertSite/Locate bodies live in the .cpp (not under App/include).

## UNKNOWN
- Location of quadedge.cpp and consumers (terrain meshing / triangulation).
