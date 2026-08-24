# App/include/v8xml/XmlSerializer.h

## Purpose

Declares the text-XML plumbing: `XmlWriter` base (shared handle/ID bookkeeping for referential integrity), `TextXmlWriter` (indented text serialization with entity/CDATA encoding), and the parser side `XmlParser` base + `TextXmlParser` (hand-rolled streaming XML reader with a legacy MD5-hash workaround map).

## Declared API

- `class RBXBaseClass XmlWriter : boost::noncopyable`
  - Protected: `std::map<RBX::InstanceHandle, int> handles;` typedef `IdValidationMap = boost::unordered_map<std::string, RBX::InstanceHandle>` member `idValidationMap;` `std::ostream& stream;` protected ctor.
  - Pure virtual `void serialize(const XmlElement* xmlNode);`
  - Inline `int getHandleIndex(RBX::InstanceHandle h)` — assigns sequential indices on first sight ("TODO: Should this be size_t getHandleIndex?").
  - Inline `isValidId(id, h)` / `recordId(id, h)` (records assert validity first).
- `class TextXmlWriter : public XmlWriter`
  - ctor(stream); override serialize(node); protected serialize(node, depth), writeOpenTag/writeCloseTag(element, depth), serializeNode.
  - Public statics: `xmlEncodedWrite(std::ostream&, const std::string&)` and `xmlOrCDataEncodedWrite(...)`.
- `class XmlParser : boost::noncopyable`
  - Protected: `std::streambuf* buffer; std::stack<XmlElement*> elements;` protected ctor.
  - Pure virtual `std::auto_ptr<XmlElement> parse();`
- `class TextXmlParser : public XmlParser`
  - Member comment: "workaround for a bug in the MD5 hasher" — `std::map<std::string,std::string> legacyHashes;`
  - parse() override; private helpers skipWhitespace, readTag/readFirstTag/readText(bool decode), removeTag/findNextToken/findText, parseAttributes.

## Usage notes

- Feeds/consumes [XmlElement.md](XmlElement.md) trees; higher-level formats in Serializer/SerializerV2.

## Gotchas

- `legacyHashes` exists because historical files contain wrong MD5 content hashes — do not "clean up" without understanding which legacy files hit it.
- Handle index assignment is insertion-order dependent; reordering writes changes serialized Ref ids.
