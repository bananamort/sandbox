# DataModelSerialize.cpp

Source: `roblox-sandbox/ClientShared/DataModelSerialize.cpp` (233 lines)

## Purpose

The FULL implementation of DataModel save/upload: binary-serializes the place (`SerializerBinary::serialize`) and POSTs it to the website, with extended HTTP timeouts, statistics reporting, and an error path that uploads a diagnostic log file. Counterpart to DataModelEmptySerialize.cpp — a target links exactly one of the two.

## API

```cpp
shared_ptr<std::stringstream> DataModel::serializeDataModel(const Instance::SaveFilter saveFilter = Instance::SAVE_ALL);
void DataModel::serverSave();                                     // sync save to serverSaveUrl + gamechat notice
void DataModel::internalSaveAsync(ContentId, boost::function<void(bool)> resume);
void DataModel::internalSave(ContentId);                          // blocking save w/ stats + error-log upload
void DataModel::AsyncUploadPlaceResponseHandler(std::string*, std::exception*, resume, errorFn);
bool DataModel::uploadPlaceReturn(bool succeeded, const std::string error, resume, errorFn);
bool DataModel::uploadPlace(const std::string& uploadUrl, const SaveFilter,
                            boost::function<void()> resume, boost::function<void(std::string)> errorFn);
```

Dynamic fast-int flags: `HttpResponseExtendedTimeoutMillis`, `HttpSendExtendedTimeoutMillis`, `HttpConnectExtendedTimeoutMillis`, `HttpDataSendExtendedTimeoutMillis` — all defaulted 600000 ms.

## Usage

- `internalSave` reports "SaveLevel Begin/Complete/Error" statistics via `ReportStatistic*` (App/util/Statistics) keyed by assetId extracted from `contentid=...assetid=N` strings; on failure it walks the DataModel (`traverseDataModelReporting`), builds a diagnostic text, uploads via `UploadLogFile(GetBaseURL(), ...)` and throws `SerializationException(response)`.
- `uploadPlace` guards `Http::isRobloxSite(uploadUrl)` — refuses non-Roblox upload URLs; compresses bodies > 256 bytes (`MIN_HTTP_COMPRESSION_SIZE`); async path binds `AsyncUploadPlaceResponseHandler` and returns false meaning "pending".
- Non-Windows only: `uploadHttp.setAuthDomain(GetBaseURL())`.

## Gotchas

- Timing statistic divides elapsed seconds by 30 (`(endTime - startTime) / 30`) — intentional normalization ("per 30 s") but reads like a bug.
- In `internalSave`'s catch block, `stream.tellp()` is called on the OUTER uninitialized local `std::stringstream stream` (declared line 86), not on the serialized shared_ptr stream — size reported in the error log is always ~0. The success-path stats use `stream->tellp()` of the right object but compute size AFTER the post consumed... actually tellp is still valid post-write; the outer-shadowing remains the defect in the error path.
- `assetId` extraction assumes the ContentId string literally contains "assetid="; find() npos would produce garbage substrings.
- `resumeFunction` null-check decides sync vs async upload; async always returns false regardless of eventual outcome.
