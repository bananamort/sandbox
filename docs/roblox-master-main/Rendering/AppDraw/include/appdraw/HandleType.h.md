# AppDraw/include/appdraw/HandleType.h

## Purpose

One-line enum for Studio drag-handle kinds, shared by DrawAdorn and the draggers.

## API

`namespace RBX { enum HandleType { HANDLE_RESIZE = 0, HANDLE_MOVE, HANDLE_ROTATE, HANDLE_VELOCITY }; }`

## Usage / Gotchas

Included as `appDraw/HandleType.h` or `appdraw/HandleType.h` (case varies by includer). Ordinal values are persisted nowhere — purely in-memory UI tagging.
