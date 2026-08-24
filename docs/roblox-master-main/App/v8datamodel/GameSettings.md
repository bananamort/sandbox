# GameSettings.cpp

## Purpose

Implements `GameSettings` ("Game Options") — the legacy user-preferences singleton: chat history lengths, sound toggles, bubble-chat params, hardware mouse, video quality enum + capture flag, Xbox overscan; UploadSetting proxies through GameBasicSettings. Mostly BoundProp registrations + two enums.

## Key types and API

Enums:
- "VideoQualitySettings": LOW_RES/"LowResolution", MEDIUM_RES, HIGH_RES (+legacy spaced names).
- "UploadSetting": NEVER, ASK (legacy "Ask me first"), ALWAYS.

Descriptors by category (BoundProps unless noted):
- "Online": ChatHistory(100), ReportAbuseChatHistory(50), ChatScrollLength(5), BubbleChatMaxBubbles(3), BubbleChatLifetime(30.0f).
- "Sound": SoundEnabled(true), SoftwareSound(false), deprecated CollisionSoundEnabled(true)/CollisionSoundVolume(10)/MaxCollisionSounds(-1).
- Input: HardwareMouse(false).
- category_Video: `prop_videoSettings("VideoQuality")` EnumPropDescriptor default MEDIUM_RES; VideoCaptureEnabled(true); Durango-only OverscanPX/PY(-1).
- `event_videoRecordingRequest("VideoRecordingChangeRequest","recording", **Security::RobloxScript**)` on videoRecordingSignal.

Constants: `sGameSettings = "GameSettings"`; instance NAME is "Game Options".

Behavior: getPostImageSetting/setPostImageSetting delegate to `GameBasicSettings::singleton()`; setVideoQualitySetting compare-then-raise.

## Usage / reflection touchpoints

Singleton initialized in [Game](Game.md)::globalInit; modern settings UI reads/writes these via the Settings framework ([DebugSettings](DebugSettings.md) sibling).

## Gotchas

- Instance name mismatch trap: class registered "GameSettings" but setName("Game Options") — findFirstChildByName("GameSettings") fails.
- MaxCollisionSounds default -1 with no clamp logic in this TU.
- The three deprecated collision-sound props remain fully registered.
