-- HV Electric Furnace
-- This is a faster version of the MV furnace which runs on EUs
-- In addition to this it can be upgraded with microcontrollers and batteries
-- This new version uses the batteries to lower the power consumption of the machine
-- Also in addition this furnace can be attached to the pipe system from the pipeworks mod.

-- FIXME: kpoppel I'd like to introduce an induction heating element here also
minetest.register_craft({
	output = 'technic:hv_electric_furnace',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_electric_furnace', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_000000',         'technic:hv_transformer',      'pipeworks:tube_000000'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable0',           'technic:stainless_steel_ingot'},
	}
})

technic.register_electric_furnace({tier="HV", upgrade=1, tube=1, demand={10000, 5000, 2500}, speed=16})

