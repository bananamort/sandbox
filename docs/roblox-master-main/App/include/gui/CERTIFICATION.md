# App/include/gui Documentation Certification — Independent Review

**Reviewer**: independent review subagent (ox-alpha).
**Scope**: all sources in `/Users/jasonhuang/Desktop/sandbox/roblox-sandbox/App/include/gui/` vs docs in `/Users/jasonhuang/Desktop/sandbox/docs/roblox-master-main/App/include/gui/`.

## Method

- Every source header read **in full via tool calls**, doc read immediately after; every concrete claim checked.
- Cross-TU claims grep/read-verified: `GuiItem::onDescendantRemoving` → loseFocus (App/gui/GUI.cpp), `ComputeBubbleLifetime` lerpLength scaling (App/gui/ChatOutput.cpp), ProfanityFilter decrypt direction (App/gui/ProfanityFilter.cpp — XOR 0x55 at load, query strings never decrypted), ScoreHud.cpp existence and emptiness.
- Severity tags WRONG / UNSUPPORTED / MISSING-GOTCHA / STYLE; mechanically-certain fixes applied in docs only.

## Coverage arithmetic

- Sources: **10 `.h` files**. Docs: **10 module `.md` + `INDEX.md` = 11**. 1:1 confirmed.

## Per-file certification

| # | Source | Doc | Verdict | Notes |
|---|--------|-----|---------|-------|
| 1 | ChatOutput.h | ChatOutput.md | PASS | ChatLine members/enums/ctor, ScalingInfo cutoff logic, handler signatures, Network::ChatMessage vs ChatColor vocab gotcha — all verified; lifetime-scaling claim confirmed in .cpp. |
| 2 | ChatWidget.h | ChatWidget.md | PASS | Three widget classes exact incl. unsigned/int ctor param variance. |
| 3 | EquationDisplay.h | EquationDisplay.md | PASS | Two ctors + protected getLabel override. |
| 4 | GUI.h | GUI.md | PASS | GuiItem focus/layout/virtual defaults (font 12 vs 8, canLoseFocus), MenuState enum, TextDisplay setFontSize resize formula — verified; onDescendantRemoving→loseFocus confirmed in .cpp. |
| 5 | GuiDraw.h | GuiDraw.md | FIXED (WRONG) | Doc called `computeUV` a "`static`-style helper" — it is a plain non-static member function (GuiDraw.h:73). Invented qualifier corrected. Enum values NORMAL..ALL=0x7F, seven proxies, mutable size, async-load semantics verified. |
| 6 | GuiEvent.h | GuiEvent.md | PASS | wasSunkAndFinished assert direction, five factories, weak target + LOGGROUP(GuiTargetLifetime) verbatim. |
| 7 | Layout.h | Layout.md | PASS | Aggregate fields + default ctor values exact. |
| 8 | ProfanityFilter.h | ProfanityFilter.md | FIXED (WRONG) | Gotcha claimed query strings "get decrypted in place" — false: decrypt (XOR 0x55) applies to the blacklist once during WordList construction; ContainsProfanity/Worker only lowercase+split the by-value copy. Rewrote gotcha with .cpp evidence; added lazy-init double-checked-locking note. |
| 9 | ScoreHud.h | ScoreHud.md | FIXED (resolvable UNKNOWN) | UNKNOWN resolved per protocol: App/gui/ScoreHud.cpp survived and is itself empty (single include). Updated. |
| 10 | Widget.h | Widget.md | PASS | processMouse/processKey privates, onLoseFocus reset chain, virtual defaults (font 10, white, isEnabled→isVisible) exact. |
| 11 | INDEX.md | — | FIXED (STYLE) | Stale "(docs pending)" marker for v8datamodel removed (campaign complete, 98/98 M–Z committed). |

## Totals

- **PASS**: 6
- **FIXED**: 5 (2 WRONG, 1 resolvable-UNKNOWN, 1 stale-marker STYLE, plus the GuiDraw qualifier counted under WRONG)
- **FAIL**: 0
