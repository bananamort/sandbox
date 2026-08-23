# stdsoap2.h

Source: `roblox-sandbox/RCCService/gSOAP/stdsoap2.h` (2281 lines)

## Purpose

The **gSOAP 2.7.10 runtime engine header** ("gSOAP runtime engine", line 2) — the vendored third-party core that every generated file includes. It defines the `struct soap` context (the object `RCCServiceSoapService` inherits from), all error codes and IO/encoding mode flags, buffer sizing constants, the internal allocator/hash-table structures, the DOM node types referenced by `import/dom.h`, and the full C API of the engine (context lifecycle, sockets, serialization primitives, faults, plugins). Implementation lives in the sibling `stdsoap2.cpp`.

## API

### Configuration & portability (54–667)

- Declaration macros: `SOAP_FMAC1…SOAP_FMAC6`, `SOAP_CMAC`, `SOAP_NMAC`.
- Platform matrix (`WIN32`, `VXWORKS`, `SYMBIAN`, `PALM`, `HP_UX`, `_AIX`, FreeBSD, `OS390`, QNX, Cygwin, Apple…) selecting `HAVE_*` capability defines; on non-config-h **WIN32** it forces `WITH_NOEMPTYSTRUCT` plus `SOAP_LONG_FORMAT "%I64d"`. WinSock vs BSD socket headers selected under `WITH_IPV6` toggle.
- Optional integrations behind compile flags: `WITH_FASTCGI`, `WITH_OPENSSL` (requires ≥0.9.6), `WITH_ZLIB`/`WITH_GZIP`, `WITH_COOKIES`, `WITH_LEAN(er)`, `WITH_NOIDREF`.

### Sizing constants (781–850)

`SOAP_BUFLEN 65536`, `SOAP_LABLEN 256`, `SOAP_PTRBLK 32`, `SOAP_PTRHASH 1024`, `SOAP_IDHASH 1999`, `SOAP_BLKLEN 256`, `SOAP_TAGLEN 1024`, `SOAP_HDRLEN 8192`, `SOAP_MAXDIMS 16`, `SOAP_MAXLOGS 3`, `SOAP_MAXKEEPALIVE 100`, `SOAP_MAXARRAYSIZE 100000` (halved sizes under `WITH_LEAN`).

### Error codes (955–1012)

`SOAP_OK 0`, `SOAP_EOF EOF`, fault/validation codes `SOAP_TAG_MISMATCH 3`, `SOAP_NO_METHOD 13` (returned by dispatch()), `SOAP_VERSIONMISMATCH 39`, … up to `SOAP_FD_EXCEEDED 46`; classification macros `soap_xml_error_check` / `soap_soap_error_check` / `soap_tcp_error_check` / `soap_http_error_check`; special statuses `SOAP_STOP 1000`, `SOAP_FORM/HTML/FILE 1001–1003`, methods `SOAP_POST 2000` / `SOAP_GET 2001`.

### Modes & flags (1046–1104)

```cpp
typedef soap_int32 soap_mode;
#define SOAP_IO_FLUSH 0x0 ... SOAP_IO_CHUNK 0x3, SOAP_IO_UDP 0x4,
SOAP_IO_LENGTH 0x8, SOAP_IO_KEEPALIVE 0x10,
SOAP_ENC_LATIN/XML/DIME/MIME/MTOM/ZLIB/SSL (0x20..0x800),
SOAP_XML_STRICT/INDENT/CANONICAL/TREE/GRAPH/NIL/DOM/SEC (0x1000..0x80000),
SOAP_C_NOIOB/UTFSTRING/MBSTRING/NILSTRING (0x100000..0x800000),
SOAP_DOM_TREE/NODE/ASIS (0x1000000..)
#define SOAP_IO_DEFAULT SOAP_IO_FLUSH
```

Plus SSL auth flags (`SOAP_SSL_DEFAULT` = require-server-auth | SSLv3+TLSv1).

### Data structures (1217–1814)

- `struct Namespace { id, ns, in, out }` — one row of a nsmap table.
- Internals: `soap_nlist` (namespace stack), `soap_blist` (block alloc), `soap_array`, `soap_plist`/`soap_pblk` (pointer id/ref tables over `pht[]`), `soap_ilist` (id lookup over `iht[]`), `soap_clist` (C++ instance list driving `soap_destroy`), `soap_attribute`, `soap_cookie`, `soap_dime`, `soap_mime`, `enum soap_mime_encoding`, `soap_multipart` (+ `soap_multipart_iterator`), `soap_xlist`, `soap_code_map`, `soap_flist`, `soap_plugin`.
- DOM types declared here (implementations in dom.cpp): `soap_dom_element` / `soap_dom_attribute` with iterators and `set/add/find/begin/end/unlink` methods.
- **`struct soap`** (1539–1774): the whole engine state — `state/version/mode/imode/omode`; user-settable timeouts `recv_timeout/send_timeout/connect_timeout/accept_timeout` (>0 sec, <0 µsec); socket flag fields; `namespaces` pointer; hash tables `iht[SOAP_IDHASH]`, `pht[SOAP_PTRHASH]`; allocation lists `alist/clist/blist`; `header`/`fault` pointers; **~30 overrideable callbacks** (`fpost/fget/fput/fdel/fhead/fform/fposthdr/fresponse/fparse/fparsehdr/fheader/fresolve/fconnect/fdisconnect/fclosesocket/fshutdownsocket/fopen/faccept/fclose/fsend/frecv/fpoll/fseterror/fignore/fserveloop/fplugin/fmalloc` + DIME/MIME streaming + SSL); `master`/`socket`; stream handles `os/is/sendfd/recvfd`; parse state (`buf[SOAP_BUFLEN]`, `msgbuf/tmpbuf[1024]`, `tag/id/href/type/arrayType[…]`, nesting level, chunk state); keep-alive bookkeeping (`keep_alive`, `max_keep_alive`); proxy settings; `status/error`; DOM/DIME/MIME state; debug log files; cookies; c14n include/exclude lists; peer address; SSL/ZLIB state blocks (dummy void* members preserve layout when compiled out); C++ constructors + virtual destructor.

### Macros & function library (1816–2279)

- One-liners: `soap_valid_socket`, `soap_get0/soap_get1` (peek/consume), `soap_revget1/soap_unget`, mode setters `soap_imode/omode/set_/clr_`, `soap_destroy(soap)` ≡ `soap_delete(soap,NULL)`, `soap_register_plugin(soap, p)`.
- Lifecycle: `soap_new/new1/new2/free/copy/copy_context/copy_stream/init[1|2]/done/cleanup/begin/end/delete`.
- Transport: `soap_bind(host,port,backlog)`, `soap_accept()`, `soap_connect[_command]`, `soap_closesock`, `soap_poll`.
- Envelope plumbing used by every generated serve/dispatch: `soap_envelope_begin_out/in`, `soap_body_begin_out/in`, `soap_recv_header`, `soap_response`, `soap_send_fault/recv_fault/print_fault/stream_fault/sprint_fault`, header/fault accessors (`soap_header`, `soap_fault`, `soap_faultcode/subcode/string/detail`) — including `soap_faultstring()` which `RCCService.cpp::startupRCC` reads to build its bind-failure exception.
- Serialization core: element emit/parse family (`soap_element[_begin/_end/_ref/_null/_id/result]_out/in`, `soap_peek_element`, `soap_attribute`, `soap_retry/revert`), primitive converters (`soap_s2int/s2double/s2string…`, `soap_int2s/double2s…`, `soap_inint/outint…` families), base64/hex/UTF-8 codecs, id/ref machinery (`soap_id_enter/lookup/forward`, `soap_pointer_lookup/enter`, `soap_embedded/reference/resolve`) with no-op macro replacements under `WITH_NOIDREF`.
- Memory: `soap_malloc/dealloc/unlink/link/free_temp/track_malloc/track_free`, block-stack helpers.
- Plugins/attrs/cookies/DIME/MIME APIs and namespace stack management.

## Usage

Included by `soapStub.h` (line 11) and thus transitively by everything; compiled once via `stdsoap2.cpp`. RCCService never calls most of this directly — it touches only the class-based wrappers (`bind/accept/serve/copy`, `accept_timeout`, `soap_faultstring`).

## Gotchas

- Version is pinned at **2.7.10** (2000–2008 era): known-era limitations apply (no IPv6 unless `WITH_IPV6`, FD_SETSIZE 1024 default — the header itself suggests raising it if `SOAP_FD_EXCEEDED` appears).
- `struct soap` embeds fixed arrays (~64KB of `buf` alone at default `SOAP_BUFLEN` 65536) — copying contexts must go through `soap_copy_context`, never struct assignment.
- The WIN32 branch hard-codes `WITH_NOEMPTYSTRUCT`, which is why `SOAP_ENV__Header` gets its dummy member in soapStub.h.
- Callback fields are the extension points gSOAP plugins use; leaving them NULL selects defaults set in `soap_init`.

UNKNOWN: none beyond the above (vendored upstream code, fully self-describing).

