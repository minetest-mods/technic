
local S = technic.getter

technic.register_recipe_type("extracting", { description = S("Extracting") })

function technic.register_extractor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("extracting", data)
end

if minetest.get_modpath("dye") then
	-- check if we are using dye or unifieddyes
	local unifieddyes = minetest.get_modpath("unifieddyes")

	-- register recipes with the same crafting ratios as `dye` provides

	local dye_recipes = {
		{"technic:coal_dust",                dye_black .. " 2"},
		{blueberries_ingredient,              dye_violet .. " 2"},
		{grass_ingredient,                    dye_green .. " 1"},
		{dry_shrub_ingredient,                dye_brown .. " 1"},
		{junglegrass_ingredient,              dye_green .. " 2"},
		{cactus_ingredient,                   dye_green .. " 4"},
		{geranium_ingredient,                 dye_blue .. " 4"},
		{dandelion_white_ingredient,          dye_white .. " 4"},
		{dandelion_yellow_ingredient,         dye_yellow .. " 4"},
		{tulip_ingredient,                    dye_orange .. " 4"},
		{rose_ingredient,                     dye_red .. " 4"},
		{viola_ingredient,                    dye_violet .. " 4"},
		{blackberry_ingredient,               unifieddyes and "unifieddyes:magenta_s50 4" or dye_violet .. " 4"},
		{blueberry_ingredient,                unifieddyes and "unifieddyes:magenta_s50 4" or dye_magenta .. " 4"},
	}
	
	

	for _, data in ipairs(dye_recipes) do
		technic.register_extractor_recipe({input = {data[1]}, output = data[2]})
	end

	-- overwrite the existing crafting recipes
	local dyes = {"white", "red", "yellow", "blue", "violet", "orange"}
	for _, color in ipairs(dyes) do
		minetest.clear_craft({
			type = "shapeless",
			recipe = {"group:flower,color_"..color},
		})
		minetest.register_craft({
			type = "shapeless",
			output = "dye:"..color.." 1",
			recipe = {"group:flower,color_"..color},
		})
	end

	minetest.clear_craft({
		type = "shapeless",
		recipe = {"group:coal"},
	})
	minetest.register_craft({
		type = "shapeless",
		output = "dye:black 1",
		recipe = {"group:coal"},
	})

	if unifieddyes then
		minetest.clear_craft({
			type = "shapeless",
			recipe = {"default:cactus"},
		})
		minetest.register_craft({
			type = "shapeless",
			output = "dye:green 1",
			recipe = {"default:cactus"},
		})
	end
end
