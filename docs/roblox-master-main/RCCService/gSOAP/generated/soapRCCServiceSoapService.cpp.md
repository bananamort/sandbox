# soapRCCServiceSoapService.cpp

Source: `roblox-sandbox/RCCService/gSOAP/generated/soapRCCServiceSoapService.cpp` (971 lines)

## Purpose

Generated implementation of the **SOAP 1.1 server object** declared in `soapRCCServiceSoapService.h`: constructors/copy logic, the namespace-table install, the `run/bind/accept/serve/dispatch` engine glue, and the 18 static per-operation `serve___ns2__<Op>` functions that deserialize a request envelope, invoke the virtual operation method, and serialize the response. This is the code path every RCCService request flows through between `process_request()` in `RCCService.cpp` and the operation implementations in `RCCServiceSoapServiceImpl.cpp`.

## API

### Lifecycle methods

```cpp
RCCServiceSoapService::RCCServiceSoapService()                       // init(SOAP_IO_DEFAULT, SOAP_IO_DEFAULT)
RCCServiceSoapService::RCCServiceSoapService(const struct soap&)     // init + soap_copy_context(this, &soap)
RCCServiceSoapService::RCCServiceSoapService(soap_mode iomode)
RCCServiceSoapService::RCCServiceSoapService(soap_mode imode, soap_mode omode)
RCCServiceSoapService::~RCCServiceSoapService() { }                  // empty — cleanup via soap_destroy/soap_end
void RCCServiceSoapService::RCCServiceSoapService_init(soap_mode imode, soap_mode omode)
```

- `_init` (30–46) applies modes and assigns a **static local** copy of the standard namespaces table (same rows as `RCCServiceSoap.nsmap`) *only if* `this->namespaces` is not already set.
- `copy()` (48–52): `new RCCServiceSoapService()` + `soap_copy_context(dup, this)` — the exact mechanism `stepRCC()` in `RCCService.cpp` uses to hand each accepted socket its own context.

### Engine wrappers (54–113)

`soap_close_socket`, four fault builders (`::soap_sender_fault[_subcode]`, `::soap_receiver_fault[_subcode]`), fault printers, `soap_noheader() { header = NULL; }`, and thin wrappers over `soap_bind` / `soap_accept`.

### `run(int port)` (92–105)

`bind(NULL, port, 100)`, then an infinite `accept(); serve(); soap_destroy(this); soap_end(this);` loop — the simple single-threaded alternative to RCCService's thread-pool design (unused there).

### `serve()` (115–171)

Keep-alive aware request loop:

1. `soap_begin` twice (outer per-iteration reset).
2. `--k` against `max_keep_alive` forces `keep_alive = 0` when exhausted.
3. On `soap_begin_recv` failure with `error < SOAP_STOP`: `return soap_send_fault(this)`; else close socket and continue.
4. `soap_envelope_begin_in || soap_recv_header || soap_body_begin_in || dispatch() || fserveloop(...)` — any failure sends a fault back and returns.

### `dispatch()` (192–232)

`soap_peek_element(this)`, then a flat ladder of `soap_match_tag(this->tag, "ns1:<Op>")` checks routing to the matching static `serve___ns2__<Op>(this)`; unknown body element sets `this->error = SOAP_NO_METHOD`.

### Static operation servers ×18 (234–970)

Each follows one template (shown for HelloWorld, lines 234–273):

1. Stack-allocate wrapper `__ns2__<Op>` and response `_ns1__<Op>Response`; `soap_default` both; force `encodingStyle = NULL` (document/literal).
2. Parse request with `soap_get___ns2__<Op>(soap, ..., "-ns2:<Op>", NULL)` — the leading `-` means "any namespace, this local name".
3. Close out input (`soap_body_end_in/envelope_end_in/end_recv`).
4. Invoke `soap-><Op>(request.ns1__<Op>, &response)` — the virtual hook implemented by `RCCServiceSoapServiceImpl`.
5. Serialize: `soap_serializeheader` + `response.soap_serialize`, a length-count pass under `SOAP_IO_LENGTH` (`soap_begin_count`…`soap_end_count`), then the real send pass `soap_response(SOAP_OK)` → envelope/header/body out → `soap_end_send`.
6. `return soap_closesock(soap);`

## Usage

Compiled into the RCCService binary as-is; never edited by hand. The 18 virtual operations are implemented in `RCCServiceSoapServiceImpl.cpp` by out-of-class definitions of the `RCCServiceSoapService::Op` members themselves (no subclass exists); the running instance is `ExceptionAwareSoap<RCCServiceSoapService>` from `RCCService.cpp`.

## Gotchas

- Dispatch matches **local names in the ns1 namespace** only; requests whose body elements carry no or a foreign prefix still match because `soap_match_tag` resolves prefixes through the nsmap — but a truly unknown element yields `SOAP_NO_METHOD`.
- `serve()`'s fault path *returns* after sending a fault, ending keep-alive processing for that connection.
- Response elements are emitted with qualified name `"ns1:<Op>Response"` regardless of the binding's target-namespace row used at parse time.
- The `-ns2:` type-id strings mean namespace-agnostic matching of the local part — clients using the Soap12 namespace against this class would parse but reply with 1.1 envelopes (mixed deployments must use the matching class).

UNKNOWN: none beyond the above; file is fully generated boilerplate.

