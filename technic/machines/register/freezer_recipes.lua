
local S = technic.getter

technic.register_recipe_type("freezing", { description = S("Freezing") })

function technic.register_freezer_recipe(data)
	data.time = data.time or 5
	technic.register_recipe("freezing", data)
end

for _, data in pairs(freezer_recipes) do
	technic.register_freezer_recipe({input = {data[1]}, output = data[2]})
end

