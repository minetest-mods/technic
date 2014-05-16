
minetest.register_craft({
	output = 'technic:lv_battery_box0',
	recipe = {
		{'technic:battery',         'group:wood',              'technic:battery'},
		{'technic:battery',         'default:copper_ingot',    'technic:battery'},
		{'technic:cast_iron_ingot', 'technic:cast_iron_ingot', 'technic:cast_iron_ingot'},
	}
})

technic.register_battery_box({
	tier           = "LV",
	max_charge     = 40000,
	charge_rate    = 1000,
	discharge_rate = 4000,
	charge_step    = 500,
	discharge_step = 800,
})

