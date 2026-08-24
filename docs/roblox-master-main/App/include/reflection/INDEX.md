# App/include/reflection — Index

The reflection type system underlying every Instance property, function, event, callback, and enum: descriptors (Descriptor → MemberDescriptor → typed flavors), the class registry (ClassDescriptor/DescribedBase), runtime Variants and Types, and the template machinery binding member pointers into callable descriptors (reflection.h). Consumed by the Lua bridge (../script/), XML serializers (../v8xml/), and replication.

## Files

- [Callback.md](Callback.md) — script-settable callbacks: Sync/Async descriptor bases + BoundCallbackDesc/BoundAsyncCallbackDesc templates.
- [Descriptor.md](Descriptor.md) — base Descriptor: name, deprecation attributes, lockedDown crash guard.
- [EnumConverter.md](EnumConverter.md) — EnumDescriptor + EnumDesc<Enum> bidirectional tables (name/int/index/legacy), RBX_REGISTER_ENUM.
- [Event.md](Event.md) — EventDescriptor, EventDesc 0–7-arity signal descriptors, RemoteEventDesc replication variants.
- [Function.md](Function.md) — FunctionDescriptor + Arguments interface + Function handle (sync flavor).
- [member.md](member.md) — MemberDescriptor, MemberException, MemberDescriptorContainer registry with inheritance propagation + member hiding.
- [Object.md](Object.md) — ClassDescriptor (functionality flags, checksums, inheritance) + DescribedBase (fastDynamicCast family).
- [Property.md](Property.md) — PropertyDescriptor functionality bitmasks, TypedPropertyDescriptor<V>, ConstProperty/Property handles, BoundProp.
- [reflection.md](reflection.md) — mega-header: Described CRTP base, PropDescriptor/EnumPropDescriptor/RefPropDescriptor, ArgHelper, BoundFuncDesc 0–7, BoundYieldFuncDesc, CustomBoundFuncDesc.
- [Type.md](Type.md) — Type singletons/registry, TypeRegistrar, Variant (96-byte in-place storage), ValueArray/Table/Map, Tuple, SignatureDescriptor.
- [YieldFunction.md](YieldFunction.md) — YieldingFunctionDescriptor/YieldFunction async flavor.

## Related

- `../script/LuaArguments.md` — the Lua-stack Arguments implementation.
- `../v8tree/Instance.md` — DescribedCreatable/DescribedNonCreatable usage at the Instance root.
