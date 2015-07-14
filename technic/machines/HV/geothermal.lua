
--- An HV geothermal EU generator
--- Using hot lava and water this device can create energy from steam




minetest.register_craft({
	output = 'technic:geothermal_hv 1',
	recipe = {
		{'technic:geothermal_mv',     'technic:geothermal_mv', 'technic:geothermal_mv'},
		{'technic:carbon_plate',       'technic:hv_transformer', 'technic:composite_plate'},
		{'',                           'technic:hv_cable0',      ''},
	}
})

technic.register_geothermal({tier="HV", power=100})

