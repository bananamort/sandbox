# soapRCCServiceSoap12Service.h

Source: `roblox-sandbox/RCCService/gSOAP/generated/soapRCCServiceSoap12Service.h` (116 lines)

## Purpose

Generated **SOAP 1.2 server skeleton** for RCCService — the exact structural twin of `soapRCCServiceSoapService.h`, differing only in the class name (`RCCServiceSoap12Service`), the init-method name (`RCCServiceSoap12Service_init`), and the wire envelope/fault namespace it serializes (SOAP 1.2 via the `ns3 = http://roblox.com/RCCServiceSoap12` binding). Both classes are generated because generate.bat runs soapcpp2 with `-i` over a WSDL that declares two bindings.

## API

```cpp
class SOAP_CMAC RCCServiceSoap12Service : public soap
{
    RCCServiceSoap12Service();                                  // + copy, iomode, imode/omode ctors
    virtual ~RCCServiceSoap12Service();
    virtual void RCCServiceSoap12Service_init(soap_mode imode, soap_mode omode);
    virtual RCCServiceSoap12Service *copy();
    virtual int  soap_close_socket();
    virtual int  soap_senderfault(const char*, const char*);
    virtual int  soap_senderfault(const char *subcodeQName, const char*, const char*);   // 1.2 subcodes
    virtual int  soap_receiverfault(const char*, const char*);
    virtual int  soap_receiverfault(const char *subcodeQName, const char*, const char*);
    virtual void soap_print_fault(FILE*);
    virtual void soap_stream_fault(std::ostream&);              // unless WITH_LEAN
    virtual char *soap_sprint_fault(char *buf, size_t len);
    virtual void soap_noheader();
    virtual int  run(int port);
    virtual SOAP_SOCKET bind(const char *host, int port, int backlog);
    virtual SOAP_SOCKET accept();
    virtual int  serve();
    virtual int  dispatch();

    // The same 18 operations as the 1.1 class, identical signatures:
    virtual int HelloWorld(_ns1__HelloWorld*, _ns1__HelloWorldResponse*);
    // ... GetVersion, GetStatus, OpenJob, OpenJobEx, RenewLease, Execute, ExecuteEx,
    //     CloseJob, BatchJob, BatchJobEx, GetExpiration, GetAllJobs, GetAllJobsEx,
    //     CloseExpiredJobs, CloseAllJobs, Diag, DiagEx ...
};
```

Operation signatures are byte-identical to the SOAP 1.1 class — they share the `_ns1__*` request/response types; only the envelope differs.

## Usage

A deployment binds whichever flavor its clients speak:

```cpp
RCCServiceSoap12Service service;      // instead of RCCServiceSoapService
service.accept_timeout = 1;
service.bind(NULL, port, 100); ... accept() ... serve();
```

RCCService.cpp instantiates only `ExceptionAwareSoap<RCCServiceSoapService>` (the 1.1 class), so in this tree the 1.2 skeleton is entirely unused — neither `soapRCCServiceSoap12Service.h` nor its `.cpp` appears in `RCCService.vcxproj`.

## Gotchas

- A subclass of one class cannot serve the other binding's envelopes; serving both on one port requires sniffing or two listeners.
- Fault helpers here emit SOAP 1.2 `Code/Reason/Subcode` structures; using them from shared code that also serves 1.1 needs care.
- Same "operations declared, not defined" rule: link fails without an implementing subclass.

UNKNOWN: whether any production Roblox client actually spoke SOAP 1.2 to RCCService (no server-side instantiation found in this tree).

