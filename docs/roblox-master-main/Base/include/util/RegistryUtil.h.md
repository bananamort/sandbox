# RegistryUtil.h

## Purpose
Declares RBX::RegistryUtil — a thin string-keyed facade over the Windows registry. Keys are single strings "BASEKEY\sub\keys\value"; base key must be one of the eight HKEY_* names documented in the header comment. Win32 desktop only (excluded on Durango; header empty elsewhere).

## API
```cpp
class RegistryUtil {   // all static
    static bool keyExists(const std::string& key);
    static bool read32bitNumber(const std::string& key, INT32& valueData);
    static bool readBinaryData(const std::string& key, BYTE* valueData, UINT32& dataSize);
        // pass valueData==NULL to query required size into dataSize
    static bool readString(const std::string& key, std::string& valueData);
    static bool write32bitNumber(const std::string& key, INT32 valueData);
    static bool writeBinaryData(const std::string& key, const BYTE* valueData, UINT32 dataSize);
    static bool writeString(const std::string& key, const std::string& valueData);
};
```

## Usage
Settings persistence and machine introspection on Windows clients. Header advises calling keyExists() first so failures of the real accessors are attributable.

## Gotchas
- Header includes pdh.h for no reason used here — copy-paste from ProcessPerfCounter.h.
- Writers open keys with KEY_ALL_ACCESS — needs admin/elevated hives; ordinary HKCU writes work, HKLM will fail at runtime.
