# Game.cpp

## Purpose

Implements the `Game` application shell and its security variants `SecurePlayerGame` / `UnsecuredStudioGame`: one-time global init (Http backend per platform + cookie policy, Profiling, FactoryRegistrator, settings singletons, Block statics, profanity filter), per-game DataModel creation with verb registration, and shutdown sequencing.

## Key types and API

No descriptors. Flag: `DYNAMIC_FASTFLAGVARIABLE(PersistenceCurlCookies, false)`. Static: shared ProfanityFilter.

- `Game::globalInit(isStudio)` — Http::init (XboxHttp/WinInet/WinHttp by platform; cookie sharing = single-process-multi-thread, or multi-process-write (+read for Studio) under PersistenceCurlCookies on Win/Mac); Profiling::init(false); static FactoryRegistrator; Analytics InfluxDb throttle-seed init; GlobalAdvancedSettings/GameSettings/LuaSettings/DebugSettings/PhysicsSettings singletons; `Block::init()` early ("make sure it doesn't get destroyed before other static objects").
- `SecurePlayerGame` ctor — once-per-process `Network::initWithPlayerSecurity` (the #else server-security branch is commented "Don't ship with this!").
- `UnsecuredStudioGame` — networked builds call `Network::initWithoutSecurity` once.
- `Game` ctor — creates DataModel (heartbeat on), submits setupDataModel as a Write task.
- `setupDataModel(baseUrl)` — ScriptInformationProvider asset URL "<base>/asset/", ContentProvider base URL, dataModel->setGame(this), CommonVerbs + 9 camera/toggle verbs pushed, touch-enabled detection from UIS platform (IOS/ANDROID true) feeding GameBasicSettings GA recording.
- `shutdown()` — idempotent via hasShutdown; clearVerbs(true) under LegacyLock then DataModel::closeDataModel + release; doClearVerbs impersonates Security::COM.
- `configurePlayer(identity, params, launchMode, vrDevice)` — PlayerConfigurer over the DataModel.

## Usage / reflection touchpoints

Owns [DataModel](DataModel.md); verb set from [Commands](Commands.md)/[CommonVerbs](CommonVerbs.md); settings peers [GameSettings](GameSettings.md)/[DebugSettings](DebugSettings.md).

## Gotchas

- globalInit runs ONCE per process regardless of how many Games are created — settings singletons are process-global, not per-game.
- Verb cleanup happens under an impersonated COM identity — the lock acquisition isn't attributable to the real caller in audit logs.
- getSuppressNavKeys silently returns false after shutdown (null DataModel).
