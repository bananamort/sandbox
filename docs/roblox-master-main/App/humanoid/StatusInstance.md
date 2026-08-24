# App/humanoid/StatusInstance.cpp

## Purpose

Implements `RBX::StatusInstance`, the internal creatable ModelInstance that hosts humanoid status markers (BoolValue children named after statuses, managed by Humanoid's status API). The implementation fixes the instance name to "Status", locks it, and denies all external parenting.

## API

Real definitions:

- `const char* const sStatusInstance = "Status"` — note the class name and the instance name differ.
- `StatusInstance::StatusInstance()` — `Super()` then `setName(sStatusInstance); lockName();`.
- `bool StatusInstance::askSetParent(const Instance* instance) const` — returns **false unconditionally**.

## Usage

Implements StatusInstance.h. Created exclusively by engine code: `Humanoid::buildJoints` creates one (marked non-archivable via `Instance::propArchivable`) and parents it under each Humanoid server-side; `getStatusFast` re-attaches to an existing "Status" child otherwise. Humanoid status add/remove operates on BoolValue children of this instance, and `onDescendantAdded`/`onDescendantRemoving` in Humanoid.cpp translate those children into statusAdded/statusRemoved/custom-status signals.

## Gotchas

- The header doc said parenting policy is "in .cpp" — the policy turns out to be total denial: `askSetParent` always returns false (and header-inline `askForbidParent` is its exact negation). Engine code bypasses this through privileged paths (`buildJoints` uses direct setParent with archivable suppression), so user scripts can neither create nor reparent Status instances.
- Name is locked ("Status"), so name-based lookups (`findFirstChildByName("Status")`) are stable; but the class descriptor name remains sStatusInstance — reflection name "Status" comes from the string constant, matching the INTERNAL creatable registration.
