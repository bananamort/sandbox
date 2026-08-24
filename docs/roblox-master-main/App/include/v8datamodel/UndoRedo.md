# App/include/v8datamodel/UndoRedo.h

## Purpose

Effectively EMPTY header: includes V8Tree/Verb.h and forward-declares `DataModel` / `IDataState` in namespace RBX. No classes, functions, or members are declared. The actual undo/redo machinery (ChangeHistory service + verbs) lives elsewhere.

## Declared API

- Forward declarations only: `class DataModel; class IDataState;`

## Gotchas

- Despite the name, nothing about undo/redo is defined here — consumers of undo/redo should look at [ChangeHistory.md](ChangeHistory.md) and the Verb layer.
- Likely a leftover include-shim kept so stale `#include "V8DataModel/UndoRedo.h"` lines still compile.

## UNKNOWN

- Which TUs include this header (not derivable from this file).

## Cross-links

- Real functionality: [ChangeHistory.md](ChangeHistory.md) (implementation: [App/v8datamodel/ChangeHistory.md](../../v8datamodel/ChangeHistory.md)).
