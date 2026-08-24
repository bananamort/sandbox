# Network/API.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 282 lines)

## Purpose

The Network module's registration and security-bootstrap translation unit ("third time's the charm"): registers all Network classes/enums with the reflection system (`RBX_REGISTER_CLASS` / `RBX_REGISTER_ENUM`), initializes RakNet string compression singletons safely, builds the obfuscated protocol `versionB` + `securityKey` strings per platform, installs the secure-replicator factory for RCC builds, exposes `isTrustedContent` URL allow-listing, and spawns a VMProtect-backed anti-debugger thread on Windows player builds.

## API

No outbound HTTP calls are made from this file. (`isTrustedContent` inspects URLs but its check is short-circuited; see Gotchas.)

```cpp
namespace RBX::Network {
    extern std::string versionB;        // protocol version string sent during connection handshake
    extern std::string securityKey;     // shared secret sent client→server

    bool isPlayerAuthenticationEnabled();
    bool isNetworkClient(const Instance* context);
    void initWithServerSecurity();      // server path; under RBX_RCC_SECURITY also sets
                                        // Server::createReplicator = createSecureReplicator
                                        // (creates CheatHandlingServerReplicator) and
                                        // _isPlayerAuthenticationEnabled = true
    void initWithPlayerSecurity();      // normal game client/server
    void initWithCloudEditSecurity();   // alternate versionB: "^" + char(17)
    void initWithoutSecurity();         // reflection forcing + NetworkSettings::singleton(),
                                        // wrapped in VMProtectBeginMutation("22")
    void setVersion(const char* version);
    void setSecurityVersions(const std::vector<std::string>& versions); // → Server::setAllowedSecurityVersions
    bool isTrustedContent(const char* url);
}
extern unsigned int RBX::initialProgramHash; // defined here, 0
void RBX::spawnDebugCheckThreads(weak_ptr<DataModel>);  // _WIN32 && !STUDIO && !DURANGO only
```

Registrations performed: classes `Client`, `Server`, `Player`, `Players`, `NetworkSettings`, `Peer`, `Marker`, `Replicator`, `ServerReplicator`, `ClientReplicator`, `GuidRegistryService`; enums `PacketPriority`, `PacketReliability`, `FilterResult`, `Player::MembershipType`, `Player::ChatMode`, `Players::PlayerChatType`, `Players::ChatOption`, `NetworkSettings::PhysicsSendMethod`, `NetworkSettings::PhysicsReceiveMethod`. Also pins `RAKNET_PROTOCOL_VERSION == 5` with a compile-time error.

## Usage

- Every process entry point calls one of the `initWith*Security` functions before touching networking; they must be called exactly once per DataModel lifetime because `versionB` accumulates characters (`initVersion1` appends `'7'` + `char(79)`='O', `initWithoutSecurity` appends `"^"` + `char(17)`, `initVersion2` appends `"l"` + `'E'`) unless overridden by `setVersion` or reset by `initWithCloudEditSecurity`.
- The embedded keys are rot13-obfuscated SHA1 digests of `<version>+<platform>+<product>+<salt>` strings (e.g. Windows player key from `"0.235.0pcplayeraskljfLUZF"`); internal/debug/iOS/Android/Durango builds share one fixed test key.
- `spawnDebugCheckThreads` polls `VMProtectIsDebuggerPresent(true)` every 1500 ms and ORs `HATE_DEBUGGER` into the DataModel hack flags when triggered.

## Gotchas

- `isTrustedContent` is effectively dead code: a local constant `kSkipNetworkTrustedContentCheck = true` makes it return true for any URL that `ContentProvider::isUrl` accepts. The unreachable remainder would restrict hosts to `roblox.com/`/`.robloxlabs.com/` plus an extension allow-list (`asset`, `game`, `analytics`, `ide`, `images`, `thumbs`, `ui`, `persistence`, `rolesets`, `auth`, `currency`, `marketplace`, `ownership`, `placerolesets`).
- Security keys are compiled in with only rot13 "obfuscation"; anyone can recover them statically.
- `SafeInitFree` exists solely so `RakNet::StringCompressor`/`StringTable` refcounts increment before any peer constructs them (static init order safety).
- The anti-debug loop runs unbounded `while(true)` (1.5 s sleeps) and only exits when the DataModel dies; the `boost::thread` is a stack local in `spawnDebugCheckThreads` that goes out of scope immediately after spawn — what happens then depends on the boost::thread destructor semantics of the (unvendored) boost build and cannot be confirmed from this repo. [UNSUPPORTED: "leaks the thread intentionally" could not be verified]
