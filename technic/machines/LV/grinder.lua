
minetest.register_alias("grinder", "technic:lv_grinder")
minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{technic_compat.desert_stone_ingredient, technic_compat.diamond_ingredient,        technic_compat.desert_stone_ingredient},
		{technic_compat.desert_stone_ingredient, 'technic:machine_casing', technic_compat.desert_stone_ingredient},
		{technic_compat.granite_ingredient,      'technic:lv_cable',       technic_compat.granite_ingredient},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

