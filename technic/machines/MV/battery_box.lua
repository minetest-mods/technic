-- MV Battery box

minetest.register_craft({
	output = 'technic:mv_battery_box0',
	recipe = {
		{'technic:lv_battery_box0', 'technic:lv_battery_box0', 'technic:lv_battery_box0'},
		{'technic:lv_battery_box0', 'technic:mv_transformer',  'technic:lv_battery_box0'},
		{'',                        'technic:mv_cable',        ''},
	}
})

technic.register_battery_box({
	tier           = "MV",
	max_charge     = 200000,
	charge_rate    = 20000,
	discharge_rate = 80000,
	charge_step    = 2000,
	discharge_step = 8000,
	upgrade        = 1,
	tube           = 1,
})

