
-- HV Electric Furnace
--
-- Credits:
-- Original code and idea is from cheapie:  <https://forum.minetest.net/viewtopic.php?id=7953>
-- Based on the pull request from qwrwed:   <https://github.com/minetest-technic/technic/pull/118>
minetest.register_craft({
	output = 'technic:hv_electric_furnace',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_electric_furnace', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer',      'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable0',           'technic:stainless_steel_ingot'},
	}
})

technic.register_electric_furnace({tier="HV", upgrade=1, upgrade_slots=4, tube=1, demand=10000, demand_reduction_factor=0.75, speed=8})

