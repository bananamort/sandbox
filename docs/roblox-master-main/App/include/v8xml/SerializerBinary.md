# App/include/v8xml/SerializerBinary.h

## Purpose

Declares the `RBX::SerializerBinary` namespace — binary place serialization of instance trees: `serialize` an Instance root or Instances list to a stream (with compression/inexact-CFrame flags), and `deserialize` back under a root or into a list. Magic header: `"<roblox!"`.

## Declared API

- `namespace RBX::SerializerBinary`
  - `enum SerializeFlags { sfHighCompression = 1<<0, sfNoCompression = 1<<1, sfInexactCFrame = 1<<2 };`
  - `static const char kMagicHeader[] = "<roblox!";`
  - `void serialize(std::ostream& out, const Instance* root, unsigned int flags = 0, const Instance::SaveFilter saveFilter = Instance::SAVE_ALL);`
  - `void serialize(std::ostream& out, const Instances& instances, unsigned int flags = 0);`
  - `void deserialize(std::istream& in, Instance* root);`
  - `void deserialize(std::istream& in, Instances& result);`

## Usage notes

- This is the place-file serialization path (distinct from the XML formats in [Serializer.md](Serializer.md)/[XmlSerializer.md](XmlSerializer.md)).

## Gotchas

- `sfHighCompression` and `sfNoCompression` are mutually exclusive by construction; passing both is undefined behavior at the writer.
- `sfInexactCFrame` trades precision for size — do not use for round-trip-critical data.
