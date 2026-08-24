# App/include/v8xml/XmlElement.h

## Purpose

The in-memory DOM for Roblox XML: `XmlNameValuePair` (tagged variant value: NONE/NAME/STRING/CONTENTID/BOOL/INT/UINT/FLOAT/HANDLE/DOUBLE with converting get/set), the intrusive `Parent<ChildClass>`/`Sibling<SiblingClass>` left-child/right-sibling-with-tail tree templates, `XmlAttribute`, and `XmlElement` (element + attribute list + children, recursive delete). Also declares the extern tag vocabulary (`name_referent`, `tag_Item`, `tag_token`, CFrame R00–R22 matrix tags, Web* tags, customPhysProp...) and the special IDREF sentinel values `null`/`nil`.

## Declared API

- `typedef RBX::Name XmlTag;` (std::string typedef commented out)
- IDREF sentinels — header comment explains W3C XSD forbids empty/nil IDREFs so Roblox defines two strings: "nil" = "don't change your current value", "null" = "set your value to NULL": `extern const RBX::Name& value_IDREF_null; value_IDREF_nil;`
- ~60 extern const XmlTag& declarations ("TODO: Put these in a file that knows about the Roblox schema"): root/roblox/xsi attributes, version/assettype, referent/Ref/token/name, bool/Refs/X/Y/Z, R00..R22, R/G/B, class/Item/Properties/Feature, hash/null/mimeType, S/O, XS/XO/YS/YO, faces/axes, Origin/Direction, Min/Max, WebTable/WebList/WebEntry/WebKey/WebValue/WebType, customPhysProp family.
- `class XmlNameValuePair`
  - `typedef enum { NONE, NAME, STRING, CONTENTID, BOOL, INT, UINT, FLOAT, HANDLE, DOUBLE } ValueType;` (UINT macro undef'd on non-Win32 first).
  - Private: `const XmlTag& tag; mutable ValueType valueType;` anonymous union of mutable pointers/values (string*, ContentId*, bool/int/uint/float/double, Name*, InstanceHandle* — TODO asks about avoiding "new" for handle); private clearValue() const.
  - Ctors per type (heap-allocates string/ContentId/handle); dtor clears.
  - Queries: getTag; isValueEmpty; isValueEqual(...) ×8 typed overloads + client-implementable template; toString(XmlWriter*) ; isValueType<T>() template; getValueType.
  - Converting getters getValue(T&) ×9 + template ("If possible, these functions will convert valueType to the desired type"; TODO rename toValue).
  - setValue overloads ×10 (std::string, ContentId, const char*, int, unsigned int, bool, float, double, const Name*, InstanceHandle — FIXED from 9: the `const char*` overload was missed) + template (clear then set).
- `namespace RBX`: `template<class ChildClass> class Parent` — first/last pointers; pushBackChild/pushFrontChild/addChild/removeChild (linear unlink), firstChild/nextChild const+non-const. `template<class SiblingClass> class Sibling` — next pointer; setNextSibling is PRIVATE, friended to Parent only.
- `class XmlAttribute : RBX::Sibling<XmlAttribute>, XmlNameValuePair, RBX::Allocator<XmlAttribute>` — tag ctor + templated value ctor.
- `class XmlElement : RBX::Sibling<XmlElement>, RBX::Parent<XmlElement>, XmlNameValuePair, RBX::Allocator<XmlElement>`
  - _DEBUG-only `char leak[15]; recordLeak();` writing "XmlElement" (leak-tagging aid).
  - Private: `RBX::Parent<XmlAttribute> attributes;`
  - Ctors (plain/templated); recursive dtor deleting all attributes then all child elements.
  - Attributes: isXsiNil() ("returns true if this element has an xsi:nil attribute with value true"); templated addAttribute(tag, value); first/next attribute iterators const+mutable; findAttribute(tag) ×2; inline findAttributeValue(tag, Name*/std::string&) ×2.
  - Children: addChild(element|tag); findFirstChildByTag(tag); findNextChildWithSameTag(node).

## Usage notes

- The entire place-file format (Serializer/SerializerV2) and web response format are built from these nodes.

## Gotchas

- XmlElement dtor deletes recursively — building shared structures by raw pointer will double-free; ownership is strictly tree-shaped.
- getValue conversions mutate nothing but can silently reinterpret (e.g. int→bool) per .cpp rules; check return codes.
- Header-level comment: xsi:nil on IDREF means "don't change when reading me" — loaders must honor it or they'll nil out references.
