minetest.register_alias("generator_hv", "technic:generator_hv")
minetest.register_alias("generator_hv", "technic:generator_hv_active")

minetest.register_craft({
	output = 'technic:generator_hv',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:generator_mv', 'technic:stainless_steel_ingot'},
                {'pipeworks:tube_000000', 'technic:hv_transformer', 'pipeworks:tube_000000'},
                {'technic:stainless_steel_ingot', 'technic:hv_cable', 'technic:stainless_steel_ingot'},

	}
})
technic.register_generator({tier="HV",supply=400})