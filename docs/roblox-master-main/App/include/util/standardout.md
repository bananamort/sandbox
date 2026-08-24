# util/standardout.h

## Purpose
Very basic singleton that distributes engine output to diagnostics — conceptually stdout & stderr combined. Consumers subscribe via a signal and receive timestamped, typed messages.

## Declared API
```cpp
typedef enum {
    MESSAGE_OUTPUT, MESSAGE_INFO, MESSAGE_WARNING,
    MESSAGE_ERROR, MESSAGE_SENSITIVE, MESSAGE_TYPE_MAX
} MessageType;

struct StandardOutMessage {
    MessageType type;
    std::string message;
    time_t time;                       // set from ::time() at construction
    StandardOutMessage(MessageType type, const char* message);
    StandardOutMessage();              // defaults to MESSAGE_OUTPUT
};

class StandardOut : public boost::enable_shared_from_this<StandardOut> {
public:
    static shared_ptr<StandardOut> singleton();
    static bool allowPrintWarnings;    // false => warnings are ignored
    rbx::signal<void(const StandardOutMessage&)> messageOut;
    static void print_exception(const boost::function0<void>& f, MessageType type, bool rethrow);
    void print(MessageType type, const std::string& message);
    void print(MessageType type, const char* message);
    void printf(MessageType type, const char* format, ...) RBX_PRINTF_ATTR(3, 4);
    void print(MessageType type, const std::exception& exp);
};
```

## Gotchas
- Private constructor; the only instance is obtained via `StandardOut::singleton()` (shared_ptr-based singleton, hence `enable_shared_from_this`).
- `print_exception` runs `f()`, prints any thrown exception as a message; if `rethrow` is true the exception is passed on.
- Header declares a `boost::mutex sync` member for internal serialization; locking discipline is implementation-side (UNKNOWN: which .cpp implements this in-tree).
- `printf` is variadic with format-string attribute (args 3,4) — mismatched format strings are UB.
- `MESSAGE_TYPE_MAX` is a sentinel, not a real message type.

## UNKNOWN
- Default sink/behavior when no `messageOut` subscriber is connected (does it fall back to stderr?).
