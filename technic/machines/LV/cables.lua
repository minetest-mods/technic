
minetest.register_alias("lv_cable", "technic:lv_cable")

minetest.register_craft({
	output = 'technic:lv_cable 6',
	recipe = {
		{paper_ingrediant,        paper_ingrediant,        paper_ingrediant},
		{copper_ingrediant, copper_ingrediant, copper_ingrediant},
		{paper_ingrediant,        paper_ingrediant,        paper_ingrediant},
	}
})

technic.register_cable("LV", 2/16)

