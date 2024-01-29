-- check if we have the necessary dependencies to allow actually using these materials in the crafts
local mesecons_materials = minetest.get_modpath("mesecons_materials")

-- Remove some recipes
-- Bronze
minetest.clear_craft({
	type = "shapeless",
	output = "default:bronze_ingot"
})
-- Restore recipe for bronze block to ingots
minetest.register_craft({
	output = "default:bronze_ingot 9",
	recipe = {
		{"default:bronzeblock"}
	}
})

-- Accelerator tube
if pipeworks.enable_accelerator_tube then
	minetest.clear_craft({
		output = "pipeworks:accelerator_tube_1",
	})

	minetest.register_craft({
		output = 'pipeworks:accelerator_tube_1',
		recipe = {
			{'technic:copper_coil', 'pipeworks:tube_1', 'technic:copper_coil'},
			}
	})
end

-- Teleport tube
if pipeworks.enable_teleport_tube then
	minetest.clear_craft({
		output = "pipeworks:teleport_tube_1",
	})

	minetest.register_craft({
		output = 'pipeworks:teleport_tube_1',
		recipe = {
			{technic_compat.mese_crystal_ingredient, 'technic:copper_coil', technic_compat.mese_crystal_ingredient},
			{'pipeworks:tube_1', 'technic:control_logic_unit', 'pipeworks:tube_1'},
			{technic_compat.mese_crystal_ingredient, 'technic:copper_coil', technic_compat.mese_crystal_ingredient},
			}
	})
end

-- basic materials' brass ingot

minetest.clear_craft({
	output = "basic_materials:brass_ingot",
})

minetest.register_craft( {
	type = "shapeless",
	output = "basic_materials:brass_ingot 9",
	recipe = { "basic_materials:brass_block" },
})

-- tubes crafting recipes

minetest.register_craft({
	output = 'technic:diamond_drill_head',
	recipe = {
		{'technic:stainless_steel_ingot', technic_compat.diamond_ingredient, 'technic:stainless_steel_ingot'},
		{technic_compat.diamond_ingredient,               '',                technic_compat.diamond_ingredient},
		{'technic:stainless_steel_ingot', technic_compat.diamond_ingredient, 'technic:stainless_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:green_energy_crystal',
	recipe = {
		{technic_compat.gold_ingot_ingredient, 'technic:battery', technic_compat.green_dye_ingredient},
		{'technic:battery', 'technic:red_energy_crystal', 'technic:battery'},
		{technic_compat.green_dye_ingredient, 'technic:battery', technic_compat.gold_ingot_ingredient},
	}
})

minetest.register_craft({
	output = 'technic:blue_energy_crystal',
	recipe = {
		{'moreores:mithril_ingot', 'technic:battery', technic_compat.blue_dye_ingredient},
		{'technic:battery', 'technic:green_energy_crystal', 'technic:battery'},
		{technic_compat.blue_dye_ingredient, 'technic:battery', 'moreores:mithril_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:red_energy_crystal',
	recipe = {
		{'moreores:silver_ingot', 'technic:battery', technic_compat.red_dye_ingredient},
		{'technic:battery', 'basic_materials:energy_crystal_simple', 'technic:battery'},
		{technic_compat.red_dye_ingredient, 'technic:battery', 'moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:copper_coil 1',
	recipe = {
		{'basic_materials:copper_wire', 'technic:wrought_iron_ingot', 'basic_materials:copper_wire'},
		{'technic:wrought_iron_ingot', '', 'technic:wrought_iron_ingot'},
		{'basic_materials:copper_wire', 'technic:wrought_iron_ingot', 'basic_materials:copper_wire'},
	},
	replacements = {
		{"basic_materials:copper_wire", "basic_materials:empty_spool"},
		{"basic_materials:copper_wire", "basic_materials:empty_spool"},
		{"basic_materials:copper_wire", "basic_materials:empty_spool"},
		{"basic_materials:copper_wire", "basic_materials:empty_spool"}
	},
})

local isolation = mesecons_materials and "mesecons_materials:fiber" or "technic:rubber"

minetest.register_craft({
	output = 'technic:lv_transformer',
	recipe = {
		{isolation,                    'technic:wrought_iron_ingot', isolation},
		{'technic:copper_coil',        'technic:wrought_iron_ingot', 'technic:copper_coil'},
		{'technic:wrought_iron_ingot', 'technic:wrought_iron_ingot', 'technic:wrought_iron_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:mv_transformer',
	recipe = {
		{isolation,                    'technic:carbon_steel_ingot', isolation},
		{'technic:copper_coil',        'technic:carbon_steel_ingot', 'technic:copper_coil'},
		{'technic:carbon_steel_ingot', 'technic:carbon_steel_ingot', 'technic:carbon_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:hv_transformer',
	recipe = {
		{isolation,                       'technic:stainless_steel_ingot', isolation},
		{'technic:copper_coil',           'technic:stainless_steel_ingot', 'technic:copper_coil'},
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:control_logic_unit',
	recipe = {
		{'', 'basic_materials:gold_wire', ''},
		{technic_compat.copper_ingredient, 'technic:silicon_wafer', technic_compat.copper_ingredient},
		{'', 'technic:chromium_ingot', ''},
	},
	replacements = { {"basic_materials:gold_wire", "basic_materials:empty_spool"}, },
})

minetest.register_craft({
	output = 'technic:mixed_metal_ingot 9',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
		{technic_compat.bronze_ingredient,          technic_compat.bronze_ingredient,          technic_compat.bronze_ingredient},
		{technic_compat.tin_ingredient,             technic_compat.tin_ingredient,             technic_compat.tin_ingredient},
	}
})

minetest.register_craft({
	output = 'technic:carbon_cloth',
	recipe = {
		{'technic:graphite', 'technic:graphite', 'technic:graphite'}
	}
})

minetest.register_craft({
	output = "technic:machine_casing",
	recipe = {
		{ "technic:cast_iron_ingot", "technic:cast_iron_ingot", "technic:cast_iron_ingot" },
		{ "technic:cast_iron_ingot", "basic_materials:brass_ingot", "technic:cast_iron_ingot" },
		{ "technic:cast_iron_ingot", "technic:cast_iron_ingot", "technic:cast_iron_ingot" },
	},
})

minetest.register_craft({
	output = technic_compat.dirt_ingredient.." 2",
	type = "shapeless",
	replacements = {{"bucket:bucket_water","bucket:bucket_empty"}},
	recipe = {
		"technic:stone_dust",
		"group:leaves",
		"bucket:bucket_water",
		"group:sand",
	},
})

minetest.register_craft({
	output = "technic:rubber_goo",
	type = "shapeless",
	recipe = {
		"technic:raw_latex",
		technic_compat.coal_ingredient,
		technic_compat.coal_ingredient,
		technic_compat.coal_ingredient,
		technic_compat.coal_ingredient,
		technic_compat.coal_ingredient,
		technic_compat.coal_ingredient,
		technic_compat.coal_ingredient,
		technic_compat.coal_ingredient,
	},
})

minetest.register_craft({
	output = "technic:rubber",
	type = "cooking",
	recipe = "technic:rubber_goo",
})

if minetest.get_modpath("mcl_core") then
minetest.register_craft({
	output = "technic:raw_latex",
	type = "cooking",
	recipe = "mcl_mobitems:slimeball",
})
end