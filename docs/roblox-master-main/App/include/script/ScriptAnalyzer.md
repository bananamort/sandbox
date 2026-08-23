# App/include/script/ScriptAnalyzer.h

## Purpose

Declares the `RBX::ScriptAnalyzer` namespace: warning codes for static script analysis (anchored to the public Roblox wiki "Script Analysis" page), position/location/error/warning structs, an IntelliSense-shaped result tree, and the single entry point `analyze(DataModel*, shared_ptr<Instance>, const std::string& code)` returning parse errors plus warnings.

## Declared API

- `namespace RBX::ScriptAnalyzer`
  - `enum WarningCode` — comment: "Don't change codes for the existing warnings - they have a corresponding wiki anchor tag". Values: `Warning_Unknown=0`, `Warning_UnknownGlobal=1`, `Warning_DeprecatedGlobal=2`, `Warning_GlobalUsedAsLocal=3`, `Warning_LocalShadow=4`, `Warning_SameLineStatement=5`, `Warning_MultiLineStatement=6`, `Warning_UnknownType=7`, `Warning_DotCall=8`, `Warning_UnknownMember=9`, `Warning_BuiltinGlobalWrite=10`, `Warning_Placeholder=11`, trailing sentinel `Warning_Internal`.
  - `struct Position { unsigned int line, column; Position(unsigned int, unsigned int); }` (inline ctor)
  - `struct Location` (inline)
    - `Location();` `(const Position& begin, const Position& end);` `(const Position& begin, unsigned int length);` — end = begin.column + length; `(const Location& begin, const Location& end);` — span from begin.begin to end.end.
  - `struct Error { Location location; std::string text; };`
  - `struct Warning { WarningCode code; Location location; std::string text; Warning(...); }` (inline ctor)
  - `struct IntellesenseResult` [sic] — `std::string name; bool isLocal; bool isFunction; Location location; std::vector<IntellesenseResult> children;` default ctor inline.
  - `struct Result { boost::optional<Error> error; std::vector<Warning> warnings; std::vector<IntellesenseResult> intellesenseAnalysis; };`
  - `Result analyze(DataModel* dm, shared_ptr<Instance> script, const std::string& code);`

## Usage notes

- Only forward declarations of `DataModel`/`Instance`/`lua_State` — cheap to include.
- Paired implementation documented under certified App/script module (`docs/roblox-master-main/App/script/`).

## Gotchas

- The struct name is misspelled `IntellesenseResult` (and field `intellesenseAnalysis`) throughout — it's API surface here; do not rename call sites unilaterally.
- Warning numeric values are frozen contract with external wiki anchors.
- Known source defect recorded during App/script certification: ScriptAnalyzer.cpp's pass loop computed `sizeof(vector)` instead of element size, disabling lint passes by default — header itself is unaffected but consumers should not assume all warnings fire.
