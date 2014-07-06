
minetest.register_alias("grinder", "technic:grinder")
minetest.register_craft({
	output = 'technic:grinder',
	recipe = {
		{'default:desert_stone', 'default:diamond',        'default:desert_stone'},
		{'default:desert_stone', 'technic:machine_casing', 'default:desert_stone'},
		{'default:stone',        'technic:lv_cable0',      'default:stone'},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

