# App/include/reflection/YieldFunction.h

## Purpose

Declares the yielding-flavored reflected member functions: `YieldFunctionDescriptor` (a MemberDescriptor with a SignatureDescriptor whose `execute` is asynchronous — results arrive later through resume/error callbacks) and `YieldFunction` (lightweight descriptor+instance pair used at invocation time).

## Declared API

- `class RBXBaseClass YieldFunctionDescriptor : public MemberDescriptor`
  - Typedefs: `typedef YieldFunction ConstMember; typedef YieldFunction Member;`
  - Protected: `SignatureDescriptor signature;` ctor `(ClassDescriptor& classDescriptor, const char* name, Security::Permissions security, Attributes attributes);`
  - Public: inline `const SignatureDescriptor& getSignature() const;` pure virtual
    `virtual void execute(DescribedBase* instance, FunctionDescriptor::Arguments& arguments, boost::function<void(Variant)> resumeFunction, boost::function<void(std::string)> errorFunction) const = 0;`
- `class RBX::Reflection::YieldFunction`
  - Protected: `const YieldFunctionDescriptor* descriptor; DescribedBase* instance;`
  - Inline copy ctor/assignment; inline getName()/getDescriptor().
  - Inline `void execute(FunctionDescriptor::Arguments&, resumeFunction, errorFunction)` — const_casts the stored instance and forwards.

## Usage notes

- The yield flavor of [Function.h](Function.md)'s synchronous FunctionDescriptor pair.
- Resume/error callbacks are how Lua threads get re-scheduled after an async operation completes (see ScriptContext resume plumbing).

## Gotchas

- `execute` may return before any callback fires — callers must not assume synchronous completion or stack lifetime.
- The instance is a raw pointer const-cast away from constness — descriptor execution can mutate the object despite the const wrapper.
