local S = minetest.get_translator("technic")
minetest.register_craft({
	output = 'technic:solar_array_mv 1',
	recipe = {
		{'technic:solar_array_lv',     'technic:solar_array_lv', 'technic:solar_array_lv'},
		{'technic:carbon_steel_ingot', 'technic:mv_transformer', 'technic:carbon_steel_ingot'},
		{'',                           'technic:mv_cable',       ''},
	}
})

technic.register_solar_array({tier="MV", power=30, tier_localized=S("MV")})

-- compatibility alias for upgrading from old versions of technic
minetest.register_alias("technic:solar_panel_mv", "technic:solar_array_mv")
