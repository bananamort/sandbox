# util/Name.h

## Purpose
Interned-string identity type: `RBX::Name` interns strings in a global registry so equal names share one object — equality is pointer comparison and ordering uses a monotonically assigned atomic `sortIndex`. Also provides `INamed` interface and `Named<BaseClass, sName>` CRTP-ish mixin giving classes a static compile-time-declared Name.

## Declared API
```cpp
class Name : public boost::noncopyable {
public:
    std::string const str;                 // the interned text (public, const)

    static size_t size();                  // registry size
    static size_t approximateMemoryUsage();

    static const Name& getNullName();
    // Fast and thread-safe:
    NOINLINE  static const Name& declare(const char* const& sName);
    FORCEINLINE static const Name& declare(const std::string& sName);

    // Runtime twin of declare<>() NTTP form; works around MSVC 14.5x NTTP bug:
    FORCEINLINE static const Name& declareClassName(const char* const& sName);

    template<const char* const& sName>
    static const Name& declare();          // once-init per string constant

    NOINLINE  static const Name& lookup(const char* const& sName);   // no insert? see UNKNOWN
    FORCEINLINE static const Name& lookup(const std::string& sName);

    bool empty() const;                    // == null name
    static bool empty(const Name* name);   // null ptr or null name

    const std::string& toString() const;
    const char* c_str() const;

    // Ordering via sortIndex (avoids string compares); lexicographic variant #ifdef'd out:
    static int compare(const Name& a, const Name& b);
    int compare(const Name& other) const;
    bool operator<(const Name&) const;     bool operator>(const Name&) const;
    bool operator==(const Name&) const;    // pointer identity!
    bool operator!=(const Name&) const;
    bool operator==(const std::string&) const;   // string compare against text
    bool operator!=(const std::string&) const;
    bool operator==(const char* const&) const;
    bool operator!=(const char* const&) const;
private:
    explicit Name(const char* const& sName);
    void setOrderIndex();
    rbx::atomic<int> sortIndex;
};

std::ostream& operator<<(std::ostream&, const RBX::Name&);

class RBXInterface INamed {
public:
    virtual const Name& getName() const = 0;
};

template <class BaseClass, const char* const& sName>
class Named : public BaseClass {           // forwards 0..4 ctor args
public:
    static const Name& name();             // declareClassName(sName)
    virtual const Name& getName() const;
};
```

## Gotchas
- `operator==` on two Names is **pointer identity** — only true if both came from the same interned entry; comparing against `std::string`/`char*` does a real string compare.
- Ordering (`<`, `>`, `compare`) uses **declaration order** (sortIndex), NOT alphabetical — sorting Names gives creation order.
- `declare()` inserts into the process-lifetime registry (names never freed); `lookup()`'s miss behavior (insert vs return null) is .cpp-side (UNKNOWN).
- The NTTP template `declare<sName>()` requires the string to be a linkage-visible `extern const char[]`; use `declareClassName` at runtime (MSVC workaround documented inline).
- `Named<Base, sName>` forwards up to 4 ctor args only.

## UNKNOWN
- Whether `lookup` inserts on miss or returns the null name (.cpp-side).
