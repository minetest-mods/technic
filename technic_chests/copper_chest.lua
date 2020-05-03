minetest.register_craft({
	output = 'technic:copper_chest 1',
	recipe = {
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
		{'default:copper_ingot','technic:iron_chest','default:copper_ingot'},
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:copper_locked_chest 1',
	recipe = {
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
		{'default:copper_ingot','technic:iron_locked_chest','default:copper_ingot'},
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:copper_locked_chest 1',
	type = "shapeless",
	recipe = {
		'basic_materials:padlock',
		'technic:copper_chest',
	}
})

technic.chests:register("Copper", {
	width = 12,
	height = 5,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = false,
})

technic.chests:register("Copper", {
	width = 12,
	height = 5,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = true,
})

