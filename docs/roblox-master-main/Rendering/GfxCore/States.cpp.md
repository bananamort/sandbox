# Rendering/GfxCore/States.cpp

## Purpose

Translation unit for `States.h`; exists only to anchor the include — every state class is header-only (inline ctors, operators, hashing). The file body is an empty namespace.

## API

None beyond what States.h declares inline.

## Usage

Included by backends that intern states; compiled once to give the header a home in the project file lists.

## Gotchas

- Any future out-of-line state logic must be added here; today there is nothing to link against.
