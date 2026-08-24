# App/include/reflection Documentation Certification — Independent Review

**Reviewer**: independent review subagent (ox-alpha).
**Scope**: all sources in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/reflection/` vs docs in `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/reflection/`.

## Method

- Every source header read **in full via tool calls** — including the 2601-line reflection.h and 1141-line Event.h end to end, no sampling. Docs read immediately after each source.
- Every concrete claim verified: template arities, ctor counts (re-counted mechanically), static-assert scopes, enum values, verbatim comments/[sic], inline constant values.
- Cross-TU checks: `__eq` metamethod gating in App/script/LuaBridge.cpp:94; getContext/RobloxExtraSpace; ActivityMeter location.
- Severity tags WRONG / UNSUPPORTED / MISSING-GOTCHA / STYLE; mechanically-certain fixes applied in docs only.

## Coverage arithmetic

- Sources: **11 `.h` files**. Docs: **11 module `.md` + `INDEX.md` = 12**. 1:1 confirmed.

## Per-file certification

| # | Source | Doc | Verdict | Notes |
|---|--------|-----|---------|-------|
| 1 | Callback.h | Callback.md | PASS | Sync 0–4 / Async 0–2 specializations, ten BoundCallbackDesc ctors, convertResult first-value extraction with "Callback did not return a value" throw, ISetter NULL-until-bound gotcha — all verified. |
| 2 | Descriptor.h | Descriptor.md | PASS | checkLockedDown RBXCRASH + verbatim production-crash comment; Attributes/deprecated factories. |
| 3 | EnumConverter.h | EnumConverter.md | PASS | addPair asserts (non-negative/no-space/no-CamelCase), sparse-table sentinels, legacy maps checked second, convertToIndex (size_t)-1, RBX_REGISTER_ENUM + GCC "WEIRD huh?" comments. |
| 4 | Event.h | Event.md | FIXED (WRONG count) | Doc claimed EventDesc has "Twelve ctors" with muddled arity breakdown. Re-counted: **10 ctors** — arities 0 and 1 have two overloads each (security+attributes / attributes-only), arities 2–7 exactly one. Corrected. All else verified: GenericSlotWrapper execute1–7, TGenericSlotWrapper catch-log, EventDescBase dual forms (member-ptr vs getOrCreate(bool)), EventDescImpl 0–7 assert-and-cast fireEvent, RemoteEventDescImpl fire-then-replicate, RemoteEventCommon enums incl. "recieve" [sic] quote, isScriptable=(flags&1), isBroadcast=(behavior&1). |
| 5 | Function.h | Function.md | PASS | Kind enum, Arguments pure-virtual set + 1-based-index contract comment, executeCustom default-0, const_cast execute. |
| 6 | member.h | member.md | PASS | memberHidingHook, sorted insert, hide-replace TODO ("required for some legacy things, like BoolValue") verbatim, allDescriptors deterministic Name::compare ordering, iterator materialization. |
| 7 | Object.h | Object.md | PASS | Functionality hex values recomputed (0x1B/0x1D/0x19/0x13/0x15/0x11/0x3/0x5/0x1/0xB/0x9) all match; bit legend correct; first-construction lockdown; fastDynamicCast family ×4; five containers. |
| 8 | Property.h | Property.md | PASS | All fifteen Functionality sums recomputed (31/23/21/19/14/12/4/2/20/16/13/34/29/15/3); checkFlags direction; debugAssertM messages verbatim; RefPropertyDescriptor "Object"-name detection + dynamic_cast cross-check assertion; BoundProp assign-if-different → changed → raisePropertyChanged chain. |
| 9 | reflection.h | reflection.md | FIXED (WRONG ×3 + STYLE) | Full 2601-line read. (a) "arity7 has 9 ctors" → **8** (counted twice mechanically). (b) Static-assert scope corrected: asserts live in declareSignature of arities 2–7 covering Arg1..Arg(N−1) only — never the last arg, absent in arities 0–1; doc's "forbid Tuple params entirely" was wrong. (c) Gotcha misattributed the misordered init list to the "no-defaults ctor": it is actually the arity-7 ctor taking `Arg7 default7` (:1602, default7..default1 then function last); no-defaults ctor is in normal order. (d) Arg4-default5 claim sharpened to grep-verified 8-of-12 ctors incl. full-defaults ones; comment-drift examples pinned (lines :855/:1308/:1476). Also restored [sic] on "duplicates code it TypedPropertyDescriptor". |
| 10 | Type.h | Type.md | FIXED (WRONG) | Gotcha said genericConvert's mutation is "relied on by get()" — inverted: get() deliberately clones ("Create a non-const copy") precisely so the original is NOT mutated; only direct convert() mutates in place. Corrected. Storage=96 bytes, cast/tryCast semantics, "Variant cast failed", boost::any static assert, SignatureDescriptor::Item default-detection all verified. |
| 11 | YieldFunction.h | YieldFunction.md | PASS | Pure-virtual async execute with resume/error continuations; const_cast pattern noted. |
| 12 | INDEX.md | — | FIXED (STYLE) | Roster entry named nonexistent "YieldingFunctionDescriptor" → corrected to YieldFunctionDescriptor. |

## Totals

- **PASS**: 7
- **FIXED**: 5 files (reflection.md ×3 WRONG + STYLE, Event.md WRONG, Type.md WRONG, INDEX STYLE)
- **FAIL**: 0
