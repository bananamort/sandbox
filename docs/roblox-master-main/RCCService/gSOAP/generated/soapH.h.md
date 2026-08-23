# soapH.h

Source: `roblox-sandbox/RCCService/gSOAP/generated/soapH.h` (1660 lines)

## Purpose

The generated **serializer function-prototype header** ("H file") for RCCService. Where `soapStub.h` declares the *types*, soapH.h declares the *functions* — for every type in the service it emits the gSOAP standard serializer family (`soap_default_X`, `soap_serialize_X`, `soap_put_X`, `soap_out_X`, `soap_get_X`, `soap_in_X`, plus allocation/copy variants), together with the element-dispatch and instantiation entry points used by the engine. Implemented in `soapC.cpp`; included by everything that touches SOAP types.

## API

### Element-level dispatch (lines 11–34)

```cpp
SOAP_FMAC3 void SOAP_FMAC4 soap_markelement(struct soap*, const void*, int);
SOAP_FMAC3 int  SOAP_FMAC4 soap_putelement(struct soap*, const void*, const char*, int, int);
SOAP_FMAC3 void *SOAP_FMAC4 soap_getelement(struct soap*, int*);
SOAP_FMAC3 int  SOAP_FMAC4 soap_putindependent(struct soap*);   // WITH_NOIDREF-gated
SOAP_FMAC3 int  SOAP_FMAC4 soap_getindependent(struct soap*);
SOAP_FMAC3 int  SOAP_FMAC4 soap_ignore_element(struct soap*);
SOAP_FMAC3 void * SOAP_FMAC4 soap_instantiate(struct soap*, int, const char*, const char*, size_t*);
SOAP_FMAC3 int  SOAP_FMAC4 soap_fdelete(struct soap_clist*);
SOAP_FMAC3 void* SOAP_FMAC4 soap_class_id_enter(...);
SOAP_FMAC3 void* SOAP_FMAC4 soap_container_id_forward(...);
SOAP_FMAC3 void  SOAP_FMAC4 soap_container_insert(...);
```

(`SOAP_FMAC3`/`SOAP_FMAC4` are visibility/calling macros; `5`/`6` mark allocator-family functions.)

### Primitive + base serializers (lines 36–88)

`byte` (type 3), `int` (1), `double` (54), enum `ns1__LuaType` (50, with `soap_ns1__LuaType2s` / `soap_s2ns1__LuaType` string converters), `std::string` (51).

### Per-type families

Every message/data type from soapStub.h gets one block of prototypes (e.g. lines 90–100):

```cpp
SOAP_FMAC3 int                    SOAP_FMAC4 soap_out__ns1__DiagExResponse(struct soap*, const char*, int, const _ns1__DiagExResponse *, const char*);
SOAP_FMAC3 _ns1__DiagExResponse * SOAP_FMAC4 soap_get__ns1__DiagExResponse(struct soap*, _ns1__DiagExResponse *, const char*, const char*);
SOAP_FMAC3 _ns1__DiagExResponse * SOAP_FMAC4 soap_in__ns1__DiagExResponse(struct soap*, const char*, _ns1__DiagExResponse *, const char*);
SOAP_FMAC5 _ns1__DiagExResponse * SOAP_FMAC6 soap_new__ns1__DiagExResponse(struct soap*, int);
SOAP_FMAC5 void                   SOAP_FMAC6 soap_delete__ns1__DiagExResponse(struct soap*, _ns1__DiagExResponse*);
SOAP_FMAC3 _ns1__DiagExResponse * SOAP_FMAC4 soap_instantiate__ns1__DiagExResponse(struct soap*, int, const char*, const char*, size_t*);
SOAP_FMAC3 void                   SOAP_FMAC4 soap_copy__ns1__DiagExResponse(struct soap*, int, int, void*, size_t, const void*, size_t);
```

Coverage: `_ns1__<Op>[Response]` ×36 (types 14–49), data classes `ns1__Status/Job/ScriptExecution/ArrayOfLuaValue/ArrayOfJob/LuaValue` (8–13), operation wrappers `__ns2__*` (66–134) and `__ns3__*` (136–170) with full `default/serialize/put/out/get/in/new/delete/instantiate/copy` sets, envelope structs under `WITH_NOGLOBAL` guards (`SOAP_ENV__Fault` 178, `Reason` 177, `Detail` 174, `Code` 172, `Header` 171).

### Pointer-reference helpers (lines 1188–1612)

`PointerTo<T>` families (types 63–132 etc.) for each message element and envelope member — these implement SOAP's multi-reference/id-based pointer serialization; gated or removed under `WITH_NOIDREF`.

### Vector templates (1634–1656)

```cpp
SOAP_TYPE_std__vectorTemplateOfPointerTons1__Job      (59)
SOAP_TYPE_std__vectorTemplateOfPointerTons1__LuaValue (57)
```

— serializers for the two `std::vector<T*>` members backing `ArrayOfJob`/`ArrayOfLuaValue` and repeated response elements.

### Base string typedefs

`_QName` (5), `string`/`char*` (4).

## Usage

Included by the service headers, nsmaps, and any TU that manipulates SOAP types directly. Regenerated with everything else by generate.bat.

## Gotchas

- The whole file is wrapped so that omitting `WITH_NOIDREF` pulls in id/href machinery; compiling with `WITH_NOIDREF` shrinks both this header and soapC.cpp but changes wire compatibility for multi-ref payloads.
- Type-id numbers in the `SOAP_TYPE_*` defines must match soapC.cpp's dispatch tables — hand-editing one side breaks deserialization silently.
- `soap_getelement`/`soap_instantiate` switch on these ids at runtime; unknown ids yield `SOAP_TYPE_MISMATCH`-class errors.

UNKNOWN: none beyond the above; fully generated.

