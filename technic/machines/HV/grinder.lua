
-- HV grinder
--
-- Credits:
-- Original code and idea is from cheapie:  <https://forum.minetest.net/viewtopic.php?id=7953>
-- Based on the pull request from qwrwed:   <https://github.com/minetest-technic/technic/pull/118>
minetest.register_craft({
	output = 'technic:hv_grinder',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_grinder',     'technic:stainless_steel_ingot'},
		{'pipeworks:tube_1',              'technic:hv_transformer', 'pipeworks:tube_1'},
		{'technic:stainless_steel_ingot', 'technic:hv_cable0',      'technic:stainless_steel_ingot'},
	}
})

technic.register_grinder({tier="HV", demand=2000, demand_reduction_factor=0.75, speed=4, upgrade=1, upgrade_slots=4, tube=1})

