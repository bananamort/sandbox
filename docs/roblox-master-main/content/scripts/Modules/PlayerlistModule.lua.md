# PlayerlistModule.lua

Source: `roblox-sandbox/content/scripts/Modules/PlayerlistModule.lua` (1753 lines; jmargh v1.3)

## Purpose

The leaderboard/player-list module: right-side scrolling list of player entries with up to 4 leaderstat columns, team grouping w/ aggregated team scores, per-player social icons (BC/TBC/OBC, place owner, admin hardcode, friend/follower status, blocked), click→PlayerDropDown popup, Tab-key toggle, and the topbar stat feed (`OnLeaderstatsChanged`/`OnStatChanged`).

## API (returned table `Playerlist`)

- Bindables: `OnLeaderstatsChanged` (fires GameStats array {Name,Text,AddId,IsPrimary,Priority}), `OnStatChanged(statName, formattedText)`.
- `GetStats()`, `ToggleVisibility(name?,inputState?)` (Tab bound via CAS "RbxPlayerListToggle"; ignores small-screen devices), `IsOpen()`, `HideTemp(self,key,hidden)` (multi-key temp-hide map used by SettingsHub 'SettingsMenu'), `TopbarEnabledChanged(enabled)`.

## Behavior highlights

- Layout constants per ten-foot (entries 80px, name 350px, stats 250px, shadows, my-entry pinned as transparent top frame outside ScrollList); MinContainerSize 165×50%; container re-anchored to widest stat row in updateLeaderstatFrames.
- GameStats lifecycle: addNewStats caps MAX_LEADERSTATS=4, honors legacy Priority/IsPrimary children (comment: unofficially supported), AddId tiebreak sorting; per-player leaderstats ChildAdded/Removed + rename detection keep frames in sync; removal checks doesStatExists across players before dropping column (resets own top-bar text to "-").
- Stat values: getScoreValue handles Constrained/Bool; formatStatString → comma grouping + thin-char width metric (strWidth halves count of `[iIl.,']`) truncating at 12 with "..."; primary stat drives sortPlayerEntries (desc) then name asc.
- Teams: entries colored by TeamColor, sorted by TeamScore then add id; Neutral synthetic Team entry created on first real team, hidden when empty (IsShowingNeutralFrame); updateAllTeamScores sums numeric stats per TeamColor bucket (invalid colors fall to Neutral).
- Social icons: getMembershipIcon (blocked > hardcoded ADMINS {jeditkacheff, Sorcus, shedletsky, Robloxsai} > place owner > BC tiers); spawned GetRankInGroup(CreatorId)==255 group-owner check + IsInGroup(1200769) admin check; xbox path uses ThumbnailLoader async avatar.
- Followers: dual legacy (isFollowing HTTP pair per selection) and server (FollowRelationshipChanged remote → setFollowRelationshipsView) paths behind EnableLuaFollowers/UserServerFollowers flags, both skipped on ten-foot.
- Entry click (non-self, userId>1): cyan highlight, ScrollList.ScrollingEnabled=false, dropdown popup tweened into PopupClipFrame; outside touch hides; blocked-status event refreshes membership icon.

## Gotchas
- `AssetGameUrl` is a GLOBAL (missing local, line 112).
- setVisible references undefined local `isUsingGamepad` in the else branch (nil compare → no-op) — latent bug on hide path.
- onFollowerStatusChanged precedence: `if not A and not B or not C` mixes conditions confusingly.
- ADMINS table icons load over HTTP from roblox.com asset ids — offline = blank icons.
