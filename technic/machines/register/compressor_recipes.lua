
local S = technic.getter

technic.register_recipe_type("compressing", { description = S("Compressing") })

function technic.register_compressor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("compressing", data)
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
	local everness_sand_to_sandstone_recipes = {
		{"everness:coral_deep_ocean_sand 2",          "everness:coral_deep_ocean_sandstone_block"},
		{"everness:coral_sand 2",                     "everness:coral_sandstone"},
		{"everness:coral_white_sand 2",               "everness:coral_white_sandstone"},
		{"everness:crystal_forest_deep_ocean_sand 2", "everness:crystal_forest_deep_ocean_sandstone_block"},
		{"everness:crystal_sand 2",                   "everness:crystal_sandstone"},
		{"everness:cursed_lands_deep_ocean_sand 2",   "everness:cursed_lands_deep_ocean_sandstone_block"},
		{"everness:cursed_sand 2",                    "everness:cursed_sandstone_block"},
		{"everness:mineral_sand 2",                   "everness:mineral_sandstone"},
	}

	for _, data in ipairs(everness_sand_to_sandstone_recipes) do
		table.insert(recipes, {data[1], data[2]})
	end
end

if minetest.get_modpath("nether") then
	local nether_brick_and_lump_recipes = {
		{"nether:brick 9",				"nether:brick_compressed"},
		{"nether:brick_compressed 9",	"nether:nether_lump"},
	}

	for _, data in ipairs(nether_brick_and_lump_recipes) do
		table.insert(recipes, {data[1], data[2]})
	end
end

-- Defuse the default sandstone recipes, since we have the compressor to take over in a more realistic manner.
local crafts_to_clear = {
	"default:desert_sand",
	"default:sand",
	"default:silver_sand"
}

if minetest.get_modpath("everness") then
	local everness_crafts_to_clear = {
		"everness:coral_sand",
		"everness:coral_forest_deep_ocean_sand",
		"everness:coral_white_sand",
		"everness:crystal_sand",
		"everness:cursed_sand",
		"everness:cursed_lands_deep_ocean_sand",
		"everness:crystal_forest_deep_ocean_sand",
		"everness:mineral_sand",
	}

	for _, sand_name in ipairs(everness_crafts_to_clear) do
		table.insert(crafts_to_clear, sand_name)
	end
end

for _, sand_name in ipairs(crafts_to_clear) do
	minetest.clear_craft({
		type = "shaped",
		recipe = {
			{sand_name, sand_name},
			{sand_name, sand_name},
		},
	})
end

if minetest.get_modpath("nether") then
	-- Defuse the default compressed nether brick and nether lump recipes,
	-- since we have the compressor to take over in a more realistic manner.
	local nether_crafts_to_clear = {
		"nether:brick",
		"nether:brick_compressed",
	}

	for _, nether_brick_name in ipairs(nether_crafts_to_clear) do
		minetest.clear_craft({
			type = "shaped",
			recipe = {
				{nether_brick_name, nether_brick_name, nether_brick_name},
				{nether_brick_name, nether_brick_name, nether_brick_name},
				{nether_brick_name, nether_brick_name, nether_brick_name},
			},
		})
	end
end

for _, data in pairs(recipes) do
	technic.register_compressor_recipe({input = {data[1]}, output = data[2]})
end
