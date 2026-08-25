# App/include/solver/DebugSerializer.h

## Purpose

Raw host-byte-order byte-buffer serializer used by [SolverSerializer.md](SolverSerializer.md) to record solver frames. Everything is appended into a public `std::vector<char> data` via `operator&` overloads; a SFINAE trait dispatches to any type's own `serialize(DebugSerializer&) const` method. `DebugSerializerScope` implements length-prefixed blocks.

## Declared API

- `template<typename T> struct HasSerializeMethod` — classic SFINAE detector for member `void U::serialize(DebugSerializer&) const`; `static const bool value`.
- `class DebugSerializer`
  - `void clear()`.
  - `storeAt(const T& t, size_t index)` (arithmetic only via `boost::enable_if<is_arithmetic>`) — memcpy-by-union of `sizeof(T)` bytes at an absolute index; returns `*this`.
  - Arithmetic `operator&` — resize + storeAt append.
  - Enum `operator&` — raw bytes of the enum through a uint8 union (no underlying-type normalization).
  - Value overloads: `Vector3` (x,y,z), `Quaternion` (x,y,z,w), `Matrix3` (three rows), `simd::v4f` (four `simd::extractSlow` lanes), `std::pair<T,U>`.
  - Container overloads: `ArrayBase<T>` and `std::vector<T>` write a `boost::uint32_t` size prefix then elements.
  - SFINAE overload: any non-pointer `T` with `HasSerializeMethod<T>::value` calls `t.serialize(*this)`; pointer overload calls `t->serialize(*this)`.
  - `DebugSerializer& tag(const char*)` — uint8 length + chars.
  - Public member: `std::vector<char> data;`.
- `class DebugSerializerScope` — ctor `(DebugSerializer&)`: records current buffer size, appends a zero `size_t` placeholder (commented-out checksum slot follows); dtor patches the placeholder with the number of bytes written inside the scope.

## Gotchas

- No endianness or version tagging — the .bin format is host-layout dependent.
- Enum serialization writes all `sizeof(T)` bytes but types the buffer `uint8_t[...]`; enums larger than 1 byte still serialize their full width.
- `storeAt` indexes `data` directly without bounds checking — out-of-range index is UB (the scope ctor/dtor pair keeps this safe only if no other thread resizes concurrently).
- The pointer overload dereferences without a null check.
- `tag` stores the name length in a `uint8` (`boost::uint8_t length = strlen(name)`) — names ≥256 chars wrap **modulo 256** (not capped at 255), so a 300-char name writes length 44 followed by its first 44 chars.
- `DebugSerializerScope` ctor writes a `size_t` placeholder, so block sizes are 8 bytes on 64-bit hosts and 4 on 32-bit — format not portable across bitness.
