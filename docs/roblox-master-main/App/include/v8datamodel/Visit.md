# App/include/v8datamodel/Visit.h

## Purpose

`Visit` — INTERNAL_LOCAL creatable service for session-level web plumbing: a background `worker_thread` pinging a URL at an interval (server keepalive/heartbeat to the website) and the place upload URL used by save flows.

## Declared API

`class Visit : public DescribedCreatable<Visit, Instance, sVisit, Reflection::ClassDescriptor::INTERNAL_LOCAL>, public Service`

- Private: `std::string uploadUrl; scoped_ptr<RBX::worker_thread> pingThread;`
- Ctor/dtor.
- Ping: `void setPing(std::string url, int interval)` — spawns/updates the background thread; static `worker_thread::work_result ping(std::string url, int interval)` — the thread body.
- Upload URL: `void setUploadUrl(std::string value)`; inline `std::string getUploadUrl()`.

## Gotchas

- Background thread owned via scoped_ptr — service teardown joins/kills it; setPing during active ping needs re-sync semantics out-of-line.
- getUploadUrl is non-const and returns by value.

## UNKNOWN

- Ping payload/response handling ("work_result" semantics) out-of-line.

## Cross-links

- Implementation: [App/v8datamodel/Visit.md](../../v8datamodel/Visit.md).
- Save/upload flow: [DataModel.md](DataModel.md) (saveToRoblox/uploadPlace); join context: Network docs.
