# soapRCCServiceSoapService.h

Source: `roblox-sandbox/RCCService/gSOAP/generated/soapRCCServiceSoapService.h` (116 lines)

## Purpose

Generated **SOAP 1.1 server skeleton** for RCCService: declares class `RCCServiceSoapService`, which publicly inherits the whole gSOAP engine (`class RCCServiceSoapService : public soap`) and adds the accept/serve loop plus 18 pure-virtual-style operation methods that the application must override. `RCCServiceSoapServiceImpl.cpp` defines `RCCServiceSoapServiceImpl` as a subclass implementing exactly these methods.

## API

```cpp
class SOAP_CMAC RCCServiceSoapService : public soap
{
    RCCServiceSoapService();
    RCCServiceSoapService(const struct soap&);          // copy of another engine state
    RCCServiceSoapService(soap_mode iomode);
    RCCServiceSoapService(soap_mode imode, soap_mode omode);
    virtual ~RCCServiceSoapService();                   // frees all data
    virtual void RCCServiceSoapService_init(soap_mode imode, soap_mode omode);
    virtual RCCServiceSoapService *copy();              // clone context (used by RCCService.cpp per-connection)
    virtual int  soap_close_socket();
    virtual int  soap_senderfault(const char *string, const char *detailXML);
    virtual int  soap_senderfault(const char *subcodeQName, const char *string, const char *detailXML); // 1.2 subcode
    virtual int  soap_receiverfault(const char *string, const char *detailXML);
    virtual int  soap_receiverfault(const char *subcodeQName, const char *string, const char *detailXML);
    virtual void soap_print_fault(FILE*);
    virtual void soap_stream_fault(std::ostream&);      // unless WITH_LEAN
    virtual char *soap_sprint_fault(char *buf, size_t len);
    virtual void soap_noheader();
    virtual int  run(int port);                          // simple iterative serve loop
    virtual SOAP_SOCKET bind(const char *host, int port, int backlog);
    virtual SOAP_SOCKET accept();
    virtual int  serve();
    virtual int  dispatch();

    // Service operations (you should define these):
    virtual int HelloWorld(_ns1__HelloWorld*, _ns1__HelloWorldResponse*);
    virtual int GetVersion(_ns1__GetVersion*, _ns1__GetVersionResponse*);
    virtual int GetStatus(_ns1__GetStatus*, _ns1__GetStatusResponse*);
    virtual int OpenJob(_ns1__OpenJob*, _ns1__OpenJobResponse*);
    virtual int OpenJobEx(_ns1__OpenJobEx*, _ns1__OpenJobExResponse*);
    virtual int RenewLease(_ns1__RenewLease*, _ns1__RenewLeaseResponse*);
    virtual int Execute(_ns1__Execute*, _ns1__ExecuteResponse*);
    virtual int ExecuteEx(_ns1__ExecuteEx*, _ns1__ExecuteExResponse*);
    virtual int CloseJob(_ns1__CloseJob*, _ns1__CloseJobResponse*);
    virtual int BatchJob(_ns1__BatchJob*, _ns1__BatchJobResponse*);
    virtual int BatchJobEx(_ns1__BatchJobEx*, _ns1__BatchJobExResponse*);
    virtual int GetExpiration(_ns1__GetExpiration*, _ns1__GetExpirationResponse*);
    virtual int GetAllJobs(_ns1__GetAllJobs*, _ns1__GetAllJobsResponse*);
    virtual int GetAllJobsEx(_ns1__GetAllJobsEx*, _ns1__GetAllJobsExResponse*);
    virtual int CloseExpiredJobs(_ns1__CloseExpiredJobs*, _ns1__CloseExpiredJobsResponse*);
    virtual int CloseAllJobs(_ns1__CloseAllJobs*, _ns1__CloseAllJobsResponse*);
    virtual int Diag(_ns1__Diag*, _ns1__DiagResponse*);
    virtual int DiagEx(_ns1__DiagEx*, _ns1__DiagExResponse*);
};
```

Every method returns a gSOAP error code or `SOAP_OK`. The operation signature pattern is uniform: `(request*, response*)`.

## Usage

The lifecycle exercised by `RCCService.cpp`: construct once → set `accept_timeout` → `bind(NULL, port, 100)` → poll `accept()` → `copy()` per connection → worker thread calls `serve()` → `dispatch()` routes to the right virtual operation.

## Gotchas

- This is the SOAP **1.1** class only; its 1.2 twin is `soapRCCServiceSoap12Service.h` with an identical shape.
- Because the class inherits `soap` directly, engine fields (`accept_timeout`, `bind_flag`, `error`, …) are accessed as members, not via a handle.
- The operations are declared but not defined in generated code — linking fails if no subclass implements them (the "you should define these" comment).

UNKNOWN: none beyond the above; header is fully self-describing.

