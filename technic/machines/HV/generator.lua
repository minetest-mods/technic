minetest.register_alias("hv_generator", "technic:hv_generator")

minetest.register_craft({
	output = 'technic:hv_generator',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_generator',   'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer', 'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable0',      'technic:stainless_steel_ingot'},
	}
})

technic.register_generator({tier="HV", tube=1, supply=1200})

