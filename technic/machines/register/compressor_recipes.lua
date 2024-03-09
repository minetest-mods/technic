
local S = technic.getter

technic.register_recipe_type("compressing", { description = S("Compressing") })

function technic.register_compressor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("compressing", data)
end

function technic.clear_sand_to_sandstone_craft(sand_name)
	minetest.clear_craft({
		recipe = {
			{sand_name, sand_name},
			{sand_name, sand_name},
		},
	})
end

local recipes = {
	{"default:snowblock",          "default:ice"},
	{"default:sand 2",             "default:sandstone"},
	{"default:desert_sand 2",      "default:desert_sandstone"},
	{"default:silver_sand 2",      "default:silver_sandstone"},
	{"default:desert_sand",        "default:desert_stone"},
	{"technic:mixed_metal_ingot",  "technic:composite_plate"},
	{"default:copper_ingot 5",     "technic:copper_plate"},
	{"technic:coal_dust 4",        "technic:graphite"},
	{"technic:carbon_cloth",       "technic:carbon_plate"},
	{"technic:uranium35_ingot 5",  "technic:uranium_fuel"},
}

if minetest.get_modpath("everness") then
	table.insert(recipes, {"everness:coral_deep_ocean_sand 2",          "everness:coral_deep_ocean_sandstone_block"})
	table.insert(recipes, {"everness:coral_sand 2",                     "everness:coral_sandstone"})
	table.insert(recipes, {"everness:coral_white_sand 2",               "everness:coral_white_sandstone"})
	table.insert(recipes, {"everness:crystal_forest_deep_ocean_sand 2", "everness:crystal_forest_deep_ocean_sandstone_block"})
	table.insert(recipes, {"everness:crystal_sand 2",                   "everness:crystal_sandstone"})
	table.insert(recipes, {"everness:cursed_lands_deep_ocean_sand 2",   "everness:cursed_lands_deep_ocean_sandstone_block"})
	table.insert(recipes, {"everness:cursed_sand 2",                    "everness:cursed_sandstone_block"})
	table.insert(recipes, {"everness:mineral_sand 2",                   "everness:mineral_sandstone"})
end

-- defuse the default sandstone recipe, since we have the compressor to take over in a more realistic manner
local crafts_to_clear = {
	"default:desert_sand",
	"default:sand",
	"default:silver_sand"
}

if minetest.get_modpath("everness") then
	table.insert(crafts_to_clear, "everness:coral_sand")
	table.insert(crafts_to_clear, "everness:coral_forest_deep_ocean_sand")
	table.insert(crafts_to_clear, "everness:coral_white_sand")
	table.insert(crafts_to_clear, "everness:crystal_sand")
	table.insert(crafts_to_clear, "everness:cursed_sand")
	table.insert(crafts_to_clear, "everness:cursed_lands_deep_ocean_sand")
	table.insert(crafts_to_clear, "everness:crystal_forest_deep_ocean_sand")
	table.insert(crafts_to_clear, "everness:mineral_sand")
end

for _, sand_name in ipairs(crafts_to_clear) do
	technic.clear_sand_to_sandstone_craft(sand_name)
end

for _, data in pairs(recipes) do
	technic.register_compressor_recipe({input = {data[1]}, output = data[2]})
end

