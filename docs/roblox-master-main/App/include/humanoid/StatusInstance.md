# App/include/humanoid/StatusInstance.h

## Purpose

Declares `RBX::StatusInstance`, a creatable INTERNAL ModelInstance representing a humanoid status marker (e.g. the invisible status objects parented under characters). Only parenting policy is defined here.

## Declared API

- `extern const char* const sStatusInstance;`
- `class RBX::StatusInstance : public DescribedCreatable<StatusInstance, ModelInstance, sStatusInstance, Reflection::ClassDescriptor::INTERNAL>`
  - `StatusInstance();`
  - Protected overrides: `bool askSetParent(const Instance* instance) const;` (policy in .cpp), inline `bool askForbidParent(const Instance* instance) const { return !askSetParent(instance); }` — forbid is exact negation of allow.

## Usage notes

- See [Humanoid.md](Humanoid.md) for how statuses are consumed by humanoid state logic.

## Gotchas

- INTERNAL descriptor: creatable only by engine code, not exposed as a user-facing class.
