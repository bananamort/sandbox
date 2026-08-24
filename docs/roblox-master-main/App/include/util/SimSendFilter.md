# util/SimSendFilter.h

## Purpose
Small POD-ish struct describing where a simulation update may be sent: the network role/mode, target `SystemAddress`, and a 2D interest `Region2`. Default mode is Client.

## Declared API
```cpp
class SimSendFilter {
public:
    typedef enum { EditVisit, Client, Server, dPhysClient, dPhysServer } Mode;

    Mode               mode;
    RBX::SystemAddress networkAddress;
    Region2            region;

    SimSendFilter() : mode(Client) {}
};
```

## Gotchas
- `networkAddress` and `region` are default-constructed (SystemAddress/Region2 defaults) — not zeroed explicitly.
- Mode enum mirrors GameMode.md concepts (client/server/dphys/edit-visit).
- All members public: treat as a plain data record.

## UNKNOWN
- Consumers in replication send-path code (outside this slice).
