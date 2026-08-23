# ThumbnailGenerator.cpp

Source: `roblox-sandbox/RCCService/ThumbnailGenerator.cpp` (369 lines)

## Purpose

Implements server-side thumbnail/asset rendering inside RCCService: renders a job's Workspace (or an individual texture) into an encoded, base64-wrapped image, or exports the scene as OBJ JSON. Rendering is funneled through a **single dedicated worker thread** that owns the only OpenGL context, because Mesa GL contexts are thread-affine and the DummyWindow's device context dies with its creating thread (rationale comment, lines 250–253).

## API

### File-level machinery

- `struct ThumbnailRenderSettings : RBX::CRenderSettings` (28): forces `AntialiasingOn`, `eagerBulkExecution=true`, `enableFRM=false`.
- `struct ThumbnailRenderRequest` (38): `{generator, fileType, cx, cy, hideSky, crop, strOutput*, errorOutput*, doneEvent*}` — caller-owned output buffers and completion event.
- Statics: `rbx::safe_queue<ThumbnailRenderRequest> gThumbRenderQueue`; auto-reset `RBX::CEvent gThumbRenderQueueNotEmpty`; `boost::scoped_ptr<boost::thread> gThumbRenderThread` + `boost::once_flag gThumbRenderThreadInit`.
- `thumbRenderWorker()` (60): creates a 1×1 `DummyWindow` holding the GL context alive, `ViewBase::InitPluginModules()`, `ViewBase::CreateView(CRenderSettings::OpenGL, &dummyContext, &dummySettings)`; then loops: wait on queue event, drain `pop_if_present`; per request takes a `DataModel::scoped_write_transfer` on the *requesting* DataModel ("the requesting thread holds a lock for us"), dispatches:
  - `"obj"` (case-insensitive) → `generator->exportScene(view, strOutput)`
  - otherwise → `generator->renderThumb(view, dummyWindow.handle, fileType, cx, cy, hideSky, crop, strOutput)`
  
  clears `errorOutput` on success, writes `"renderThumb failed: <what>"` on exception, always `doneEvent->Set()`. Thread never exits.
- `thumbRenderInit()` (112): spawns the worker once via `boost::call_once` from `click`.

### Reflection registration (119–125)

```cpp
const char* const sThumbnailGenerator = "ThumbnailGenerator";
BoundFuncDesc<...> clickFunction(&ThumbnailGenerator::click, "Click",
    "fileType","width","height","hideSky","crop", /*deprecated=*/false, Security::LocalUser);
BoundFuncDesc<...> clickTextureFunction(&ThumbnailGenerator::clickTexture, "ClickTexture",
    "textureId","fileType","width","height", Security::LocalUser);
BoundProp<int> prop_HeadColor("GraphicsMode", "Settings", &ThumbnailGenerator::graphicsMode);
```

(`prop_HeadColor` is misnamed; it actually binds GraphicsMode.)

### Methods

- `ThumbnailGenerator()` / `~ThumbnailGenerator()` (129/134): trivial; `graphicsMode(0)`.
- `configureCaches()` (139, private): sets `ContentProvider`, `TextureContentProvider`, `MeshContentProvider`, `SolidModelContentProvider` caches to `INT_MAX` and immediate mode for texture/mesh/solidmodel — thumbnails never evict assets.
- **`click(fileType, cx, cy, hideSky, crop)`** (233): increments `totalCount`; logs; `ReadAccessKey()` (extern from RCCService.cpp); configures caches; marshals a `ThumbnailRenderRequest` onto the render queue (`call_once(thumbRenderInit)`, push, set event, wait `doneEvent`), converting worker-side failures to `runtime_error(errorOutput)`; reports elapsed seconds via `StatsService::report("Thumbnail", {Time})`; returns tuple `{base64ImageString, contentProvider->getRequestedUrls()}`.
- **`clickTexture(textureId, fileType, cx, cy)`** (161): no 3D render — fetches the texture asset bytes via `ContentProvider::getContentString(ContentId)`, decodes with `G3D::GImage` (format autodetect), strips alpha unless PNG requested (PNG path instead does `setColorAlphaTest(255,255,255,0)`), `bilinearStretchBlt(cx,cy)` when non-empty else substitutes a 1×1 RGB image ("PNG encode can't handle empty images"), encodes + base64 (`base64<char>::encode(..., noline())`); returns `{base64Image, getRequestedUrls()}`. G3D errors are rethrown as `runtime_error(e.reason)`.
- **`exportScene(ViewBase*, std::string*)`** (296): finds Workspace, `setImageServerView(false)` (returns previous allowDolly), binds view to parent DataModel, `view->exportSceneThumbJSON(ExporterSaveType_Everything, ExporterFormat_Obj, true, *outStr)`, unbinds.
- **`renderThumb(ViewBase*, windowHandle, fileType, cx, cy, hideSky, crop, strOutput*)`** (307):
  1. `hideSky` → create/toggle `Lighting`: `suppressSky(true)`; PNG requests additionally `setClearAlpha(0)` + later keep RGBA; other formats `setClearAlpha(1)`.
  2. Camera selection policy (comment 330–333): use a camera named **"ThumbnailCamera"** if present; models viewed from −Z via `w->setImageServerView(!hideSky /* = isAPlace*/)`.
  3. Allocates `G3D::GImage image(cx, cy, 4)`; `view->bindWorkspace(parentDataModel)`; `view->renderThumb(image.byte(), cx, cy, crop, allowDolly)`; unbind; `view->garbageCollect()`; converts to RGB when no alpha channel requested; encodes + base64 into `strOutput`.
  4. `hideSky` cleanup calls `setImageServerView(false)` again ("Hack to avoid double-toggle").

## Usage

Job scripts (submitted via OpenJob/BatchJob) call `game:GetService("ThumbnailGenerator"):Click(...)` / `:ClickTexture(...)`; results flow back through the Lua→SOAP value conversion in `RCCServiceSoapServiceImpl.cpp`. The service also appears in Diag memory counters as `ThumbnailGenerator::totalCount`.

## Gotchas

- **Single-render-thread design is load-bearing**: all `click()` calls serialize through one queue/thread; concurrent thumbnail requests queue rather than parallelize. The write-transfer lock is taken on the *worker* thread while the caller blocks on `doneEvent`.
- **Deadlock shape**: `click()` holds no DataModel lock while waiting, but any caller already holding a conflicting DataModel lock across `Click` will deadlock against the worker's `scoped_write_transfer`.
- Worker thread + GL context live forever once started (`call_once`); there is no shutdown hook for `gThumbRenderThread` (process exit tears it down).
- `clickTexture` bypasses rendering entirely — it's a re-encode/stretch pipeline over fetched texture bytes.
- OBJ export path ignores `cx/cy/hideSky/crop` and the image pipeline altogether.
- `ReadAccessKey()` is declared locally (line 159) but defined in RCCService.cpp — cross-TU coupling by free function.
- Typo'd local `tuble` (215, 283).
- `graphicsMode` property is bound under reflection name "GraphicsMode" but stored in member named `graphicsMode` with descriptor variable misleadingly called `prop_HeadColor`.
