-- MV freezer

minetest.register_craft({
	output = 'technic:mv_freezer',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:motor',          'technic:stainless_steel_ingot'},
		{'pipeworks:pipe_1_empty',        'technic:mv_transformer', 'pipeworks:pipe_1_empty'},
		{'technic:stainless_steel_ingot', 'technic:mv_cable',       'technic:stainless_steel_ingot'},
	}
})

technic.register_freezer({tier = "MV", demand = {800, 600, 400}, speed = 0.5, upgrade = 1, tube = 1})
