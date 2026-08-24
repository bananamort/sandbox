# App/include/v8datamodel/Game.h

## Purpose

App-side bootstrap wrapper around a [DataModel](DataModel.md): "Encapsulates the creation of a DataModel used by client apps." Owns the verb set, performs global init/exit, and offers two concrete flavors — `SecurePlayerGame` (player client, loading screen on) and `UnsecuredStudioGame` (studio, security relaxed).

## Declared API

`class Game : boost::noncopyable`

- Protected ctor: `Game(Verb* lockVerb, const char* baseUrl, bool shouldShowLoadingScreen = false);`
- Statics: `static void globalInit(bool isStudio); static void globalExit();`
- Members: `std::vector<Verb*> verbs; boost::shared_ptr<CommonVerbs> commonVerbs; boost::shared_ptr<DataModel> dataModel; shared_ptr<GameConfigurer> gameConfigurer; bool hasShutdown;`
- Methods: `boost::shared_ptr<DataModel> getDataModel() const { return dataModel; }`; `void shutdown(); virtual ~Game(void); void setupDataModel(const std::string& baseUrl); bool getSuppressNavKeys(); void configurePlayer(RBX::Security::Identities identity, const std::string& params, int launchMode = -1, const char* vrDevice = 0);` private `doClearVerbs()/clearVerbs(bool needsLock = true)`.

`class SecurePlayerGame : public Game` — ctor `(Verb*, baseUrl, shouldShowLoadingScreen = true)`.
`class UnsecuredStudioGame : public Game` — ctor `(Verb*, baseUrl, isNetworked = false, showLoadingScreen = false)`.

## Gotchas

- Verb list is raw pointers owned elsewhere; clearVerbs takes the DataModel lock by default.
- configurePlayer carries a Security identity + launch params + VR device string — app-launch plumbing funneled through one call.

## UNKNOWN

- GameConfigurer responsibilities (.cpp / other headers).

## Cross-links

- Implementation: [App/v8datamodel/Game.md](../../v8datamodel/Game.md).
- Owned: [DataModel.md](DataModel.md), [CommonVerbs.md](CommonVerbs.md); settings kin: [GameSettings.h](GameSettings.md), [GameBasicSettings.md](GameBasicSettings.md).
