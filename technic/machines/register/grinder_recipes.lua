local S = technic.getter

technic.register_recipe_type("grinding", { description = S("Grinding") })

function technic.register_grinder_recipe(data)
	data.time = data.time or 3
	technic.register_recipe("grinding", data)
end

local recipes = {}

if minetest.get_modpath("default") then
	table.insert(recipes, {"default:silver_sandstone", "default:silver_sand 2"})
	table.insert(recipes, {"default:silver_sand",        "technic:stone_dust"})
end

local dependent_recipes = {
	-- Sandstones
	everness = {
		{"everness:coral_deep_ocean_sandstone_block",			"everness:coral_deep_ocean_sand 2"},
		{"everness:coral_sandstone",							"everness:coral_sand 2"},
		{"everness:coral_white_sandstone",						"everness:coral_white_sand 2"},
		{"everness:crystal_forest_deep_ocean_sandstone_block",	"everness:crystal_forest_deep_ocean_sand 2"},
		{"everness:crystal_sandstone",							"everness:crystal_sand 2"},
		{"everness:cursed_lands_deep_ocean_sandstone_block",	"everness:cursed_lands_deep_ocean_sand 2"},
		{"everness:cursed_sandstone_block",						"everness:cursed_sand 2"},
		{"everness:mineral_sandstone",							"everness:mineral_sand 2"},
		{"everness:pyrite_lump",	"technic:pyrite_dust 2"},
	},
	farming = {
		{"farming:seed_wheat",		"farming:flour 1"},
	},
	gloopores = {
		{"gloopores:alatro_lump",	"technic:alatro_dust 2"},
		{"gloopores:kalite_lump",	"technic:kalite_dust 2"},
		{"gloopores:arol_lump",		"technic:arol_dust 2"},
		{"gloopores:talinite_lump",	"technic:talinite_dust 2"},
		{"gloopores:akalin_lump",	"technic:akalin_dust 2"},
	},
	homedecor = {
		{"home_decor:brass_ingot",	"technic:brass_dust 1"},
	},
	moreores = {
		{"moreores:mithril_lump",	"technic:mithril_dust 2"},
		{"moreores:silver_lump",	"technic:silver_dust 2"},
		{"moreores:tin_lump",		"technic:tin_dust 2"},
	},
	nether = {
		{"nether:nether_lump",		"technic:nether_dust 2"},
	},
}

for dependency, materials_to_add in pairs(dependent_recipes) do
	if minetest.get_modpath(dependency) then
		for _, material_entry in ipairs(materials_to_add) do
			table.insert(recipes, material_entry)
		end
	end
end

-- Coal lump -> coal dust (coal dust has nil ingot so register_dust won't add this)
table.insert(recipes, {technic_compat.coal_ingredient, "technic:coal_dust 2"})

-- MCL raw ore lump -> dust recipes
if technic_compat.mcl then
	table.insert(recipes, {technic_compat.iron_lump_ingredient, "technic:iron_dust 2"})
	table.insert(recipes, {technic_compat.gold_lump_ingredient, "technic:gold_dust 2"})
	table.insert(recipes, {technic_compat.copper_lump_ingredient, "technic:copper_dust 2"})
end

-- Defuse sandstone -> 4 sand recipe to avoid infinite sand bugs
if minetest.get_modpath("default") then
	minetest.clear_craft({ recipe = {{"default:sandstone"}} })
	minetest.clear_craft({ recipe = {{"default:desert_sandstone"}} })
	minetest.clear_craft({ recipe = {{"default:silver_sandstone"}} })
end

if minetest.get_modpath("everness") then
	minetest.clear_craft({ recipe = {{"everness:mineral_sandstone"}} })
end

for _, data in ipairs(recipes) do
	technic.register_grinder_recipe({input = {data[1]}, output = data[2]})
end

-- Dusts
local function register_dust(name, ingot, texture_name)
	local lname = texture_name or string.lower(name):gsub(' ', '_')
	local item_lname = string.lower(name):gsub(' ', '_')
	minetest.register_craftitem("technic:"..item_lname.."_dust", {
		description = S("%s Dust"):format(S(name)),
		inventory_image = "technic_"..lname.."_dust.png",
	})
	if ingot then
		minetest.register_craft({
			type = "cooking",
			recipe = "technic:"..item_lname.."_dust",
			output = ingot,
		})
		technic.register_grinder_recipe({ input = {ingot}, output = "technic:"..item_lname.."_dust 1" })
	end
end

local dusts = {
	{"Brass",           "basic_materials:brass_ingot"},
	{"Bronze",          technic_compat.bronze_ingredient},
	{"Carbon Steel",    "technic:carbon_steel_ingot"},
	{"Cast Iron",       "technic:cast_iron_ingot"},
	{"Chernobylite",    "technic:chernobylite_block"},
	{"Chromium",        "technic:chromium_ingot"},
	{"Coal",            nil},
	{"Lead",            "technic:lead_ingot"},
	{"Stainless Steel", "technic:stainless_steel_ingot"},
	{"Stone",           technic_compat.stone_ingredient},
	{"Sulfur",          nil},
	{"Tin",             technic_compat.tin_ingredient or "default:tin_ingot"},
	{"Wrought Iron",    "technic:wrought_iron_ingot"},
	{"Zinc",            "technic:zinc_ingot"},
}

-- Add base metal dusts only when their source mod is present
if technic_compat.mcl then
	table.insert(dusts, {"Iron",   "mcl_core:iron_ingot", "wrought_iron"})
	table.insert(dusts, {"Gold",   "mcl_core:gold_ingot"})
	if minetest.get_modpath("mcl_copper") then
		table.insert(dusts, {"Copper", "mcl_copper:copper_ingot"})
	end
elseif minetest.get_modpath("default") then
	table.insert(dusts, {"Gold",   "default:gold_ingot"})
	table.insert(dusts, {"Copper", "default:copper_ingot"})
end

local dependent_dusts = {
	everness = {
		{"Pyrite",          "everness:pyrite_ingot"},
	},
	moreores = {
		{"Mithril",         "moreores:mithril_ingot"},
		{"Silver",          "moreores:silver_ingot"},
	},
	gloopores = {
		{"Akalin",          "glooptest:akalin_ingot"},
		{"Alatro",          "glooptest:alatro_ingot"},
		{"Arol",            "glooptest:arol_ingot"},
		{"Kalite",          nil},
		{"Talinite",        "glooptest:talinite_ingot"},
	},
	nether = {
		{"Nether",          "nether:nether_ingot"},
	},
}

for dependency, dusts_to_add in pairs(dependent_dusts) do
	if minetest.get_modpath(dependency) then
		for _, dust_entry in ipairs(dusts_to_add) do
			table.insert(dusts, dust_entry)
		end
	end
end

for _, data in ipairs(dusts) do
	register_dust(data[1], data[2], data[3])
end

-- Uranium Logic remains same...