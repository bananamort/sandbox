# App/include/reflection/Function.h

## Purpose

Declares the synchronous reflected-function pair: `FunctionDescriptor` (MemberDescriptor with a SignatureDescriptor and the abstract `Arguments` parameter-source interface) plus `Function` (lightweight descriptor+instance invocation handle). The nested `FunctionDescriptor::Arguments` interface is what LuaArguments implements to feed reflected calls from the Lua stack.

## Declared API

- `class RBXBaseClass FunctionDescriptor : public MemberDescriptor`
  - `enum Kind { Kind_Default, Kind_Custom };`
  - Nested `class RBXInterface Arguments` — public member `Variant returnValue;` pure virtuals: `size()`, `getVariant(int index, Variant&)`, `getBool/getLong/getDouble/getString`, `getVector3int16/getRegion3int16/getVector3/getRegion3/getRect`, `getObject(index, shared_ptr<DescribedBase>&)`, `getEnum(index, const EnumDescriptor&, int&)`. Contract comments: index is 1-based; returns false leaves value unchanged.
  - Typedefs `Function ConstMember/Member`; protected `SignatureDescriptor signature; Kind kind;` ctor `(ClassDescriptor&, const char* name, Security::Permissions, Attributes);`
  - Public inline getSignature/getKind; virtual `int executeCustom(DescribedBase*, lua_State*) const { return 0; }` (Lua-direct fast path for Kind_Custom); pure virtual `void execute(DescribedBase* instance, Arguments& arguments) const;`
- `class RBX::Reflection::Function`
  - Protected descriptor/instance raw pointers; inline copy ops, getName, getDescriptor.
  - Inline `execute(Arguments&) const` — const_casts instance, forwards to descriptor.

## Usage notes

- Sibling async flavor: [YieldFunction.md](YieldFunction.md).
- `Arguments` implementations: [../script/LuaArguments.md](../script/LuaArguments.md).

## Gotchas

- Default `executeCustom` returns 0 without touching the stack — only meaningful when kind == Kind_Custom.
- Same const_cast pattern as YieldFunction: stored "const" instances are mutated during execution.
