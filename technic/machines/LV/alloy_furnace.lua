-- LV Alloy furnace

-- FIXME: kpoppel: I'd like to introduce an induction heating element here...
minetest.register_craft({
	output = 'technic:lv_alloy_furnace',
	recipe = {
		{'default:brick', 'default:brick',          'default:brick'},
		{'default:brick', 'technic:machine_casing', 'default:brick'},
		{'default:brick', 'technic:lv_cable',       'default:brick'},
	}
})

technic.register_alloy_furnace({tier = "LV", speed = 1, demand = {300}})

