minetest.register_alias("generator_mv", "technic:generator_mv")

minetest.register_craft({
	output = 'technic:mv_generator',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:lv_generator',   'technic:stainless_steel_ingot'},
		{'pipeworks:tube_000000',         'technic:mv_transformer', 'pipeworks:tube_000000'},
		{'technic:stainless_steel_ingot', 'technic:mv_cable',       'technic:stainless_steel_ingot'},
	}
})

technic.register_generator({tier="MV", tube=1, supply=600})

