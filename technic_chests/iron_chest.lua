
minetest.register_craft({
	output = 'technic:iron_chest 1',
	recipe = {
		{'technic:cast_iron_ingot','technic:cast_iron_ingot','technic:cast_iron_ingot'},
		{'technic:cast_iron_ingot','default:chest','technic:cast_iron_ingot'},
		{'technic:cast_iron_ingot','technic:cast_iron_ingot','technic:cast_iron_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'technic:cast_iron_ingot','technic:cast_iron_ingot','technic:cast_iron_ingot'},
		{'technic:cast_iron_ingot','default:chest_locked','technic:cast_iron_ingot'},
		{'technic:cast_iron_ingot','technic:cast_iron_ingot','technic:cast_iron_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'technic:wrought_iron_ingot'},
		{'technic:iron_chest'},
	}
})

technic.chests:register("Iron", {
	width = 9,
	height = 5,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = false,
})

technic.chests:register("Iron", {
	width = 9,
	height = 5,
	sort = true,
	autosort = false,
	infotext = false,
	color = false,
	locked = true,
})

