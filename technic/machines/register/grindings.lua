local S = technic.getter
local moretrees = minetest.get_modpath("moretrees")
local dye = minetest.get_modpath("dye")

-- sawdust, the finest wood/tree grinding
local sawdust = "technic:sawdust"
minetest.register_craftitem(sawdust, {
	description = S("Sawdust"),
	inventory_image = "technic_sawdust.png",
})
minetest.register_craft({ type = "fuel", recipe = sawdust, burntime = 6 })
technic.register_compressor_recipe({ input = {sawdust .. " 4"}, output = "default:wood" })

-- tree/wood grindings
local function register_tree_grinding(name, tree, wood, extract, grinding_color)
	local lname = string.lower(name)
	lname = string.gsub(lname, ' ', '_')
	local grindings_name = "technic:"..lname.."_grindings"
	local inventory_image = "technic_"..lname.."_grindings.png"
	if grinding_color then
		inventory_image = inventory_image .. "^[colorize:" .. grinding_color
	end
	minetest.register_craftitem(grindings_name, {
		description = S("%s Grinding"):format(S(name)),
		inventory_image = inventory_image,
	})
	minetest.register_craft({
		type = "fuel",
		recipe = grindings_name,
		burntime = 8,
	})
	technic.register_grinder_recipe({ input = { tree }, output = grindings_name .. " 4" })
	technic.register_grinder_recipe({ input = { grindings_name }, output = sawdust .. " 4" })
	if wood then
		technic.register_grinder_recipe({ input = { wood }, output = grindings_name })
	end
	if extract then
		technic.register_extractor_recipe({ input = { grindings_name .. " 4" }, output = extract})
		technic.register_separating_recipe({
			input = { grindings_name .. " 4" },
			output = { sawdust .. " 4", extract }
		})
	end
end

local rubber_tree_planks = moretrees and "moretrees:rubber_tree_planks"
local default_extract = dye and "dye:brown 2"

local grinding_recipes = {
	{"Common Tree",	"group:tree",	 			"group:wood",		default_extract },
	{"Rubber Tree",	"moretrees:rubber_tree_trunk",  	rubber_tree_planks, 	"technic:raw_latex"}
}

for _, data in pairs(grinding_recipes) do
	register_tree_grinding(unpack(data))
end

if moretrees and dye then
	-- https://en.wikipedia.org/wiki/Catechu ancient brown dye from the wood of acacia trees
	register_tree_grinding("Acacia", "moretrees:acacia_trunk", "moretrees:acacia_planks", "dye:brown 8")
end
