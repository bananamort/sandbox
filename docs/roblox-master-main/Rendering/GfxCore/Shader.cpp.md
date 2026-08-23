# Rendering/GfxCore/Shader.cpp

## Purpose

Non-template plumbing for the shader object model: ctors/dtors of `VertexShader`, `FragmentShader`, `ShaderProgram` (which retains shared_ptr references to both stage objects), the `ShaderProgram::dumpToFLog` line-splitter, and the `ShaderGlobalConstant` ctor.

## API

- `VertexShader::VertexShader(Device*) / ~VertexShader()` — pass-through to Resource.
- `FragmentShader::FragmentShader(Device*) / ~FragmentShader()`.
- `ShaderProgram::ShaderProgram(Device*, const shared_ptr<VertexShader>&, const shared_ptr<FragmentShader>&)` — stores both stages.
- `static void ShaderProgram::dumpToFLog(const std::string& text, int channel)` — splits on `'\n'` (boost::split), trims trailing empty lines, emits each line via `FASTLOGS(channel, "%s", line)`.
- `ShaderGlobalConstant::ShaderGlobalConstant(const char* name, unsigned int offset, unsigned int size)`.

## Usage

Backends call these base ctors from their own (e.g. `ShaderD3D11(Device*)`). `dumpToFLog` is used for compiler info/error dumps on a chosen FastLog channel.

## Gotchas

- ShaderProgram keeps shared_ptr refs, so destroying a program does not destroy its stage shaders — stages can be shared between programs.
- All real backend work (native handles, constant reflection) lives in D3D9/D3D11/GL subclasses.
