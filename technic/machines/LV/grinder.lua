
minetest.register_alias("grinder", "technic:grinder")
minetest.register_craft({
	output = 'technic:grinder',
	recipe = {
		{'default:desert_stone', 'default:desert_stone',  'default:desert_stone'},
		{'default:desert_stone', 'default:diamond',       'default:desert_stone'},
		{'default:stone',        'moreores:copper_ingot', 'default:stone'},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

