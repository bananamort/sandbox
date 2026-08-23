# soapC.cpp

Source: `roblox-sandbox/RCCService/gSOAP/generated/soapC.cpp` (15162 lines)

## Purpose

The generated **serializer implementation file** for RCCService — the largest artifact of the tree. It implements every prototype in `soapH.h`: envelope/header/fault plumbing, the element dispatch switches (`soap_getelement`/`soap_putelement`/`soap_markelement`), the type-instantiation and deletion tables backing `soap_destroy`, and the full default/serialize/put/out/get/in/new/delete/instantiate/copy function set for each of the ~100 SOAP types (primitives, enum, data classes, 36 message classes, 36 operation wrappers, envelope structs, PointerTo reference helpers, vector templates). Stamp on line 10: *"ver 2.7.10 2018-02-23 23:46:18 GMT"*.

*Coverage note:* this doc was written from continuous verbatim reads of lines 1–5561 (globals through the first ~30 message-class serializer blocks) plus targeted verbatim reads of every remaining structurally distinct section type (data classes incl. recursive `ns1__LuaValue` at 7227–7384, array classes 7386–7654, envelope structs 8131–8778, wrapper structs 8780+, PointerTo families 13163+, vector templates 14980–15162); the unread middle is the same generated block pattern repeated per type (verified via grep anchors at lines 5534, 7099, 7227, 8131–8678, 15082).

## API

### Globals & header/fault accessors (13–129)

`soap_serializeheader/putheader/getheader`, `soap_header`, `soap_fault`, `soap_serializefault`, `soap_putfault/getfault`, and version-aware accessors:

```cpp
const char **soap_faultcode(struct soap*)   // 1.1 → &fault->faultcode ; 1.2 → Code->Value
const char **soap_faultsubcode(struct soap*) // 1.2 only; allocates Subcode chain
const char **soap_faultstring(struct soap*)  // 1.1 faultstring / 1.2 Reason->Text
const char **soap_faultdetail(struct soap*)  // 1.1 detail->__any / 1.2 Detail->__any
```

`soap_fault()` lazily allocates `SOAP_ENV__Fault` and, when `soap->version == 2` (set automatically from the envelope namespace URI), also `Code` and `Reason`. This is the machinery behind `RCCService.cpp::ExceptionAwareSoap::dispatch`'s `soap_receiver_fault(e.what())`.

### Element dispatch (132–485)

`soap_getindependent` + giant `switch (*type)` over all `SOAP_TYPE_*` ids calling `soap_in_*`; unknown types fall back to tag matching against `"ns1:<Type>"` names; final fallback sets `SOAP_TAG_MISMATCH`.

`soap_ignore_element` (487–515) consumes unexpected elements (faults on mustUnderstand or strict mode), recursively skipping nested content.

### Output dispatch (518–732)

`soap_putindependent` emits multi-ref independents for SOAP 1.1 encodingStyle; `soap_putelement` switch routes by type id to virtual `soap_out` methods or `PointerTo` helpers.

### Marker + instantiation tables (739–1860)

`soap_markelement` switch calls each type's `soap_serialize`. `soap_instantiate(soap, t, ...)` maps type id → allocator; `soap_fdelete(soap_clist*)` maps id → `delete`/`delete[]` (the pair that makes context-scoped C++ cleanup work). `soap_container_id_forward`/`soap_container_insert` (1842–1860) patch elements into vectors during id-based array parsing.

### Per-type serializer template

Primitives (1862–1965) delegate to runtime (`soap_outint` etc.) after a `SOAP_DEFAULT_*`-aware reset. The enum uses a `soap_code_map` table (`LUA_TNIL`…`LUA_TTABLE`, 1984–1991) with `soap_s2ns1__LuaType` accepting either a listed string or an integer (range-checked 0–4 only under `SOAP_XML_STRICT`). `std::string` (2050–2143) honors `SOAP_C_NILSTRING` for empty strings and assigns from `soap_string_in`.

Every compound type then gets the same block shape (illustrated by `_ns1__DiagExResponse` 2145–2288):

- `soap_default`: null pointers / primitive zeros.
- `soap_serialize`: recurse into pointer members.
- `soap_in_<T>`: `soap_class_id_enter` (alloc-or-reuse, honoring href/id multi-ref), then an infinite member loop — one guarded `soap_in_*` attempt per member using `short soap_flag_X1` occurrence counters; unknown tags go to `soap_ignore_element`; `SOAP_NO_TAG` ends the body. Under `SOAP_XML_STRICT`, leftover required flags raise **`SOAP_OCCURS`**.
- `soap_out_<T>`: begin element, emit members in declaration order (`soap_element_result` marks RPC result elements), end element.
- `new/delete/instantiate/copy` quartet wiring into the context's `clist`.

Notable members: recursive `ns1__LuaValue { type, value*, table*(ArrayOfLuaValue) }` (7227–7384) is what lets Lua tables nest arbitrarily deep in job results; `ns1__Job::soap_serialize` calls `soap_embedded` on its value-member `id` string (7825) so required strings serialize inline under multi-ref rules.

Wrapper structs `__ns2__/__ns3__<Op>` (e.g. 8780–8878): single-pointer holders whose `soap_out` just emits `ns1:<Op>` via the corresponding `PointerTo_` helper; their `soap_in` uses the flag-less two-state loop variant.

Envelope structs (~8131–8778): `Header` serializers are empty shells (all content ignored); `Fault`/`Code`/`Detail`/`Reason` follow the standard pattern.

PointerTo families (through ~14800): `soap_in_PointerTo_X` implements nullable-pointer semantics — plain element → instantiate+parse; `href="#id"` → `soap_id_lookup` forward reference; `xsi:nil` → leave NULL.

Vector templates (14980–15160): `soap_in_std__vectorTemplateOfPointerTons1__{Job,LuaValue}` loop `soap_revert` + parse + `push_back` until the repeated tag stops matching — this is how `OpenJobResult`-style unbounded sequences and `ArrayOfX` wrappers fill their vectors.

## Usage

Compiled once into the RCCService binary alongside stdsoap2.cpp; regenerated by generate.bat; never hand-edited.

## Gotchas

- Member order matters on input: the parser accepts members in *any* order (each attempt resets `error = SOAP_TAG_MISMATCH`), but duplicates beyond the flag count are silently ignored unless strict mode.
- Unknown-element tolerance means a misspelled request field parses fine but leaves the field NULL — errors surface later in `RCCServiceSoapServiceImpl` as nil dereferences if unchecked.
- `soap->version` decides which fault representation the accessors touch; mixing bindings on one context corrupts faults.
- All allocation flows through `soap_link`/`soap_malloc`, so everything is freed by `soap_destroy`/`soap_end` — leaking requires escaping objects outside the context lifetime.

UNKNOWN: none material; file is fully generated boilerplate (see coverage note for read method).

