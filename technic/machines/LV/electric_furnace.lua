-- LV Electric Furnace
-- This is a faster version of the stone furnace which runs on EUs

-- FIXME: kpoppel I'd like to introduce an induction heating element here also
minetest.register_craft({
	output = 'technic:electric_furnace',
	recipe = {
		{technic_compat.cobble_ingredient, technic_compat.cobble_ingredient,         technic_compat.cobble_ingredient},
		{technic_compat.cobble_ingredient, 'technic:machine_casing', technic_compat.cobble_ingredient},
		{technic_compat.cobble_ingredient, 'technic:lv_cable',       technic_compat.cobble_ingredient},
	}
})

technic.register_electric_furnace({tier="LV", demand={300}, speed = 2})


