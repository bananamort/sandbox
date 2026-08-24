# App/include/v8datamodel/VirtualUser.h

## Purpose

`VirtualUser` — INTERNAL_LOCAL creatable service for scripted input automation (test scripts): synthesizes key/mouse InputObjects through a private `VirtualHardwareDevice`, and can RECORD real input into Lua playback source (startRecording/stopRecording with wait/key/mouse emitters).

## Declared API

`class VirtualUser : public DescribedCreatable<VirtualUser, Instance, sVirtualUser, Reflection::ClassDescriptor::INTERNAL_LOCAL>, public Service`

- Private: `boost::scoped_ptr<VirtualHardwareDevice> virtualHardwareDevice`; `std::stringstream recording` ("the script code when recording"); scoped recordingConnection; `RBX::Time lastEventTime`.
- Automation API ("used to automate user input (used by test scripts, for example)"):
  - Keys: `pressKey(std::string key)`, `setKeyDown(std::string)`, `setKeyUp(std::string)` — string keys converted by private `KeyCode convert(const std::string&)`.
  - Mouse: `clickButton1/clickButton2(Vector2 position, CoordinateFrame camera)`; down/up pairs `button1Down/button2Down/button1Up/button2Up(...)`; `moveMouse(position, camera)`.
  - Device: `void captureInputDevice()`.
- Recording: `void startRecording()`; `std::string stopRecording()`.
- Override: `onServiceProvider`.
- Private plumbing: `onInputObject(shared_ptr<InputObject>)` (recording tap), `sendMouseEvent(UserInputType, UserInputState, Vector2, CoordinateFrame)`, script writers `writeWait()/writeKey(const char* func, event)/writeMouse(const char* func, event)`, `DataModel* getDataModel()`.

## Gotchas

- captureInputDevice implies exclusive routing of hardware events while active.
- Recording generates Lua source with synthesized waits (writeWait uses lastEventTime deltas) — timing fidelity limited to recorded resolution.
- INTERNAL_LOCAL: test-only surface; not for shipped gameplay use.

## UNKNOWN

- Target recording dialect (exact emitted Lua calls) visible only via writeKey/writeMouse bodies.

## Cross-links

- Implementation: [App/v8datamodel/VirtualUser.md](../../v8datamodel/VirtualUser.md).
- Event model: [InputObject.md](InputObject.md); consumer context: [Test.md](Test.md), [UserInputService.md](UserInputService.md).
