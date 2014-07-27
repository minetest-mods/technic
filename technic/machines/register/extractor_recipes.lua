
local S = technic.getter

technic.register_recipe_type("extracting", { description = S("Extracting") })

function technic.register_extractor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("extracting", data)
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
}

for _, data in pairs(recipes) do
	technic.register_extractor_recipe({input = {data[1]}, output = data[2]})
end

