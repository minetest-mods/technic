
local material_list
if minetest.get_modpath("moreores") then
	material_list = { 'silver' }
else
	-- Make the gold chest obtainable for mere mortals (the silver chest is not obtainable)
	material_list = { 'copper', 'silver' }
end

for _, material in ipairs(material_list) do
	minetest.register_craft({
		output = 'technic:gold_chest',
		recipe = {
			{gold_ingot_ingredient,gold_ingot_ingredient,gold_ingot_ingredient},
			{gold_ingot_ingredient,"technic:"..material.."_chest",gold_ingot_ingredient},
			{gold_ingot_ingredient,gold_ingot_ingredient,gold_ingot_ingredient},
		}
	})

	minetest.register_craft({
		output = 'technic:gold_locked_chest',
		recipe = {
			{gold_ingot_ingredient,gold_ingot_ingredient,gold_ingot_ingredient},
			{gold_ingot_ingredient,"technic:"..material.."_locked_chest",gold_ingot_ingredient},
			{gold_ingot_ingredient,gold_ingot_ingredient,gold_ingot_ingredient},
		}
	})
end

minetest.register_craft({
	output = 'technic:gold_locked_chest',
	type = "shapeless",
	recipe = {
		'basic_materials:padlock',
		'technic:gold_chest',
	}
})

technic.chests:register("Gold", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = true,
	locked = false,
})

technic.chests:register("Gold", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = true,
	locked = true,
})

