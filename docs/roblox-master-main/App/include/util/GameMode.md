# util/GameMode.h

## Purpose
Single typedef enum describing the session/mode the engine is running in (server vs client vs edit vs solo visit etc.), scoped under `RBX::Network`.

## Declared API
```cpp
namespace RBX::Network {
    typedef enum {
        GAME_SERVER,
        DPHYS_GAME_SERVER,   // dedicated physics game server
        CLIENT,
        DPHYS_CLIENT,
        WATCH_ONLINE,
        VISIT_SOLO,
        EDIT,
        LOCAL_PLAY
    } GameMode;
}
```

## Gotchas
- No zero-value sentinel; `GAME_SERVER` == 0 is a meaningful mode — beware uninitialized/zero-initialized variables reading as GAME_SERVER.
- DPHYS variants denote "dedicated physics" splits of server/client.

## UNKNOWN
- Where GameMode is set/consumed (network/session code outside this slice).
