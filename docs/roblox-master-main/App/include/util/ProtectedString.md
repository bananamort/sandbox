# App/include/util/ProtectedString.h

## Purpose

Declares `RBX::ProtectedString`, the tamper-resistant container for script source and precompiled bytecode. Source strings can only enter through `fromTrustedSource` (the `setString` setter is private), bytecode through `fromBytecode`, so ordinary code cannot smuggle raw text into the VM; a lazily cached hash (`boost::scoped_ptr<std::string>`) supports dedup/caching without exposing the contents.

## Declared API

- `class RBX::ProtectedString`
  - `static const ProtectedString emptyString`.
  - Factories: `static ProtectedString fromTrustedSource(const std::string&)`, `static ProtectedString fromBytecode(const std::string&)`, `static ProtectedString fromTestSource(const std::string&)` — comment: "Only use in unit tests!".
  - Default + copy ctors; assignment operator.
  - `const std::string& getSource() const`, `const std::string& getBytecode() const`, `bool empty() const` (true iff both empty).
  - `const std::string& getOriginalHash() const` (lazy, returns ref to cached hash), `void calculateHash(std::string* out) const`.
  - `operator==` / `operator!=`.
  - Private: `std::string source`, `std::string bytecode`, `scoped_ptr<std::string> hash`, `void setString(newSource, newBytecode)` (hidden to force `fromTrustedSource`).
- `size_t hash_value(const ProtectedString&)` — free function for boost.hash compatibility.

## Usage notes

- Storage model: either `source` (plain Lua text, compiled later by ScriptContext) or `bytecode` (pre-compiled, e.g. from replicated CoreScripts) is populated, not necessarily both.
- Hash is kept behind a pointer "to keep the size of this object in line with other lua-bridged types" per the header comment.

## Gotchas

- `getSource()` on a bytecode-only ProtectedString returns an empty string (and vice versa) — callers must check which representation they hold.
- Nothing in this class actually encrypts anything; "protected" refers to the restricted construction path enforced at compile time.
- `getOriginalHash()` returns a reference into the lazily allocated cache — safe while the object lives, but it mutates logical const state.
