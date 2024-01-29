local modpath = minetest.get_modpath("technic_worldgen")


-- Mineclone Support
sounds = minetest.get_modpath("mcl_sounds") and mcl_sounds or default

technic = rawget(_G, "technic") or {}
technic.worldgen = {
	gettext = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end,
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

