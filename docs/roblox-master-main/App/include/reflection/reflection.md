# App/include/reflection/reflection.h

## Purpose

The mega-header of the reflection system: `ClassRegistrar` + `RBX_REGISTER_CLASS`, the CRTP base `Described<...>` that every reflectable class inherits through `DescribedCreatable`/`DescribedNonCreatable` (defined in Instance.h-adjacent code), property binding templates (`PropDescriptor` with get/set/get-only/set-only GetSet impls, `EnumPropDescriptor`, `RefPropDescriptor` + `RefType`), argument marshaling (`ArgHelper::getArg`), and the arity-templated function descriptors: `BoundFuncDesc` (0–7 args, default-cascade ctors), `BoundYieldFuncDesc` (0–5 args, ReturnType/void specializations), and `CustomBoundFuncDesc` (0–4 args, raw lua_State fast path). Also defines the RCC-security `.lua` section pragmas.

## Declared API

Macros:
- `NULL_FUNCTION_PTR` — `typeof(NULL)` on iOS else `int`; used to overload getset() for NULL getter/setter.
- `_PRISM_PYRAMID_` defined (no visible consumer here).
- Under `RBX_RCC_SECURITY`: `REFLECTION_BEGIN()`/`REFLECTION_END()` push/pop MSVC `data_seg/const_seg/bss_seg` all into section `.lua` (comment: data_seg=init rw, const_seg=init ro, bss_seg=rw) — groups reflection statics into one address range; empty otherwise.
- `RBX_REGISTER_CLASS(Class)` — defines `template<> ClassRegistrar<Class> ...::registrar(0)`.

Templates/classes (namespace RBX::Reflection):
- `template<class Class> class ClassRegistrar : boost::noncopyable` — private ctor(int) calls `Class::classDescriptor()`; public dummy(); static registrar with main-thread-init warning ("Otherwise the reflection database can change at runtime, which would be a disaster").
- `template<class Class, const char* const& sClassName, class BaseClass = DescribedBase, ClassDescriptor::Functionality = PERSISTENT, Security::Permissions = Security::None> class RBXBaseClass Described : public BaseClass`
  - "A CRTP class for implementing reflection. Must be a descendant of DescribedBase."
  - static function-local `classDescriptor()` building `ClassDescriptor(BaseClass::classDescriptor(), sClassName, functionality, security)`.
  - Default ctor + Arg0..Arg3 forwarding ctors: set `this->descriptor = &classDescriptor(); forceRegistration();` (calls ClassRegistrar<Class>::registrar.dummy() to force client-side registrar definition).
- `template<class Class, typename V> class PropDescriptor : public TypedPropertyDescriptor<V>`
  - Nested GetSetImpl (get+set member-pointer functors; isReadOnly/isWriteOnly false; polymorphic_downcast dispatch), GetImpl (read-only; setValue throws `"can't set value"`), SetImpl (write-only; getValue throws `"can't get value"`).
  - Ctor `(name, category, Get, Set, flags = Attributes(), security = None)`; static `getset(Get, Set)` with two NULL_FUNCTION_PTR overloads selecting GetImpl/SetImpl.
- `template<class Class, typename V> class EnumPropDescriptor : public EnumPropertyDescriptor` ("TODO: Refactor: This duplicates code it [sic] TypedPropertyDescriptor")
  - Holds auto_ptr GetSet (from PropDescriptor::getset) + `const EnumDesc<V>& enumDesc`.
  - Implements isReadOnly/isWriteOnly, getVariant/setVariant (int-based), copyValue, getValue/setValue<V>, equalValues, getEnumItem/getEnumValue/setEnumValue (validates via enumDesc.isValue)/getIndexValue/setIndexValue/setIntValue (legacy int mapping); hasStringValue→true, string get/set incl. Name overload ("An alternate, more efficient version"); XML readValue accepts int, legacy pre-10/29/05 STRING form ("TODO: Opt: Remove this legacy code sometime? It slows text XML down a bit"), empty-string → index 0; writeValue writes int.
- `template<typename T> class RefType : public Type` — static singleton named "Object" tagged "Ref" (this is the type RefPropertyDescriptor detection greps by name).
- `template<class Class, typename RefClass> class RefPropDescriptor : public RefPropertyDescriptor, public IIDREF`
  - getset over RefClass* member accessors; getVariant wraps as shared_ptr via shared_from; setVariant extracts shared_ptr<DescribedBase>; setRefValue polymorphic_cast-validates non-null; setRefValueUnsafe polymorphic_downcast ("We know (assume) that this is the right type. If not, then the file is corrupt!"); XML readValue announces IDREF via binder; writeValue writes InstanceHandle; implements assignIDREF.
- `template <class Class> class FuncDesc : public FunctionDescriptor` — protected ctor binding Class::classDescriptor().
- `class ArgHelper` — private try_integral (bool/int/long overloads + disable_if fallback false), try_floating_point, try_string, try_Vector3int16, try_Region3int16, try_Vector3, try_Region3, try_Rect, try_object (shared_ptr<T> of DescribedBase-derived via shared_static_cast), try_enum (via EnumDesc<T>::singleton) — each enable_if/disable_if SFINAE pairs.
  - Public `getArg<T, index>(Arguments&, const scoped_ptr<T>& defaultArg)` — disable_if Tuple specialization: tries direct typed getters in order (integral, floating, string, enum, object, Vector3int16, Region3int16, Vector3, Region3, Rect), then Variant fall-back (comment cites http://lua-users.org/wiki/TrailingNilParameters — nil args return false so defaults apply), else default or throws `RBX::runtime_error("Argument %d missing or nil", index)`.
  - enable_if<Tuple> overload: builds Tuple from arguments.size()-index+1 trailing values ("null Tuple... shorthand for empty" when none).
- CallNHelper (N=0..7) templates: static call(o, functionPtr, returnValue&, args...) writing result into Variant; void-return specializations skip assignment. (Comment drift: several say "take N arguments" with wrong N.)
- `template <class Class, typename Signature, int arity = function_traits<Signature>::arity> class BoundFuncDesc;` — specializations 0..7:
  - Members: member FunctionPtr + scoped_ptr<ArgN> defaultN chain; declareSignature sets resultType + addArgument(name, Type, default).
  - Ctor cascade per arity: full-defaults, then progressively fewer leading defaults (e.g. arity2 has 3 ctors: both defaults / only arg1 missing-with-arg2-default / none); arity7 has 8 ctors (FIXED: doc previously claimed 9).
  - execute(): CallNHelper::call on polymorphic_downcast<Class*>; BOOST_STATIC_ASSERTs inside declareSignature forbid `shared_ptr<const Tuple>` params for arities 2–7 — but only for Arg1..Arg(N-1), never the last argument, and arity 0/1 have no asserts at all (scope verified in-source). Tuple capture happens through ArgHelper's enable_if<Tuple> specialization, which these asserts do exclude.
- `template <class Class> class YieldFuncDesc : public YieldFunctionDescriptor` — protected ctor passthrough.
- `template<typename ReturnType> static void resume_adapter(boost::function<void(Variant)> resumeFunction, ReturnType returnValue)` — wraps resume value into Variant.
- `template <class Class, typename Signature, typename ReturnType = ..., int arity = ...> class BoundYieldFuncDesc;` — specializations:
  - ReturnType/void × arity 0..5: YieldFunctionPtr appends `(resumeFunction, errorFunction)` continuations after real args; declareSignature mirrors BoundFuncDesc; execute passes ArgHelper-extracted args then bound resume_adapter (or bound resumeFunction(Variant()) for void).
  - Note the arity-5 variants (ReturnType AND void) carry copy-paste parameter-type bugs: 8 of their 12 ctors mis-type the trailing default as `Arg4 default5` instead of `Arg5 default5` — including each variant's full-defaults ctor; only the "defaults-from-arg3" and no-defaults ctors are clean.
- `template <class Class, typename Signature, int arity = ...> class CustomBoundFuncDesc;` — specializations 0..4 extending the matching BoundFuncDesc: hold `int (Class::*customFunction)(lua_State*)`, construct base with NULL function pointer, set `this->kind = Kind_Custom`, override executeCustom to invoke it.

## Usage notes

- This header is included wherever classes declare members; the certified App/script docs reference its behavior indirectly through LuaBridge.
- REFLECTION_BEGIN/END matters for RCC security work: descriptor statics land in the `.lua` PE section under RBX_RCC_SECURITY.

## Gotchas

- Copy-paste defects visible in-source (safe to document, NOT safe to "fix" without review): 8 of 12 arity-5 BoundYieldFuncDesc ctors use `Arg4 default5` types; several "take N arguments" comments are off by one (e.g. "3" above arity-2, "5" above arities 6 and 7); the arity-7 ctor taking only `Arg7 default7` initializes default7..default1 before function (FIXED: doc previously attributed this to the no-defaults ctor, whose init list is in normal order).
- getset(NULL, set)/getset(get, NULL) rely on NULL_FUNCTION_PTR being `int` (non-iOS) for overload resolution — passing literal NULL selects the right overload only because of this typedef trick.
- All casts are boost::polymorphic_downcast — checked only in debug; descriptor/class mismatches silently corrupt in release.
