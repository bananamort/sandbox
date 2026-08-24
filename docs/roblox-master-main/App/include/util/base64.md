# util/base64.hpp

## Purpose
Header-only base64 codec (Konstantin Pilipchuk, via codeguru; vendored by Erik Cassel 12/21/05). STL-style `base64<_E,_Tr>` class with `put` (encode) / `get` (decode) iterator interfaces plus a Roblox-added convenience `encode()` static that returns `std::string`.

## Declared API
```cpp
template<class _E = char, class _Tr = std::char_traits<_E> >
class base64 {
public:
    typedef unsigned char byte_t;

    // Line-ending policies: lf, crlf, crlfsp, noline (functors applied to output iterator)
    struct lf; struct crlf; struct crlfsp; struct noline;

    // Roblox convenience wrapper:
    template <class _Endline>
    static void encode(const char* input, size_t length, std::string& output, _Endline _Endl);

    template<class _II, class _OI, class _State, class _Endline>
    _II put(_II _First, _II _Last, _OI _To, _State& _St, _Endline _Endl) const;   // encode

    template<class _II, class _OI, class _State>
    _II get(_II _First, _II _Last, _OI _To, _State& _St) const;                   // decode
protected:
    int _getCharType(int C) const;
};
```
Standard alphabet `A–Z a–z 0-9 + /` with `=` padding. `_State` accumulates iostream bits (`failbit`/`eofbit`/`badbit`) via macros `_IOS_*`.

## Gotchas
- Encoding inserts line breaks every 18 encoded groups (~72 chars per MIME rule) unless `noline` is passed — decoded input must tolerate newlines (the decoder skips unknown chars including whitespace).
- Decode error reporting is loose by design: several malformed-input cases only set `_IOS_EOFBIT` and comments say "ignore it" — do not treat absence of `failbit` as strict validation.
- A leading `=` or second-char `=` sets failbit; trailing padding of 1 or 2 `=` handled.
- `_base64Chars` is a file-`static` mutable-looking array (actually non-const!) at namespace scope in a header — every TU gets its own copy; beware ODR/bloat quirks.
- Uses old-style MSVC-era identifiers (`_First`, `_St`, reserved underscore names); not modern C++.

## UNKNOWN
- Which callers use which line-end policy (`ProtectedString.h`-adjacent serialization is a likely consumer but unconfirmed here).
