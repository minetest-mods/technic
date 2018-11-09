-- HV Electric Furnace

minetest.register_craft({
	output = 'technic:hv_electric_furnace',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_electric_furnace', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer',      'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable',            'technic:stainless_steel_ingot'},
	}
})

technic.register_electric_furnace({tier="HV", upgrade=1, tube=1, demand={4000, 2000, 1000}, speed=8})

