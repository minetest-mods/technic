
local S = technic.getter

technic.register_recipe_type("extracting", { description = S("Extracting") })

function technic.register_extractor_recipe(data)
	data.time = data.time or 4
	technic.register_recipe("extracting", data)
end

if minetest.get_modpath("dye") or minetest.get_modpath("mcl_dye") then
	-- check if we are using dye or unifieddyes
	local unifieddyes = minetest.get_modpath("unifieddyes")

	for _, data in ipairs(extractor_recipes) do
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
