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


-- Boilerplate to support intllib
if rawget(_G, "intllib") then
	technic.getter = intllib.Getter()
else
	-- Intllib copypasta: TODO replace with the client-side translation API
	technic.getter = function(s,a,...)
		if a==nil then return s end
		a={a,...}
		return s:gsub("(@?)@(%(?)(%d+)(%)?)", function(e,o,n,c)
			if e==""then
				return a[tonumber(n)]..(o==""and c or"")
			end
			return "@"..o..n..c
		end)
	end
end
local S = technic.getter

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

if minetest.settings:get_bool("log_mods") then
	print(S("[Technic] Loaded in %f seconds"):format(os.clock() - load_start))
end

