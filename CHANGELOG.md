# Changelog

## 1.1.0 (2026-10-26)

- Settings that are not at the game's default are marked with a *; All settings can list only the changed ones.
- Fixed: a remembered setting changed in the game's own options (for example Interface > Status Text) was put back to the old value at the next login. Changes made while an options window is open are now remembered.
- The addon list shows a readable name ("Skom's Proc Glow" style). The About tab uses those names, and lists Skom's Arena Stats.

## 1.0.0 (2026-10-21)

First release.

- An About tab in the options: how to get help (GitHub issues, Warperia, Discord) and the other addons by Skom, with what is installed. ArenaLFG is marked as Warmane only.
- Camera, Nameplates, Combat, Chat, Interface and Sound tabs for the hidden console variables of the 3.3.5a client, plus a search over all the variables the game accepts and a Settings tab.
- Switches to hide the red error messages and the yellow information messages (Interface tab).
- Your changes are remembered and re-applied at every login (option), with backup, restore and reset to the defaults of the game.
- Only settings that exist in this client are shown.
- `/saio` (or `/sio`) opens the window, `/saio <setting> [value]` reads or sets one.
