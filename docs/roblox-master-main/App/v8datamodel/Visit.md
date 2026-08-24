# Visit.cpp

## Purpose

Implements `Visit` ("Visit"), a tiny legacy session service holding the upload URL and running a background keep-alive ping thread. Mostly vestigial.

## Key types and API

Descriptors (all **Security::Roblox**):
- "SetUploadUrl(url)" / "GetUploadUrl():string".
- "SetPing(pingUrl, interval:int)".

Behavior:
- `setPing`: non-empty url spawns a `worker_thread` ("rbx_visit") looping `ping` — HTTP GET the url, swallow ALL exceptions (even the error print is commented out), sleep `interval` seconds via boost::xtime, repeat (`worker_thread::more`). Empty url resets (stops) the thread.
- Ping failures are completely silent by design (comment: message should be employee-only).

## Usage / reflection touchpoints

Roblox-security setters — core scripts only. Pairs with [Network](../../Network/) keep-alive concepts; Http util docs under App/util.

## Gotchas

- The ping loop sleeps with plain thread::sleep — shutdown can block up to `interval` seconds waiting for the cycle (TODO in source acknowledges no timed condition).
- No validation of interval; zero/negative spins the server hot.
- GetUploadUrl/SetUploadUrl remain reflected despite "Still used" comment applying only to some members.
