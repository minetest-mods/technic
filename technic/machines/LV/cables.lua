
minetest.register_alias("lv_cable", "technic:lv_cable0")

minetest.register_craft({
	output = 'technic:lv_cable0 6',
	recipe = {
		{'default:paper',        'default:paper',        'default:paper'},
		{'default:copper_ingot', 'default:copper_ingot', 'default:copper_ingot'},
		{'default:paper',        'default:paper',        'default:paper'},
	}
}) 

technic.register_cable("LV", 2/16)

