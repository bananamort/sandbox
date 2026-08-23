# Rendering/GfxCore/include/GfxCore/Shader.h

## Purpose

Declares the backend-neutral shader object model: `VertexShader`, `FragmentShader`, and the linked pair `ShaderProgram`, plus the `ShaderGlobalConstant` descriptor used to lay out global constant buffers. Backends (D3D9/D3D11/GL) subclass these to wrap HLSL vertex/fragment shaders + effect programs or GL program objects. Note the design speaks of *bytecode*: source compilation happens on the Device (`createShaderSource` / `createShaderBytecode`), and shaders are constructed from precompiled bytecode blobs.

## API

- `class VertexShader : public Resource`
  - `virtual void reloadBytecode(const std::vector<char>& bytecode) = 0` — hot-swap shader bytecode without recreating the object.
  - `protected VertexShader(Device* device)`; non-virtual dtor declared.
- `class FragmentShader : public Resource` — identical shape (`reloadBytecode`).
- `class ShaderProgram : public Resource`
  - ctor takes `shared_ptr<VertexShader> vertexShader, shared_ptr<FragmentShader> fragmentShader` (stored as members).
  - `virtual int getConstantHandle(const char* name) const = 0` — maps a constant name to an int handle for `DeviceContext::setConstant`.
  - `virtual unsigned int getMaxWorldTransforms() const = 0` — size of the world-matrix array the program can index.
  - `virtual unsigned int getSamplerMask() const = 0` — bitmask of sampler stages the program actually uses.
  - `static void dumpToFLog(const std::string& text, int channel)` — debug dump helper.
- `struct ShaderGlobalConstant { const char* name; unsigned int offset; unsigned int size; ShaderGlobalConstant(const char*, unsigned int, unsigned int); }` — one entry in the process-global constant table registered via `Device::defineGlobalConstants(dataSize, constants)`.

## Usage

Upper rendering layers request shaders through `Device::createVertexShader/createFragmentShader(createShaderBytecode(...))` and combine them with `createShaderProgram`. Per-draw binding goes through `DeviceContext::bindProgram(ShaderProgram*)`; per-frame globals go through `updateGlobalConstants` using offsets described by `ShaderGlobalConstant`. `getSamplerMask()` lets the context skip redundant sampler binds; `getMaxWorldTransforms()` bounds skinning/batched-transform arrays.

## Gotchas

- `reloadBytecode` exists specifically for runtime shader replacement/hot-reload paths; programs keep referencing the same Vertex/Fragment objects.
- Constant handles are plain ints resolved once via `getConstantHandle(name)` — UNKNOWN whether invalid names return a sentinel (-1 vs 0) uniformly across backends; check per-backend implementations.
- The header only declares dtors (not defined here); they live in Shader.cpp.
