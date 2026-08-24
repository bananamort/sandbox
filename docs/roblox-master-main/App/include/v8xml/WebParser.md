# App/include/v8xml/WebParser.h

## Purpose

Declares `RBX::WebParser`, the web-response parsing/serialization utility: XML table/list/entry/value loading, generic response sniffing, and JSON parse/write (legacy hand-rolled parser plus a boost property-tree variant).

## Declared API

- `class RBX::WebParser`
  - Private: `static boost::mutex JSONmutex;`
  - `typedef enum { FailOnNonJSON, SkipNonJSON } NonJSONBehavior;`
  - Public statics:
    - `parseWebGenericResponse(std::istream&, Variant&)` / `(const XmlElement* root, Variant&)` — sniffs format
    - `parseWebListResponse(std::istream&, ValueArray&)`
    - `legacyParseWebJSONResponse(std::stringstream&, shared_ptr<const ValueTable>&)`
    - `ptreeParseWebJSONResponse(std::stringstream&, shared_ptr<const ValueTable>&)`
    - `parseJSONTable(const std::string&, shared_ptr<const ValueTable>&)`
    - `parseJSONArray(const std::string&, shared_ptr<const ValueArray>&)`
    - `parseJSONObject(const std::string&, Variant&)`
    - `writeJSON(const Variant& value, std::string& result, NonJSONBehavior skip = SkipNonJSON);`
  - Protected statics: `loadTable/loadList/loadEntry/loadValue` (XmlElement → reflection containers).

## Usage notes

- Counterpart to [WebSerializer.md](WebSerializer.md).
- The JSONmutex implies the JSON paths are not reentrant/thread-safe without it.

## Gotchas

- Two competing JSON table parsers exist (`legacy...` vs `ptree...`) — behavior differences (number formats? escapes?) live in the .cpp; pick deliberately.
- Default SkipNonJSON silently drops unrepresentable values on write — switch to FailOnNonJSON when fidelity matters.
