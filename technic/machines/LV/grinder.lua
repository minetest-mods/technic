
minetest.register_alias("grinder", "technic:lv_grinder")
minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{desert_stone_ingredient, diamond_ingredient,        desert_stone_ingredient},
		{desert_stone_ingredient, 'technic:machine_casing', desert_stone_ingredient},
		{granite_ingredient,      'technic:lv_cable',       granite_ingredient},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

