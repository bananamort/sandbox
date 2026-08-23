# Rendering/GfxCore/GL/ShaderGL.cpp

## Purpose

Implementation of the GL shader stack. Compiles GLSL source into shader/program objects, scrapes source text for attribute and sampler declarations (text-based reflection), builds uniform tables at link time, binds sampler slots once per program, uploads global-constant blocks lazily on version change, and handles 4x3 world-matrix transposition.

## API

- `static int getShaderParameter(GLuint, GLenum)` / `getProgramParameter` — iv getters.
- `template<GetParameter, GetLog> static std::string getInfoLog(id, ...)`; `dumpInfoLog(...)` — logs only when the log contains "warn"/"Warn"/"WARN" ("Intel and AMD drivers like to say 'No errors' for every shader").
- `static unsigned int compileShader(const std::string& source, GLenum type)` — glShaderSource/glCompileShader; throws runtime_error(infoLog) on GL_COMPILE_STATUS != 1.
- `static unsigned int parseAttribs(const std::string& source, const char* prefix)` — scans lines starting with prefix ("in " on ext3, else "attribute ") that end in ';' before EOL; maps names via `VertexLayoutGL::getShaderAttributeName(attr)` into a 16-bit mask.
- `static void applyAttribs(unsigned int programId, unsigned attribMask)` — glBindAttribLocation for each active attr before linking.
- `static vector<Sampler> parseSamplers(const std::string& source)` — parses `//$$NAME=sN` comment directives into name→slot entries.
- `static int getSamplerLocation(unsigned id, const std::string& name)` — glGetUniformLocation under plain or "xlu_" prefixed name.
- `static unsigned applySamplers(unsigned id, const vector<Sampler>&)` — glUniform1i slot assignment while briefly bound; returns used-slot bitmask; leaves current program 0.
- `static Uniform::Type getUniformType(GLenum)` — FLOAT/VEC2/VEC3/VEC4/MAT4 → typed enum, else Unknown.
- `static UniformTable extractUniforms(unsigned id)` — glGetActiveUniform walk; strips "xlu_" prefix and "[i]" array suffix from names.
- `static findUniform(table, name)`; `static transposeMatrix(float* dest, const float* src4x3, const float* lastColumn)` — column-major↔row-major shuffle with injected last column.
- `VertexShaderGL(Device*, const std::string& source)` — compiles GL_VERTEX_SHADER + attrib scan; dtor deletes shader; `reloadBytecode` throws "Bytecode reloading is not supported".
- `FragmentShaderGL(Device*, source)` — compiles GL_FRAGMENT_SHADER + `//$$` sampler scan; same reload behavior.
- `ShaderProgramGL(Device*, vs, fs)` — create/attach/applyAttribs/link (throw on failure) → invalidateCachedProgram (applySamplers resets program binding) → samplerMask → partition uniforms: globals (matched against Device's `globalConstants` list by name, offset filled from the list) / WorldMatrix (Float4x4, maxWorldTransforms=1) / WorldMatrixArray (Float4 ×3 per matrix, maxWorldTransforms=size/3) / remainder kept as named uniforms. Destructor deletes program + invalidates cached program.
- `int getConstantHandle(const char*)` — index into `uniforms` vector or -1.
- `void bind(const void* globalData, unsigned globalVersion, ShaderProgramGL** cache)` — glUseProgram on cache change; when version differs re-uploads each global uniform from its byte offset; Float4x4 path transposes with data+12 as last column.
- `void setWorldTransforms4x3(const float*, size_t)` — single-matrix transpose with synthetic {0,0,0,1} column; array path raw glUniform4fv of matrixCount*3 vectors.
- `void setConstant(int handle, const float*, size_t vectorCount)` — glUniform dispatch by type; Float4 allows arrays, others assert vectorCount==1.

## Usage

The abstract pipeline (`createShaderSource` returns raw file text; `createShaderBytecode` is identity) feeds these classes. Programs are bound exclusively through DeviceContextGL::bindProgram → bind(). Sampler slots come from shader-source comments rather than driver reflection — a Roblox-specific convention.

## Gotchas

- Attribute/sampler discovery is **source-text scraping**, not GL reflection: attributes must be declared one-per-line at line start ending with ';'; samplers must carry `//$$Name=sSlot` comments or they get arbitrary slots (mask misses them).
- The "xlu_" prefix convention marks entrypoint-local uniforms; getSamplerLocation/extractUniforms both special-case it.
- Globals matching depends on DeviceGL::defineGlobalConstants having been called BEFORE any program construction (constructor reads device->getGlobalConstants()).
- All matrices uploaded transposed with transpose=false; engine matrices are row-major 4x3.
- applySamplers temporarily binds program 0 — hence the invalidateCachedProgram dance right after link.
- setConstant asserts type-appropriate vector counts; passing matrices through setConstant hits RBXASSERT(false).
