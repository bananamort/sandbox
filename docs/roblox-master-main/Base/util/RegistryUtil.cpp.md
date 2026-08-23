# RegistryUtil.cpp

## Purpose
Implements RegistryUtil: parses "BASE\sub\value" strings (first '\\' splits base key, last '\\' splits value from subkey path), opens via RegOpenKeyEx, then RegQueryValueEx/RegSetValueEx per type. Morgan McGuire / G3D heritage (2006 banner; closing comment still says `} // namespace G3D`).

## API
All seven statics from util/RegistryUtil.h, plus file-local `getKeyFromString(str, length)` mapping the eight HKEY_* names to handles.

## Usage
Win32 desktop only — the entire body is inside `#ifdef _WIN32` after the _WINSOCKAPI_ guard.

## Gotchas
- readString: two-pass query (size then data); on success `valueData = tmpStr` where tmpStr is a NUL-filled buffer of exactly dataSize bytes — embedded-NUL REG_SZ values truncate at first NUL via std::string assignment.
- keyExists uses only the FIRST '\\' as the split: a bare "HKEY_CURRENT_USER\value" (no subkey) is opened as subkey "value" — works only if callers always include a real subkey path.
- getKeyFromString compares with strncmp against `length` = position of first backslash; "HKEY_CURRENT_USER_EXTRA\..." style prefixes would false-match shorter names? No — strncmp stops at length, so prefix collisions DO match ("HKEY_CLASSES_ROOTXYZ" matches at 17 chars). Latent.
- Duplicate HKEY_CLASSES_ROOT branch in getKeyFromString's else-if chain (harmless dead code).
- Writes require KEY_ALL_ACCESS; failures are RBXASSERT-only in release.
- VC6-era HKEY_PERFORMANCE_* defines guarded by #if !defined.
