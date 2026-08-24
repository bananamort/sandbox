# Enums.cpp

## Purpose

Implements shared Reflection enum registrations for classes whose descriptors live elsewhere: PartType, Style (truss), PrismSides/PyramidSides (_PRISM_PYRAMID_ gated), HandlesStyle, SizeConstraint, and ScaleType. No Instance logic at all.

## Key types and API

EnumDesc template specializations (descriptor name → pairs):
- "PartType": Ball, Block, Cylinder (BasicPartInstance::LegacyPartType).
- "Style": AlternatingSupports / BridgeStyleSupports / NoSupports + LEGACY NAMES "Alternating Supports"/"Bridge Style Supports"/"No Supports" (ExtrudedPartInstance::VisualTrussStyle).
- _PRISM_PYRAMID_ only: "PrismSides" {3,5,6,8,10,20} — 4 deliberately absent ("Don't allow a 4 sided prism - should use block"); "PyramidSides" {3,4,5,6,8,10,20}.
- "HandlesStyle": Resize, Movement ([Handles](Handles.md)::VisualStyle).
- "SizeConstraint": RelativeXY/RelativeXX/RelativeYY ([GuiObject](GuiObject.md)).
- "ScaleType": Stretch, Slice ([GuiObject](GuiObject.md)::ImageScale).

## Usage / reflection touchpoints

Consumed by [BasicPartInstance](BasicPartInstance.md), [ExtrudedPartInstance](ExtrudedPartInstance.md), [PrismInstance](PrismInstance.md)/[PyramidInstance](PyramidInstance.md), [Handles](Handles.md), [GuiObject](GuiObject.md) property plumbing.

## Gotchas

- Enum registration ORDER here matters for numeric persistence — values are the enum's raw ints, names are display-only.
- The legacy-name aliases for Style exist purely to parse old place files/scripts using spaces.
