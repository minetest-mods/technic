
minetest.register_alias("lv_cable", "technic:lv_cable")

minetest.register_craft({
	output = 'technic:lv_cable 6',
	recipe = {
		{paper_ingredient,        paper_ingredient,        paper_ingredient},
		{copper_ingredient, copper_ingredient, copper_ingredient},
		{paper_ingredient,        paper_ingredient,        paper_ingredient},
	}
})

technic.register_cable("LV", 2/16)

