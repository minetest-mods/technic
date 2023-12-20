
local S = technic.getter

technic.register_recipe_type("grinding", { description = S("Grinding") })

function technic.register_grinder_recipe(data)
	data.time = data.time or 3
	technic.register_recipe("grinding", data)
end

local recipes = {
    -- Dusts
    {coal_ingrediant,              "technic:coal_dust 2"},
    {copper_lump_ingrediant,            "technic:copper_dust 2"},
    {desert_stone_ingrediant,      desert_sand_ingrediant},
    {gold_lump_ingrediant,        "technic:gold_dust 2"},
    {iron_lump_ingrediant,              "technic:wrought_iron_dust 2"},
    {"moreores:tin_lump",               "technic:tin_dust 2"},
    {"technic:chromium_lump",      "technic:chromium_dust 2"},
    {"technic:uranium_lump",       "technic:uranium_dust 2"},
    {"technic:zinc_lump",          "technic:zinc_dust 2"},
    {"technic:lead_lump",          "technic:lead_dust 2"},
    {"technic:sulfur_lump",        "technic:sulfur_dust 2"},
    {stone_ingrediant,             "technic:stone_dust"},
    {sand_ingrediant,              "technic:stone_dust"},
    {desert_sand_ingrediant,       "technic:stone_dust"},

    -- Other
    {cobble_ingrediant,             gravel_ingrediant},
    {gravel_ingrediant,             sand_ingrediant},
    {sandstone_ingrediant,         sand_ingrediant.." 2"}, -- reverse recipe can be found in the compressor
    {desert_stone_ingrediant,   desert_sand_ingrediant.." 2"}, -- reverse recipe can be found in the compressor
    {ice_block_ingrediant,         snow_block_ingrediant},
}


if minetest.get_modpath("default") then
	table.insert(recipes, {"default:silver_sandstone", "default:silver_sand 2"}) -- reverse recipe can be found in the compressor
	table.insert(recipes, {"default:silver_sand",        "technic:stone_dust"})
end

-- defuse the sandstone -> 4 sand recipe to avoid infinite sand bugs (also consult the inverse compressor recipe)
minetest.clear_craft({
	recipe = {
		{"default:sandstone"}
	},
})
minetest.clear_craft({
	recipe = {
		{"default:desert_sandstone"}
	},
})
minetest.clear_craft({
	recipe = {
		{"default:silver_sandstone"}
	},
})

if minetest.get_modpath("farming") then
	table.insert(recipes, {"farming:seed_wheat",   "farming:flour 1"})
end

if minetest.get_modpath("moreores") then
	table.insert(recipes, {"moreores:mithril_lump",   "technic:mithril_dust 2"})
	table.insert(recipes, {"moreores:silver_lump",    "technic:silver_dust 2"})
end

if minetest.get_modpath("gloopores") or minetest.get_modpath("glooptest") then
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
	technic.register_grinder_recipe({input = {data[1]}, output = data[2]})
end

-- dusts
local function register_dust(name, ingot)
	local lname = string.lower(name)
	lname = string.gsub(lname, ' ', '_')
	minetest.register_craftitem("technic:"..lname.."_dust", {
		description = S("%s Dust"):format(S(name)),
		inventory_image = "technic_"..lname.."_dust.png",
	})
	if ingot then
		data1 = {
			type = "cooking",
			recipe = "technic:"..lname.."_dust",
			output = ingot,
		}
		minetest.log("action",minetest.serialize(data1))
		minetest.register_craft(data1)
		technic.register_grinder_recipe({ input = {ingot}, output = "technic:"..lname.."_dust 1" })
	end
end

-- Sorted alphibeticaly
register_dust("Brass",           "basic_materials:brass_ingot")
register_dust("Bronze",          "default:bronze_ingot")
register_dust("Carbon Steel",    "technic:carbon_steel_ingot")
register_dust("Cast Iron",       "technic:cast_iron_ingot")
register_dust("Chernobylite",    "technic:chernobylite_block")
register_dust("Chromium",        "technic:chromium_ingot")
register_dust("Coal",            nil)
register_dust("Copper",          copper_ingrediant)
register_dust("Lead",            "technic:lead_ingot")
register_dust("Gold",            gold_ingot_ingrediant)
register_dust("Mithril",         "moreores:mithril_ingot")
register_dust("Silver",          "moreores:silver_ingot")
register_dust("Stainless Steel", "technic:stainless_steel_ingot")
register_dust("Stone",           "default:stone")
register_dust("Sulfur",          nil)
register_dust("Tin",             tin_ingrediant)
register_dust("Wrought Iron",    "technic:wrought_iron_ingot")
register_dust("Zinc",            "technic:zinc_ingot")
if minetest.get_modpath("gloopores") or minetest.get_modpath("glooptest") then
	register_dust("Akalin",          "glooptest:akalin_ingot")
	register_dust("Alatro",          "glooptest:alatro_ingot")
	register_dust("Arol",            "glooptest:arol_ingot")
	register_dust("Kalite",          nil)
	register_dust("Talinite",        "glooptest:talinite_ingot")
end

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
