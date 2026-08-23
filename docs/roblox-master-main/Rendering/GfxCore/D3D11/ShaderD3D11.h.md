# Rendering/GfxCore/D3D11/ShaderD3D11.h

## Purpose

D3D11 shader stack: `UniformD3D11` descriptor, `CBufferD3D11` (constant buffer with CPU-side shadow), `BaseShaderD3D11` (shared bytecode + cbuffer reflection logic for both stages), `VertexShaderD3D11` (with per-layout input-layout cache and world-matrix handling), `FragmentShaderD3D11` (sampler mask), and `ShaderProgramD3D11` (pair binding plus the static source/bytecode pipeline incl. dynamic compiler-DLL loading).

## API

- `struct UniformD3D11 { std::string name; unsigned offset; unsigned size; }`.
- `class CBufferD3D11 : public Resource`
  - ctor `(device, int registerId, name, sizeIn, uniformsIn)`.
  - getters `getUniforms()/getName()/getRegisterId()/getObject()`; `const UniformD3D11& getUniform(int id)`; `int findUniform(const std::string&)`.
  - `void updateUniform(int uniformId, const float* uniformData, unsigned vectorCount)` — writes into shadow `char* data`; `void updateBuffer()` — flushes shadow to ID3D11Buffer when dirty.
- `class BaseShaderD3D11`
  - ctor parses `const std::vector<char>& bytecode` (reflection done in cpp).
  - `getByteCode()`; `int findUniform(name)`; `void setConstant(int handle, const float*, size_t vectorCount)`; `void updateConstantBuffers()`.
  - Members: `CBufferList cBuffers`, `int uniformsBufferId` (which cbuffer holds per-draw constants).
- `class VertexShaderD3D11 : public VertexShader, public BaseShaderD3D11, enable_shared_from_this`
  - ctor compiles bytecode → ID3D11VertexShader via deferred creation path; `reloadBytecode`.
  - `getObject()`; input-layout management: `ID3D11InputLayout* getInputLayout11(VertexLayoutD3D11*)` (creates+caches in `InputLayoutMap`), `removeLayout(VertexLayoutD3D11*)`.
  - World transforms: `setWorldTransforms4x3(const float*, size_t matrixCount)`, `getMaxWorldTransforms()`; private handles `worldMatrixArray/worldMatrix/worldMatrixCbuffer`, `maxWorldTransforms`; `shared_ptr sharedThis` self-pin.
- `class FragmentShaderD3D11 : public FragmentShader, public BaseShaderD3D11`
  - ctor/reloadBytecode; `getObject()` (ID3D11PixelShader); re-exposes `getCBuffers()`; `unsigned getSamplerMask()` — computed from reflected sampler slots.
- `class ShaderProgramD3D11 : public ShaderProgram`
  - `getConstantHandle(const char*)` — encodes cbuffer+uniform into an int handle; `getMaxWorldTransforms()/getSamplerMask()` forward to stages.
  - `getInputLayout11(VertexLayoutD3D11*)` (delegates to VS); frame glue: `bind()`, `setWorldTransforms4x3(...)`, `setConstant(...)`, `uploadConstantBuffers()`.
  - Static compile pipeline: `createShaderSource(path, defines, const DeviceD3D11*, fileCallback)` (preprocessor with #include expansion through fileCallback); `createShaderBytecode(source, target, device, entrypoint)`; `static HMODULE loadShaderCompilerDLL()`.

## Usage

DeviceD3D11::createShaderSource/Bytecode delegate here; runtime flow per draw: bindProgram → program->bind() (sets VS/PS objects + global cbuffer) → setConstant/setWorldTransforms write shadows → uploadConstantBuffers flushes dirty cbuffers before drawImpl.

## Gotchas

- Bytecode is standard D3D compiler output reflected at construction time via `D3DReflect` (see `extractCbuffers` in ShaderD3D11.cpp): cbuffers, `$Globals` uniforms and sampler bind points all come from that reflection pass.
- The header declares a `sharedThis` self-reference member on VertexShaderD3D11, but nothing in this tree ever assigns or reads it (dead field as shipped) — no cycle exists in practice despite the declaration.
- World transforms are a special-cased cbuffer (`worldMatrixCbuffer`) separate from named uniforms.
