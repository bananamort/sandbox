# Rendering/GfxCore/GL/ShaderGL.h

## Purpose

Class declarations for the GL shader stack: `VertexShaderGL`, `FragmentShaderGL` (compiled GLSL shader objects; the VS exposes its attribute mask, the FS its sampler list), and `ShaderProgramGL` (linked program with uniform metadata, world-transform slots, and global-constant version tracking).

## API

- `class VertexShaderGL : public VertexShader`
  - `VertexShaderGL(Device*, const std::string& source)` / `~VertexShaderGL()`.
  - `void reloadBytecode(const std::vector<char>& bytecode)` — recompiles from new source.
  - `unsigned int getId()` — GL shader object id.
  - `unsigned int getAttribMask()` — bitmask of active vertex attributes.
- `class FragmentShaderGL : public FragmentShader`
  - nested `struct Sampler { std::string name; int slot; }`.
  - ctor/dtor/reloadBytecode as above; `getId()`; `const std::vector<Sampler>& getSamplers()`.
- `class ShaderProgramGL : public ShaderProgram`
  - nested `struct Uniform { enum Type { Type_Unknown, Type_Float, Type_Float2, Type_Float3, Type_Float4, Type_Float4x4, Type_Count }; int location; Type type; unsigned int size; unsigned int offset; }` — offset is the byte position inside the shared globals buffer.
  - `ShaderProgramGL(Device*, shared_ptr<VertexShader>, shared_ptr<FragmentShader>)` / `~`.
  - `int getConstantHandle(const char* name) const`; `unsigned int getMaxWorldTransforms() const`; `unsigned int getSamplerMask() const`.
  - `void bind(const void* globalData, unsigned int globalVersion, ShaderProgramGL** cache)` — use program + lazily re-upload globals when version changed.
  - `void setWorldTransforms4x3(const float* data, size_t matrixCount)`; `void setConstant(int handle, const float* data, size_t vectorCount)`.
  - `unsigned int getId()` — program object id.
  - Members: `id; int uniformWorldMatrix; int uniformWorldMatrixArray; unsigned cachedGlobalVersion; std::vector<Uniform> globalUniforms; std::vector<std::pair<std::string, Uniform>> uniforms; unsigned maxWorldTransforms; unsigned samplerMask;`.

## Usage

Created by DeviceGL factories from GLSL source strings. Runtime flow: DeviceContextGL::bindProgram → bind(...) with the context's global buffer and version counter; per-draw setWorldTransforms4x3/setConstant write uniforms directly via glUniform calls.

## Gotchas

- GL compiles at construction time (source in = compiled object out); "bytecode" reloads are actually full source recompiles.
- Uniform handles are indices into the program's own `uniforms` vector, not packed VS/FS pairs like D3D11.
- The globals model differs from D3D11's constant-buffer scheme: one flat byte block + per-program uniform offsets, re-uploaded only when `globalVersion` changes.
