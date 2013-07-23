minetest.register_alias("generator_mv", "technic:generator_mv")
minetest.register_alias("generator_mv", "technic:generator_mv_active")

minetest.register_craft({
	output = 'technic:generator_mv',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:generator_lv', 'technic:stainless_steel_ingot'},
                {'pipeworks:tube_000000', 'technic:mv_transformer', 'pipeworks:tube_000000'},
                {'technic:stainless_steel_ingot', 'technic:mv_cable', 'technic:stainless_steel_ingot'},

	}
})
technic.register_generator({tier="MV",supply=300})