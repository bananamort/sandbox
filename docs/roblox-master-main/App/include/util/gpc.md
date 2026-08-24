# util/gpc.h

## Purpose
Vendored "Generic Polygon Clipper" v2.32 (Alan Murta, University of Manchester, 2004): computes difference, intersection, XOR, or union of arbitrary 2D polygon sets, plus tristrip output. C API over double-precision vertices.

## Declared API
```c
#define GPC_EPSILON (DBL_EPSILON)   // raise to encourage merging near-coincident edges
#define GPC_VERSION "2.32"

typedef enum { GPC_DIFF, GPC_INT, GPC_XOR, GPC_UNION } gpc_op;

typedef struct { double x, y; } gpc_vertex;
typedef struct { int num_vertices; gpc_vertex* vertex; } gpc_vertex_list;

typedef struct {                 // polygon set: outer contours + holes
    int num_contours;
    int* hole;                   // hole / external contour flags per contour
    gpc_vertex_list* contour;
} gpc_polygon;

typedef struct { int num_strips; gpc_vertex_list* strip; } gpc_tristrip;

void gpc_add_contour(gpc_polygon* polygon, gpc_vertex_list* contour, int hole);
void gpc_polygon_clip(gpc_op set_operation, gpc_polygon* subject_polygon,
                      gpc_polygon* clip_polygon, gpc_polygon* result_polygon);
void gpc_tristrip_clip(gpc_op set_operation, gpc_polygon* subject_polygon,
                       gpc_polygon* clip_polygon, gpc_tristrip* result_tristrip);
void gpc_polygon_to_tristrip(gpc_polygon* polygon, gpc_tristrip* tristrip);
void gpc_free_polygon(gpc_polygon* polygon);
void gpc_free_tristrip(gpc_tristrip* tristrip);
```

## Gotchas
- Manual memory management: caller frees results with `gpc_free_polygon`/`gpc_free_tristrip`; `gpc_add_contour` copies the vertex list.
- License: free for **non-commercial use** only without author consent (per header notice).
- Pure C ABI — no namespace; all symbols are global (`gpc_*`).
- `hole[]` flags must be maintained consistently when hand-building polygons.
- Implementation is `gpc.c` (not under App/include).

## UNKNOWN
- Roblox call sites (likely decal/terrain or plugin geometry ops).
