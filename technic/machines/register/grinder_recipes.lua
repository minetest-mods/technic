
local S = technic.getter

technic.register_recipe_type("grinding", { description = S("Grinding") })

function technic.register_grinder_recipe(data)
	data.time = data.time or 3
	technic.register_recipe("grinding", data)
end

local recipes = {
	-- Dusts
	{"default:coal_lump",          "technic:coal_dust 2"},
	{"default:copper_lump",        "technic:copper_dust 2"},
	{"default:desert_stone",       "default:desert_sand"},
	{"default:gold_lump",          "technic:gold_dust 2"},
	{"default:iron_lump",          "technic:wrought_iron_dust 2"},
	{"default:tin_lump",           "technic:tin_dust 2"},
	{"technic:chromium_lump",      "technic:chromium_dust 2"},
	{"technic:uranium_lump",       "technic:uranium_dust 2"},
	{"technic:zinc_lump",          "technic:zinc_dust 2"},
	{"technic:lead_lump",          "technic:lead_dust 2"},
	{"technic:sulfur_lump",        "technic:sulfur_dust 2"},
	{"default:stone",              "technic:stone_dust"},
	{"default:sand",               "technic:stone_dust"},
	{"default:desert_sand",        "technic:stone_dust"},
	{"default:silver_sand",        "technic:stone_dust"},

	-- Other
	{"default:cobble",           "default:gravel"},
	{"default:gravel",           "default:sand"},
	{"default:sandstone",        "default:sand 2"}, -- reverse recipe can be found in the compressor
	{"default:desert_sandstone", "default:desert_sand 2"}, -- reverse recipe can be found in the compressor
	{"default:silver_sandstone", "default:silver_sand 2"}, -- reverse recipe can be found in the compressor

	{"default:ice",              "default:snowblock"},
}

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
	-- Lumps and wheat
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

-- defuse the sandstone -> 4 sand recipe to avoid infinite sand bugs (also consult the inverse compressor recipe)
minetest.clear_craft({
	recipe = {{"default:sandstone"}},
})
minetest.clear_craft({
	recipe = {{"default:desert_sandstone"}},
})
minetest.clear_craft({
	recipe = {{"default:silver_sandstone"}},
})

if minetest.get_modpath("everness") then
	minetest.clear_craft({
		recipe = {{"everness:mineral_sandstone"}},
	})
	-- Currently (2024-03-09), there seem to be no reverse recipes for any of the other everness sandstones.
end

for _, data in ipairs(recipes) do
	technic.register_grinder_recipe({input = {data[1]}, output = data[2]})
end

-- Dusts
local function register_dust(name, ingot)
	local lname = string.lower(name)
	lname = string.gsub(lname, ' ', '_')
	minetest.register_craftitem("technic:"..lname.."_dust", {
		description = S("%s Dust"):format(S(name)),
		inventory_image = "technic_"..lname.."_dust.png",
	})
	if ingot then
		minetest.register_craft({
			type = "cooking",
			recipe = "technic:"..lname.."_dust",
			output = ingot,
		})
		technic.register_grinder_recipe({ input = {ingot}, output = "technic:"..lname.."_dust 1" })
	end
end

-- Sorted alphabetically
local dusts = {
	{"Brass",           "basic_materials:brass_ingot"},
	{"Bronze",          "default:bronze_ingot"},
	{"Carbon Steel",    "technic:carbon_steel_ingot"},
	{"Cast Iron",       "technic:cast_iron_ingot"},
	{"Chernobylite",    "technic:chernobylite_block"},
	{"Chromium",        "technic:chromium_ingot"},
	{"Coal",            nil},
	{"Copper",          "default:copper_ingot"},
	{"Lead",            "technic:lead_ingot"},
	{"Gold",            "default:gold_ingot"},
	{"Mithril",         "moreores:mithril_ingot"},
	{"Silver",          "moreores:silver_ingot"},
	{"Stainless Steel", "technic:stainless_steel_ingot"},
	{"Stone",           "default:stone"},
	{"Sulfur",          nil},
	{"Tin",             "default:tin_ingot"},
	{"Wrought Iron",    "technic:wrought_iron_ingot"},
	{"Zinc",            "technic:zinc_ingot"},
}

local dependent_dusts = {
	everness = {
		{"Pyrite",          "everness:pyrite_ingot"},
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
		for _, dust_entry in pairs(dusts_to_add) do
			table.insert(dusts, dust_entry)
		end
	end
end

for _, data in ipairs(dusts) do
	register_dust(data[1], data[2])
end

-- Uranium
for p = 0, 35 do
	local nici = (p ~= 0 and p ~= 7 and p ~= 35) and 1 or nil
	local psuffix = p == 7 and "" or p
	local ingot = "technic:uranium"..psuffix.."_ingot"
	local dust = "technic:uranium"..psuffix.."_dust"
	minetest.register_craftitem(dust, {
		description = S("%s Dust"):format(string.format(S("%.1f%%-Fissile Uranium"), p/10)),
		inventory_image = "technic_uranium_dust.png",
		on_place_on_ground = minetest.craftitem_place_item,
		groups = {uranium_dust=1, not_in_creative_inventory=nici},
	})
	minetest.register_craft({
		type = "cooking",
		recipe = dust,
		output = ingot,
	})
	technic.register_grinder_recipe({ input = {ingot}, output = dust })
end

local function uranium_dust(p)
	return "technic:uranium"..(p == 7 and "" or p).."_dust"
end
for pa = 0, 34 do
	for pb = pa+1, 35 do
		local pc = (pa+pb)/2
		if pc == math.floor(pc) then
			minetest.register_craft({
				type = "shapeless",
				recipe = { uranium_dust(pa), uranium_dust(pb) },
				output = uranium_dust(pc).." 2",
			})
		end
	end
end

-- Fuels
minetest.register_craft({
	type = "fuel",
	recipe = "technic:coal_dust",
	burntime = 50,
})

if minetest.get_modpath("gloopores") or minetest.get_modpath("glooptest") then
	minetest.register_craft({
		type = "fuel",
		recipe = "technic:kalite_dust",
		burntime = 37.5,
	})
end
