# App/include/v8xml — Index

Serialization layer for instance trees: the in-memory XML DOM (XmlElement/XmlAttribute + tag vocabulary), text-XML reader/writer, the schema-versioned place-file loader (SerializerV2 → Serializer with SaveFilter whitelists), binary place serialization (`<roblox!` magic), and web response formats (WebParser/WebSerializer JSON+XML).

## Files

- [Reference.md](Reference.md) — IIDREF / IReferenceBinder streaming reference-resolution contracts.
- [Serializer.md](Serializer.md) — Serializer extends V2 with canWriteChild SaveFilter service whitelists.
- [SerializerBinary.md](SerializerBinary.md) — binary serialize/deserialize with compression flags; kMagicHeader `"<roblox!"`.
- [SerializerV2.md](SerializerV2.md) — schema v4 loader/writer core + MergeBinder (deferred IDREF resolution for undo/redo).
- [WebParser.md](WebParser.md) — parse web responses: generic sniffing, XML tables/lists, legacy + ptree JSON.
- [WebSerializer.md](WebSerializer.md) — write ValueMap/ValueArray/Variant as XML elements.
- [XmlElement.md](XmlElement.md) — DOM node/attribute variant values, intrusive tree templates, Roblox tag vocabulary, IDREF null/nil sentinels.
- [XmlSerializer.md](XmlSerializer.md) — XmlWriter/TextXmlWriter (handle indexing, entity encoding), XmlParser/TextXmlParser (legacy hash workaround).

## Related

- Consumers: `../reflection/Property.h` (XML read/write of properties), DataModel load paths in `../v8datamodel/`.
