-- Minetest 0.4.6 mod: technic_chests
-- namespace: technic
-- (c) 2012-2013 by RealBadAngel <mk@realbadangel.pl>

local modpath = minetest.get_modpath("technic_chests")

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
