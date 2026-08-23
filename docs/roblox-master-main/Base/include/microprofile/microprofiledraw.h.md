# microprofile/microprofiledraw.h

## Purpose
VENDORED MicroProfile optional GL3 renderer: an immediate-mode batched 2D draw path (vertex/command ring, embedded bitmap font atlas, GLSL 110/150 shaders) implementing the MicroProfileDrawText/Box/Line2D callbacks natively in OpenGL. Requires microprofile.h first (#error otherwise); body under MICROPROFILEDRAW_IMPL.

## API
```cpp
void MicroProfileDrawInitGL();                       // compile/link shaders, font texture (1024x9 RGBA), VBO(+VAO if GL>=3)
void MicroProfileRender(width, height, scale);       // BeginDraw -> MicroProfileDraw -> EndDraw
void MicroProfileBeginDraw(w, h, float* projection); // or (w,h,scale) building an ortho matrix
void MicroProfileEndDraw();
// implements (normally engine-supplied): MicroProfileDrawText/DrawBox/DrawLine2D
```
Internals: MicroProfileDrawVertex {x,y,color,u,v}; context caps MAX_COMMANDS=32, MAX_VERTICES=16384; Q0–Q3 macros fill two triangles per glyph/quad; Flush batches via glBufferSubData + glDrawArrays.

## Usage
An ALTERNATIVE to Roblox's own Renderer bridge in rbx/Profiler.cpp — this tree does NOT define MICROPROFILEDRAW_IMPL (Profiler.cpp supplies its own draw callbacks), so this file is dormant unless a build flips it on.

## Gotchas
- Uses raw GL calls with no context management; must run with a current GL context on the calling thread.
- Color handling: text/lines expect RGB packed as 0x00RRGGBB and swap R/B before upload; BoxTypeBar builds light/dark gradient pairs.
- Font is 5x9-ish pixel font in g_MicroProfileFont bitplane + per-char u-offset table g_MicroProfileFontDescription (non-ASCII → 0x0ce blank).
- Shader selection by parsing GL_VERSION string characters [0] and [2] — fragile against "OpenGL ES" prefixes.
