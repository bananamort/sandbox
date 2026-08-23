# App/include/security/FuzzyTokens.h

## Purpose

Fuzzy anti-tamper security reporting tokens. The client accumulates tamper-evidence bits into a tag that is TEA-encrypted before transmission; each individual '1' bit only has a ~50% chance of surviving encryption, but because checks re-fire continuously an exploiter's signal gets through quickly while naive packet tampering almost certainly corrupts the report. The server side (`ServerFuzzySecurityToken`) decrypts and treats any set bit as suspicious ("fuzzy" one-way detection).

## Declared API

- `namespace RBX::Security { unsigned long long teaDecrypt(unsigned long long); unsigned long long teaEncrypt(unsigned long long); }` — TEA cipher round-trip for tags (implemented elsewhere).
- `namespace RBX::Tokens { union binaryTag { unsigned int asHalf[2]; unsigned long long asFull; }; }` — dual-view of the 64-bit tag.
- `class ClientFuzzySecurityToken`
  - State: current `tag`, `prevTag`, `savedTag` (all `binaryTag`) + `boost::mutex tokenMutex`.
  - `ClientFuzzySecurityToken(unsigned long long inTag)` / `void set(inTag)`.
  - `void addFlagFast(unsigned long long flags)` — unsynchronized OR (forced-inline).
  - `void addFlagSafe(unsigned long long flags)` — mutex-guarded OR (forced-inline).
  - `unsigned long long crypt()` — encrypt-and-rotate for transmission; `unsigned long long getPrev()` returns previous transmitted tag.
- `class ServerFuzzySecurityToken`
  - `ServerFuzzySecurityToken(inTag, ignoreFlags = 0)`; `setLastTag(tag)`; `unsigned long long decrypt(inTag)`.
  - Comment: each '1' from client has 50% chance of being '0' server-side, hence "fuzzy".
- Global tokens: `extern ClientFuzzySecurityToken sendStatsToken;` `extern unsigned int simpleToken;` `extern ClientFuzzySecurityToken apiToken;`

## Usage notes

- Producers (e.g. `RBX::Security::callCheckSetBasicFlag` / `callCheckSetApiFlag` in ApiSecurity.h) call `addFlagFast/Safe` with bit flags; something periodically calls `crypt()` and ships the result to the server for `decrypt`.

## Gotchas

- Header includes only boost mutex; the TEA functions and global token definitions live in a .cpp elsewhere.
- `addFlagFast` is deliberately lock-free — safe only where races are acceptable; use `addFlagSafe` otherwise.
- Fuzziness is asymmetric by design: false negatives are common, false positives are not; never treat a clean packet as proof of health.
