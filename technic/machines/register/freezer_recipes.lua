
local S = technic.getter

technic.register_recipe_type("freezing", { description = S("Freezing") })

function technic.register_freezer_recipe(data)
	data.time = data.time or 5
	technic.register_recipe("freezing", data)
end

local recipes = {
	{water_bucket_ingrediant, { ice_block_ingrediant, emtpy_bucket_ingrediant } },
	{bucket_river_water_ingrediant, { ice_block_ingrediant, emtpy_bucket_ingrediant } },
	{dirt_ingrediant , dirt_with_snow_ingrediant },
	{bucket_lava_ingrediant, { obsidian_ingrediant, emtpy_bucket_ingrediant } }
}

for _, data in pairs(recipes) do
	technic.register_freezer_recipe({input = {data[1]}, output = data[2]})
end

