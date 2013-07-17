-- Minetest 0.4.7 mod: technic
-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

technic = {}

local load_start = os.clock()
local modpath = minetest.get_modpath("technic")
technic.modpath = modpath


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

-- Machines
dofile(modpath.."/machines/init.lua")

-- Tools
dofile(modpath.."/tools/init.lua")

-- Aliases for legacy node/item names
dofile(modpath.."/legacy.lua")

function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end

-- Swap nodes out. Return the node name.
function hacky_swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name ~= name then
		local meta = minetest.get_meta(pos)
		local meta_table = meta:to_table()
		node.name = name
		minetest.set_node(pos, node)
		meta = minetest.get_meta(pos)
		meta:from_table(meta_table)
	end
	return node.name
end

if minetest.setting_get("log_mod") then
	print("[Technic] Loaded in "..tostring(os.clock() - load_start).."s")
end

