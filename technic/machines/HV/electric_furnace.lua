-- MV Electric Furnace
-- This is a faster version of the stone furnace which runs on EUs
-- In addition to this it can be upgraded with microcontrollers and batteries
-- This new version uses the batteries to lower the power consumption of the machine
-- Also in addition this furnace can be attached to the pipe system from the pipeworks mod.

-- FIXME: kpoppel I'd like to introduce an induction heating element here also
minetest.register_craft({
	output = 'technic:hv_electric_furnace',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_electric_furnace', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer',      'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable',            'technic:stainless_steel_ingot'},
	}
})

technic.register_electric_furnace({tier="HV", upgrade=1, tube=1, demand={4000, 2500, 1500}, speed=12})

