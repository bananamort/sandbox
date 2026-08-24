# AppDraw/include/appdraw/HandleType.h

## Purpose

One-line enum for Studio drag-handle kinds, shared by DrawAdorn and the draggers.

## API

`namespace RBX { enum HandleType { HANDLE_RESIZE = 0, HANDLE_MOVE, HANDLE_ROTATE, HANDLE_VELOCITY }; }`

## Usage / Gotchas

Included under three casings tree-wide: `"AppDraw/HandleType.h"` (the majority — tool headers, Handles/ArcHandles), `"appDraw/HandleType.h"` (DrawAdorn.h), and `"appdraw/HandleType.h"` (util/HitTest.h) — works only on case-insensitive filesystems. Ordinal values are persisted nowhere — purely in-memory UI tagging.
