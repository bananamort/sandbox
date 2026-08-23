# App/include/gui/ProfanityFilter.h

## Purpose

Declares `RBX::WordList` (an encrypted blacklist of profane words, decrypted at construction) and `RBX::ProfanityFilter`, a ScopedSingleton wrapping the word list behind a static `ContainsProfanity` check used by chat and naming paths.

## Declared API

- `class RBX::WordList`
  - Private: `std::set<std::string> blacklist; void decrypt(std::string& str);`
  - `WordList(); ~WordList(); bool ContainsProfanity(std::string str);` — takes string BY VALUE (decrypt mutates the copy).
- `class RBX::ProfanityFilter : public ScopedSingleton<ProfanityFilter>`
  - Private: `WordList* wordlist; bool ContainsProfanityWorker(std::string str);`
  - `ProfanityFilter(); ~ProfanityFilter(); static bool ContainsProfanity(const std::string& str);`

## Usage notes

- Depends on `Util/ScopedSingleton.h`; access is via the scoped-singleton lookup, so a ProfanityFilter must be alive in scope for the static call to succeed.

## Gotchas

- `ContainsProfanity(const std::string&)` forwards to workers taking by-value strings that get decrypted in place — obfuscation is per-string at runtime, not stored plaintext.
- Raw owning pointer `wordlist` with destructor cleanup; copying the filter would double-free.
- UNKNOWN: exact decryption scheme and blacklist contents live in the .cpp/data (not in this header).
