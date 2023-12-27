
minetest.register_alias("lv_cable", "technic:lv_cable")

minetest.register_craft({
	output = 'technic:lv_cable 6',
	recipe = {
		{technic.compat.paper_ingredient,        technic.compat.paper_ingredient,        technic.compat.paper_ingredient},
		{technic.compat.copper_ingredient, technic.compat.copper_ingredient, technic.compat.copper_ingredient},
		{technic.compat.paper_ingredient,        technic.compat.paper_ingredient,        technic.compat.paper_ingredient},
	}
})

technic.register_cable("LV", 2/16)

