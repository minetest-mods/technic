
local S = technic.getter

if unified_inventory and unified_inventory.register_craft_type then
	unified_inventory.register_craft_type("grinding", {
		description = S("Grinding"),
		height = 1,
		width = 1,
	})
end

technic.grinder_recipes = {}

function technic.register_grinder_recipe(data)
	data.time = data.time or 3
	technic.grinder_recipes[data.input] = data
	if unified_inventory then
		unified_inventory.register_craft({
			type = "grinding",
			output = data.output,
			items = {data.input},
			width = 0,
		})
	end
end

minetest.after(0.01, function ()
	for ingredient, recipe in pairs(technic.grinder_recipes) do
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

-- Sorted alphebeticaly
local recipes = {
	{"default:bronze_ingot",    "technic:bronze_dust 1"},
	{"default:coal_lump",       "technic:coal_dust 2"},
	{"default:cobble",          "default:gravel"},
	{"default:copper_ingot",    "technic:copper_dust 1"},
	{"default:copper_lump",     "technic:copper_dust 2"},
	{"default:desert_stone",    "default:desert_sand"},
	{"default:gold_ingot",      "technic:gold_dust 1"},
	{"default:gold_lump",       "technic:gold_dust 2"},
	{"default:gravel",          "default:dirt"},
	{"default:iron_lump",       "technic:wrought_iron_dust 2"},
	{"default:stone",           "default:sand"},
	{"moreores:mithril_ingot",  "technic:mithril_dust 1"},
	{"moreores:mithril_lump",   "technic:mithril_dust 2"},
	{"moreores:silver_ingot",   "technic:silver_dust 1"},
	{"moreores:silver_lump",    "technic:silver_dust 2"},
	{"moreores:tin_ingot",      "technic:tin_dust 1"},
	{"moreores:tin_lump",       "technic:tin_dust 2"},
	{"technic:cast_iron_ingot", "technic:cast_iron_dust 1"},
	{"technic:chromium_ingot",  "technic:chromium_dust 1"},
	{"technic:chromium_lump",   "technic:chromium_dust 2"},
	{"technic:wrought_iron_ingot", "technic:wrought_iron_dust 1"},
	{"technic:carbon_steel_ingot", "technic:carbon_steel_dust 1"},
	{"technic:stainless_steel_ingot", "technic:stainless_steel_dust 1"},
	{"technic:zinc_ingot",      "technic:zinc_dust 1"},
	{"technic:zinc_lump",       "technic:zinc_dust 2"},
	{"technic:brass_ingot",     "technic:brass_dust 1"},
}

if minetest.get_modpath("gloopores") then
	table.insert(recipes, {"gloopores:alatro_lump",   "technic:alatro_dust 2"})
	table.insert(recipes, {"gloopores:kalite_lump",   "technic:kalite_dust 2"})
	table.insert(recipes, {"gloopores:arol_lump",     "technic:arol_dust 2"})
	table.insert(recipes, {"gloopores:talinite_lump", "technic:talinite_dust 2"})
	table.insert(recipes, {"gloopores:akalin_lump",   "technic:akalin_dust 2"})
end

if minetest.get_modpath("homedecor") then
	table.insert(recipes, {"home_decor:brass_ingot", "technic:brass_dust 1"})
end

for _, data in pairs(recipes) do
	technic.register_grinder_recipe({input=data[1], output=data[2]})
end

local function register_dust(name, ingot)
	local lname = string.lower(name)
	lname = string.gsub(lname, ' ', '_')
	minetest.register_craftitem("technic:"..lname.."_dust", {
		description = S("%s Dust"):format(S(name)),
		inventory_image = "technic_"..lname.."_dust.png",
		on_place_on_ground = minetest.craftitem_place_item,
	})
	if ingot then
		minetest.register_craft({
			type = "cooking",
			recipe = "technic:"..lname.."_dust",
			output = ingot,
		})
	end
end

-- Sorted alphibeticaly
register_dust("Brass",           "technic:brass_ingot")
register_dust("Bronze",          "default:bronze_ingot")
register_dust("Carbon Steel",    "technic:carbon_steel_ingot")
register_dust("Cast Iron",       "technic:cast_iron_ingot")
register_dust("Chromium",        "technic:chromium_ingot")
register_dust("Coal",            nil)
register_dust("Copper",          "default:copper_ingot")
register_dust("Gold",            "default:gold_ingot")
register_dust("Mithril",         "moreores:mithril_ingot")
register_dust("Silver",          "moreores:silver_ingot")
register_dust("Stainless Steel", "technic:stainless_steel_ingot")
register_dust("Tin",             "moreores:tin_ingot")
register_dust("Wrought Iron",    "technic:wrought_iron_ingot")
register_dust("Zinc",            "technic:zinc_ingot")
if minetest.get_modpath("gloopores") then
	register_dust("Akalin",          "glooptest:akalin_ingot")
	register_dust("Alatro",          "glooptest:alatro_ingot")
	register_dust("Arol",            "glooptest:arol_ingot")
	register_dust("Talinite",        "glooptest:talinite_ingot")
end

minetest.register_craft({
	type = "fuel",
	recipe = "technic:coal_dust",
	burntime = 50,
})

