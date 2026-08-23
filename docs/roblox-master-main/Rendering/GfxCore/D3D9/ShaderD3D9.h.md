# Rendering/GfxCore/D3D9/ShaderD3D9.h

## Purpose

Class declarations for D3D9 shader objects: `UniformD3D9` (constant-register reflection record), `VertexShaderD3D9`/`FragmentShaderD3D9` (bytecode-backed shader wrappers), `ShaderProgramD3D9` (VS+PS pair with register-based constant setting and HLSL source/bytecode compilation helpers), and `ShaderProgramFFPD3D9` (fixed-function emulation program).

## API

- `struct UniformD3D9` — `enum RegisterSet { Register_Float, Register_Bool, Register_Int, Register_Count }`; fields `std::string name; RegisterSet registerSet; unsigned int registerIndex; unsigned int registerCount;`.
- `class VertexShaderD3D9 : public VertexShader`
  - `VertexShaderD3D9(Device*, const std::vector<char>& bytecode)` / destructor.
  - `void reloadBytecode(const std::vector<char>& bytecode)`.
  - `IDirect3DVertexShader9* getObject()`.
  - Reflection: `int getRegisterWorldMatrix()`, `int getRegisterWorldMatrixArray()`, `unsigned int getMaxWorldTransforms()`, `const std::vector<UniformD3D9>& getUniforms()`.
  - Members: object, registerWorldMatrix, registerWorldMatrixArray, maxWorldTransforms, uniforms.
- `class FragmentShaderD3D9 : public FragmentShader`
  - `FragmentShaderD3D9(Device*, const std::vector<char>& bytecode)` / destructor; `reloadBytecode(...)`.
  - `IDirect3DPixelShader9* getObject()`; `unsigned int getSamplerMask()`; `getUniforms()`.
- `class ShaderProgramD3D9 : public ShaderProgram`
  - `ShaderProgramD3D9(Device*, const shared_ptr<VertexShader>&, const shared_ptr<FragmentShader>&)` / destructor.
  - `int getConstantHandle(const char* name) const`; `unsigned int getMaxWorldTransforms() const`; `unsigned int getSamplerMask() const`.
  - Bind-time helpers used by DeviceContextD3D9: `void bind(); void setWorldTransforms4x3(const float* data, size_t matrixCount); void setConstant(int handle, const float* data, size_t vectorCount);`
  - Statics: `createShaderSource(path, defines, fileCallback)` → processed HLSL source; `createShaderBytecode(source, target, entrypoint)` → compiled bytecode vector.
- `class ShaderProgramFFPD3D9 : public ShaderProgram`
  - `ShaderProgramFFPD3D9(Device*)` / destructor; overrides getConstantHandle/getMaxWorldTransforms/getSamplerMask only.

## Usage

Created via DeviceD3D9's shader factories. The context binds a `ShaderProgramD3D9` and routes world-transform/constant updates through it (register writes on the device). `ShaderProgramFFPD3D9` pairs with `DeviceContextFFPD3D9` for hardware without usable shader support. Uniform reflection is parsed from compiled bytecode/disassembly at construction (see ShaderD3D9.cpp).

## Gotchas

- Constants are addressed by a packed per-stage index (`handle` = `(vsIndex+1) | ((fsIndex+1) << 16)` into each stage's `uniforms` vector), not by name — name→handle mapping lives in ShaderProgramD3D9::getConstantHandle; register indices come from the referenced UniformD3D9 at set time.
- World matrix registers are special-cased (`registerWorldMatrix`/`registerWorldMatrixArray`) rather than being ordinary named constants.
- `createShaderBytecode` shells out to the HLSL compiler with a `target` profile string — invalid profiles fail at runtime, not compile time.
- Sampler mask comes from the fragment shader only; vertex-stage samplers are not modeled.
