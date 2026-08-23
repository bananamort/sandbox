# DataModelEmptySerialize.cpp

Source: `roblox-sandbox/ClientShared/DataModelEmptySerialize.cpp` (49 lines)

## Purpose

Provides deliberately EMPTY stub implementations of the `DataModel` serialization/save entry points so that targets linking `DataModel` can compile **without** any XML/binary place-saving capability. The header comment states the intent verbatim: "this makes 'place stealing hacks' more difficult to implement" — i.e., the shipped player binary must not contain code that writes places to disk/web.

## API

Stubs overriding DataModel's declared-but-not-here-defined methods:

```cpp
shared_ptr<std::stringstream> DataModel::serializeDataModel(const Instance::SaveFilter); // returns NULL stream
void DataModel::serverSave();                                                            // no-op
static void HandleAsyncSaveResult(...);                                                  // no-op
void DataModel::internalSaveAsync(ContentId, boost::function<void(bool)>);               // no-op
void DataModel::internalSave(ContentId);                                                 // no-op
void DataModel::AsyncUploadPlaceResponseHandler(...);                                    // no-op
bool DataModel::uploadPlaceReturn(...)  -> true
bool DataModel::uploadPlace(...)        -> true
```

## Usage

Exactly one of this file or `DataModelSerialize.cpp` is linked into a given target — verified from project files: `WindowsClient/WindowsClient.vcxproj` compiles THIS stub (the shipped player cannot save places), while `RCCService/RCCService.vcxproj` and App's CMakeLists.txt compile the full `DataModelSerialize.cpp`. ClientShared/CMakeLists.txt lists both files in its SOURCES.

## Gotchas

- `uploadPlace*` returning true while doing nothing means callers interpret saves as SUCCESS silently — any target linked against this stub reports successful uploads that never happened.
- The static `HandleAsyncSaveResult` here is dead (never referenced).
