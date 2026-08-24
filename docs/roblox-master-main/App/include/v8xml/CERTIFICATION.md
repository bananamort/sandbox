# App/include/v8xml Documentation Certification — Independent Review

**Reviewer**: independent review subagent (ox-alpha).
**Scope**: all sources in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/v8xml/` vs docs in `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/v8xml/`.

## Method

- Every source header read **in full via tool calls**, doc immediately after; every concrete claim checked (signatures, enum orders, whitelist membership, verbatim comments).
- Whitelist membership and include-set claims re-checked line-by-line against Serializer.h; tag vocabulary counted against XmlElement.h.
- Severity tags WRONG / UNSUPPORTED / MISSING-GOTCHA / STYLE; mechanically-certain fixes applied in docs only.

## Coverage arithmetic

- Sources: **8 `.h` files**. Docs: **8 module `.md` + `INDEX.md` = 9**. 1:1 confirmed; INDEX roster complete.

## Per-file certification

| # | Source | Doc | Verdict | Notes |
|---|--------|-----|---------|-------|
| 1 | Reference.h | Reference.md | PASS | GUID guard, IIDREF private assignIDREF + friend-broker assign, three binder pure virtuals. |
| 2 | Serializer.h | Serializer.md | PASS | SAVE_WORLD whitelist (Workspace/Lighting/Soundscape::SoundService/ServerStorage/ReplicatedStorage/CSGDictionaryService) and SAVE_GAME whitelist (StarterGui/StarterPack/StarterPlayer/ServerScriptService/ReplicatedFirst) match exactly; archivable gate; default→true; StarterGui/Pack not directly included. |
| 3 | SerializerBinary.h | SerializerBinary.md | PASS | SerializeFlags bit values, kMagicHeader "<roblox!", all four serialize/deserialize overloads with defaults. |
| 4 | SerializerV2.h | SerializerV2.md | PASS | CURRENT_SCHEMA_VERSION=4, load trio, warning-4290 wrap, MergeBinder deferred IDREF flow incl. "nil"-skip comments, processID/processIDREF protected virtuals, resolveRefs always true. |
| 5 | WebParser.h | WebParser.md | PASS | All ten public statics + NonJSONBehavior enum + four protected loaders exact; SkipNonJSON default noted. |
| 6 | WebSerializer.h | WebSerializer.md | PASS | Four write statics exact. |
| 7 | XmlElement.h | XmlElement.md | FIXED (WRONG count) | Doc claimed setValue has "×9 + template" overloads — header has **10** non-template overloads (the `const char*` one was missed). Corrected. Everything else verified: ValueType enum with UINT undef order, anonymous mutable union + handle-"new" TODO, IDREF null/nil sentinel comment block, 61-tag extern roster ("~60" claim fine), Parent/Sibling intrusive templates with Parent-only setNextSibling friendship, _DEBUG leak[15] tagging, recursive dtor, isXsiNil comment. |
| 8 | XmlSerializer.h | XmlSerializer.md | PASS | XmlWriter handle indexing + size_t TODO quote, isValidId/recordId assert-first ordering, TextXmlWriter encode statics, TextXmlParser legacyHashes MD5-workaround comment verbatim, helper list complete. |
| 9 | INDEX.md | — | PASS | Roster complete, descriptions accurate. |

## Totals

- **PASS**: 8
- **FIXED**: 1 (XmlElement.md WRONG overload count)
- **FAIL**: 0
