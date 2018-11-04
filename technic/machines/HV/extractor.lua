-- HV extractor

minetest.register_craft({
	output = 'technic:hv_extractor',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_extractor',   'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer', 'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable',       'technic:stainless_steel_ingot'},
	}
})

technic.register_extractor({tier = "HV", demand = {1600, 1200, 800}, speed = 3, upgrade = 1, tube = 1})
