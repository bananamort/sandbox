# App/include/v8datamodel/ParametricPartInstance.h

## Purpose

`RBX::PART::ParametricPartInstance` — thin intermediate class between `FormFactorPart` and parametric shape parts; plus `RBX::PART::Wedge`, the creatable wedge part (`WEDGE_PART`) deriving from it.

## Declared API

Namespace `RBX::PART`:

- `class ParametricPartInstance : public FormFactorPart` — only ctor/dtor declared; no members or overrides.
- `extern const char* const sWedge;`
- `class Wedge : public DescribedCreatable<Wedge, ParametricPartInstance, sWedge>`
  - private `virtual PartType getPartType() const { return WEDGE_PART; }`
  - `Wedge(); ~Wedge();`

## Gotchas

- Lives in namespace `RBX::PART`, not plain `RBX` — callers must qualify or be inside the namespace.
- Note this header does NOT include its own base's header guard pattern of DescribedNonCreatable — ParametricPartInstance itself is not reflection-described, only `Wedge` is.
- Class name vs file name mismatch: the file also defines `Wedge`; grep for both when auditing usage.

## UNKNOWN

- Where FormFactorPart is declared (not included here — presumably pulled transitively via BasicPartInstance.h-style includes in other TUs).

## Cross-links

- Implementation: [App/v8datamodel/ParametricPartInstance.md](../../v8datamodel/ParametricPartInstance.md).
- Base chain: [BasicPartInstance.md](BasicPartInstance.md), [PartInstance.md](PartInstance.md), [PVInstance.md](PVInstance.md); siblings: [CornerWedgeInstance.md](CornerWedgeInstance.md), [PrismInstance.md](PrismInstance.md).
