# GroupService.cpp

## Purpose

Implements `GroupService` ("GroupService") — web group queries: GetGroupInfoAsync (JSON table), GetAlliesAsync/GetEnemiesAsync (StandardPages over "Groups"), and GetGroupsAsync (JSON array, flag-gated off by default). Defines `Security::hackFlag9` decoy at file scope.

## Key types and API

Descriptors (all **Security::None**):
- `func_getGroupInfo("GetGroupInfoAsync", "groupId")` → Variant.
- `func_getAlliesAsync("GetAlliesAsync", "groupId")` / `func_getEnemiesAsync("GetEnemiesAsync", "groupId")` → Pages instance.
- `func_getGroupsAsync("GetGroupsAsync", "userId")` → ValueArray.

FStrings: GroupInfoUrl "%sgroups/%i", GroupAlliesUrl "%sgroups/%i/allies", GroupEnemiesUrl "%sgroups/%i/enemies" (apiBaseUrl-prefixed), GetGroupsUrl "%susers/%i/groups". Flag: `GetGroupsAsyncEnabled(false)`.

Behavior:
- groupId/userId ≤ 0 → argument errors. Allies/enemies build URL with ContentProvider apiBaseUrl and return StandardPages after first chunk.
- Success/error callbacks hold weak_ptr<DataModel> — responses after DataModel death are dropped silently.
- GetGroupsAsync rejects with "is not yet enabled!" unless flagged; parses JSON array via WebParser.

## Usage / reflection touchpoints

Rides [HttpRbxApiService](HttpRbxApiService.md); pagination pattern like [AssetService](AssetService.md)::GetGamePlacesAsync; TeamColor-vs-group interplay documented under [Team](Team.md).

## Gotchas

- GetAllies/GetEnemies have NO enable flag while GetGroups does — asymmetric rollout state.
- hackFlag9 is a decoy canary defined here, consumed elsewhere (UNKNOWN where).
- Group info response passes through raw — no field normalization; schema is whatever the web endpoint returns.
