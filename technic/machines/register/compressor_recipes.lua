
local S = technic.getter

technic.register_recipe_type("compressing", { description = S("Compressing") })

function technic.register_compressor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("compressing", data)
end

if minetest.get_modpath("default") then
table.insert(compressor_recipes, {"default:silver_sand 2",      "default:silver_sandstone"})
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

for _, data in pairs(compressor_recipes) do
	technic.register_compressor_recipe({input = {data[1]}, output = data[2]})
end

