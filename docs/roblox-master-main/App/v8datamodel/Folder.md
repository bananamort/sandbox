# Folder.cpp

## Purpose

Implements `Folder` ("Folder") — the pure organizational container. Parenting rules are fully delegated: a Folder accepts any children its PARENT would accept, and can be parented anywhere.

## Key types and API

Descriptors: none. Constants: `sFolder = "Folder"`.

Behavior:
- `askAddChild(instance)` — parent ? `parent->canAddChild(instance, false)` : true — i.e., Folder inherits its container's child policy rather than imposing its own.
- `askForbidChild` / `askSetParent`(always true) / `askForbidParent` — direct inversions/delegates.

## Usage / reflection touchpoints

Generic grouping for scripts ([App/script](../../script/) organization), values, models; contrast with restrictive [Configuration](Configuration.md).

## Gotchas

- Because child rules mirror the PARENT, moving a Folder changes what it may contain — a Folder under Workspace behaves differently than one inside another restricted container.
