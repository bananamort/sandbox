# App/include/v8datamodel/GroupService.h

## Purpose

`GroupService` (INTERNAL_LOCAL service) — web client for group data: fetch group info, ally/enemy lists (returned as Instances containers), and all groups for a user.

## Declared API

`class GroupService : public DescribedCreatable<GroupService, Instance, sGroupService, ClassDescriptor::INTERNAL_LOCAL>, public Service`

- `void getGroupInfoAsync(const int groupId, function<void(Reflection::Variant)> resumeFunction, error);`
- `void getAlliesAsync(const int groupId, function<void(shared_ptr<Instance>)> resumeFunction, error);`
- `void getEnemiesAsync(const int groupId, same signature);`
- `void getGroupsAsync(const int userId, function<void(shared_ptr<const Reflection::ValueArray>)> resumeFunction, error);`
- Private static HTTP result handlers (each taking `weak_ptr<DataModel>`): `onReceivedRawGroupInfoSuccess/Error`, `onReceivedRawGetGroupsSuccess/Error`.

## Gotchas

- Handlers hold weak DataModel refs — shutdown mid-request no-ops.
- Ally/enemy results come back as generic Instance containers (likely a "Groups" folder of entries).

## UNKNOWN

- Endpoint URLs and response schema (.cpp — see [GroupService.md](../../v8datamodel/GroupService.md)).

## Cross-links

- Implementation: [App/v8datamodel/GroupService.md](../../v8datamodel/GroupService.md).
- Social kin: [FriendService.md](FriendService.md), [Team.md](Team.md) (T–Z half).
