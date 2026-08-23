# Rendering/GfxCore/D3D9/ShaderD3D9.cpp

## Purpose

Implementation of D3D9 shader objects: constant-table reflection into `UniformD3D9` records, global-constant register validation, VS/PS creation with special-cased world-matrix registers, packed-handle constant setting, and runtime HLSL preprocessing/compilation through dynamically loaded d3dx9 DLLs.

## API

Implements VertexShaderD3D9, FragmentShaderD3D9, ShaderProgramD3D9, ShaderProgramFFPD3D9 from ShaderD3D9.h.

- Reflection helpers:
  - `extractUniforms(ID3DXConstantTable*, prefix, container, size, out, samplerMask)` — recursive walk; trims leading `$`; recurses into D3DXPC_STRUCT members as `prefix.name.`; samplers recorded in a bitmask; everything else becomes a UniformD3D9 (bool/int4/float register set).
  - `extractUniforms(const DWORD* bytecodePointer, unsigned int* outSamplerMask)` — via D3DXGetShaderConstantTable; throws RBX::runtime_error on failure or missing table.
  - `validateUniformsAndDisableGlobal(uniforms, globalDataSize, globalConstants)` — any uniform fully inside the reserved global register block [0, globalDataSize/16) must match a named global constant's expected offset/size (register range must be a prefix); matching globals are disabled (name cleared), mismatches throw.
  - `removeDisabledUniforms`, `findUniform(uniforms, name)` → index or −1, `reloadUniforms` (match by name; missing uniforms get zeroed registers but keep their slot).
- Shader creation:
  - `createVertexShader(device, bytecode, uniforms, registerWorldMatrix, registerWorldMatrixArray, maxWorldTransforms)` — extracts + validates uniforms, then pulls `WorldMatrix` (single transform, maxWorldTransforms=1) and `WorldMatrixArray` (registerCount must be multiple of 3; maxWorldTransforms = count/3) out of the uniform list into dedicated registers; creates the COM object.
  - `createPixelShader(device, bytecode, uniforms, samplerMask)` — same minus matrix handling.
- Constructors/reload: `VertexShaderD3D9`/`FragmentShaderD3D9` build from bytecode (registerWorldMatrix/-Array start at −1); `reloadBytecode` rebuilds and rematches uniforms by name so stale handles stay index-stable.
- `ShaderProgramD3D9`:
  - dtor invalidates the device context's cached program.
  - `bind()` — SetVertexShader + SetPixelShader.
  - `setWorldTransforms4x3(data, count)` — writes 4x4 (4x3 padded with {0,0,0,1}) to WorldMatrix register, or raw 4x3 triples to WorldMatrixArray (`matrixCount*3` float4s).
  - `getConstantHandle(name)` — packs both stages into one int: `(vsIndex+1) | ((fsIndex+1) << 16)`; −1 if absent in both.
  - `setConstant(handle, data, vectorCount)` — unpacks handle; per stage writes `u.registerCount` float4s via Set{Vertex,Pixel}ShaderConstantF; negative slot skipped; zero-registerCount uniforms skipped.
- Compilation:
  - `IncludeCallback : ID3DXInclude` — resolves #include paths relative to the parent file via fileCallback; maps returned buffer pointer→path for nested includes; Close frees.
  - `loadShaderCompilerDLL()` — tries d3dx9_43.dll down to d3dx9_24.dll (also loads matching D3DCompiler_N.dll); cached static.
  - `consumeData<T>(hr, buffer, messages)` — logs warning output on success, throws std::runtime_error with compiler log on failure.
  - `createShaderSource(path, defines, fileCallback)` — builds D3DXMACRO array from "NAME" / "NAME=VALUE" whitespace-split defines, preprocesses `#include "<path>"`, strips the leading `#line 1 "<drive>:` directive the preprocessor emits.
  - `createShaderBytecode(source, target, entrypoint)` — D3DXCompileShader with D3DXSHADER_PACKMATRIX_ROWMAJOR.
- `ShaderProgramFFPD3D9` — null shaders; getConstantHandle returns 0 for "Color", else −1; getMaxWorldTransforms()=1; getSamplerMask()=0.

## Usage

Source pipeline: createShaderSource (preprocess) → createShaderBytecode (compile) → DeviceD3D9::createVertexShader/createFragmentShader/createShaderProgram. Renderer queries handles once, then setConstant/setWorldTransforms4x3 each frame through the bound program. reloadBytecode supports hot-reload without invalidating stored handles.

## Gotchas

- The reserved global register block is mandatory: shaders whose non-global uniforms collide with it fail construction (throw), and bool/int uniforms anywhere throw ("unsupported register set") — D3D9 path only supports float constants by design.
- Handle encoding caps each stage's uniform index at 65534; indices are +1-biased so 0 is never a valid slot value.
- `setConstant` writes `u.registerCount` floats regardless of caller-supplied vectorCount beyond an assert — undersized buffers over-read (assert-only guard).
- After reloadBytecode, uniforms missing from new bytecode keep their vector slot with registerIndex=0/registerCount=0 — setConstant silently no-ops for them (handle still valid).
- Matrix layout depends on D3DXSHADER_PACKMATRIX_ROWMAJOR at compile time plus explicit transposes here; mixing compiled-with-different-flags bytecodes breaks transforms.
- d3dx9 DLL discovery is ordinal-name based (d3dx9_43…24): machines with only newer redists or only D3DCompiler DLLs fail compilation at runtime with "Unable to load shader compiler".
- Include callback allocates with `new char[source.length()]` (no NUL terminator) — length-based copy is correct but any consumer treating ppData as a C string over-reads.
- The `#line 1 "` strip heuristic checks `result[10] == ':'` — assumes a drive-letter path; UNC/network paths would slip through unstripped.
