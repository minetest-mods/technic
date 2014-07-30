local S = technic.getter

technic.register_recipe_type("separating", {
	description = S("Separating"),
	output_size = 2,
})

function technic.register_separating_recipe(data)
	data.time = data.time or 10
	technic.register_recipe("separating", data)
end

local rubber_tree_planks = minetest.get_modpath("moretrees") and "moretrees:rubber_tree_planks" or "default:wood"

local recipes = {
	{ "technic:bronze_dust 4",             "technic:copper_dust 3",       "technic:tin_dust"      },
	{ "technic:stainless_steel_dust 4",    "technic:wrought_iron_dust 3", "technic:chromium_dust" },
	{ "technic:brass_dust 3",              "technic:copper_dust 2",       "technic:zinc_dust"     },
	{ "moretrees:rubber_tree_trunk_empty", rubber_tree_planks.." 4",      "technic:raw_latex"     },
	{ "moretrees:rubber_tree_trunk",       rubber_tree_planks.." 4",      "technic:raw_latex"     },
}

-- Refining uranium via centrifuge is intended to make it a practical
-- necessity to set up an automated cascade of centrifuges.  Once the
-- cascade has been primed, production of one 3.5%-fissile dust requires
-- input of five 0.7%-fissile dust and 490 centrifuge operations, and
-- produces four 0.0%-fissile dust as a byproduct.  The busiest stage
-- of the cascade is the one taking 0.7%-fissile dust, which performs 28
-- of the 490 operations.  The least busy is the one taking 3.4%-fissile
-- dust, which performs 1 of the 490 operations.
local function uranium_dust(p)
	return "technic:uranium"..(p == 7 and "" or p).."_dust"
end
for p = 1, 34 do
	table.insert(recipes, { uranium_dust(p).." 2", uranium_dust(p-1), uranium_dust(p+1) })
end

if minetest.get_modpath("bushes_classic") then
	for _, berry in ipairs({ "blackberry", "blueberry", "gooseberry", "raspberry", "strawberry" }) do
		table.insert(recipes, { "bushes:"..berry.."_bush", "default:stick 20", "bushes:"..berry.." 4" })
	end
end

for _, data in pairs(recipes) do
	technic.register_separating_recipe({ input = { data[1] }, output = { data[2], data[3] } })
end
