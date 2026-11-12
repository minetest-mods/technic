if not core.strip_escapes then
	error("technic_worldgen requires Luanti 5.14.0 or newer. Please update.")
end

local modpath = minetest.get_modpath("technic_worldgen")

technic_worldgen = {
	getter = core.get_translator("technic_worldgen"),
	config = nil,
	sounds = minetest.get_modpath("mcl_sounds") and mcl_sounds or default
}

-- Check if mcl_core or default is installed
if not minetest.get_modpath("mcl_core") and not minetest.get_modpath("default") then
	error(minetest.get_current_modname().." ".."requires mcl_core or default to be installed (please install MTG or MCL2, or compatible games)")
end

dofile(modpath.."/config.lua")
dofile(modpath.."/nodes.lua")
dofile(modpath.."/oregen.lua")
dofile(modpath.."/crafts.lua")

-- Rubber trees, moretrees also supplies these
if not minetest.get_modpath("moretrees") then
	dofile(modpath.."/rubber.lua")
else
	-- older versions of technic provided rubber trees regardless
	minetest.register_alias("technic:rubber_sapling", "moretrees:rubber_tree_sapling")
	minetest.register_alias("technic:rubber_tree_empty", "moretrees:rubber_tree_trunk_empty")
end

-- mg suppport
if minetest.get_modpath("mg") then
	dofile(modpath.."/mg.lua")
end

