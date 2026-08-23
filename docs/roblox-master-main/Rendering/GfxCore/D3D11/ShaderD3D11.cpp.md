# Rendering/GfxCore/D3D11/ShaderD3D11.cpp

## Purpose

Implementation of the D3D11 shader stack: `CBufferD3D11` (reflection-driven constant buffer with CPU shadow), `BaseShaderD3D11`/`VertexShaderD3D11`/`FragmentShaderD3D11` (compiled shader objects with cbuffer metadata), and `ShaderProgramD3D11` (VS+FS pairing, input-layout baking, constant-handle packing, source preprocessing and offline-style compilation via D3DCompiler).

## API

- Compiler loaders: `static TypeD3DCompile loadShaderCompiler()`, `loadShaderPreprocessor()`, `loadShaderReflector()` — GetProcAddress from `ShaderProgramD3D11::loadShaderCompilerDLL()` (`D3DCompiler_47.dll`, cached static); direct function pointers under RBX_PLATFORM_DURANGO.
- `static void extractCbuffers(Device*, const std::vector<char>& bytecode, std::vector<shared_ptr<CBufferD3D11>>& cbuffers, unsigned globalSize, unsigned int* outSamplerMask)` — D3DReflect walk: collects texture bind points into a sampler mask; cbuffers at register 0 must be named "Globals" and match `globalSize` exactly (throws otherwise) and are skipped (device-global); all other cbuffers become `CBufferD3D11` entries with name/offset/size uniforms.
- `static int findCBuffer(const vector<shared_ptr<CBufferD3D11>>&, const string& name)` — index or -1.
- `static ID3D11VertexShader* createVertexShader(Device*, bytecode, cbuffers&, int& uniformsCBuffer, unsigned& maxWorldTransforms, int& worldMatCBuffer, int& uniformWorldMatrix, int& uniformWorldMatrixArray)` — reflection + CreateVertexShader; world-transform capacity derived from `WorldMatrix` (1) or `WorldMatrixArray` size / 48 bytes.
- `static ID3D11PixelShader* createPixelShader(Device*, bytecode, cbuffers&, int& uniformsCBuffer, unsigned& samplerMask)` — reflection + CreatePixelShader; `$Globals` is the uniforms cbuffer for both stages.
- `CBufferD3D11(Device*, int registerId, const std::string& name, unsigned size, const std::vector<UniformD3D11>&)` — zeroed CPU shadow + DEFAULT constant buffer.
- `void CBufferD3D11::updateUniform(int uniformId, const float* data, unsigned vectorCount)` — memcmp-diffed write into shadow (vectors are always float4); marks dirty.
- `void CBufferD3D11::updateBuffer()` — `UpdateSubresource` of full shadow when dirty.
- `int findUniform(const std::string&)`; `const UniformD3D11& getUniform(int)`; destructor releases buffer + shadow.
- `BaseShaderD3D11(const std::vector<char>& bytecode)`; `int findUniform(name)` (via `$Globals` cbuffer), `void setConstant(int handle, const float*, size_t)`, `void updateConstantBuffers()`.
- `VertexShaderD3D11(Device*, bytecode)`; `void reloadBytecode(const std::vector<char>&)`; `ID3D11InputLayout* getInputLayout11(VertexLayoutD3D11*)` — lazily bakes+registers an input layout per (shader, layout) pair; `void removeLayout(VertexLayoutD3D11*)`; `void setWorldTransforms4x3(const float* data, size_t matrixCount)` — single-matrix path appends `{0,0,0,1}` last row into float[16]; array path writes matrixCount*3 vectors raw.
- `FragmentShaderD3D11(Device*, bytecode)` (+ reloadBytecode); owns `samplerMask`.
- `static void verifyShaderSignatures(const VertexShaderD3D11*, const FragmentShaderD3D11*)` — non-release only; every FS input signature element must exist in VS outputs (type/register/semantic/system-value).
- `ShaderProgramD3D11(Device*, shared_ptr<VertexShader>, shared_ptr<FragmentShader>)`; destructor invalidates context program cache.
- `struct IncludeCallback : ID3DInclude` — resolves includes through caller's `fileCallback(path)`, tracks per-buffer path map for relative include chains; returns ERROR_FILE_NOT_FOUND on failure.
- `template<T> static std::vector<T> consumeData(HRESULT, ID3DBlob* buffer, ID3DBlob* messages)` — success: log warnings, copy blob out; failure: throw with compiler log or `"Unknown error %x"`.
- `static std::string ShaderProgramD3D11::createShaderSource(const std::string& path, const std::string& defines, const DeviceD3D11*, boost::function<std::string(const std::string&)> fileCallback)` — D3DPreprocess over `#include "<path>"`; defines parsed as whitespace-separated tokens with optional `NAME=VALUE` (else =1); always adds `DX11=1`, adds `WIN_MOBILE=1` on feature-level 9_3 profiles; strips leading absolute-path `#line 1 "..."` directive.
- `static void translateShaderProfile(const std::string& originalTarget, ShaderProfile, std::string& targetOut)` — rewrites e.g. `vs_2_0` → `vs_5_0` or `vs_4_0_level_9_3`.
- `static bool needsBackwardCompatibility(const std::string& target)` — true when target char [3] >= '4'.
- `static std::vector<char> createShaderBytecode(const std::string& source, const std::string& target, const DeviceD3D11*, const std::string& entrypoint)` — D3DCompile with `D3DCOMPILE_PACK_MATRIX_ROW_MAJOR` (+ back-compat flag).
- Program interface: `getInputLayout11(layout)`, `unsigned getMaxWorldTransforms()`, `setWorldTransforms4x3(...)`, `int getConstantHandle(const char*)` — packs VS/FS uniform indices as `(vs+1) | ((fs+1)<<16)`; `void setConstant(int, const float*, size_t)` unpacks to both stages; `uploadConstantBuffers()`, `unsigned getSamplerMask()`, `void bind()` — binds each stage's cbuffers by registerId then VSSetShader/PSSetShader.

## Usage

The abstract Device pipeline (`createShaderSource` → `createShaderBytecode` → `createVertexShader/createFragmentShader/createShaderProgram`) lands here. Runtime binds happen exclusively through `DeviceContextD3D11::bindProgram` → `bind()`; constants flow `setConstant(handle)` → per-stage `$Globals` shadow → flushed at draw time by `GeometryD3D11::draw` → `uploadConstantBuffers`.

## Gotchas

- The Globals cbuffer **must** be bound to register(b0) with byte size equal to the device-wide global block, or shader creation throws.
- Uniform handles are bit-packed (16 bits per stage); a uniform present in both VS and FS updates both on one `setConstant`.
- Matrices are compiled ROW_MAJOR; world transforms arrive as 4x3 and are expanded with a synthetic last row only in the single-matrix path — the array path writes raw 12-float matrices.
- `createShaderSource` strips only the specific `#line 1 "<drive>:"` first-line pattern (checks result[10]==':'); other #line forms survive.
- Include resolution depends entirely on the injected `fileCallback`; relative includes are resolved against the parent buffer's path recorded in `IncludeCallback::paths` — including the same file twice allocates separate copies.
- Sampler mask reflects textures bound in the pixel shader only (`createPixelShader` passes `&samplerMask`; VS passes NULL).
- D3DCompiler_47.dll is loaded lazily once per process; if absent, compile/reflection calls assert then crash on null pointer.
