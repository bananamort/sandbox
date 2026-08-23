# Rendering/GfxCore/Framebuffer.cpp

## Purpose

Constructors/dtors for `Renderbuffer` and `Framebuffer`, with GPU-memory profiling on renderbuffers.

## API

- `Renderbuffer::Renderbuffer(device, format, width, height, samples)` — adds `Texture::getImageSize(format, width, height) * samples` to profiler counter `memory/gpu/renderbuffer`; dtor subtracts.
- `Framebuffer::Framebuffer(device, width, height, samples)` / `~Framebuffer()` — plain member init; no counters (memory already counted per-attachment).

## Usage

Base ctors invoked by all backend Renderbuffer/Framebuffer subclasses before they create native resources.

## Gotchas

- MSAA memory is approximated as image size × sample count — accurate for color, ignores extra depth/tile storage.
- Framebuffer itself tracks only dimensions/samples; the actual attachment list lives in backend subclasses.
