# ScriptService.cpp

## Purpose

Implements `ScriptService` — the entire TU is the class-name constant `sScriptService = "ScriptService"`. No constructor, no methods, no descriptors; all behavior (legacy script-running service) lives header-side or is vestigial.

## Key types and API

- `const char* const sScriptService = "ScriptService";` — that's all.

## Usage / reflection touchpoints

None in this TU. Modern script hosting lives in ScriptContext ([App/script](../../script/)) and ServerScriptService.md in this folder.

## Gotchas

- Don't confuse with ServerScriptService.md — different class, this one is essentially an empty shell.
