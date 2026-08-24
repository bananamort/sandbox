# util/Utilities.h

## Purpose
Grab-bag utility header: SHA-1 and rot13 string "encryption" helpers, `isCamel` name checker, the `StringConverter<Type>` trait (convertToString/convertToValue), and `copy_on_write_ptr<Class>` — a copy-on-write shared pointer for cheap immutable reads with lazy copies on write.

## Declared API
```cpp
namespace RBX {
    // generic encryption functions
    std::string sha1(const std::string& source);
    std::string rot13(std::string source);      // by-value arg, returns transformed copy

    bool isCamel(const char* name);

    template <typename Type>
    class StringConverter {
    public:
        static std::string convertToString(const Type& value);
        static bool convertToValue(const std::string& text, Type& value);
    };

    // Note: not thread-safe
    template<class Class>
    class copy_on_write_ptr : public boost::noncopyable {
    public:
        copy_on_write_ptr();                        // empty
        explicit-ish copy_on_write_ptr(const Class& object);  // owns a copy
        // bool conversion (explicit operator bool on C++11-capable boost,
        // else unspecified_bool_type; added 8/3/2013 for iOS boost 1.5+):
        operator bool() const;

        const Class& operator*() const;             // asserts non-null; "do not keep reference"
        const Class* operator->() const;            // asserts non-null

        boost::shared_ptr<const Class> read() const;// may return empty ptr
        boost::shared_ptr<Class>& write();          // CoW: clones if shared; creates if empty
        void reset();
    private:
        mutable boost::shared_ptr<Class> object;
    };
}
```

## Gotchas
- `copy_on_write_ptr` is explicitly **not thread-safe** — concurrent `write()` calls race.
- `write()` semantics: if refcount > 1 it CLONES (so other holders keep the old value); if empty it default-constructs. Holding the returned reference too long defeats CoW.
- `operator*`/`operator->` assert non-empty in debug but UB in release when empty.
- `sha1` output format (hex? raw bytes?) unspecified here (UNKNOWN — likely hex string).
- `StringConverter` primary template has no definition — specializations provide behavior per type.

## UNKNOWN
- sha1 encoding and the set of StringConverter specializations that exist (.cpp side).
