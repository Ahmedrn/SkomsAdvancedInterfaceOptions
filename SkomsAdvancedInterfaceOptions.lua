-- SkomsAdvancedInterfaceOptions: the hidden game settings (console variables) of the 3.3.5a client in one window.
-- Inspired by AdvancedInterfaceOptions (Stanzilla, Semlar). Only settings that exist in this client are offered.
local ADDON, ns = ...

local db
local PREFIX = "|cff33ff99SkomsAdvancedInterfaceOptions|r: "
local function Say(m) print(PREFIX .. m) end

-- this client raises an error for a name that is not a console variable, so every read goes through pcall
local function Get(cv)
	local ok, v = pcall(GetCVar, cv)
	if ok then return v end
end
local function Exists(cv) return Get(cv) ~= nil end
local function Default(cv)
	if not GetCVarDefault then return nil end
	local ok, v = pcall(GetCVarDefault, cv)
	if ok then return v end
end

-- keep only the names this client really has
do
	local kept = {}
	for _, e in ipairs(ns.CVarList) do
		if Exists(e[1]) then kept[#kept + 1] = e end
	end
	ns.CVarList = kept
end

-- the value is remembered so it can be re-applied at login
local function Set(cv, v)
	v = tostring(v)
	pcall(SetCVar, cv, v)
	if db then db.values[cv] = v end
end

-- ---------------------------------------------------------------------------------------------------------
-- the curated settings
-- ---------------------------------------------------------------------------------------------------------
local function B(cv, label, desc) return { cv = cv, label = label, desc = desc, kind = "bool" } end
local function R(cv, label, desc, min, max, step) return { cv = cv, label = label, desc = desc, kind = "range", min = min, max = max, step = step } end
local function S(cv, label, desc, values) return { cv = cv, label = label, desc = desc, kind = "select", values = values } end
local function H(text) return { header = text } end
local function T(text) return { text = text } end

local tabs = {
	{ key = "camera", name = "Camera", items = {
		R("cameraDistanceMaxFactor", "Maximum camera distance", "How far you can zoom out with the mouse wheel. 1 is the normal limit, higher values let you zoom out further (up to 4).", 1, 4, 0.1),
		S("cameraSmoothStyle", "Camera follow", "When the camera turns behind your character by itself.", {
			["0"] = "Never adjust the camera", ["1"] = "Adjust only horizontally when moving",
			["2"] = "Always adjust the camera", ["4"] = "Adjust only when moving" }),
		B("cameraTerrainTilt", "Tilt the camera with the terrain", "The camera follows slopes when you ride or walk up and down hills."),
		B("cameraWaterCollision", "Camera collides with water", "Off: the camera can go under the water surface."),
		B("cameraBobbing", "Camera bobbing", "A head bob while moving (mostly visible in first person)."),
		H("Speeds"),
		R("cameraYawMoveSpeed", "Horizontal follow speed", "How fast the camera turns behind you (default 180).", 10, 360, 5),
		R("cameraPitchMoveSpeed", "Vertical follow speed", "How fast the camera tilts up and down by itself (default 90).", 10, 360, 5),
		R("mouseSpeed", "Mouse look speed", "Speed of the camera when you turn it with the mouse (default 1).", 0.5, 1.5, 0.05),
		B("mouseInvertPitch", "Invert mouse look", "Moving the mouse up looks down."),
		B("deselectOnClick", "Clicking empty ground clears your target", "Off is the \"sticky targeting\" option."),
	} },
	{ key = "nameplates", name = "Nameplates", items = {
		T("The plates can also be switched with V (enemies) and Shift-V (friends). These switches are the same as the keys, split by unit type."),
		H("Enemy nameplates"),
		B("nameplateShowEnemies", "Enemies"),
		B("nameplateShowEnemyPets", "Enemy pets"),
		B("nameplateShowEnemyGuardians", "Enemy guardians"),
		B("nameplateShowEnemyTotems", "Enemy totems"),
		H("Friendly nameplates"),
		B("nameplateShowFriends", "Friends"),
		B("nameplateShowFriendlyPets", "Friendly pets"),
		B("nameplateShowFriendlyGuardians", "Friendly guardians"),
		B("nameplateShowFriendlyTotems", "Friendly totems"),
		H("Colour"),
		B("ShowClassColorInNameplate", "Class colour on player nameplates"),
		H("Names above units"),
		B("UnitNameOwn", "Your own name"),
		B("UnitNameNPC", "NPC names"),
		B("UnitNameNonCombatCreatureName", "Non-combat creatures (critters)"),
		B("UnitNamePlayerGuild", "Guild names"),
		B("UnitNamePlayerPVPTitle", "PvP titles"),
		B("UnitNameFriendlyPlayerName", "Friendly players"),
		B("UnitNameFriendlyPetName", "Friendly pets"),
		B("UnitNameFriendlyGuardianName", "Friendly guardians"),
		B("UnitNameFriendlyTotemName", "Friendly totems"),
		B("UnitNameEnemyPlayerName", "Enemy players"),
		B("UnitNameEnemyPetName", "Enemy pets"),
		B("UnitNameEnemyGuardianName", "Enemy guardians"),
		B("UnitNameEnemyTotemName", "Enemy totems"),
	} },
	{ key = "combat", name = "Combat", items = {
		B("stopAutoAttackOnTargetChange", "Stop auto attack when you change target"),
		B("assistAttack", "Assist also starts attacking", "Using Assist on a player makes you attack their target."),
		B("autoSelfCast", "Cast helpful spells on yourself when you have no friendly target"),
		B("autoDismount", "Dismount when casting"),
		B("autoDismountFlying", "Dismount from a flying mount when casting", "Be careful in the air."),
		B("autoUnshift", "Leave your shapeshift form when casting a spell that needs it"),
		B("autoStand", "Stand up when casting"),
		H("Frames"),
		B("showTargetCastbar", "Target cast bar"),
		B("showTargetOfTarget", "Target of target"),
		S("targetOfTargetMode", "Show target of target", "Used when target of target is on.", {
			["0"] = "Raid", ["1"] = "Party", ["2"] = "Solo", ["3"] = "Raid and party", ["4"] = "Raid and solo", ["5"] = "Always" }),
		B("threatShowNumeric", "Threat as a number on the target frame"),
		B("showCastableBuffs", "Show only buffs you can cast on a friendly target"),
		B("showDispelDebuffs", "Show only debuffs you can dispel on a friendly target"),
		B("screenEdgeFlash", "Flash the screen edges at low health"),
		H("Arena"),
		B("showArenaEnemyFrames", "Enemy arena frames"),
		B("showArenaEnemyCastbar", "Enemy arena cast bars"),
		B("showArenaEnemyPets", "Enemy arena pets"),
		H("Action bars"),
		B("lockActionBars", "Lock the action bars"),
		B("alwaysShowActionBars", "Always show the extra action bars"),
	} },
	{ key = "chat", name = "Chat", items = {
		B("chatMouseScroll", "Scroll chat with the mouse wheel"),
		B("removeChatDelay", "No delay when the chat fades"),
		B("colorChatNamesByClass", "Colour player names by class"),
		B("wholeChatWindowClickable", "Whole chat window can be clicked"),
		B("chatBubbles", "Chat bubbles above characters"),
		B("chatBubblesParty", "Chat bubbles for party members"),
		B("profanityFilter", "Profanity filter"),
		B("spamFilter", "Spam filter"),
		B("guildMemberNotify", "Tell me when guild members log in or out"),
		B("autoClearAFK", "Leave AFK when I move or type"),
		B("blockTrades", "Block trade requests"),
		S("showTimestamps", "Timestamps", "Applies to new chat lines.", {
			["none"] = "None", ["%I:%M "] = "05:04 (12 hour)", ["%I:%M:%S "] = "05:04:03 (12 hour)",
			["%H:%M "] = "17:04", ["%H:%M:%S "] = "17:04:03" }),
		S("chatStyle", "Chat style", "Needs /reload.", { ["classic"] = "Classic", ["im"] = "Instant message" }),
	} },
	{ key = "interface", name = "Interface", items = {
		B("UberTooltips", "Enhanced tooltips", "More details in tooltips."),
		B("lootUnderMouse", "Loot window opens under the mouse"),
		B("autoLootDefault", "Auto loot by default"),
		B("showLootSpam", "Show loot messages of other players"),
		B("alwaysCompareItems", "Always compare items"),
		B("displayFreeBagSlots", "Free bag slots on the backpack"),
		B("xpBarText", "Numbers on the experience bar"),
		B("buffDurations", "Buff durations"),
		B("showNewbieTips", "Beginner tooltips"),
		B("showTutorials", "Tutorials"),
		B("scriptErrors", "Show Lua errors in a pop-up", "Normally off when you use BugSack."),
		H("Unit frames"),
		B("playerStatusText", "Numbers on the player frame"),
		B("targetStatusText", "Numbers on the target frame"),
		B("petStatusText", "Numbers on the pet frame"),
		B("partyStatusText", "Numbers on the party frames"),
		B("showPartyBackground", "Party background"),
		R("partyBackgroundOpacity", "Party background opacity", nil, 0, 1, 0.05),
		B("showPartyPets", "Party pets"),
		H("Map and quests"),
		B("rotateMinimap", "Rotate the minimap"),
		B("displayWorldPVPObjectives", "World PvP objectives"),
		B("advancedWatchFrame", "Advanced objectives tracker"),
		R("watchFrameBaseAlpha", "Objectives tracker opacity", nil, 0, 1, 0.05),
		R("worldMapOpacity", "World map opacity", nil, 0, 1, 0.05),
		H("Performance"),
		R("maxFPS", "Maximum frame rate", "0 is unlimited.", 0, 200, 1),
		R("maxFPSBk", "Maximum frame rate in the background", "0 is unlimited.", 0, 200, 1),
		B("gxVSync", "Vertical sync", "Applied after restarting the game."),
	} },
	{ key = "sound", name = "Sound", items = {
		B("Sound_EnableAllSound", "Sound"),
		R("Sound_MasterVolume", "Master volume", nil, 0, 1, 0.05),
		B("Sound_EnableSFX", "Sound effects"),
		B("Sound_EnableMusic", "Music"),
		B("Sound_EnableAmbience", "Ambient sounds"),
		B("Sound_EnableEmoteSounds", "Emote sounds"),
		B("Sound_EnablePetSounds", "Pet sounds"),
		B("Sound_EnableErrorSpeech", "Error speech", "The voice that says \"Not enough mana\", \"Out of range\" ..."),
		B("Sound_EnableSoundWhenGameIsInBG", "Sound when the game is in the background"),
		B("Sound_EnableReverb", "Reverb"),
		B("Sound_EnableArmorFoleySoundForSelf", "Armour sounds for you"),
		B("Sound_EnableArmorFoleySoundForOthers", "Armour sounds for others"),
	} },
}

-- ---------------------------------------------------------------------------------------------------------
-- options table
-- ---------------------------------------------------------------------------------------------------------
local function Describe(it)
	local d = it.desc and (it.desc .. "\n") or ""
	local def = Default(it.cv)
	return d .. "|cff888888" .. it.cv .. (def and ("  (default " .. tostring(def) .. ")") or "") .. "|r"
end

local function MakeOption(it)
	local cv = it.cv
	local o = { name = it.label, desc = Describe(it), hidden = function() return not Exists(cv) end }
	if it.kind == "bool" then
		o.type = "toggle"; o.width = "full"
		o.get = function() return (tonumber(Get(cv)) or 0) ~= 0 end
		o.set = function(_, v) Set(cv, v and "1" or "0") end
	elseif it.kind == "range" then
		o.type = "range"; o.min = it.min; o.max = it.max; o.step = it.step; o.width = "double"
		o.get = function() return tonumber(Get(cv)) or it.min end
		o.set = function(_, v) Set(cv, v) end
	else
		o.type = "select"; o.values = it.values; o.width = "double"
		o.get = function()
			local cur = Get(cv)
			if it.values[cur] then return cur end
			local n = tonumber(cur)
			if n then
				for k in pairs(it.values) do if tonumber(k) == n then return k end end
			end
			return cur
		end
		o.set = function(_, v) Set(cv, v) end
	end
	return o
end

-- every setting the addon manages: the curated ones and the browser list
local managed, managedList = {}, {}
local function AddManaged(cv)
	if not managed[cv] then managed[cv] = true; managedList[#managedList + 1] = cv end
end
for _, tab in ipairs(tabs) do
	for _, it in ipairs(tab.items) do if it.cv then AddManaged(it.cv) end end
end
for _, e in ipairs(ns.CVarList) do AddManaged(e[1]) end

local function CountStored()
	local n = 0
	for _ in pairs(db.values) do n = n + 1 end
	return n
end

-- the browser
local MAXSHOW = 30
local filter, matches, matchCount = "", {}, 0
local function UpdateMatches()
	wipe(matches); matchCount = 0
	if #filter < 2 then return end
	local f = filter:lower()
	for i, e in ipairs(ns.CVarList) do
		if Exists(e[1]) and (e[1]:lower():find(f, 1, true) or e[2]:lower():find(f, 1, true)) then
			matchCount = matchCount + 1
			if matchCount <= MAXSHOW then matches[i] = true end
		end
	end
end

local function BuildOptions()
	local root = { type = "group", name = "SkomsAdvancedInterfaceOptions", childGroups = "tab", args = {} }
	local order = 1

	for _, tab in ipairs(tabs) do
		local g = { type = "group", name = tab.name, order = order, args = {} }
		order = order + 1
		for i, it in ipairs(tab.items) do
			if it.header then
				g.args["h" .. i] = { type = "header", name = it.header, order = i }
			elseif it.text then
				g.args["t" .. i] = { type = "description", name = it.text, order = i, fontSize = "medium" }
			else
				local o = MakeOption(it)
				o.order = i
				g.args[it.cv] = o
			end
		end
		root.args[tab.key] = g
	end

	root.args.browser = {
		type = "group", name = "All settings", order = order,
		args = {
			info = { type = "description", order = 1, fontSize = "medium",
				name = "Every console variable this client knows (" .. #ns.CVarList .. "). Type part of a name or of the description, then edit the value." },
			filter = { type = "input", order = 2, name = "Search", width = "double",
				get = function() return filter end,
				set = function(_, v) filter = strtrim(v or ""); UpdateMatches() end },
			count = { type = "description", order = 3,
				name = function()
					if #filter < 2 then return "Type at least 2 letters." end
					if matchCount == 0 then return "Nothing found." end
					return ("%d found%s"):format(matchCount, matchCount > MAXSHOW and (", showing the first " .. MAXSHOW .. ", type more to narrow it down") or "")
				end },
		},
	}
	for i, e in ipairs(ns.CVarList) do
		local cv = e[1]
		root.args.browser.args["c" .. i] = {
			type = "input", order = 10 + i, name = cv, width = "double",
			desc = (e[2] ~= "" and (e[2] .. "\n") or "") .. "|cff888888default " .. tostring(Default(cv)) .. "|r",
			hidden = function() return not matches[i] end,
			get = function() return tostring(Get(cv)) end,
			set = function(_, v) Set(cv, v) end,
		}
	end
	order = order + 1

	root.args.settings = {
		type = "group", name = "Settings", order = order,
		args = {
			enforce = { type = "toggle", order = 1, width = "full", name = "Re-apply my choices at every login",
				desc = "The game keeps most settings by itself; this makes sure the ones you changed here are set again when you log in (some are reset by other addons or by the game).",
				get = function() return db.enforce end, set = function(_, v) db.enforce = v end },
			stored = { type = "description", order = 2, fontSize = "medium",
				name = function() return ("%d setting(s) changed here are remembered."):format(CountStored()) end },
			forget = { type = "execute", order = 3, name = "Forget my choices",
				desc = "Stops re-applying them. The current values of the game are kept.",
				func = function() wipe(db.values); Say("choices forgotten.") end },
			header = { type = "header", order = 10, name = "Backup" },
			backupInfo = { type = "description", order = 11,
				name = function() return db.backup and ("A backup of " .. db.backupCount .. " settings from " .. db.backupDate .. " exists.") or "No backup yet." end },
			backup = { type = "execute", order = 12, name = "Backup the settings",
				func = function()
					db.backup = {}
					local n = 0
					for _, cv in ipairs(managedList) do
						local v = Get(cv)
						if v ~= nil then db.backup[cv] = tostring(v); n = n + 1 end
					end
					db.backupCount, db.backupDate = n, date("%Y-%m-%d %H:%M")
					Say(n .. " settings saved.")
				end },
			restore = { type = "execute", order = 13, name = "Restore the backup", disabled = function() return not db.backup end,
				confirm = true, confirmText = "Restore all settings from the backup?",
				func = function()
					wipe(db.values)
					for cv, v in pairs(db.backup) do
						pcall(SetCVar, cv, v)
						if tostring(Default(cv)) ~= v then db.values[cv] = v end
					end
					Say("backup restored.")
				end },
			header2 = { type = "header", order = 20, name = "Reset" },
			reset = { type = "execute", order = 21, name = "Reset all settings to the game's defaults",
				desc = "Every setting listed in this addon goes back to its default value.",
				confirm = true, confirmText = "Reset all the settings of this addon to the defaults of the game?",
				func = function()
					wipe(db.values)
					local n = 0
					for _, cv in ipairs(managedList) do
						local def = Default(cv)
						if def ~= nil and Get(cv) ~= nil then pcall(SetCVar, cv, def); n = n + 1 end
					end
					Say(n .. " settings reset.")
				end },
		},
	}
	return root
end

-- ---------------------------------------------------------------------------------------------------------
-- start-up
-- ---------------------------------------------------------------------------------------------------------
local function ApplyStored()
	if not db or not db.enforce then return end
	for cv, v in pairs(db.values) do
		if Get(cv) ~= nil and tostring(Get(cv)) ~= v then pcall(SetCVar, cv, v) end
	end
end

local function Open()
	LibStub("AceConfigDialog-3.0"):Open(ADDON)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
local wait
f:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == ADDON then
		SkomsAdvancedInterfaceOptionsDB = SkomsAdvancedInterfaceOptionsDB or {}
		db = SkomsAdvancedInterfaceOptionsDB
		if db.enforce == nil then db.enforce = true end
		db.values = db.values or {}
		UpdateMatches()
		LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON, BuildOptions())
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON, ADDON)
	elseif event == "PLAYER_LOGIN" then
		ApplyStored()
	elseif event == "PLAYER_ENTERING_WORLD" then
		-- once more a little later: other addons and the game may have changed settings during the load
		if not wait then wait = 3 end
	end
end)
f:SetScript("OnUpdate", function(self, elapsed)
	if wait and wait > 0 then
		wait = wait - elapsed
		if wait <= 0 then wait = -1; ApplyStored() end
	end
end)

SLASH_SKOMSADVANCEDINTERFACEOPTIONS1 = "/saio"
SLASH_SKOMSADVANCEDINTERFACEOPTIONS2 = "/sio"
SLASH_SKOMSADVANCEDINTERFACEOPTIONS3 = "/skomsadvancedinterfaceoptions"
SlashCmdList["SKOMSADVANCEDINTERFACEOPTIONS"] = function(msg)
	msg = strlower(strtrim(msg or ""))
	if msg == "" then
		Open()
	elseif msg == "info" then
		Say("version " .. tostring(GetAddOnMetadata(ADDON, "Version")) .. ", " .. #managedList .. " settings known, " .. CountStored() .. " remembered, re-apply at login: " .. tostring(db.enforce))
	else
		-- /saio <name> shows a setting, /saio <name> <value> sets it
		local name, value = msg:match("^(%S+)%s*(.*)$")
		for _, cv in ipairs(managedList) do
			if cv:lower() == name then
				if value ~= "" then Set(cv, value) end
				Say(cv .. " = " .. tostring(Get(cv)) .. " (default " .. tostring(Default(cv)) .. ")")
				return
			end
		end
		Say("/saio opens the window; /saio <setting> [value] shows or sets one setting; /saio info.")
	end
end
