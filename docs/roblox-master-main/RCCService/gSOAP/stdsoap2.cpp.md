# stdsoap2.cpp

Source: `roblox-sandbox/RCCService/gSOAP/stdsoap2.cpp` (14892 lines)

## Purpose

The **gSOAP 2.7.10 runtime engine implementation** — the vendored third-party core (Robert van Engelen, Genivia; stamp line 86: *"ver 2.7.10 2008-01-27"*) that implements every function declared in `stdsoap2.h`: socket transport, HTTP framing, the XML pull parser, encoding/decoding primitives, context lifecycle, memory management, id/ref resolution, DIME/MIME, faults and plugins. RCCService links this file once; all SOAP I/O for every job request flows through it.

*Coverage note:* written from continuous verbatim reads of lines 1–700 (license/statics/code maps/`fsend`), 4290–4549 (`soap_poll`/`tcp_accept`/`soap_accept`), 6300–6519 (`soap_copy`/`soap_copy_context`/`soap_copy_stream`/`soap_init`), and 14700–14892 (fault printers/plugin registry/C++ methods), plus a full top-level function-position enumeration via grep (all ~150 definitions located) — the unread middle is the standard per-function implementation of exactly those declared APIs.

## API

### Transport layer (503–1050)

- `fsend` (503): write loop over `soap->socket` honoring `send_timeout` via `select()` (with the recurring guard `if ((int)soap->socket >= FD_SETSIZE) return SOAP_FD_EXCEEDED`), SSL/BIO branches, UDP `sendto` with the SOAP-over-UDP retry/back-off algorithm (udp_repeat 1–3, delay doubling 50→500 ms), falling back to FastCGI/file-descriptor writes.
- `frecv`, `soap_recv_raw`, chunked-transfer decoding (`soap_getchunkchar`), `soap_recv`.
- TCP plumbing: `tcp_init` (WinSock init), `tcp_connect`, `tcp_gethost`, `tcp_closesocket/shutdownsocket/disconnect`, `tcp_error`/`soap_strerror`.

### Server accept path (4135–4532) — what RCCService exercises

- `soap_bind(host, port, backlog)` (4135): getaddrinfo → socket → setsockopt chain (`SO_KEEPALIVE`, `SO_SNDBUF/RCVBUF`, `TCP_NODELAY`) → bind → listen; every failure funnels into `soap_set_receiver_error(..., "… failed in soap_bind()", SOAP_TCP_ERROR)` — the error whose fault string `startupRCC()` rethrows as `std::runtime_error`.
- `soap_poll` (~4270): non-blocking `select` probe used to detect closed peer connections.
- `tcp_accept` (4358): raw `accept` + optional FD_CLOEXEC.
- `soap_accept` (4381): the loop `stepRCC()` polls every second — honors `accept_timeout` (>0 sec / <0 µsec; **default select timeout 60 s when timeout fields are zero**), flips master socket non-blocking during waits, then on success records `soap->ip`/`soap->port` from the peer, applies `accept_flags`/`SO_LINGER`, sets buffer sizes and `TCP_NODELAY`, and derives `keep_alive` from `SOAP_IO_KEEPALIVE`. Returns `SOAP_INVALID_SOCKET` on timeout/error.

### HTTP layer

`http_post/get/put/del/head`, `http_send_header/post_header`, `http_response`, `http_parse`, `http_parse_header` (static, wired as `soap->f*` callbacks in `soap_init`), keep-alive handling, proxy support, Basic-auth userid/passwd, cookie processing under `WITH_COOKIES`.

### XML pull parser & codecs (1317–2100)

Single-character state machine: `soap_char`, `soap_get0/1` peek/consume, `soap_get` (returns synthetic codes `SOAP_LT/-2`, `SOAP_TT/-3`, `SOAP_GT/-4`, `SOAP_QT/-5`, `SOAP_AP/-6`), PI skipping, entity decoding incl. full XHTML entity table (296–394). Encodings: UTF-8 in/out, hex, base64 (tables at 275–276), gzip/zlib inflate under `WITH_GZIP/ZLIB`, XOP/DIME attachment forwarding.

### Memory & id/ref machinery (2100–2600+)

`soap_malloc` (context-owned arena freed by `soap_end`), block-stack helpers (`soap_new_block/push/pop/save/end_block`), pointer/id hash tables (`soap_init_iht/pht`, `soap_lookup_type`, `soap_id_enter/lookup/forward`, `soap_pointer_lookup/enter`, `soap_reference/embedded/resolve`, `soap_update_ptrs`, `soap_has_copies`) implementing SOAP multi-ref graphs; array-dimension attribute codecs (`soap_putsize/getsize/offsets…`).

### Context lifecycle (3305, 6309–6519+)

```cpp
struct soap *soap_copy(const struct soap*)          // malloc + copy_context
struct soap *soap_copy_context(struct soap*, const struct soap*) // memcpy then RESET:
    // state=SOAP_COPY, clears nlist/blist/clist/alist/attributes/labbuf,
    // local_namespaces, header/fault/action/plugins=NULL, re-inits iht/pht,
    // copies plugins via their fcopy callbacks
void soap_init(struct soap*)   // defaults: version 0, SOAP_IO_DEFAULT modes,
                               // fpost=http_post ... fparse=http_parse,
                               // faccept=tcp_accept, fopen=tcp_connect,
                               // fsend/fsend, fpoll=soap_poll, fplugin=fplugin
void soap_done(struct soap*)   // inverse: frees tables, closes logs, tcp_cleanup
```

This is precisely the semantics `RCCServiceSoapService::copy()` relies on to give each accepted connection an independent serializer state while inheriting timeouts/modes/nsmap from the global service object.

### Serialization core, faults, plugins (remainder through 14892)

Envelope/body/header begin-end pairs, `soap_response(status)`, `soap_send_fault/recv_fault`, `soap_set_fault` mapping gSOAP error codes → fault QNames, string↔value converters (`soap_s2int/s2double/s2string/...`, `soap_int2s/double2s/...`), element emit/parse helpers, namespace stack push/pop/utilize, `soap_set_namespaces`. Fault formatters at the tail: `soap_print_fault(_location)` ("** HERE **" marker), `soap_stream_fault`, `soap_sprint_fault` (14704–14792); plugin registry `soap_register_plugin_arg`/`fplugin`/`soap_lookup_plugin` (14801–14843). The final section defines the C++ `soap::soap()` ctors and the destructor trio `soap_destroy → soap_end → soap_done` (14857–14889).

## Usage

Compiled once into RCCService.vcxproj; no project code calls it except through generated wrappers and `RCCService.cpp`'s direct use of `service.bind/accept/copy` and `soap_faultstring`.

## Gotchas

- **FD_SETSIZE trap**: on non-WIN32 builds any fd ≥1024 makes send/recv/accept fail with `SOAP_FD_EXCEEDED`; the header suggests raising the constant before including sys/types.h.
- `soap_accept` with *no* explicit timeout still aborts after a 60 s select — but RCCService sets `accept_timeout = 1`, so its poll loop sees clean timeouts instead.
- `soap_copy_context` does a blind `memcpy` of the whole struct first; anything heap-backed not explicitly re-initialized afterwards would alias — the reset list above is therefore security-critical.
- Win32 build requires `wsock32.lib` (noted at lines 55–58; also `#pragma comment(lib, "wsock32.lib")` at line 79).
- Version 2.7.10 predates modern TLS defaults (`SOAP_SSL_DEFAULT` = SSLv3+TLSv1) — relevant only if SSL were enabled, which this build does not.

UNKNOWN: exact behavior of WITH_OPENSSL/WITH_ZLIB/WITH_FASTCGI paths in this binary (compile flags live in the vcxproj; none appear active for the shipping configuration).

