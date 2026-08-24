# util/MachineIdUploader.h

## Purpose
Anti-abuse helper: gathers machine identifying info (MAC addresses), sends it to the web banned-machine database, and reports whether this machine is banned.

## Declared API
```cpp
class MachineIdUploader {
public:
    static const char* kBannedMachineMessage;

    enum Result {
        RESULT_MachineAccepted = 1,
        RESULT_MachineBanned   = 0
    };

    // Gather identifying info, send it out, and return whether banned:
    static Result uploadMachineId(const char* baseUrl);
    static std::string getMachineId();
private:
    struct MacAddress { static const int kBytesInMacAddress = 6;
                        unsigned char address[6]; std::string asString() const; };
    struct MachineId  { std::vector<MacAddress> macAddresses; };
    static bool fillMachineId(MachineId* out);
    static bool buildMacAddressContent(bool needsLeadingAmp, const MachineId& id, std::stringstream& stream);
    static void buildContent(const MachineId& id, std::stringstream& stream);
};
```

## Gotchas
- `uploadMachineId` is a blocking network call (name says upload; returns verdict).
- Identity basis is MAC addresses — spoofable and unreliable on modern OSes (randomized Wi-Fi MACs).
- `RESULT_MachineBanned == 0`, accepted == 1: zero-initialized variables read "banned".
- Privacy-sensitive: transmits hardware identifiers to `baseUrl`.
- `needsLeadingAmp` in the content builder hints at form-encoded payload assembly.

## UNKNOWN
- Exact wire format/endpoint under `baseUrl` (.cpp outside App/include).
