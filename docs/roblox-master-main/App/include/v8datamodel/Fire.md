# App/include/v8datamodel/Fire.h

## Purpose

`Fire` Instance — the classic part-attached flame effect: two colors, size and heat floats with clamped views, an enable flag, and UI-vs-engine setter split.

## Declared API

`class Fire : public DescribedCreatable<Fire, Instance, sFire>, public Effect`

- Props/state: `static BoundProp<bool> prop_Enabled; bool getEnabled() const;` colors `setColor(Color3)/getColor()`, `setSecondaryColor/getSecondaryColor`; statics `MaxHeat`, `MaxSize` (`static float getMaxSize()`).
- Size: `void setSizeUi(float); void setSize(float); float getSizeRaw() const; float getClampedSize() const;`
- Heat: `void setHeatUi(float); void setHeat(float); float getHeatRaw() const; float getClampedHeat() const;`
- Change hook: `void onChangedEnabled(const Reflection::PropertyDescriptor&);`
- Tree rules: parent must be PartInstance (`askSetParent`), children allowed.
- Ctor/dtor.

## Gotchas

- Ui vs raw setters differ (UI presumably maps 0..1 to clamp range) — mixing them skews values.
- Clamped getters exist separately from raw members: render path uses clamps.

## UNKNOWN

- MaxSize/MaxHeat numeric values (defined in .cpp — see [Fire.md](../../v8datamodel/Fire.md)).

## Cross-links

- Implementation: [App/v8datamodel/Fire.md](../../v8datamodel/Fire.md).
- Kin: [Smoke.md](Smoke.md), [Sparkles.md](Sparkles.md), base [Effect.md](Effect.md).
