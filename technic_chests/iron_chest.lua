
minetest.register_craft({
	output = 'technic:iron_chest 1',
	recipe = {
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
		{'default:steel_ingot','default:chest','default:steel_ingot'},
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
		{'default:steel_ingot','default:chest_locked','default:steel_ingot'},
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'default:steel_ingot'},
		{'technic:iron_chest'},
	}
})

technic.chests:register("Iron", {
	width = 9,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = false,
})

technic.chests:register("Iron", {
	width = 9,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = true,
})

