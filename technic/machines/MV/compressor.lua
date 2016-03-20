-- MV compressor

minetest.register_craft({
	output = 'technic:mv_compressor',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:lv_compressor',  'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:mv_transformer', 'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:mv_cable',       'technic:stainless_steel_ingot'},
	}
})

technic.register_compressor({tier = "MV", demand = {800, 600, 400}, speed = 2, upgrade = 1, tube = 1})
