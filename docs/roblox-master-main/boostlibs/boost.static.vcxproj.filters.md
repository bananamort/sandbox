# boost.static.vcxproj.filters

## Purpose

VS solution-explorer filter metadata for boost.static.vcxproj. Organizes the compiled sources into `Source Files\{chrono,filesystem,iostreams,system,thread}` buckets. No build semantics.

## Gotchas

- **Stale paths**: every entry points through `$(CONTRIB_PATH)` at `boost_1_56_0` / `cpp-netlib-0.11.0-final` (plus one hard-coded `..\..\..\..\Contrib2\boost_1_56_0\...` header), while the actual vcxproj uses `..\Library\boost\libs\...` relative includes. VS shows these as unresolved unless `CONTRIB_PATH` is defined; builds are unaffected because filters are display-only.
- Keep in sync manually if sources are added to the vcxproj.
