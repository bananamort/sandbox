# Network/Dictionary.h

**Module**: Network (root) · **Type**: header (.h, 360 lines, mostly template code)

## Purpose

Bandwidth-saving string/name dictionaries for replication: a 128-slot cyclic "dictionary" shared per-connection so repeating the same string costs 8 bits instead of full bytes. `SenderDictionary` teaches new entries (id | 0x80 followed by the value) and thereafter sends bare ids; `ReceiverDictionary` mirrors the learning. `id==0` is reserved for the empty/default item.

## API

```cpp
#define DICTIONARY_SIZE 128   // must be power of 2; ids use [1..127]

template<class T> class SenderDictionary {
    bool canSend(const T&);                       // id already taught?
    bool trySend(RakNet::BitStream&, const T&);   // only send if known (no teach)
    void send(RakNet::BitStream&, const T&);      // teach-on-first-use
    void sendEmptyItem(RakNet::BitStream&);
};
template<class T> class ReceiverDictionary {
    void learn(unsigned char id, const T&);
    bool get(unsigned char id, T&);               // always returns true (template version)
    bool receive(RakNet::BitStream&, T&);         // handles 0 / 0x80-teach / bare-id cases
};
class ReceiverStringDictionary {                  // adds optional hash "protection"
    ReceiverStringDictionary(bool protection);
    void learn(unsigned char id, const std::string&);
    bool get(unsigned char id, std::string&);     // false if tamper hash mismatch
};
class SharedDictionary<T>        : SenderDictionary<T>, ReceiverDictionary<T>;
class SharedStringDictionary     : SenderDictionary<std::string>, ReceiverDictionary<std::string>
    // serializeString/deserializeString for raw strings and Reflection properties;
    // send/trySend overloads for RBX::Name and const char*; receive into const RBX::Name*
class SharedStringProtectedDictionary : SenderDictionary<std::string>, ReceiverStringDictionary
    // deserializeString returns bool; false = "they were cheating"
class SharedBinaryStringDictionary : SenderDictionary<BinaryString>, ReceiverDictionary<BinaryString>;
```

Specialization `SenderDictionary<const RBX::Name*>` uses `boost::unordered_map`; its `send` is implemented in Dictionary.cpp.

## Usage

Members of Replicator/ClientReplicator/ServerReplicator for property strings, names and binary strings (`ID_DATA` payload encoding).

## Gotchas

- Cyclic replacement: when slots run out the *oldest* entry is silently evicted — receiver and sender must stay perfectly in lockstep or ids desynchronize (no resync mechanism here).
- Template `ReceiverDictionary<T>::get` always returns true with no validation; only the string-protected variant validates.
- `SharedStringProtectedDictionary::receive` calls `RBX::Name::declare`, whose TODO warns of unbounded Name-database growth on malicious input.
- `#pragma optimize("", off/on)` wraps learn/get/receive — deliberately unoptimized (debuggability/tamper checks).
