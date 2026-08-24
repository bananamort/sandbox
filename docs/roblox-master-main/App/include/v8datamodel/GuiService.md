# App/include/v8datamodel/GuiService.h

## Purpose

`GuiService` (INTERNAL_LOCAL service) — global GUI coordination: the inset rectangle (top-left/bottom-right pixel margins), keyboard/special-key subscription and dispatch, center-dialog queueing with show/hide Lua callbacks, menu-open state, error/UI message channels, screen-resolution queries, gamepad-navigation selection groups, and URL-window plumbing.

## Declared API

`class GuiService : public DescribedNonCreatable<GuiService, Instance, sGuiService, ClassDescriptor::INTERNAL_LOCAL>, public Service`

- Reflection: `prop_selectedGuiObject`, `prop_selectedCoreGuiObject` (RefProps to GuiObject).
- Enums: `SpecialKey {KEY_INSERT=0, KEY_HOME, KEY_END, KEY_PAGEUP, KEY_PAGEDOWN, KEY_CHATHOTKEY}`; `CenterDialogType {UNSOLICITED_DIALOG=1, PLAYER_INITIATED_DIALOG=2, MODAL_DIALOG=3, QUIT_DIALOG=4}`; `UiMessageType {UIMESSAGE_ERROR, UIMESSAGE_INFO}`.
- Inset: `const Vector4& getGlobalGuiInset() const` (comment: x,y top-left inset; z,w bottom-right) / `void setGlobalGuiInset(int x1, int y1, int x2, y2)` — "in pixels".
- Dialogs: `void addCenterDialog(shared_ptr<Instance> dialog, CenterDialogType type, Lua::WeakFunctionRef show, hide); void removeCenterDialog(...)`; protected `struct DialogWrapper { weak_ptr<GuiObject> dialog; CenterDialogType; function<void()> showFunction/hideFunction; }` with raw-pointer queue `std::map<CenterDialogType, std::list<DialogWrapper*>> dialogQueue`, wrapper map keyed by weak_ptr, preemption logic (`shouldPreemptCurrentDialog`, `queueDialogWrapper(new, bool preempted)`, `showWaitingDialog(type)`).
- Keys: `addKey(std::string)/removeKey(...)`, `addSpecialKey/removeSpecialKey(SpecialKey)`, `bool dispatchKey(SpecialKey)`, `bool processKeyDown(const shared_ptr<InputObject>&)`; subscription sets `subscribedChars`, `subscribedSpecials` (TODO comment suggests boost::array<char,256>).
- Signals: openUrlWindow(str), urlWindowClosed, keyPressed(key, str), escapeKeyPressed, specialKeyPressed(SpecialKey, str), newErrorSignal(str), newUiMessageSignal(UiMessageType, str), showLeaveConfirmation, menuOpened/Closed (+fire helpers).
- Menu state: `setMenuOpen(bool)/getMenuOpen()`.
- Messages: set/getErrorMessage, setUiMessage(type, str)/getUiMessage.
- Screen: `Vector2 getScreenResolution(); void getScreenResolutionLua(resume(Vector2), error);` private no-retry variant.
- Misc: `int getBrickCount(); shared_ptr<Instance> getClosestDialogToPosition(Vector3); bool showStatsBasedOnInputString(std::string); bool getModalDialogStatus(); bool getIsWindows()` (#ifdef _WIN32 inline); `toggleFullscreen(); bool isTenFootInterface();`
- Gamepad nav selection: get/setSelectedGuiObjectLua, get/setSelectedCoreGuiObjectLua, getSelectedGuiObject; selection groups `addSelectionGroup(name, shared_ptr<Instance>|Tuple)`, `removeSelectionGroup(name)`, `SelectionGroupPair getSelectedObjectGroup(shared_ptr<GuiObject>)`; types `SelectionGroupPair = pair<weak_ptr<GuiObject>, shared_ptr<const Tuple>>`, `SelectionMap = unordered_map<string, SelectionGroupPair>`.
- Nav flags: GamepadNavEnabled / CoreGamepadNavEnabled / AutoGuiSelectionAllowed (get+set each; auto delegates to [GamepadService](GamepadService.md)).
- Public callback member: `NotificationCallback notificationCallback` (url, msg, resume, error typedef).
- State: guiInset (Vector4), errorMessage/uiMessage strings, selectionMap, nav flags + menuOpen, scoped connections (screenGuiConnection), currentDialog raw pointer.

## Gotchas

- DialogWrapper objects are heap-managed raw pointers in STL containers — ownership rules matter (.cpp frees them).
- Key dispatch is subscription-based: only subscribed chars/keys reach Lua listeners.
- CenterDialogType values start at 1 (0 reserved).

## UNKNOWN

- Precedence rules among the four dialog types (.cpp — see [GuiService.md](../../v8datamodel/GuiService.md)).

## Cross-links

- Implementation: [App/v8datamodel/GuiService.md](../../v8datamodel/GuiService.md).
- Kin: [GamepadService.md](GamepadService.md), [UserInputService.md](UserInputService.md), [TextService.md](TextService.md), [GuiObject.md](GuiObject.md).
