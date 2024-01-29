local S = technic.getter

technic.register_recipe_type("separating", {
	description = S("Separating"),
	output_size = 2,
})

function technic.register_separating_recipe(data)
	data.time = data.time or 10
	technic.register_recipe("separating", data)
end

local function uranium_dust(p)
	return "technic:uranium"..(p == 7 and "" or p).."_dust"
end
for p = 1, 34 do
	table.insert(centrifuge_recipes, { uranium_dust(p).." 2", uranium_dust(p-1), uranium_dust(p+1) })
end

if minetest.get_modpath("bushes_classic") then
	for _, berry in ipairs({ "blackberry", "blueberry", "gooseberry", "raspberry", "strawberry" }) do
		table.insert(centrifuge_recipes, { "bushes:"..berry.."_bush", "default:stick 20", "bushes:"..berry.." 4" })
	end
end

if minetest.get_modpath("farming") then
	table.insert(centrifuge_recipes, { "farming:wheat 4", "farming:seed_wheat 3", "default:dry_shrub 1" })
end

for _, data in pairs(centrifuge_recipes) do
	technic.register_separating_recipe({ input = { data[1] }, output = { data[2], data[3], data[4] } })
end
