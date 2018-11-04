-- HV alloy furnace

minetest.register_craft({
	output = 'technic:hv_alloy_furnace',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_alloy_furnace', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer',   'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable',         'technic:stainless_steel_ingot'},
	}
})


technic.register_alloy_furnace({tier = "HV", speed = 2.5, upgrade = 1, tube = 1, demand = {5000, 3500, 2000}})

