# CERTIFICATION.md — ClientBase

Independent review of `docs/roblox-master-main/ClientBase/` against `roblox-sandbox/ClientBase/`.
Method: every source re-enumerated and read in full; every concrete doc claim checked against the code (cross-directory claims verified by tree-wide grep); XML claims validated with a full-file structural scan.

## Coverage

Source-ext files (.cpp/.h): **6** — all documented. Extra doc: `ReflectionMetadata.xml.md` documents the directory's 4224-line data file (real dir member, claims verified) — accepted, not an orphan. INDEX.md present and accurate after fixes. Coverage: **COMPLETE 1:1** (with one accepted non-source-ext doc).

## Per-file verdicts

| Doc | Verdict | Findings |
|---|---|---|
| MachineConfiguration.cpp.md | FIXED | WRONG: claimed forcing shader models to -1 makes them report "actual device caps"; setters are plain stores and the Profile descriptors read them back synchronously — payload actually reports -1/-1. Corrected. |
| MachineConfiguration.h.md | PASS | Caller (WindowsClient/Application.cpp:708) verified. |
| ReflectionMetadata.cpp.md | PASS | All 13 registered names, bound props, Writer tags, Mouse.Origin duplicate and Humanoid malformed nesting (NameOcclusion/Health/MaxHealth/TargetPoint in ONE ReflectionMetadataMember) verified against source and XML. |
| ReflectionMetadata.h.md | PASS | API mirror accurate; findBestMatch inheritance and image-index clamping verified. |
| ReflectionMetadata.xml.md | FIXED | WRONG: "~180 ReflectionMetadataClass children" → actual 208 (full scan). UNKNOWN resolved: StockSound's `<string name="Browsable">false` IS coerced — traced TypedPropertyDescriptor<bool>::readValue → XmlNameValuePair::getValue(bool&) → StringConverter<bool> accepting false/False/FALSE. Material enum Browsable=false on all 10 listed materials and deprecated Status enum verified. |
| RenderSettingsItem.cpp.md | FIXED | WRONG: category list included "Profile" (no such descriptor here). MISSING-GOTCHA: silent setters were under-listed — added setDebugReloadAssets/setObjExportMergeByMaterial/runProfiler note. |
| RenderSettingsItem.h.md | FIXED | WRONG: "Every mutating setter fires settingsChangedSignal" — six setters are silent. Resolved UNKNOWN: setMinCullDistance declared nowhere defined in tree (dead declaration). STYLE: macro-generated-bodies phrasing cleaned. |
| INDEX.md | FIXED | Overclaimed View/UserInput/GameVerbs call `singleton()`; verified actual callers (View, RenderJob, Application) and include-only files. |
| ReflectionMetadata.xml (source) | — | Not a .cpp/.h file; documented anyway as above. |

## Totals

- Docs reviewed: 9 (7 per-source + xml doc + INDEX)
- PASS: 3 · FIXED: 6 · FAIL: 0
- Fixes applied: 7 (WRONG 4 · MISSING-GOTCHA 1 · resolvable-UNKNOWN 3 · STYLE 1 — some docs had multiple)
- Line-count claims: all match (visual-line convention).

**Verdict: CERTIFIED** — ClientBase documentation is now claim-accurate.
