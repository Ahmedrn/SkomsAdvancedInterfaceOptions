# SkomsInterfaceOptions 1.0.0 (WoW 3.3.5a)

The hidden game settings (console variables) of the 3.3.5a client in one window, and a way to keep your choices at every login. Type `/sio`.

Inspired by **AdvancedInterfaceOptions** (Stanzilla, Semlar), which is made for retail and later clients and does not work on 3.3.5a. Here only settings that exist in this client are offered (the names were checked against the game executable).

## Tabs
- **Camera:** maximum zoom distance (up to 4x), camera follow style, terrain tilt, water collision, bobbing, follow speeds, mouse look speed, invert mouse, sticky targeting.
- **Nameplates:** enemy and friendly plates by type (players, pets, guardians, totems), class colour on plates, and the names above units (own, NPC, guild, PvP title, friendly and enemy players, pets, guardians, totems).
- **Combat:** auto attack on target change, assist, self cast, auto dismount / unshift / stand, target cast bar, target of target mode, threat number, castable buffs and dispellable debuffs, arena frames, action bar locks.
- **Chat:** mouse wheel scroll, fade delay, class colours, bubbles, filters, timestamps, chat style.
- **Interface:** tooltips, loot, bags, unit frame numbers, party background, map, tracker, frame rate limits, vertical sync.
- **Sound:** sound switches and the master volume, error speech ("Not enough mana"), sound in the background.
- **All settings:** a search box over 245 console variables of this client, with their descriptions, to read and edit the value of any of them.
- **Settings:** re-apply my choices at every login (on by default), backup, restore, reset to the game's defaults.

Every setting shows its console name and default value in its tooltip. Settings that the client does not have (nameplate distance, action camera, spell queue window ...) are not shown, because they would do nothing.

## Commands
`/sio` opens the window. `/sio <setting>` shows a setting, `/sio <setting> <value>` sets it. `/sio info`.

## Install
Put the `SkomsInterfaceOptions` folder in `Interface\AddOns`. Disable or delete AdvancedInterfaceOptions if you have it: it is not made for this client and throws errors.

## Help and feedback
A setting you miss, or something that does not work:
- **GitHub issues:** https://github.com/Ahmedrn/SkomsInterfaceOptions/issues
- **A comment on the Warperia page**
- **Discord:** `skomzx`

## Credits
- **AdvancedInterfaceOptions** by **Stanzilla** and **Semlar**: the idea and the list of hidden settings. No code copied.
- **Ace3** for the window.
