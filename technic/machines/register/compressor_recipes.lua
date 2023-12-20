
local S = technic.getter

technic.register_recipe_type("compressing", { description = S("Compressing") })

function technic.register_compressor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("compressing", data)
end

local recipes = {
	{snow_block_ingrediant,          ice_block_ingrediant},
	{sand_ingrediant.." 2",             sandstone_ingrediant},
	{desert_sand_ingrediant.." 2",      desert_stone_ingrediant},
	{desert_sand_ingrediant,        desert_stone_ingrediant},
	{"technic:mixed_metal_ingot",  "technic:composite_plate"},
	{copper_ingrediant.." 5",     "technic:copper_plate"},
	{"technic:coal_dust 4",        "technic:graphite"},
	{"technic:carbon_cloth",       "technic:carbon_plate"},
	{"technic:uranium35_ingot 5",  "technic:uranium_fuel"},
}
if minetest.get_modpath("default") then
table.insert(recipes, {"default:silver_sand 2",      "default:silver_sandstone"})
end
-- defuse the default sandstone recipe, since we have the compressor to take over in a more realistic manner
minetest.clear_craft({
	recipe = {
		{"default:sand", "default:sand"},
		{"default:sand", "default:sand"},
	},
})
minetest.clear_craft({
	recipe = {
		{"default:desert_sand", "default:desert_sand"},
		{"default:desert_sand", "default:desert_sand"},
	},
})
minetest.clear_craft({
	recipe = {
		{"default:silver_sand", "default:silver_sand"},
		{"default:silver_sand", "default:silver_sand"},
	},
})

for _, data in pairs(recipes) do
	technic.register_compressor_recipe({input = {data[1]}, output = data[2]})
end

