# soapRCCServiceSoap12Service.cpp

Source: `roblox-sandbox/RCCService/gSOAP/generated/soapRCCServiceSoap12Service.cpp` (971 lines)

## Purpose

Generated implementation of the **SOAP 1.2 server object** (`RCCServiceSoap12Service`): the structural twin of `soapRCCServiceSoapService.cpp`, with every per-operation static helper renamed from `serve___ns2__*` to `serve___ns3__*` and request type-ids changed from `-ns2:<Op>` to `-ns3:<Op>`. It exists so RCCService could serve SOAP 1.2 envelopes; nothing in this tree instantiates it at runtime.

## API

Identical method set and behavior to the 1.1 file:

- Constructors (`SOAP_IO_DEFAULT`, copy-context, iomode, imode+omode), empty destructor.
- `RCCServiceSoap12Service_init(soap_mode, soap_mode)` (30–46): applies modes and installs the same static namespaces table (rows identical to both nsmaps) if none is set.
- `copy()` (48–52): `new RCCServiceSoap12Service()` + `soap_copy_context`.
- Engine wrappers (54–113): `soap_close_socket`, `soap_senderfault` ×2 / `soap_receiverfault` ×2, fault printers, `soap_noheader { header = NULL; }`, `bind(host,port,backlog)` → `soap_bind`, `accept()` → `soap_accept`.
- `run(int port)` (92–105): bind + infinite accept/serve/destroy/end loop (single-threaded alternative, unused).
- `serve()` (115–171): keep-alive loop with `max_keep_alive` countdown; recv/envelope/header/body parse then `dispatch()`; faults sent via `soap_send_fault`; FastCGI variant behind `WITH_FASTCGI`.
- `dispatch()` (192–232): peek element, match body tag against `"ns1:<Op>"` ladder (18 ops) → `serve___ns3__<Op>`; else `error = SOAP_NO_METHOD`.
- Static `serve___ns3__<Op>` ×18 (234–970): default response, parse with `soap_get___ns3__<Op>(..., "-ns3:<Op>", NULL)`, invoke virtual op, two-pass serialize (count under `SOAP_IO_LENGTH`, then send with `soap_response(SOAP_OK)`), `soap_closesock`.

## Usage

Drop-in alternative to the 1.1 service class:

```cpp
RCCServiceSoap12Service service;   // same bind/accept/serve/copy flow
```

Not compiled into the RCCService binary — `RCCService.vcxproj` lists only `soapC.cpp`, `soapRCCServiceSoapService.cpp`, and `stdsoap2.cpp` from `gSOAP/` — and unreferenced by `RCCService.cpp`, which uses `ExceptionAwareSoap<RCCServiceSoapService>`.

## Gotchas

- The dispatch ladder matches **`ns1:`** tags in both classes — binding selection happens at envelope level (`soap_envelope_begin_in` validates the envelope namespace against SOAP 1.2), not at dispatch time; a 1.1 client hitting this class fails earlier with an envelope error.
- Response elements are still emitted as qualified `"ns1:<Op>Response"` — identical payload markup between bindings; only envelope/fault framing differs.
- Dead weight unless a deployment swaps the template argument in RCCService.cpp.

UNKNOWN: whether the 1.2 path was ever enabled by recompiling with a different global instance (no evidence in-tree).

