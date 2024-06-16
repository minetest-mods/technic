
local S = technic.getter

technic.register_recipe_type("compressing", { description = S("Compressing") })

function technic.register_compressor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("compressing", data)
end

-- Defuse the default recipes, since we have
-- the compressor to take over in a more realistic manner.
local crafts_to_clear = {
	"default:desert_sand",
	"default:sand",
	"default:silver_sand",
}

local dependent_crafts_to_clear = {
	everness = {
		"everness:coral_sand",
		"everness:coral_forest_deep_ocean_sand",
		"everness:coral_white_sand",
		"everness:crystal_sand",
		"everness:cursed_sand",
		"everness:cursed_lands_deep_ocean_sand",
		"everness:crystal_forest_deep_ocean_sand",
		"everness:mineral_sand",
	},
	nether = {
		"nether:brick",
		"nether:brick_compressed",
		"nether:rack",
		"nether:rack_deep",
	},
}

-- Add dependent recipes to main collection of
-- recipes to be cleared if their mods are used.
for dependency, crafts in pairs(dependent_crafts_to_clear) do
	if minetest.get_modpath(dependency) then
		for _, craft_entry in ipairs(crafts) do
			table.insert(crafts_to_clear, craft_entry)
		end
	end
end

-- Clear recipes
for _, craft_name in ipairs(crafts_to_clear) do
	-- Regular bricks are 2x2 shaped, nether bricks are 3x3 shaped (irregular)
	local is_regular = string.sub(craft_name, 1, 12) ~= "nether:brick"
	local shaped_recipe

	if is_regular then
		shaped_recipe = {
			{craft_name, craft_name},
			{craft_name, craft_name},
		}
	else
		shaped_recipe = {
			{craft_name, craft_name, craft_name},
			{craft_name, craft_name, craft_name},
			{craft_name, craft_name, craft_name},
		}
	end

	minetest.clear_craft({
		type = "shaped",
		recipe = shaped_recipe,
	})
end

--
-- Compile compressor recipes
--
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

local dependent_recipes = {
	everness = {
		{"everness:coral_deep_ocean_sand 2",          "everness:coral_deep_ocean_sandstone_block"},
		{"everness:coral_sand 2",                     "everness:coral_sandstone"},
		{"everness:coral_white_sand 2",               "everness:coral_white_sandstone"},
		{"everness:crystal_forest_deep_ocean_sand 2", "everness:crystal_forest_deep_ocean_sandstone_block"},
		{"everness:crystal_sand 2",                   "everness:crystal_sandstone"},
		{"everness:cursed_lands_deep_ocean_sand 2",   "everness:cursed_lands_deep_ocean_sandstone_block"},
		{"everness:cursed_sand 2",                    "everness:cursed_sandstone_block"},
		{"everness:mineral_sand 2",                   "everness:mineral_sandstone"},
	},
	nether = {
		{"nether:brick 9",				"nether:brick_compressed"},
		{"nether:brick_compressed 9",	"nether:nether_lump"},
		{"nether:rack",                 "nether:brick",},
		{"nether:rack_deep",            "nether:brick_deep"},
	},
}

-- Add dependent recipes to main recipe collection
-- if their mods are used.
for dependency, recipes_to_add in pairs(dependent_recipes) do
	if minetest.get_modpath(dependency) then
		for _, recipe_entry in ipairs(recipes_to_add) do
			table.insert(recipes, recipe_entry)
		end
	end
end

-- Register compressor recipes
for _, data in pairs(recipes) do
	technic.register_compressor_recipe({input = {data[1]}, output = data[2]})
end
