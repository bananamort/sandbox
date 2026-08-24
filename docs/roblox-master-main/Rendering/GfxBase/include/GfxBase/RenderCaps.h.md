# RenderCaps.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/RenderCaps.h` (32 lines)

## Purpose

Value class describing the GPU's capabilities, filled by the backend at device-init and consulted engine-wide to gate features (NPOT textures, G-buffer path, skinning bone budget).

## API

```cpp
class RBX::RenderCaps {
    size_t vidMemSize;
    std::string gfxCardName;
    bool texturePowerOf2Only;
    bool supportsGBuffer;
    unsigned int skinningBoneCount;
public:
    RenderCaps(std::string gfxCardName, size_t vidMemSize);
    void setTexturePowerOf2Only(bool b);   // inline
    void setSupportsGBuffer(bool b);       // inline
    void setSkinningBoneCount(unsigned int v); // inline
    size_t getVidMemSize() const;
    bool getTexturePowerOf2Only() const;
    const std::string& getGfxCardName() const;
    bool getSupportsGBuffer() const;
    unsigned int getSkinningBoneCount() const;
};
```

Ctor (in RenderCaps.cpp) defaults `texturePowerOf2Only=false`, `supportsGBuffer=false`, `skinningBoneCount=0`.

## Usage

Includes only `<string>` + RenderSettings.h. Constructed once per backend startup; read-only afterwards except via setters during probing.

## Gotchas
- No setter for card name or VRAM — fixed at construction.
- Defaults are conservative: GBuffer OFF and skinning 0 until explicitly probed/enabled; a backend forgetting to set skinningBoneCount silently disables skinning paths.
