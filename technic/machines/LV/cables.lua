
minetest.register_alias("lv_cable", "technic:lv_cable")

minetest.register_craft({
	output = 'technic:lv_cable 6',
	recipe = {
		{technic_compat.paper_ingredient,        technic_compat.paper_ingredient,        technic_compat.paper_ingredient},
		{technic_compat.copper_ingredient, technic_compat.copper_ingredient, technic_compat.copper_ingredient},
		{technic_compat.paper_ingredient,        technic_compat.paper_ingredient,        technic_compat.paper_ingredient},
	}
})

technic.register_cable("LV", 2/16)

