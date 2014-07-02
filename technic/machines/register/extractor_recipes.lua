
local S = technic.getter

if unified_inventory and unified_inventory.register_craft_type then
	unified_inventory.register_craft_type("extracting", {
		description = S("Extracting"),
		height = 1,
		width = 1,
	})
end

technic.extractor_recipes = {}

function technic.register_extractor_recipe(data)
	data.time = data.time or 4
	local src = ItemStack(data.input):get_name()
	technic.extractor_recipes[src] = data
	if unified_inventory then
		unified_inventory.register_craft({
			type = "extracting",
			output = data.output,
			items = {data.input},
			width = 0,
		})
	end
end

-- Receive an ItemStack of result by an ItemStack input
function technic.get_extractor_recipe(item)
	if technic.extractor_recipes[item:get_name()] and
	   item:get_count() >= ItemStack(technic.extractor_recipes[item:get_name()].input):get_count() then
		return technic.extractor_recipes[item:get_name()]
	else
		return nil
	end
end

minetest.after(0.01, function ()
	for ingredient, recipe in pairs(technic.extractor_recipes) do
		ingredient = minetest.registered_aliases[ingredient]
		while ingredient do
			technic.grinder_recipes[ingredient] = recipe
			ingredient = minetest.registered_aliases[ingredient]
		end
	end
end)

-- Receive an ItemStack of result by an ItemStack input
function technic.get_grinder_recipe(itemstack)
	return technic.grinder_recipes[itemstack:get_name()]
end

local recipes = {
	-- Dyes
	{"technic:coal_dust",                 "dye:black 2"},
	{"default:cactus",                    "dye:green 2"},
	{"default:dry_shrub",                 "dye:brown 2"},
	{"flowers:geranium",                  "dye:blue 2"},
	{"flowers:dandelion_white",           "dye:white 2"},
	{"flowers:dandelion_yellow",          "dye:yellow 2"},
	{"flowers:tulip",                     "dye:orange 2"},
	{"flowers:rose",                      "dye:red 2"},
	{"flowers:viola",                     "dye:violet 2"},
	
	-- Rubber
	{"technic:raw_latex",                 "technic:rubber 3"},
	{"moretrees:rubber_tree_trunk_empty", "technic:rubber"},
	{"moretrees:rubber_tree_trunk",       "technic:rubber"},
	
	-- Other
	{"technic:uranium 5",                 "technic:enriched_uranium"},
}

for _, data in pairs(recipes) do
	technic.register_extractor_recipe({input = data[1], output = data[2]})
end

