-- The high voltage solar array is an assembly of medium voltage arrays.
-- Solar arrays are not able to store large amounts of energy.

local S = minetest.get_translator("technic")

minetest.register_craft({
	output = 'technic:solar_array_hv 1',
	recipe = {
		{'technic:solar_array_mv',     'technic:solar_array_mv', 'technic:solar_array_mv'},
		{'technic:carbon_plate',       'technic:hv_transformer', 'technic:composite_plate'},
		{'',                           'technic:hv_cable',       ''},
	}
})

technic.register_solar_array({tier="HV", power=100, tier_localized=S("HV")})

