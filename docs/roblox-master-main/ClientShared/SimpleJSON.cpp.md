# SimpleJSON.cpp

Source: `roblox-sandbox/ClientShared/SimpleJSON.cpp` (113 lines)

## Purpose

Implements `SimpleJSON::ReadFromStream`: parses a flat JSON object with rapidjson 0.11 and dispatches each top-level member to a registered static setter (via the macro-generated `_propValues` map), falling back to the virtual `DefaultHandler`. Also contains a legacy hand-rolled trimming parser kept only under `RBX_BOOTSTRAPPER_MAC`.

## API

```cpp
void SimpleJSON::ReadFromStream(const char *stream);   // parse+dispatch
bool SimpleJSON::ParseBool(const char* value);         // accepts "true"/"True"
```

Dispatch rules inside ReadFromStream:

- String values pass through verbatim; ints are streamed as decimal; bools become `"True"`/`"False"` strings before hitting the registered `parser`.
- Objects/arrays/doubles/null at top level hit the `continue` branch — silently ignored (not an error).
- Unknown names call `DefaultHandler(name, data)`; base returns false.

## Usage

Base class for `RBX::FastLogSettings` (App/include/v8datamodel/FastLogSettings.h), GuiBuilder's JSON responses, and RCCServiceSoapServiceImpl's settings parsing. Consumers subclass with `START_DATA_MAP` / `DECLARE_DATA_INT|BOOL|STRING` / `IMPL_DATA` macros from SimpleJSON.h.

## Gotchas

- Bool round-trip asymmetry: the IsBool dispatch branch capitalizes to `"True"`/`"False"`, and `ParseBool` only recognizes `"true"`/`"True"` as true — so JSON booleans round-trip correctly (`"False"` falls through every match and returns false). The catch-all is lossy in both directions: ANY unrecognized string (including `"false"`, `"0"`, `""`) yields bool false, while a JSON *string* value of `"true"` will set a `DECLARE_DATA_BOOL` field to true because it matches before the type distinction ever matters.
- Parse errors set `_error`/`_errorString` (`"SimpleJson, @offset: message"`) and return early; callers must check `GetError()`.
- rapidjson crashes iterating an invalid document — hence the explicit early-return guard (comment preserved from source).
- The old parser below the marker only compiles when `RBX_BOOTSTRAPPER_MAC` is defined; on other platforms its static trim helpers don't exist.
