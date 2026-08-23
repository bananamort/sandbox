# RegistryUtil.cpp

## Purpose
Implements RegistryUtil: parses "BASE\sub\value" strings (first '\\' splits base key, last '\\' splits value from subkey path), opens via RegOpenKeyEx, then RegQueryValueEx/RegSetValueEx per type. Morgan McGuire / G3D heritage (2006 banner; closing comment still says `} // namespace G3D`).

## API
All seven statics from util/RegistryUtil.h, plus file-local `getKeyFromString(str, length)` mapping SEVEN distinct HKEY_* names (the HKEY_CLASSES_ROOT branch appears twice) — note the header doc-comment additionally lists HKEY_USERS, but getKeyFromString does not handle it and returns NULL for it.

## Usage
Win32 desktop only — the entire body is inside `#ifdef _WIN32` after the _WINSOCKAPI_ guard.

## Gotchas
- readString: two-pass query (size then data); on success `valueData = tmpStr` where tmpStr is a NUL-filled buffer of exactly dataSize bytes — embedded-NUL REG_SZ values truncate at first NUL via std::string assignment.
- keyExists uses only the FIRST '\\' as the split: a bare "HKEY_CURRENT_USER\value" (no subkey) is opened as subkey "value" — works only if callers always include a real subkey path.
- getKeyFromString compares with strncmp bounded by `length` = position of first backslash. False matches occur only when the key's base is SHORTER than a candidate name (e.g. "HKEY_LOCAL\foo" matches the HKEY_LOCAL_MACHINE branch because only the first 10 chars are compared). Longer strings like "HKEY_CLASSES_ROOTXYZ\..." do NOT match — comparison hits the literal's NUL terminator first. Also, the forward declaration says `size_t length` while the definition uses `UINT32` (same width on Win32).
- Duplicate HKEY_CLASSES_ROOT branch in getKeyFromString's else-if chain (harmless dead code).
- Writes require KEY_ALL_ACCESS; failures are RBXASSERT-only in release.
- VC6-era HKEY_PERFORMANCE_* defines guarded by #if !defined.
