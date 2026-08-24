# App/include/tool/HammerTool.h

## Purpose

Legacy hammer tool (`Named<MouseCommand, sHammerTool>`): tracks a hammer `PartInstance`, reacts to mouse idle/down, and adorns a 3D cursor. Mostly historical — one of the original 2005-era tool set alongside Clone/Grab.

## Declared API

- `extern const char* const sHammerTool;`
- `class HammerTool : public Named<MouseCommand, sHammerTool>`
  - `HammerTool(Workspace* workspace)`; `~HammerTool()`.
  - Private state: `shared_ptr<PartInstance> hammerPart;`
  - Overrides: `void onMouseIdle(const shared_ptr<InputObject>&)` (note misspelled marker comment `/*ovverrid*/`), `shared_ptr<MouseCommand> onMouseDown(const shared_ptr<InputObject>&)`, `void render3dAdorn(Adorn*)`, `const std::string getCursorName() const`.
  - `shared_ptr<MouseCommand> isSticky() const` → recreates itself.

## Gotchas

- The `/*ovverrid*/` typo on `onMouseIdle` is cosmetic (marker comments aren't enforced), but signals that override may not match a base virtual signature anymore.
- Implementation not under App/include; consumers are legacy tool registration paths.
