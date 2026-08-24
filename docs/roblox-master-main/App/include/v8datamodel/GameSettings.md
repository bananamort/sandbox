# App/include/v8datamodel/GameSettings.h

## Purpose

Advanced-settings item for engine-level game options: chat mode/history lengths, sound and collision-sound toggles, bubble-chat tuning, overscan, video capture quality + upload policy, hardware mouse. Mostly public raw fields persisted via the settings framework.

## Declared API

`class GameSettings : public GlobalAdvancedSettingsItem<GameSettings, sGameSettings>`

- `enum ChatMode { CHAT_AUTO=0, CHAT_CLASSIC=1, CHAT_BUBBLE=2, CHAT_BOTH=3 };`
- `typedef enum { LOW_RES=0, MEDIUM_RES, HIGH_RES } VideoQuality;`
- `typedef enum { NEVER=0, ASK, ALWAYS } UploadSetting;` (reused by GameBasicSettings for video/image upload).
- Public fields: `int chatHistory, reportAbuseChatHistory, chatScrollLength; bool soundEnabled, softwareSound, collisionSoundEnabled; float collisionSoundVolume; int maxCollisionSounds; int bubbleChatMaxBubbles; float bubbleChatLifetime; float overscanPX, overscanPY; bool hardwareMouse, videoCaptureEnabled;`
- Video quality: `VideoQuality getVideoQualitySetting() const / setVideoQualitySetting(VideoQuality)`.
- Upload: `UploadSetting getPostImageSetting() const / setPostImageSetting(...)`.
- Signal: `rbx::signal<void(bool)> videoRecordingSignal;`

## Gotchas

- Nearly all state is public mutable fields — no encapsulation; persistence relies on the GlobalAdvancedSettingsItem machinery.
- ChatMode enum exists here though the header has no chatMode member — consumers elsewhere.

## UNKNOWN

- Which subsystems read the raw fields at startup (.cpp — see [GameSettings.md](../../v8datamodel/GameSettings.md)).

## Cross-links

- Implementation: [App/v8datamodel/GameSettings.md](../../v8datamodel/GameSettings.md).
- Settings family: [GlobalSettings.md](GlobalSettings.md), [GameBasicSettings.md](GameBasicSettings.md), [DebugSettings.md](DebugSettings.md).
