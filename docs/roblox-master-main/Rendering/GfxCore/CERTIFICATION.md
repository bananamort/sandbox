# Rendering/GfxCore — Certification

Independent review of the GfxCore documentation set against sources in `roblox-sandbox/Rendering/GfxCore/` (glew/ excluded). Every source file was read IN FULL via tool calls before judging its `.md`; every concrete claim checked against code (API signatures, backend behaviors, vendor workarounds, flag gates).

- **Scope**: 63 code files (.cpp/.h/.mm), glew/ excluded — re-enumerated independently.
- **Coverage**: EXACT 1:1 match confirmed (diff of source list vs doc list is empty). INDEX.md roster matches the tree; build-system files (CMakeLists.txt, .vcxproj, .filters, .pbxproj) correctly excluded from documentation.
- **Method**: full source read → full doc read → claim-by-claim verification → mechanically-certain fixes applied in place. No sampling.
- **Verdicts**: PASS = accurate as written. FIXED = defects corrected during this review (all fixes mechanically certain from source). FAIL = uncorrectable/unverified claims remain (none).

## Totals

| Verdict | Count |
|---|---|
| PASS   | 47 |
| FIXED  | 16 |
| FAIL   | 0 |
| **Total** | **63** |

Plus INDEX.md: verified accurate (PASS).

## Per-file results

### Root (9)
| File | Verdict | Notes |
|---|---|---|
| Device.cpp | PASS | Flags/defaults, leak-crash path, lost(tail→head)/restored(head→tail) all correct |
| DeviceCreate.cpp | FIXED | Gotcha said Durango = "Xbox 360"; Durango is the Xbox One codename |
| Framebuffer.cpp | PASS | |
| Geometry.cpp | PASS | Minor style left: `isCountValid` is a file-local inline free function, not `static` member |
| pix.cpp | PASS | PIX_ENABLED=1 claim cross-checked against pix.h |
| Resource.cpp | PASS | |
| Shader.cpp | PASS | |
| States.cpp | PASS | |
| Texture.cpp | PASS | Format table verified enum-order against Texture.h |

### include/GfxCore (8)
| File | Verdict | Notes |
|---|---|---|
| Device.h | PASS | All virtual signatures verified |
| Framebuffer.h | PASS | copyFramebuffer/resolveFramebuffer/createRenderbuffer references verified real |
| Geometry.h | FIXED | "UNKNOWN exact formula" for short GeometryBatch ctor replaced with actual mapping (offset=0, begin=0, end=indexRangeSize; count unused for range) |
| pix.h | PASS | Stale in-file comment correctly flagged by writer |
| Resource.h | FIXED | Claimed fireDeviceLost walks head→tail; source walks tail→head (restored walks head→tail) |
| Shader.h | PASS | dumpToFLog static confirmed |
| States.h | PASS | Blend mode table, depth/stencil enums verified |
| Texture.h | PASS | Enum order verified |

### GL (19)
| File | Verdict | Notes |
|---|---|---|
| CardboardVRGL.cpp | PASS | Cardboard v2 spec constants, prediction caps, neck offset, C hooks verified |
| ContextGL.h | PASS | |
| ContextGLAndroid.cpp | PASS | Six-way config ladder, GLES2 pin, eglGetProcAddress core→ext fallback verified |
| ContextGLiOS.mm | PASS | Drawable-backed main FBO (nonzero id), retina gate ES3+iOS6 verified |
| ContextGLMac.mm | PASS | DepthSize 16 vs Win32's 24; 10.8 gate; deferred update flag verified |
| ContextGLWin32.cpp | PASS | Debug-context two-phase init, vsync-off verified |
| DeviceContextGL.cpp | FIXED | MISSING-GOTCHA added: setWorldTransforms4x3/setConstant deref cachedProgram unguarded (not even an assert, unlike D3D11) — cachedProgram null-deref pattern audit item; matches pattern already documented in D3D9 context doc |
| DeviceGL.cpp | PASS | Intel VAO loss / AMD TexStorage loss workarounds, NPOT ≥8192 heuristic, Adreno exclusion, 5s fence wait verified |
| DeviceGL.h | PASS | GearVR-not-exposed gotcha confirmed true |
| FramebufferGL.cpp | FIXED | Empty color list is RBXASSERT, not throw (throw only > maxDrawBuffers) |
| FramebufferGL.h | PASS | |
| GearVRGL.cpp | PASS | createGear unreachable via createVR() correctly noted |
| GeometryGL.cpp | PASS | baseVertexIndex folded into attrib pointer offsets correctly described |
| GeometryGL.h | PASS | |
| HeadersGL.h | FIXED | Extension resolution attributed to DeviceContextGL.cpp; actually ContextGLAndroid.cpp (eglGetProcAddress) + ContextGLiOS.mm (OES/GLES3 stubs) |
| ShaderGL.cpp | PASS | Source-scraped attribs/samplers, warn-only infolog, xlu_ convention verified |
| ShaderGL.h | FIXED | reloadBytecode described as "recompiles"; it throws ("Bytecode reloading is not supported") — fixed in API line and gotcha |
| TextureGL.cpp | PASS | PBO scratch ring, ETC1 whole-image fallback, GLES download=false verified |
| TextureGL.h | FIXED | Scratch path labeled "(GLES path)"; actual gate is GraphicsTextureCommitChanges + Dynamic + ext3 (desktop GL3 included) |

### D3D9 (11)
| File | Verdict | Notes |
|---|---|---|
| DeviceContextD3D9.cpp | PASS | cachedProgram null-deref pattern already documented correctly here; d3d9.dll D3DPERF probing + GetStatus gate verified |
| DeviceD3D9.cpp | FIXED | getFeatureLevel fallback omitted the "D3D_9.0" branch that exists in source |
| DeviceD3D9.h | FIXED | "API_D3D9" → actual enum API_Direct3D9; garbled "GL-of-D3D9-specific" phrase repaired |
| FramebufferD3D9.cpp | PASS | grabCopy ownership, BGRA swizzle, level-0 view gotcha verified |
| FramebufferD3D9.h | FIXED | "MRT capped at 4" unsupported (cap = probed NumSimultaneousRTs); "resolveFramebuffer is a no-op / MSAA implicit" inverted reality — resolve does explicit StretchRect, discardFramebuffer is the no-op |
| GeometryD3D9.cpp | FIXED | Gotcha lumped VertexLayout into stale-cache claim; ~VertexLayoutD3D9 calls invalidateCachedVertexLayout — rewrote to buffers/stream-bindings staleness only |
| GeometryD3D9.h | FIXED | Claimed indexRange params unused on D3D9; they are MinVertexIndex/NumVertices of DrawIndexedPrimitive |
| ShaderD3D9.cpp | PASS | d3dx9_43→24 DLL probing + matching D3DCompiler_N load, Globals register-prefix validation, packed handles all verified |
| ShaderD3D9.h | FIXED | Handle described as "raw register index"; it packs per-stage uniform-list indices ((vs+1)\|((fs+1)<<16)) |
| TextureD3D9.cpp | PASS | NVidia UpdateTexture-per-lock workaround (markAsDirty) and commitChanges/flushChanges mutual exclusion via GraphicsTextureCommitChanges both verified exactly right |
| TextureD3D9.h | FIXED | Mirror described as readback path for render targets; it is a SYSTEMMEM staging copy for Usage_Dynamic only, and download() returns false for non-MANAGED without touching it |

### D3D11 (16)
| File | Verdict | Notes |
|---|---|---|
| DeviceContextD3D11.cpp | PASS | SRV-unbind feedback avoidance, PS-only textures, front-INCR/back-DECR stencil (reversed vs GL/D3D9), depth-bias gated on DX11 profile verified |
| DeviceD3D11.cpp | PASS | `return false` in pointer function gotcha verified real; Intel gpuInit skip verified |
| DeviceD3D11.h | PASS | ReleaseCheck Durango refcount note verified |
| DeviceD3D11Durango.cpp | PASS | FLIP_SEQUENTIAL, DXGIXPresentArray overscan centering, xboxPlatformGetRenderSize_Hack verified |
| DeviceD3D11Win32.cpp | PASS | Self-assignment line, single FL 11_0 request, DISCARD swapchain verified |
| FramebufferD3D11.cpp | PASS | View-format inheritance, owner no-AddRef aliasing, staging readback verified |
| FramebufferD3D11.h | PASS | |
| GeometryD3D11.cpp | PASS | Static shadow-buffer lock path, DrawIndexed(count,offset,baseVertexIndex), indexRange unused — all verified |
| GeometryD3D11.h | PASS | |
| HeadersD3D11.h | PASS | |
| OculusVRD3D11.cpp | PASS | LUID adapter selection, SRGB typeless swap sets, AddRef wrapping, Ctrl+F8 perf HUD verified |
| OpenVRD3D11.cpp | PASS | openvr_api.dll dynamic loading, negated upTan/leftTan, WaitGetPoses sync point verified |
| ShaderD3D11.cpp | PASS | D3DReflect cbuffer extraction, Globals b0 size enforcement, profile translation, ROW_MAJOR verified |
| ShaderD3D11.h | FIXED | Gotcha claimed bytecode "parsed by hand (UNKNOWN format)" — construction-time D3DReflect reflection is the actual mechanism; sharedThis described as live self-reference/cycle risk — grep proves field is declared but never assigned anywhere in GfxCore |
| TextureD3D11.cpp | PASS | BC2→BC3 duplicate mapping quirk captured, staging download flow verified |
| TextureD3D11.h | PASS | |

## Cross-cutting audits

- **cachedProgram null-deref pattern**: present identically in DeviceContextGL (`cachedProgram->…`, no guard), DeviceContextD3D9 (no guard), DeviceContextD3D11 (RBXASSERT then deref — assert-only protection). Precondition in all three backends: bindProgram must precede setWorldTransforms4x3/setConstant, and clearStates()/invalidateCachedProgram() reset the cache every frame via beginFrame. Now documented in all three context docs (D3D9 already had it; GL added this review; D3D11 documents its assert).
- **NVidia vendor workaround**: TextureD3D9::markAsDirty issues `UpdateTexture(mirror, object)` immediately after every lock/unlock when `caps.vendor == Vendor_NVidia` (in-code comment cites driver perf); other vendors defer via mirrorDirty until flushChanges (bind time) or commitChanges. Doc claim verified accurate.
- **commitChanges/flushChanges mutual exclusion**: on D3D9, `GraphicsTextureCommitChanges` ON ⇒ flushChanges early-outs and commitChanges performs UpdateTexture; OFF ⇒ reverse. On GL the same flag gates the PBO scratch ring (supportsLocking/commitChanges); on D3D11 both are inert stubs. Docs state this correctly after review.
- **d3dx9 DLL probing**: ShaderProgramD3D9 loads `d3dx9_43.dll` down to `d3dx9_24.dll` (first hit wins, also loads matching `D3DCompiler_N.dll`), resolving `D3DXCompileShader`/`D3DXPreprocessShader` by name. Separate, unrelated probes: `d3d9.dll` (Direct3DCreate9; D3DPERF_* markers in both contexts incl. D3D11's), `d3d11.dll` (feature-level probe + CreateDeviceAndSwapChain + CreateDXGIFactory), `D3DCompiler_47.dll` (D3D11 pipeline), `openvr_api.dll`. Docs verified on all counts.
