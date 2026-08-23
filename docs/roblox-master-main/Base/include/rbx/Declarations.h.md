# Declarations.h

## Purpose
Declares the `RBXInterface` / `RBXBaseClass` decoration macros marking abstract classes whose vtables may be skipped. On MSVC they expand to `__declspec(novtable)` (documented inline via an MSDN article excerpt: suppresses vtable initialization for classes only used as bases); on other compilers they expand to nothing.

## API
```cpp
#ifdef _WIN32
#define RBXInterface  __declspec(novtable)
#define RBXBaseClass  __declspec(novtable)
#else
#define RBXInterface
#define RBXBaseClass
#endif
```

## Usage
Applied to pure-interface classes across the engine (`RBXInterface` = only pure virtuals + trivial members; `RBXBaseClass` = partial implementation never instantiated directly).

## Gotchas
- In-file warning applies to BOTH macros on Windows: you cannot define a virtual destructor in such a class — destruction must be routed through a derived concrete class or the vtable call faults at construction/destruction time.
- Distinction between the two macros is purely documentary; they expand identically.
