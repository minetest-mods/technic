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
	if not minetest.registered_craftitems[grindings_name] then
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
	end
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

-- https://en.wikipedia.org/wiki/Catechu ancient brown dye from the wood of acacia trees
local acacia_extract = dye and "dye:brown 8"

register_tree_grinding("Common Tree",	"group:tree", 						 "group:wood",			default_extract)
register_tree_grinding("Common Tree",	"default:tree",                      "default:wood",        default_extract)
register_tree_grinding("Common Tree",	"default:aspen_tree",                "default:aspen_wood",  default_extract)
register_tree_grinding("Common Tree",	"default:jungletree",                "default:junglewood",  default_extract)
register_tree_grinding("Common Tree",	"default:pine_tree",                 "default:pine_wood",   default_extract)
register_tree_grinding("Rubber Tree",	"moretrees:rubber_tree_trunk",  	 rubber_tree_planks, 	"technic:raw_latex")
register_tree_grinding("Rubber Tree", 	"moretrees:rubber_tree_trunk_empty", nil,                   "technic:raw_latex")

if moretrees then
	register_tree_grinding("Common Tree",	"moretrees:beech_tree_trunk",		"moretrees:beech_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:apple_tree_trunk",		"moretrees:apple_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:oak_tree_trunk",			"moretrees:oak_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:giant_sequoia_trunk",	"moretrees:giant_sequoia_planks",	default_extract)
	register_tree_grinding("Common Tree",	"moretrees:birch_tree_trunk",		"moretrees:birch_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:palm_tree_trunk",		"moretrees:palm_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:date_palm_tree_trunk",	"moretrees:date_palm_tree_planks",	default_extract)
	register_tree_grinding("Common Tree",	"moretrees:spruce_tree_trunk",		"moretrees:spruce_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:ceder_tree_trunk",		"moretrees:ceder_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:poplar_tree_trunk",		"moretrees:poplar_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:wollow_tree_trunk",		"moretrees:wollow_tree_planks",		default_extract)
	register_tree_grinding("Common Tree",	"moretrees:douglas_fir_trunk",		"moretrees:douglas_fir_planks",		default_extract)

	register_tree_grinding("Acacia", 		"moretrees:acacia_trunk", 			"moretrees:acacia_planks", 			acacia_extract)
else
	register_tree_grinding("Acacia", 		"default:acacia_tree", 				"default:acacia_wood", 				acacia_extract)
end
