# Adorn.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/Adorn.h` (341 lines)

## Purpose

THE central abstraction of the adorn layer (per its own comment): *"RBX::Adorn is a base class used to decorate other objects using 2D or 3D basic shapes."* Declares every primitive the engine's debug/UI overlay drawing uses — lines, rects, text, boxes, spheres, cylinders, cones, quads, polygons, extrusions — plus material state, viewport/GUI-rect helpers, and texture-proxy creation. Implemented by GfxCore backends and wrapped by decorators (AdornSurface/AdornBillboarder/2D).

## API

```cpp
struct Canvas {
    Canvas(Vector2 viewPort);
    Vector2 size;
    Vector2 toPixelSize(const Vector2& percent) const; // "std screen is 100% wide and 75% tall"
    int normalizedFontSize(int fontSize) const;
};

class Adorn {
public:
    enum Material { Material_Default, Material_NoLighting, Material_SelfLit,
                    Material_SelfLitHighlight, Material_AALine, Material_Outline,
                    Material_Count };
    Adorn();                       // ignoreTexture=false, vr=false, Material_Default
    Canvas getCanvas() const;      // getViewport().wh()
    bool isVR() const;
    virtual const Camera* getCamera() const = 0;

    virtual TextureProxyBaseRef createTextureProxy(const ContentId& id, bool& waiting,
        bool bBlocking = false, const std::string& context = "") = 0;
    virtual rbx::signal<void()>& getUnbindResourcesSignal() = 0;  // "hint when to release TextureProxys"

    virtual void prepareRenderPass() {}   virtual void finishRenderPass() {}
    virtual void preSubmitPass() {}       virtual void postSubmitPass() {}
    virtual bool useFontSmoothScalling() { return false; }   // [sic]
    void setMaterial(Material); Material getMaterial() const;

    virtual Rect2D getViewport() const = 0;  // "doesn't always represent the area where the game is displayed"
    void setUserGuiInset(const Vector4&);    // "Hack - buffering the GuiRect here"
    Rect2D getUserGuiRect() const;           // viewport inset by userGuiInset xyzw

    void setIgnoreTexture(bool)/getIgnoreTexture();
    virtual void setTexture(int id, const TextureProxyBaseRef&) = 0;
    virtual Rect2D getTextureSize(const TextureProxyBaseRef&) const = 0;

    virtual void line2d(p0, p1, color) = 0;
    void outlineRect2d(rect, thick, color [,Rotation2D|clipRect]);      // in .cpp
    void rect2d(...) — 9 overloads (color / +texul,texbr × Rotation2D|clipRect) // in .cpp
    virtual void rect2dImpl(x0y0,x1y0,x0y1,x1y1,tex0,tex1,color) = 0;

    virtual Vector2 get2DStringBounds(s, size, font=FONT_LEGACY,
                                      availableSpace=zero()) const = 0;
    Vector2 drawFont2D(s, position, size, autoScale, color=black(),
        outline=clear(), font=FONT_LEGACY, xalign=LEFT, yalign=TOP, ...); // in .cpp
    virtual Vector2 drawFont2DImpl(target, s, position, size, autoScale, color,
                                   outline, font, xalign, yalign, ...) = 0;

    // 3D procedural:
    virtual line3d(start,end,color)=0;
    virtual line3dAA(start,end,color,thickness,zIndex,alwaysOnTop)=0;
    virtual setObjectToWorldMatrix(CFrame)=0;
    virtual box(AABox, solidColor=(1,.2,.2,.5))=0;
    void box(const Extents&, solidColor);            // inline → AABox
    virtual box(CFrame,size,color,zIndex,alwaysOnTop)=0;
    virtual sphere(Sphere,(1,1,0,.5))=0;  virtual sphere(CFrame,radius,...)=0;
    virtual explosion(Sphere)=0;
    virtual cylinder(CFrame,radius,height,color,zIndex,alwaysOnTop)=0;
    virtual cylinderAlongX(radius,length,solidColor,cap=true)=0;
    virtual cone(...)=0;  virtual ray(RbxRay,color=orange())=0;
    virtual axes(xColor=red,yColor=green,zColor=blue,scale=1)=0;
    virtual quad(v0..v3,color=blue,v0tex,v2tex,zIndex=-1,alwaysOnTop=false)=0;
    virtual convexPolygon(Vector3*,countv,color)=0;
    virtual convexPolygon2d(Vector2*,countv,color)=0;
    virtual extrusion(trajectory,trajSegs,profile,profSegs,color,
                      closeTrajectory=true,closeProfile=true)=0;
    virtual bool isVisible(const Extents&, const CoordinateFrame&) { return true; }

    static const int maximumZIndex = 10;
protected:
    Vector4 userGuiInset; bool ignoreTexture; bool vr; Material currentMaterial;
};
```

## Usage

Included by essentially everything that draws overlays: AppDraw, GfxCore backends, billboarders, IAdornable render hooks.

## Gotchas
- `quad` takes only v0tex/v2tex despite four vertices (two-triangle strip semantics).
- `maximumZIndex=10` bounds zIndex arguments.
- `Canvas::toPixelSize` assumes a 100%-wide × **75%-tall** standard screen — non-obvious aspect convention.
- `isVisible` default true — culling opt-in per backend.
