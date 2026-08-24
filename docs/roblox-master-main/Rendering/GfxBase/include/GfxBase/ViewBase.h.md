# ViewBase.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/ViewBase.h` (116 lines)

## Purpose

Abstract render-view interface: the swap-chain-owning bridge between the app shell and the renderer. Defines `OSContext` (window handle + size), `IViewBaseFactory`, export enums, and the ~25 virtual methods a concrete view must implement (RenderView/D3D/GL side).

## API

```cpp
enum ExporterFormat { ExporterFormat_Obj, ExporterFormat_NumFormats };
enum ExporterSaveType { ExporterSaveType_Everything, ExporterSaveType_Selection,
                        ExporterSaveType_NumSaveTypes };

struct OSContext {
    void* hWnd; int width; int height;   // defaults 0, 640x480
};

class IViewBaseFactory {
    virtual ViewBase* Create(CRenderSettings::GraphicsMode mode,
        OSContext* context, CRenderSettings* renderSettings) = 0;
};

class RBX::ViewBase {
public:
    static ViewBase* CreateView(GraphicsMode, OSContext*, CRenderSettings*);
    static void RegisterFactory(GraphicsMode, IViewBaseFactory*);
    // "need this because we are statically linking."
    static void InitPluginModules();
    // "it is bad form to need this. phase out please."
    static void ShutdownPluginModules();

    virtual void initResources() = 0;
    virtual void bindWorkspace(shared_ptr<DataModel>) = 0;
    virtual void render(IMetric*, double timeJobStart);       // non-pure, in .cpp
    virtual void renderPrepare(IMetric*) = 0;
    virtual void renderPerform(double timeJobStart) = 0;
    virtual void enableVR(bool) = 0;  virtual void updateVR() = 0;
    virtual const char* getVRDeviceName() = 0;
    virtual void onResize(int cx, int cy) = 0;
    virtual void buildGui(bool buildInGameGui = true) = 0;
    virtual void renderThumb(unsigned char* data, int w, int h, bool crop, bool allowDolly) = 0;
    virtual void garbageCollect() {}
    virtual Instance* getWorkspace() = 0;
    virtual RenderStats& getRenderStats() = 0;
    virtual DataModel* getDataModel() = 0;
    virtual FrameRateManager* getFrameRateManager() { return 0; }   // debug pull only
    virtual double getMetricValue(const std::string&) { return -1; }
    virtual bool getAndClearDoScreenshot() = 0;
    virtual bool exportScene(filePath, ExporterSaveType, ExporterFormat) = 0;
    virtual bool exportSceneThumbJSON(ExporterSaveType, ExporterFormat,
                                      bool encodeBase64, std::string& strOut) = 0;
    virtual void queueAssetReload(const std::string& filePath) {}
    virtual void immediateAssetReload(const std::string& filePath) = 0;
    virtual void suspendView() = 0;  virtual void resumeView() = 0;
    virtual std::pair<unsigned,unsigned> setFrameDataCallback(
        const boost::function<void(void*)>&);                  // stub in .cpp
    virtual ~ViewBase() {}
};
```

## Usage

Consumers (WindowsClient shell, Studio) create a view via factory after `InitPluginModules()`; per frame they call `render(metric, t)` which sequences prepare→perform.

## Gotchas
- Only Obj exporter format exists (`NumFormats`=1 guard).
- Default `getFrameRateManager` returns NULL and `getMetricValue` −1 — check before deref/compare.
- `renderThumb` raw buffer contract (w×h bytes of what format?) is defined by implementations — UNKNOWN from this header.
