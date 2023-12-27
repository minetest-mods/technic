
minetest.register_alias("grinder", "technic:lv_grinder")
minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{technic.compat.desert_stone_ingredient, technic.compat.diamond_ingredient,        technic.compat.desert_stone_ingredient},
		{technic.compat.desert_stone_ingredient, 'technic:machine_casing', technic.compat.desert_stone_ingredient},
		{technic.compat.granite_ingredient,      'technic:lv_cable',       technic.compat.granite_ingredient},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

