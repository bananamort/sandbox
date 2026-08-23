# Network/Dictionary.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 204 lines)

## Purpose

Implements the out-of-line pieces of the Dictionary templates (see Dictionary.h): default-value predicates for `std::string`/`BinaryString`, `SenderDictionary<const RBX::Name*>::send`, tamper-protection hashing in `ReceiverStringDictionary`, and the Shared*Dictionary property (de)serialization wrappers.

## API

```cpp
template<> bool SenderDictionary<std::string>::isDefaultValue(const std::string&);   // empty()
template<> bool SenderDictionary<BinaryString>::isDefaultValue(const BinaryString&); // value().empty()
void SenderDictionary<const RBX::Name*>::send(RakNet::BitStream&, const RBX::Name*);
template<> void ReceiverDictionary<std::string>::setDefault(std::string&);   // clear
template<> void ReceiverDictionary<BinaryString>::setDefault(BinaryString&);
void ReceiverStringDictionary::learn(unsigned char id, const std::string&);
bool ReceiverStringDictionary::get(unsigned char id, std::string&);
// SharedStringDictionary / SharedStringProtectedDictionary / SharedBinaryStringDictionary:
//   serializeString(std::string|BinaryString|ConstProperty, BitStream)
//   deserializeString(std::string|BinaryString|Property, BitStream)  [protected variants return bool]
```

Protection scheme: on learn with `protection==true`, stores `boost::hash<std::string>("a" + value + "s")` per id; get recomputes and clears value + returns false on mismatch ("Someone has been messing with our content... death to the infidels").

## Usage

Property-string replication inside Replicator/ClientReplicator/ServerReplicator; includes `util/RobloxGoogleAnalytics.h` and `streaming.h` though no analytics calls appear in this file — UNKNOWN whether that include is vestigial.

## Gotchas

- `hashTable.reset(new std::size_t[DICTIONARY_SIZE])` stored in a `std::auto_ptr<std::size_t>` — array deleted without `[]` (UB pre-C++11, benign-ish in practice).
- Protected get returns false but still hands back the (cleared) string; callers must check the bool.
- `deserializeString(Property&)` skips setting when `property.getInstance()` is null.
