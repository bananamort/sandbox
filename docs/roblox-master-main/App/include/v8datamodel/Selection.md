# App/include/v8datamodel/Selection.h

## Purpose

`Selection` — the non-creatable Studio selection service (ordered instance list with copy-on-write storage), change signals for C++ and Lua, per-instance ancestry tracking, filtered-selection fan-out, and std-algorithm iterator adapters. Plus `FilteredSelection<C>` template — a Service that mirrors the root Selection restricted to type C — and support types `SelectionChanged`, `ISelectionBase`.

## Declared API

- `class SelectionChanged { friend class Selection; public: shared_ptr<Instance> const addedItem, removedItem; private ctor(added, removed); }`
- `class RBXInterface ISelectionBase { friend class Selection; virtual void onSelectionChanged(const SelectionChanged&) = 0; }`

`class Selection : public DescribedNonCreatable<Selection, Instance, sSelection>, public Service`
- State: `copy_on_write_ptr<Instances> selection`; `std::vector<ISelectionBase*> filteredSelections`; `std::map<Instance*, rbx::signals::connection> connections` (per-selected-instance ancestry watch).
- Signals: `rbx::signal<void(const SelectionChanged&)> selectionChanged`, `rbx::signal<void()> luaSelectionChanged`.
- Read API (inline): `size()`, `front()`/`back()` (NULL-safe), `begin()/end()`, `const copy_on_write_ptr<Instances>& getSelection()`, `isSelected(const Instance*)` (linear find), `shared_ptr<const Instances> getSelection2()` ("Used for reflection. Note that it might return NULL").
- Write API: `setSelection(Instance*)`; template `setSelection(_First,_Last)` (in-header comment: "can cause more events to fire than needed... more efficient than an O(n^2) algorithm" — clear then add each); `clearSelection()`; `setSelection(shared_ptr<const Instances>)`; `addToSelection(...)` ×3 overloads incl. template range; `toggleSelection(...)` ×3; `removeFromSelection(...)` ×3; `virtual void onAncestryChanged(Instance* source)`.
- Iterator adapters: nested `AddIterator`, `RemoveIterator`, `ToggleIterator` — output iterators whose operator= mutates selection (std-algorithm glue).
- Filter plumbing: `addFilteredSelection(ISelectionBase*)`, `removeFilteredSelection(ISelectionBase*)`.
- Private: raiseAdded/raiseRemoved, connect/disconnect ancestry watchers, `propagateChangeSignalToLua(event)`, `instanceCanLiveInSelection(Instance*)`, `selectionChangedConnection`.

`template<class C> class FilteredSelection : public NonFactoryProduct<Instance, sFilteredSelection>, public Service, public ISelectionBase`
- `typedef std::vector<C*> CollectionType`; holds `shared_ptr<Selection> rootSelection` + `CollectionType filteredSelection`.
- Ctor sets name "FilteredSelection"; dtor detaches from root.
- `Selection* getSelection()` (asserts root present); read surface `items()/size()/front()/back()/begin()/end()` (+const); STL helpers `for_each(fn)`, `find_if(pred) → C*`.
- Pass-throughs to root Selection: `clearSelection()`, range/ptr `addToSelection/removeFromSelection/setSelection` — in-header comment: "functions like clearSelection clears EVERYTHING, even selected items that are not of type C".
- `onSelectionChanged` override inline: dynamic_cast-add / pointer-find-remove from filtered list.
- Out-of-line template `onAncestorChanged`: on first ancestor change grabs the sibling Selection service via `ServiceProvider::create<Selection>`, back-fills filter from current selection, registers itself.

## Gotchas

- setSelection(range) fires add+remove events per item rather than a diff — Lua listeners see churn.
- FilteredSelection pass-throughs mutate the GLOBAL selection (documented in-header) — surprising cross-type side effects.
- Selection holds a connection map keyed by raw Instance* — destruction ordering during shutdown matters.
- getSelection2 may return NULL by design.

## UNKNOWN

- What instanceCanLiveInSelection filters out (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Selection.md](../../v8datamodel/Selection.md).
- Visualizers: [SelectionBox.md](SelectionBox.md), [SelectionLasso.md](SelectionLasso.md), [SelectionSphere.md](SelectionSphere.md), [SurfaceSelection.md](SurfaceSelection.md); consumer: [PluginManager.md](PluginManager.md).
