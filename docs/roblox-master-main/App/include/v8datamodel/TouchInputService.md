# App/include/v8datamodel/TouchInputService.h

## Purpose

`TouchInputService` — non-creatable service buffering OS touch callbacks (arriving off-thread as raw `void*` touch handles) into a mutex-guarded buffer keyed by touch id; a scoped update-input connection drains the buffer (`processTouchBuffer`) into InputObjects on the input thread.

## Declared API

- Namespace typedefs: `TouchInfo = std::pair<RBX::Vector3, RBX::InputObject::UserInputState>`; `TouchBufferMap = boost::unordered_map<int, std::vector<TouchInfo>>`.
- `class TouchInputService : public DescribedNonCreatable<TouchInputService, Instance, sTouchInputService>, public Service`
  - Private state: `boost::mutex touchBufferMutex`; `int touchCount`; `touchBufferMap`; bidirectional handle maps `countToTouchMap (int→void*)` / `touchToCountMap (void*→int)`; `touchIdToInputObjectMap (int→shared_ptr<InputObject>)`; `updateInputConnection`.
  - `void processTouchBuffer()` — drains buffered touches.
  - Public: ctor; `void addTouchToBuffer(void* touch, Vector3 rbxLocation, InputObject::UserInputState newState)` — thread-safe entry point.
  - Override: `onServiceProvider`.

## Gotchas

- Touch identity is an opaque platform `void*` — the two maps translate between handles and internal ids; leaks if remove path is missed.
- Per project recon: decoy hackFlag usage is associated with this cluster (hackFlag0/6/7 in SurfaceSelection/PhysicsInstructions/TouchTransmitter) — treat nearby flag logic as anti-tamper noise until verified.
- Buffer + mutex implies producer threads other than the input thread call addTouchToBuffer.

## UNKNOWN

- Which connection processTouchBuffer is wired to (updateInputConnection target, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/TouchInputService.md](../../v8datamodel/TouchInputService.md).
- Input plumbing: [InputObject.md](InputObject.md), [UserInputService.md](UserInputService.md); touch events on parts: [TouchTransmitter.md](TouchTransmitter.md).
