# App/include/v8datamodel/Value.h

## Purpose

The Value-object family: template `Value<ValueType, sClassName>` (BoundProp + Changed event + signal), `NumericValue` (int/double with an anti-tamper XOR-obfuscated union storage under RBX_SECURE_DOUBLE), hand-written `StringValue` and `ObjectValue` (weak ref), and `ConstrainedValue` (min/max clamped, Configuration-only parenting). Typedefs instantiate the whole Lua Value* family (IntValue, DoubleValue, BoolValue, Vector3Value, RayValue, CFrameValue, Color3Value, BrickColorValue, BinaryStringValue, IntConstrainedValue, DoubleConstrainedValue). Free `registerValueClasses()`.

## Declared API

- Macro: `LUA_VALUE_CONVERT(x)` — under RBX_SECURE_DOUBLE XORs the top int of a double's binary representation with `LuaSecureDouble::luaXorMask[3]`; no-op otherwise.
- `class IValue {}` — empty tag.
- Free: `void registerValueClasses();`

`template<class ValueType, const char* const& sClassName> class Value : public DescribedCreatable<..., Instance, sClassName>, public IValue`
- Static `defaultValue`; member `ValueType value;`
- `static Reflection::BoundProp<ValueType> desc_Value;` — NOTE: BoundProp (not PropDescriptor) here.
- `rbx::signal<void(ValueType)> valueChangedSignal; static EventDesc<..., void(ValueType)> desc_ValueChanged;`
- Inline ctor names instance "Value"; inline `getValue()/setValue()` (setValue routes through desc_Value).
- Protected inline `askSetParent {return true;}` ("Values are willing to be placed anywhere"); private `onValueChanged(desc)` fires signal.

`template<class ValueType, ...> class NumericValue : public DescribedCreatable<...>` — same shape but:
- Private `union Storage { size_t binary[sizeof(ValueType)/sizeof(int)]; ValueType native; };`
- Ctor stores defaultValue THROUGH LUA_VALUE_CONVERT (obfuscated at rest); getValue de-obfuscates on read; setValue compares via getValue() then writes obfuscated + raises prop-changed + fires signal manually.
- Uses REFLECTION_BEGIN/END + `static Reflection::PropDescriptor<..., ValueType> desc_Value;` (PropDescriptor, not BoundProp) — comment shows BoundProp variant commented out.
- Comment: "NumericValue is an obscured version for int/double. The name avoids RTTI issues."

- Typedefs: `IntValue = NumericValue<int>`, `DoubleValue = NumericValue<double>` (TODO comment re min/max range), `BoolValue/Vector3Value/RayValue/CFrameValue/Color3Value/BrickColorValue/BinaryStringValue = Value<...>`.

`class StringValue : public DescribedCreatable<StringValue, Instance, sStringValue>, public IValue`
- Hand-written like Value but for std::string; adds override `getPersistentDataCost()` = Super + computeStringCost(getValue()).

`template<class ValueType, ...> class ConstrainedValue : public DescribedCreatable<...>`
- Statics defaultValue/defaultMinValue/defaultMaxValue; members value/minValue/maxValue.
- Descriptors: `desc_ValueUi`, `desc_ValueUiDeprecated`, `desc_ValueRaw` (all const PropDescriptor), `desc_MinValue/desc_MaxValue` (BoundProp), `desc_ValueChanged`, `valueChangedSignal`.
- `setValue(ValueType)` clamps to [min,max] then calls inline `setValueRaw(ValueType)` which raises BOTH Ui and Raw property-changed + fires signal when changed.
- askSetParent: ONLY inside `Configuration` instances ("ConstrainedValues only make sense in Configuration objects").
- Typedefs `IntConstrainedValue`, `DoubleConstrainedValue`.

`class ObjectValue : public DescribedCreatable<ObjectValue, Instance, sObjectValue>, public IValue`
- Private `weak_ptr<Instance> value;` ctors (default names "Value", named variant); out-of-line `Instance* getValue() const / setValue(Instance*)`; `static RefPropDescriptor<ObjectValue, Instance> desc_Value;` signal `valueChangedSignal<void(shared_ptr<Instance>)>`; askSetParent true anywhere; onValueChanged locks weak ref.

## Gotchas

- NumericValue stores int/double OBFUSCATED at rest when RBX_SECURE_DOUBLE is defined — raw memory inspection shows garbage; comparisons must go through getValue().
- Two descriptor styles coexist (BoundProp in Value vs PropDescriptor in NumericValue/ConstrainedValue) — reflection behavior differs subtly.
- ConstrainedValue can ONLY be parented under Configuration — reparenting elsewhere fails.
- ObjectValue holds weak refs — dangling name resolution returns NULL after target destruction.
- In-header design note: Values exist as "simple bridges to scripting"/"control panel to a Model".

## UNKNOWN

- Where desc_ValueUiDeprecated maps in serialization (legacy alias handling out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Value.md](../../v8datamodel/Value.md).
- Parent container: [Configuration.md](Configuration.md); number types: [NumberRange.md](NumberRange.md), [NumberSequence.md](NumberSequence.md).
