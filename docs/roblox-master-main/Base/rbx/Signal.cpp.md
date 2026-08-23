# Signal.cpp

## Purpose
Out-of-line implementation for rbx/signals: defines the `slot_exception_handler` global (default null) and connection's disconnect/connected/equality via weak→strong slot lock. Also owns the FLog::ScopedConnection channel and a vestigial once-init struct.

## API
```cpp
boost::function<void(std::exception&)> rbx::signals::slot_exception_handler(0);
void  connection::disconnect() const;   // lock() then islot::disconnect(); no-op if slot gone
bool  connection::connected() const;    // lock() && islot::connected()
bool  connection::operator==/!=(const connection&); // compares locked strong ptrs
connection& connection::operator=(const connection&);
LOGVARIABLE(ScopedConnection, 0);       // log group, off by default
```

## Usage
Pairs with include/rbx/signal.h. The exception handler stays null unless some startup code assigns it — with no handler, exceptions from slots propagate out of operator().

## Gotchas
- `struct Init` calls an EMPTY initStaticData through boost::call_once — dead scaffolding from an earlier static-init scheme; harmless.
- Equality compares `weak_slot.lock()` intrusive_ptrs — two connections to the same slot compare equal; a disconnected-and-reconnected pair may alias.
