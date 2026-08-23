# RCCService.wsdl

Source: `roblox-sandbox/RCCService/gSOAP/RCCService.wsdl` (794 lines)

## Purpose

The **service contract** for RCC Service ("RCCService"): a document/literal SOAP web service that lets the website farm game-server jobs onto compute nodes. This is the single input from which `generate.bat` produces all generated bindings (`prototypes.h` → `soapStub.h`, `soapH.h`, `soapC.cpp`, service classes, nsmaps). The C++ implementation lives in `RCCServiceSoapServiceImpl.cpp`.

## API

`targetNamespace="http://roblox.com/"` (`tns`). Port type `RCCServiceSoap` exposes **18 operations**, each with soapAction `http://roblox.com/<Op>` and both a SOAP 1.1 binding (`RCCServiceSoap`) and SOAP 1.2 binding (`RCCServiceSoap12`), all `style="document" use="literal"` over HTTP transport:

| Operation | Request → Response |
| --- | --- |
| `HelloWorld` | () → `string? HelloWorldResult` |
| `GetVersion` | () → required `string GetVersionResult` |
| `GetStatus` | () → `Status { version?: string, environmentCount: int }` |
| `OpenJob` | (`job: Job`, optional `script: ScriptExecution?`) → unbounded `LuaValue OpenJobResult` |
| `OpenJobEx` | same inputs → single `ArrayOfLuaValue OpenJobExResult` |
| `RenewLease` | (`jobID: string`, `expirationInSeconds: double`) → `double RenewLeaseResult` |
| `Execute` | (`jobID: string`, `script: ScriptExecution`) → unbounded nillable `LuaValue ExecuteResult` |
| `ExecuteEx` | same inputs → single `ArrayOfLuaValue ExecuteExResult` |
| `CloseJob` | (`jobID: string`) → empty response |
| `BatchJob` | (`job: Job`, `script: ScriptExecution`) → unbounded nillable `LuaValue BatchJobResult` (open+execute in one call) |
| `BatchJobEx` | same inputs → single `ArrayOfLuaValue BatchJobExResult` |
| `GetExpiration` | (`jobID: string`) → `double GetExpirationResult` |
| `GetAllJobs` | () → unbounded nillable `Job GetAllJobsResult` |
| `getAllJobsEx` (`GetAllJobsEx`) | () → single `ArrayOfJob GetAllJobsExResult` |
| `CloseExpiredJobs` | () → `int CloseExpiredJobsResult` |
| `CloseAllJobs` | () → `int CloseAllJobsResult` |
| `Diag` | (`type: int`, optional `jobID: string?`) → unbounded nillable `LuaValue DiagResult` |
| `DiagEx` | same inputs → single `ArrayOfLuaValue DiagExResult` |

Core types:
- `Job`: `id` (string, required), `expirationInSeconds` (**double**), `category` (int), `cores` (**double**).
- `ScriptExecution`: optional `name`, `script` (the Lua source text), optional `arguments: ArrayOfLuaValue`.
- `LuaValue`: required `type: LuaType`; either `value: string?` or recursive `table: ArrayOfLuaValue?`.
- `LuaType` enum: `LUA_TNIL`, `LUA_TBOOLEAN`, `LUA_TNUMBER`, `LUA_TSTRING`, `LUA_TTABLE` — mirrors Lua 5.1's `LUA_T*` constants; numbers/booleans ride as strings plus a type tag.

## Usage

The `Ex` suffixed operations are wire-compatible re-encodings of their plain counterparts: they return a single wrapper array element (`ArrayOfLuaValue`/`ArrayOfJob`) instead of an unbounded sequence of child elements. Both forms coexist so older clients keep working while newer ones get cleaner XML.

## Gotchas

- **No `<wsdl:service>` section**: the file defines port types and bindings but no endpoint/address — clients must know host:port out of band (default RCC listen port 64989, see `RCCService.cpp`).
- There is no authentication anywhere in the contract — access control is done by the engine-side access key inside job scripts, not at the SOAP layer.
- `OpenJobResponse`'s result is *not* marked nillable, but `Execute`/`BatchJob`/`Diag` results are — nil values serialize differently per operation.
- The operation order here (HelloWorld … DiagEx) matches the extern op counters listed in `RCCService.cpp`'s backpressure error message.
- `cores` and `expirationInSeconds` are XML `double`s even though they are conceptually integral counts/durations.

UNKNOWN: which client versions used plain vs `Ex` operations; whether `Diag`'s `type` int maps to documented diagnostic constants (mapping lives server-side in `RCCServiceSoapServiceImpl.cpp`).

