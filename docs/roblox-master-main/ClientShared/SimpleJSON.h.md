# SimpleJSON.h

Source: `roblox-sandbox/ClientShared/SimpleJSON.h` (76 lines)

## Purpose

Macro framework for declaratively binding flat JSON payloads onto C++ classes. A subclass declares fields with `DECLARE_DATA_*` macros; `SimpleJSON::ReadFromStream` (see SimpleJSON.cpp) then fills them from a JSON object using a name -> static-parser map built at construction.

## API

```cpp
class SimpleJSON {
public:
    SimpleJSON();
    static bool ParseBool(const char* value);
    void ReadFromStream(const char *stream);
    bool GetError() const;
    void ClearError();
    std::string GetErrorString() const;
protected:
    virtual bool DefaultHandler(const std::string& valueName, const std::string& valueData) { return false; }
    std::map<std::string, parser> _propValues;   // name -> void(*)(const char*)
    bool _error; std::string _errorString;
};
typedef void (*parser)(const char *stream);
```

Macros:

- `START_DATA_MAP(className)` / `END_DATA_MAP()` — declares static `_thisPtr`, ctor that assigns `_thisPtr = this; Init();`, virtual dtor.
- `DATA_MAP_IMPL_START(className)` / `DATA_MAP_IMPL_END()` — defines `_thisPtr` and `Init()`.
- `DECLARE_DATA_INT(name)`, `DECLARE_DATA_BOOL(name)`, `DECLARE_DATA_STRING(name)` — private field `_prop##name`, getter `GetValue##name()`, static setter `ReadValue##name(const char*)`.
- `IMPL_DATA(name, def)` — inside Init(): sets default and registers the parser in `_propValues`.

## Usage

Subclasses (FastLogSettings, RCC settings parsers, GuiBuilder responses) look like:

```cpp
class X : public SimpleJSON { START_DATA_MAP(X) DECLARE_DATA_INT(Foo) END_DATA_MAP()
  DATA_MAP_IMPL_START(X) IMPL_DATA(Foo, 0) DATA_MAP_IMPL_END() };
```

then call `x.ReadFromStream(jsonText)`.

## Gotchas

- The design supports only ONE live instance per class at a time: setters write through the static `_thisPtr`. Constructing two instances of the same subclass makes the last-constructed one receive all parses of both.
- Values are delivered to setters as C strings even for ints/bools (`atoi`/`ParseBool` inside the macro), so numeric precision beyond int is unavailable and bools accept only "true"/"True".
- Not thread safe: static `_thisPtr` plus shared map make concurrent parses on distinct instances race.
