local modpath = minetest.get_modpath("technic_worldgen")

-- Mineclone Support
stone_sounds = nil
if minetest.get_modpath("mcl_sounds") then
	stone_sounds = mcl_sounds.node_sound_stone_defaults()
else
	stone_sounds = default.node_sound_stone_defaults()
end

node_sounds = nil
if minetest.get_modpath("mcl_sounds") then
	node_sounds = mcl_sounds.node_sound_defaults()
else
	node_sounds = default.node_sound_defaults()
end

wood_sounds = nil
if minetest.get_modpath("mcl_sounds") then
	wood_sounds = mcl_sounds.node_sound_wood_defaults()
else
	wood_sounds = default.node_sound_wood_defaults()
end

leaves_sounds = nil
if minetest.get_modpath("mcl_sounds") then
	leaves_sounds = mcl_sounds.node_sound_leaves_defaults()
else
	leaves_sounds = default.node_sound_leaves_defaults()
end

technic = rawget(_G, "technic") or {}
technic.worldgen = {
	gettext = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end,
}

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

