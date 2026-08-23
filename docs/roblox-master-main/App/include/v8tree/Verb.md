# App/include/v8tree/Verb.h

## Purpose

Declares the legacy command/"verb" system: `RBX::Verb` (named, container-bound action with enable/check/select state — historically wired to menus/toolbars), its callback-based `BoundVerb` convenience subclass, inert `NullVerb`, `VerbContainer` (a name→Verb registry with optional parent chaining), and `IDataState` (dirty-flag interface passed to `doIt`). Includes anti-tamper gating: executing a security-carrying verb outside studio raises a hack flag (`doItWithChecks`).

## Declared API

- `LOGGROUP(Verbs)` — fast-log group.
- `class IDataState` (RBXInterface) — pure virtual `setDirty(bool)`, `isDirty()`.
- `class Verb` (RBXBaseClass)
  - Protected ctors: `Verb(VerbContainer*, const std::string& name, bool blacklisted = false)` and `Name&` overload; protected field `bool verbSecurity`.
  - Virtuals: `~Verb()`, `isEnabled()` (true), `isChecked()` (false), `isSelected()` (false), `getText()` ("") , `void doIt(IDataState*) = 0`.
  - `const Name& getName()`, `VerbContainer* getContainer()`, `bool getVerbSecurity()`.
  - `static void doItWithChecks(Verb*, IDataState*)` — non-studio builds: if verb has `verbSecurity` set, records `Security::hackFlag9` via `setHackFlagVs<LINE_RAND1>(..., HATE_VERB_SNATCH)` instead of running; studio builds run directly.
- `class BoundVerb : Verb` — ctor takes container, name, `doItFunction`, optional `isEnabledFunction/isCheckedFunction/getTextFunction` (`boost::function`s over `VerbContainer*`); overrides dispatch to the callbacks, falling back to base behavior when null.
- `class NullVerb : Verb` — always disabled, no-op doIt.
- `class VerbContainer`
  - Ctors `(VerbContainer* parent)`; virtual dtor.
  - `Verb* getVerb(const Name&)` / `(const std::string&)` — searches both maps then parent chain (implementation-side).
  - `getWhitelistVerb(...)` overloads incl. obfuscating 3-piece `(prefix, name, suffix)` lookup; `setVerbParent(parent)`, `getVerbParent()`.
  - `template<class F> void eachVerbName(F f, bool includeParent = true)` — iterates whitelist then blacklist names, recursing into parent.
  - Internal: two registries `whitelistVerbs` ("UI verbs") and `blacklistVerbs` ("tools"), both `std::map<const Name*, Verb*>`; friends `Verb` for add/remove.

## Usage notes

- Tools register verbs in containers; UI enumerates via `eachVerbName`/`getWhitelistVerb` to build menus. Execute through `Verb::doItWithChecks`, never raw `doIt`, for secured verbs.

## Gotchas

- Despite the names, *both* maps are consulted by plain `getVerb`; "blacklistVerbs" are tool verbs kept separate from whitelisted UI verbs rather than denied verbs.
- `doItWithChecks` silently converts secured verb execution into a hack-flag report in client builds — verbs flagged `verbSecurity` will never run there.
- Verb lifetime is managed by their owning container (friend access for registration/removal).
