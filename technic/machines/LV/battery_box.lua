-- LV Battery box

minetest.register_craft({
	output = 'technic:lv_battery_box0',
	recipe = {
		{'group:wood',      'group:wood',             'group:wood'},
		{'technic:battery', 'technic:machine_casing', 'technic:battery'},
		{'technic:battery', 'technic:lv_cable',       'technic:battery'},
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

