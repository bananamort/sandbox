# Network/PacketIds.h

**Module**: Network (root) · **Type**: header (.h, 68 lines)

## Purpose

Defines the Roblox application-layer packet IDs layered on top of RakNet's `ID_USER_PACKET_ENUM`, plus per-traffic-class priority/reliability/channel constants. This is the authoritative map of every message type the replication, chat, physics and ticket flows exchange.

## API

```cpp
namespace RBX::Network {
enum {
    ID_SET_GLOBALS = ID_USER_PACKET_ENUM,  // Server → Client: top replication containers
    ID_TEACH_DESCRIPTOR_DICTIONARIES,
    ID_DATA,
    ID_REQUEST_MARKER,
    ID_PHYSICS,
    ID_PHYSICS_TOUCHES,
    ID_CHAT_ALL,
    ID_CHAT_TEAM,
    ID_REPORT_ABUSE,
    ID_SUBMIT_TICKET,
    ID_CHAT_GAME,
    ID_CHAT_PLAYER,
    ID_CLUSTER,
    ID_PROTOCAL_MISMATCH,      // (sic — misspelled in source)
    ID_SPAWN_NAME,
    ID_PROTOCOL_SYNC,
    ID_SCHEMA_SYNC,
    ID_PLACEID_VERIFICATION,
    ID_DICTIONARY_FORMAT,
    ID_HASH_MISMATCH,
    ID_SECURITYKEY_MISMATCH,
    ID_REQUEST_STATS
};

const PacketPriority PHYSICS_GENERAL_PRIORITY = MEDIUM_PRIORITY;
const int PHYSICS_CHANNEL = 0;

const PacketPriority DATAMODEL_PRIORITY = MEDIUM_PRIORITY;
const PacketReliability DATAMODEL_RELIABILITY = RELIABLE_ORDERED;
const int DATA_CHANNEL = 0;

const PacketPriority CHAT_PRIORITY = HIGH_PRIORITY;
const PacketReliability CHAT_RELIABILITY = RELIABLE;
const int CHAT_CHANNEL = 2;
}
```

The header also documents the connection handshake order:

```
Client --> Server  ID_NEW_INCOMING_CONNECTION
Client --> Server  ID_SUBMIT_TICKET   (client info incl. network protocol version)
Server --> Client  ID_SET_GLOBALS     (top containers: workspace, lighting, ...)
Client --> Server  ID_INSTANCE_NEW ...
Client --> Server  ID_REQUEST_CHARACTER
```

(Note: `ID_REQUEST_CHARACTER` appears only in this comment; no such enum constant exists here — UNKNOWN where it is defined.)

## Usage

Included by Replicator/ClientReplicator/ServerReplicator/Players/chat and physics senders to stamp outgoing packets and dispatch incoming ones.

## Gotchas

- Enum values are positional — inserting a value in the middle breaks protocol compatibility with older clients/servers.
- `ID_PROTOCAL_MISMATCH` misspelling is baked into the wire format name; do not "fix" it.
- Physics shares channel 0 with DataModel but uses `MEDIUM_PRIORITY` unreliably elsewhere; chat is the only HIGH_PRIORITY traffic on channel 2.
