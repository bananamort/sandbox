# thumbnailgenerator.h

Source: `roblox-sandbox/RCCService/thumbnailgenerator.h` (35 lines)

## Purpose

Declares `ThumbnailGenerator`, an RBX `Instance`-derived **Creatable Service** that lives inside a job's DataModel and renders place/model thumbnails or exports scenes to OBJ. This is the in-engine face of Roblox's server-side thumbnail pipeline; the SOAP layer reaches it through Lua (`Click`/`ClickTexture` bound functions) after jobs are opened.

## API

```cpp
extern const char* const sThumbnailGenerator;   // "ThumbnailGenerator"

class ThumbnailGenerator
    : public RBX::DescribedCreatable<ThumbnailGenerator, RBX::Instance, sThumbnailGenerator>
    , public RBX::Service
{
public:
    int graphicsMode;                       // reflection property "GraphicsMode" ("Settings")
    static volatile long totalCount;        // process-wide render counter (surfaced by Diag)

    ThumbnailGenerator(void);
    ~ThumbnailGenerator(void);

    shared_ptr<const Reflection::Tuple> click(std::string fileType, int cx, int cy,
                                              bool hideSky, bool crop);
    shared_ptr<const Reflection::Tuple> clickTexture(std::string textureId, std::string fileType,
                                                     int cx, int cy);

    void renderThumb(RBX::ViewBase* view, void* windowHandle, std::string fileType, int cx, int cy,
                     bool hideSky, bool crop, std::string* strOutput);
    void exportScene(RBX::ViewBase* view, std::string* outStr);

private:
    void configureCaches();
};
```

Reflection bindings (declared in the .cpp): `Click(fileType, width, height, hideSky, crop)` and `ClickTexture(textureId, fileType, width, height)`, both gated `RBX::Security::LocalUser`; property `GraphicsMode`.

## Usage

Registered into the engine class registry via `RBX_REGISTER_CLASS(ThumbnailGenerator)` (RCCServiceSoapServiceImpl.cpp:1238); created per DataModel when a job script instantiates the service.

## Gotchas

- Filename is lowercase (`thumbnailgenerator.h`) while the .cpp includes `"ThumbnailGenerator.h"` — works only on case-insensitive filesystems.
- Forward declares `G3D::BinaryOutput`, `RBX::ContentProvider`, `RBX::ViewBase`; callers need real headers.
- `renderThumb`'s `windowHandle` is type-erased `void*` (HWND on Windows).
