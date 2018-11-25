
local S = technic.getter

technic.register_recipe_type("freezing", { description = S("Freezing") })

function technic.register_freezer_recipe(data)
    data.time = data.time or 2
    technic.register_recipe("freezing", data)
end

local recipes = {
    {"bucket:bucket_water", { "default:snowblock", "bucket:bucket_empty" } },
    {"bucket:bucket_river_water", { "default:snowblock", "bucket:bucket_empty" } },
    {"default:dirt", "default:dirt_with_snow" }
}

for _, data in pairs(recipes) do
    technic.register_freezer_recipe({input = {data[1]}, output = data[2]})
end

