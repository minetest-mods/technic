-- LV Battery box and some other nodes...

technic.register_power_tool("technic:battery", 10000)
technic.register_power_tool("technic:red_energy_crystal", 100000)
technic.register_power_tool("technic:green_energy_crystal", 250000)
technic.register_power_tool("technic:blue_energy_crystal", 500000)

minetest.register_craft({
	output = 'technic:battery',
	recipe = {
		{'group:wood', 'default:copper_ingot', 'group:wood'},
		{'group:wood', 'moreores:tin_ingot',   'group:wood'},
		{'group:wood', 'default:copper_ingot', 'group:wood'},
	}
})

minetest.register_tool("technic:battery", {
	description = "RE Battery",
	inventory_image = "technic_battery.png",
	tool_capabilities = {
		charge = 0,
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
})

minetest.register_craft({
	output = 'technic:lv_battery_box0',
	recipe = {
		{'technic:battery',     'group:wood',           'technic:battery'},
		{'technic:battery',     'default:copper_ingot', 'technic:battery'},
		{'default:steel_ingot', 'default:steel_ingot',  'default:steel_ingot'},
	}
})

technic.register_battery_box({
	tier           = "LV",
	max_charge     = 50000,
	charge_rate    = 1000,
	discharge_rate = 4000,
	charge_step    = 500,
	discharge_step = 800,
})

