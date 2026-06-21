-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

if not minetest.get_translator then
	error("[technic] Your Minetest version is no longer supported."
		.. " (version < 5.0.0)")
end

local load_start = os.clock()

technic = rawget(_G, "technic") or {}
technic.creative_mode = minetest.settings:get_bool("creative_mode")


local modpath = minetest.get_modpath("technic")
technic.modpath = modpath

local S = core.get_translator("technic")
technic.getter = S
technic.getter_escaped = function(...)
	return core.formspec_escape(S(...))
end

-- Read configuration file
dofile(modpath.."/config.lua")

-- Helper functions
dofile(modpath.."/helpers.lua")

-- Items
dofile(modpath.."/items.lua")

-- Craft recipes for items
dofile(modpath.."/crafts.lua")

-- Register functions
dofile(modpath.."/register.lua")

-- Radiation
dofile(modpath.."/radiation.lua")

-- Machines
dofile(modpath.."/machines/init.lua")

-- Tools
dofile(modpath.."/tools/init.lua")

-- Aliases for legacy node/item names
dofile(modpath.."/legacy.lua")

if core.settings:get_bool("log_mods") then
	print(("[Technic] Loaded in %.2f ms"):format(1000 * (os.clock() - load_start)))
end
