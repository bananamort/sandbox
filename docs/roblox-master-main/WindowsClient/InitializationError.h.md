# WindowsClient/InitializationError.h

## Purpose

Defines the single exception type used to abort client startup: `RBX::initialization_error`. Thrown by graphics-backend failure (`View::initializeView` — "Your graphics drivers seem to be too old...") and caught in `_tWinMain` around `Application::Initialize` (main.cpp step 9: FASTLOGS + MessageBoxA + clean shutdown).

## API

```cpp
namespace RBX {
class initialization_error : public std::runtime_error {
public:
    initialization_error(const char* const errorMessage) :
      std::runtime_error(errorMessage) {}
};
}
```

No extra members; `e.what()` carries the user-facing message shown by the WndInit error MessageBox.

## Usage

Include wherever startup can bail with a presentable message; catch as `RBX::initialization_error` specifically (not `std::exception`) when you want only the controlled-failure path.

## Gotchas

- Only a `const char*` ctor — constructing from std::string requires `.c_str()`.
