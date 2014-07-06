
minetest.register_craft({
	output = 'technic:lv_battery_box0',
	recipe = {
		{'technic:battery',         'default:copper_ingot',    'technic:battery'},
		{'technic:battery',         'technic:machine_casing',  'technic:battery'},
		{'group:wood',              'group:wood',              'group:wood'},
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

