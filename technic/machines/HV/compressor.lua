-- HV compressor

minetest.register_craft({
	output = 'technic:mv_compressor',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_compressor',  'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer', 'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable',       'technic:stainless_steel_ingot'},
	}
})

technic.register_compressor({tier = "HV", demand = {1500, 1000, 750}, speed = 5, upgrade = 1, tube = 1})
