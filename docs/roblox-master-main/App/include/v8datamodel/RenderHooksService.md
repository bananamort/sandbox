# App/include/v8datamodel/RenderHooksService.h

## Purpose

`RenderHooksService` — non-creatable service bridging the data model to the renderer through two injected interfaces: `IMainWndHooks` (window resize) and `IRenderHooks` (metrics capture, adorn enable, scene print). Also relays shader-reload and render-queue enable/disable commands as signals and exposes the latest `RenderMetrics` snapshot.

## Declared API

- `struct IMainWndHooks { virtual void resizeWindow(int cx, int cy) = 0; }`
- `struct RenderMetrics { double presentTime, renderAve, deltaAve, GPUDelay; double renderConfidenceMin, renderConfidenceMax; double renderStd; }`
- `struct IRenderHooks { virtual void captureMetrics(RenderMetrics&) = 0; virtual void enableAdorns(bool) = 0; virtual void printScene() = 0; }`
- `class RenderHooksService : public DescribedNonCreatable<RenderHooksService, Instance, sRenderHooksService>, public Service`
  - Injection (inline): `setMainWndHooks(IMainWndHooks*)`, `setRenderHooks(IRenderHooks*)`.
  - Metric getters (inline over private RenderMetrics): `getPresentTime()`, `getGPUDelay()`, `getRenderAve()`, `getRenderConfMin()`, `getRenderConfMax()`, `getRenderStd()`, `getDeltaAve()`.
  - Delegating actions: `void enableAdorns(bool enabled)`, `void printScene()`, `void captureMetrics()`, `void resizeWindow(int cx, int cy)` — forward to injected interfaces.
  - Signal relays (inline fire helpers): `reloadShadersSignal<void()>` + `reloadShaders()`; `enableQueueSignal<void(int)>` + `enableQueue(int qID)`; `disableQueueSignal<void(int)>` + `disableQueue(int qID)`.

## Gotchas

- Raw unowned interface pointers — the renderer/window must outlive the service or hooks dangle.
- Metrics are a passive snapshot: values only refresh when someone calls captureMetrics().
- The signal-relay pattern means reloadShaders/enableQueue do nothing unless a listener is connected.

## UNKNOWN

- Who injects the IRenderHooks implementation in each build flavor (GfxCore side, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/RenderHooksService.md](../../v8datamodel/RenderHooksService.md).
- Renderer side: GfxCore docs under App/render; job context: [BaseRenderJob.md](BaseRenderJob.md), [DataModel.md](DataModel.md).
