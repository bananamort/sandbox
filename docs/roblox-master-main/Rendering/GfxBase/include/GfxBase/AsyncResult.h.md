# AsyncResult.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/AsyncResult.h` (45 lines)

## Purpose

Header-only accumulator for asynchronous content-fetch outcomes: folds multiple async request results into one monotonically-worsening status (`Succeeded < Waiting < Failed`) and tracks which content ids are still pending. Used when e.g. texture loading must report "not ready yet" vs "hard failure".

## API

```cpp
class RBX::AsyncResult {
public:
    AsyncResult();  // reqResult = RBX::AsyncHttpQueue::Succeeded
    void returnResult(RBX::AsyncHttpQueue::RequestResult reqResult); // monotonic fold
    void returnWaitingFor(const RBX::ContentId& id); // fold(Waiting) + push_back(id)

    RBX::AsyncHttpQueue::RequestResult reqResult;
    std::vector<RBX::ContentId> waitingFor;
};
```

Fold rule (in-code comment: *"make result always more restrictive only"*):
- `Succeeded` never downgrades anything.
- `Waiting` upgrades only `Succeeded` → `Waiting`.
- `Failed` always wins, regardless of current state.

## Usage

Depends on `v8datamodel/contentprovider.h` for `RBX::AsyncHttpQueue` (enum + `RequestResult`) and `RBX::ContentId`. Consumers call `returnResult`/`returnWaitingFor` as each async op resolves, then inspect `reqResult` once all are in.

## Gotchas

- Once `Failed`, state is sticky — no path back to Waiting/Succeeded.
- Header-only; pulls in contentprovider.h transitively, so including it drags ContentProvider machinery into your TU.
- `waitingFor` grows unboundedly if callers keep reporting waits without consuming it.
