# Message.mc

Source: `roblox-sandbox/RCCService/Message.mc` (7 lines)

## Purpose

Windows message-compiler source defining the single event-log message template used by `SvcReportEvent` (RCCService.cpp:123). Compiled by `mc.exe` into `MSG00001.bin` / RC resources so `ReportEvent` can format strings into the Application event log under the "RCCService" source.

## API

```
MessageId=
SymbolicName=GENERIC_MESSAGE
Language=English
%1
.
```

One message, auto-assigned id (yields the `0x20000001L` "GENERIC_MESSAGE" constant hard-referenced in `RCCService.cpp` line 134), format string `%1` = single inserted string (the log text).

## Usage

Built via the project's custom message-compiler step; consumed at runtime every time RCCService reports service start/stop/errors to the event log.

## Gotchas

- **Id coupling is by hand**: if the .mc ever gains another message above GENERIC_MESSAGE, the hardcoded `0x20000001L` in RCCService.cpp silently points at the wrong entry.
- `MessageId=` empty → compiler assigns severity/facility bits producing exactly `0x20000001`; keep in sync or event text breaks.
