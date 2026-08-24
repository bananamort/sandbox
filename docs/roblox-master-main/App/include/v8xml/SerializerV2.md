# App/include/v8xml/SerializerV2.h

## Purpose

Declares `SerializerV2`, the XML instance-tree loader/writer core (schema version 4): root element creation, text-XML loading into Instances or a special-cased DataModel, and the per-instance recursive XML reader. Also declares `RBX::MergeBinder`, an IReferenceBinder that defers unresolved IDREFs so an XML stream can be merged into an existing world (undo/redo).

## Declared API

- `class SerializerV2` ("TODO: Refactor: Call this RBX::DOM or something")
  - Protected member `int schemaVersionLoading;` public static `const int CURRENT_SCHEMA_VERSION = 4;`
  - Writing: statics `newRootElement()` / `newRootElement(const std::string& type)`.
  - Reading: `void loadInstancesFromText(const XmlElement* root, RBX::Instances& result);` `void load(std::istream&, RBX::DataModel*);` ("Until DataModel becomes an Instance and it can handle 'globals' like Workspace, we need to treat it specially during reads") `void loadInstances(std::istream&, RBX::Instances&);`
  - Private: loadXML(stream, DataModel), loadInstancesXML(root, result, IReferenceBinder&, CreatorRole), loadInstanceXML(itemElement, binder, creatorRole) returning shared_ptr<Instance>.
  - Wrapped in `#pragma warning(disable:4290)` on G3D_WIN32 (exception-specification warnings).
- `class RBX::MergeBinder : public IReferenceBinder`
  - Private nested `struct IDREFItem { const IIDREF* idref; Reflection::DescribedBase* propertyOwner; RBX::InstanceHandle value; };` vector deferredIDREFItems ("TODO: vector or list???").
  - announceID → processID: reads InstanceHandle from the pair, `linkTo(shared_from(source))`; value "nil" means skip (like xsi:nil).
  - announceIDREF → processIDREF (asserted true): immediate assign when handle non-empty, else defer into deferredIDREFItems.
  - resolveRefs(): assigns all deferred items then clears; always returns true.
  - Both process methods protected virtual — subclass hook points.

## Usage notes

- [Serializer.md](Serializer.md) extends this with SaveFilter policy.
- MergeBinder is the undo/redo paste path — deferred refs let forward references resolve after the whole subtree loads.

## Gotchas

- CURRENT_SCHEMA_VERSION = 4 gates format compatibility; schemaVersionLoading drives any migration logic in the .cpp.
- processIDREF asserts success — malformed files with unresolvable refs crash checked builds instead of skipping.
