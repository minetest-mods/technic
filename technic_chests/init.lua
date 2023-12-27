-- Minetest 0.4.6 mod: technic_chests
-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

local modpath = minetest.get_modpath("technic_chests")

-- Check if mcl_core or default is installed
if not minetest.get_modpath("mcl_core") and not minetest.get_modpath("default") then
	error(minetest.get_current_modname().." ".."requires mcl_core or default to be installed (please install MTG or MCL2, or compatible games)")
end

-- Mineclone2 Support
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

-- Mineclone2 Recipes
chest_ingredient = nil
if minetest.get_modpath("mcl_core") then
	chest_ingredient = "mcl_chests:chest"
else
	chest_ingredient = "default:chest"
end

copper_ingredient = nil
if minetest.get_modpath("mcl_core") then
	copper_ingredient = "mcl_copper:copper_ingot"
else
	copper_ingredient = 'default:copper_ingot'
end

gold_ingot_ingredient = nil
if minetest.get_modpath("mcl_core") then
	gold_ingot_ingredient = "mcl_core:gold_ingot"
else
	gold_ingot_ingredient = 'default:gold_ingot'
end

granite_ingredient = nil
if minetest.get_modpath("mcl_core") then
	granite_ingredient = "mcl_core:granite"
else
	granite_ingredient = 'technic:granite'
end

granite_bricks_ingredient = nil
if minetest.get_modpath("mcl_core") then
	granite_bricks_ingredient = "mcl_core:granite_smooth"
else
	granite_bricks_ingredient = 'technic:granite_bricks'
end

coal_ingredient = nil
if minetest.get_modpath("mcl_core") then
	coal_ingredient = "group:coal"
else
	coal_ingredient = "default:coal_lump"
end

technic = rawget(_G, "technic") or {}
technic.chests = {}

dofile(modpath.."/common.lua")
dofile(modpath.."/register.lua")
dofile(modpath.."/iron_chest.lua")
dofile(modpath.."/copper_chest.lua")
dofile(modpath.."/silver_chest.lua")
dofile(modpath.."/gold_chest.lua")
dofile(modpath.."/mithril_chest.lua")

-- undo all of the locked wooden chest recipes created by default and
-- moreblocks, and just make them use a padlock.

if minetest.get_modpath("moreblocks") then
	minetest.clear_craft({
		type = "shapeless",
		recipe = {
			"default:chest",
			"default:gold_ingot",
		}
	})

	minetest.clear_craft({
		type = "shapeless",
		recipe = {
			"default:chest",
			"default:bronze_ingot",
		}
	})

	minetest.clear_craft({
		type = "shapeless",
		recipe = {
			"default:chest",
			"default:copper_ingot",
		}
	})
end

minetest.clear_craft({
	type = "shapeless",
	recipe = {
		"default:chest",
		"default:steel_ingot",
	}
})

minetest.clear_craft({output = "default:chest_locked"})

minetest.register_craft({
	output = "default:chest_locked",
	recipe = {
		{ "group:wood", "group:wood", "group:wood" },
		{ "group:wood", "basic_materials:padlock", "group:wood" },
		{ "group:wood", "group:wood", "group:wood" }
	}
})

minetest.register_craft({
	output = "default:chest_locked",
	type = "shapeless",
	recipe = {
		"default:chest",
		"basic_materials:padlock"
	}
})

minetest.register_lbm({
	name = "technic_chests:fix_wooden_chests",
	nodenames = {"default:chest"},
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "")
	end
})
