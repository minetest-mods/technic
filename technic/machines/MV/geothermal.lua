

--- An MV geothermal EU generator
--- Using hot lava and water this device can create energy from steam



minetest.register_craft({
	output = 'technic:geothermal_mv 1',
	recipe = {
		{'technic:geothermal_lv',     'technic:geothermal_lv', 'technic:geothermal_lv'},
		{'technic:carbon_steel_ingot', 'technic:mv_transformer', 'technic:carbon_steel_ingot'},
		{'',                           'technic:mv_cable0',      ''},
	}
})


minetest.register_craft({
	output = 'technic:geothermal_mv 1',
	recipe = {
		{'technic:geothermal',     'technic:geothermal', 'technic:geothermal'},
		{'technic:carbon_steel_ingot', 'technic:mv_transformer', 'technic:carbon_steel_ingot'},
		{'',                           'technic:mv_cable0',      ''},
	}
})






technic.register_geothermal({tier="MV", power=30})

-- compatibility alias for upgrading from old versions of technic
--minetest.register_alias("technic:geothermal_mv", "technic:geothermal_mv")
