-- HV grinder

minetest.register_craft({
	output = 'technic:hv_grinder',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_grinder',     'technic:stainless_steel_ingot'},
		{'pipeworks:tube_000000',         'technic:hv_transformer', 'pipeworks:tube_000000'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable0',      'technic:stainless_steel_ingot'},
	}
})

technic.register_grinder({tier="HV", demand={2000, 1000, 500}, speed=8, upgrade=1, tube=1})

