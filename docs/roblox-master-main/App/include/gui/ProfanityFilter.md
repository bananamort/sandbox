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

- Obfuscation direction: the blacklist file entries are XOR-0x55 encrypted on disk and `decrypt`ed once during `WordList` construction; query strings are never decrypted — they are lowercased and split into words, each checked against the deobfuscated set (FIXED after .cpp verification: original text claimed the by-value parameter copies "get decrypted in place", which does not happen).
- Lazy init race handled by double-checked locking on a function-local mutex (`ContainsProfanityWorker`); bigram blacklist entries are effectively ignored (TODO in source).
- Raw owning pointer `wordlist` with destructor cleanup; copying the filter would double-free.
- UNKNOWN: exact decryption scheme and blacklist contents live in the .cpp/data (not in this header).
