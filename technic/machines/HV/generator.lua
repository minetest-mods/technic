
minetest.register_alias("hv_generator", "technic:hv_generator")

minetest.register_craft({
	output = 'technic:hv_generator',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_generator',   'technic:stainless_steel_ingot'},
		{'pipeworks:tube_000000',         'technic:hv_transformer', 'pipeworks:tube_000000'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable',       'technic:stainless_steel_ingot'},
	}
})

technic.register_generator({tier="HV", supply=1200})

