-- check if we have the necessary dependencies to allow actually using these materials in the crafts
local mesecons_materials = minetest.get_modpath("mesecons_materials")

-- Remove some recipes
-- Bronze
minetest.clear_craft({
	type = "shapeless",
	output = "default:bronze_ingot"
})

-- Accelerator tube
minetest.clear_craft({
	output = "pipeworks:accelerator_tube_1",
})

-- Teleport tube
minetest.clear_craft({
	output = "pipeworks:teleport_tube_1",
})

-- tubes crafting recipes

minetest.register_craft({
    output = 'pipeworks:accelerator_tube_1',
    recipe = {
        {'technic:copper_coil', 'pipeworks:tube_1', 'technic:copper_coil'},
        }
})

minetest.register_craft({
    output = 'pipeworks:teleport_tube_1',
    recipe = {
        {'default:mese_crystal', 'technic:copper_coil', 'default:mese_crystal'},
        {'pipeworks:tube_1', 'technic:control_logic_unit', 'pipeworks:tube_1'},
        {'default:mese_crystal', 'technic:copper_coil', 'default:mese_crystal'},
        }
})

minetest.register_craft({
	output = 'technic:diamond_drill_head',
	recipe = {
		{'technic:stainless_steel_ingot', 'default:diamond', 'technic:stainless_steel_ingot'},
		{'default:diamond',               '',                'default:diamond'},
		{'technic:stainless_steel_ingot', 'default:diamond', 'technic:stainless_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:green_energy_crystal',
	recipe = {
		{'default:gold_ingot', 'technic:battery', 'dye:green'},
		{'technic:battery', 'technic:red_energy_crystal', 'technic:battery'},
		{'dye:green', 'technic:battery', 'default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:blue_energy_crystal',
	recipe = {
		{'moreores:mithril_ingot', 'technic:battery', 'dye:blue'},
		{'technic:battery', 'technic:green_energy_crystal', 'technic:battery'},
		{'dye:blue', 'technic:battery', 'moreores:mithril_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:red_energy_crystal',
	recipe = {
		{'moreores:silver_ingot', 'technic:battery', 'dye:red'},
		{'technic:battery', 'default:diamondblock', 'technic:battery'},
		{'dye:red', 'technic:battery', 'moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:fine_copper_wire 2',
	recipe = {
		{'', 'default:copper_ingot', ''},
		{'', 'default:copper_ingot', ''},
		{'', 'default:copper_ingot', ''},
	}
})

minetest.register_craft({
	output = 'technic:fine_gold_wire 2',
	recipe = {
		{'', 'default:gold_ingot', ''},
		{'', 'default:gold_ingot', ''},
		{'', 'default:gold_ingot', ''},
	}
})

minetest.register_craft({
	output = 'technic:fine_silver_wire 2',
	recipe = {
		{'', 'moreores:silver_ingot', ''},
		{'', 'moreores:silver_ingot', ''},
		{'', 'moreores:silver_ingot', ''},
	}
})

minetest.register_craft({
	output = 'technic:copper_coil 1',
	recipe = {
		{'technic:fine_copper_wire', 'technic:wrought_iron_ingot', 'technic:fine_copper_wire'},
		{'technic:wrought_iron_ingot', '', 'technic:wrought_iron_ingot'},
		{'technic:fine_copper_wire', 'technic:wrought_iron_ingot', 'technic:fine_copper_wire'},
	}
})

minetest.register_craft({
	output = 'technic:motor',
	recipe = {
		{'technic:carbon_steel_ingot', 'technic:copper_coil', 'technic:carbon_steel_ingot'},
		{'technic:carbon_steel_ingot', 'technic:copper_coil', 'technic:carbon_steel_ingot'},
		{'technic:carbon_steel_ingot', 'default:copper_ingot', 'technic:carbon_steel_ingot'},
	}
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
		{'', 'technic:fine_gold_wire', ''},
		{'default:copper_ingot', 'technic:silicon_wafer', 'default:copper_ingot'},
		{'', 'technic:chromium_ingot', ''},
	}
})

minetest.register_craft({
	output = 'technic:mixed_metal_ingot 9',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
		{'default:bronze_ingot',          'default:bronze_ingot',          'default:bronze_ingot'},
		{'moreores:tin_ingot',            'moreores:tin_ingot',            'moreores:tin_ingot'},
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
		{ "technic:cast_iron_ingot", "technic:brass_ingot", "technic:cast_iron_ingot" },
		{ "technic:cast_iron_ingot", "technic:cast_iron_ingot", "technic:cast_iron_ingot" },
	},
})


minetest.register_craft({
	output = "default:dirt 2",
	type = "shapeless",
	replacements = {{"bucket:bucket_water","bucket:bucket_empty"}},
	recipe = {
		"technic:stone_dust",
		"group:leaves",
		"bucket:bucket_water",
		"group:sand",
	},
})
