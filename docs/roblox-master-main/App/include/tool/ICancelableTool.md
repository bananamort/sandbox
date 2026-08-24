# App/include/tool/ICancelableTool.h

## Purpose

Minimal interface letting a tool hand back a replacement `MouseCommand` when its operation is cancelled (e.g. pressing Esc mid-drag returns to the previous tool).

## Declared API

- `class ICancelableTool` — single pure virtual: `virtual shared_ptr<MouseCommand> onCancelOperation() = 0;`

## Gotchas

- No virtual destructor — deleting through an `ICancelableTool*` is UB; always hold concrete types or `shared_ptr<MouseCommand>`.
- Return semantics: implementations return the `MouseCommand` to install after cancellation (often `nullptr` meaning "no follow-up command"); exact convention per implementing tool.
