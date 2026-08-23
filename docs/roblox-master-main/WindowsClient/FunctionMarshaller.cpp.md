# WindowsClient/FunctionMarshaller.cpp

## Purpose

Implements the per-thread hidden-window marshaller. Two transports: `Execute` = synchronous `SendMessage(WM_EVENT)` (or direct call when already on the owning thread); `Submit` = queue push + single coalesced `PostMessage(WM_ASYNCEVENT)` guarded by an atomic flag. The owning thread's normal message pump drains both; a non-pumping thread can force-drain async work with `ProcessMessages()`.

## API

Real signatures:

- `FunctionMarshaller::FunctionMarshaller(DWORD threadID)` — stores id; `Create(NULL, 0, 0, WS_POPUP)` makes the invisible ATL window (`ATLASSERT(hWnd!=NULL)`).
- `~FunctionMarshaller()` — drains and deletes queued async closures; debug asserts: called on owning thread, refCount==0, not present in staticData().windows.
- `static FunctionMarshaller* GetWindow()` — under staticData's recursive mutex, returns existing per-thread instance or constructs one; bumps refCount. "Share a common FunctionMarshaller in a given Thread".
- `static void ReleaseWindow(FunctionMarshaller* window)` — decrements refCount; at 0 erases map entry and `DestroyWindow()` (which triggers OnFinalMessage ⇒ `delete this`).
- `LRESULT OnAsyncEvent(UINT, WPARAM, LPARAM, BOOL&)` — `postedAsyncMessage.swap(0)` first (allows new Posts during drain), then pops and runs every queued closure; on std::exception prints via StandardOut and **rethrows** after delete.
- `LRESULT OnEvent(UINT, WPARAM, LPARAM, BOOL&)` — unpacks `Closure*` from lParam, runs it, same print+rethrow on exception. Note: closure.errorMessage is never actually set anywhere — the throw path in Execute reads an always-empty string.
- `void Execute(boost::function<void()> job)` — same-thread ⇒ direct `job()`; else stack Closure holding &job, blocking `SendMessage(WM_EVENT, 0, (LPARAM)&closure)`; throws runtime_error(closure.errorMessage) on non-S_OK return.
- `void Submit(boost::function<void()> job)` — heap-copies the function into asyncCalls; only Posts WM_ASYNCEVENT if `postedAsyncMessage.swap(1) == 0` (coalescing: one posted message drains whatever is queued when it arrives).
- `void ProcessMessages()` — PeekMessage loop restricted to `this->m_hWnd`, range [WM_ASYNCEVENT, WM_ASYNCEVENT], PM_REMOVE + Translate/Dispatch. Used by View::RemoveJobs to guarantee no marshalled render callback outlives the View.
- `void OnFinalMessage(HWND hWnd)` — `delete this`.
- `StaticData::~StaticData()` — safety net destroying any windows still registered at process exit.

## Usage

Lifecycle pattern across the client: `marshaller = FunctionMarshaller::GetWindow()` at View/Document construction on the UI thread; engine threads (RenderJob via TaskScheduler view-thread, TeleportService callbacks) Submit/Execute onto it; `ReleaseWindow` at teardown. RenderJob additionally calls ProcessMessages() from the scheduler thread to flush its own submissions without a pump.

## Gotchas

- `Execute` from the wrong thread BLOCKS until the owning thread pumps messages — calling it from a thread that holds a lock the UI thread needs deadlocks; RenderJob deliberately uses it only for renderPrepare inside its own lock scope on the legacy path.
- Exceptions propagate through SendMessage's window procedure — crossing that boundary with C++ exceptions is UB-ish but relied upon here (print + rethrow); the Closure error-message channel is vestigial (never populated).
- Coalescing means exactly-once Post per drain cycle; closures submitted while a drain is in flight may run late — ordering between two Submits is preserved (FIFO queue) but timing is not.
- `#undef min / #undef max` after stdafx include — GDI macro pollution defense.
