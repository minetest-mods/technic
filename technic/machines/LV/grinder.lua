
minetest.register_alias("grinder", "technic:lv_grinder")
minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{desert_stone_ingrediant, diamond_ingrediant,        desert_stone_ingrediant},
		{desert_stone_ingrediant, 'technic:machine_casing', desert_stone_ingrediant},
		{granite_ingrediant,      'technic:lv_cable',       granite_ingrediant},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

