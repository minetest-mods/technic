minetest.register_craft({
	output = 'technic:copper_chest 1',
	recipe = {
		{copper_ingrediant,copper_ingrediant,copper_ingrediant},
		{copper_ingrediant,'technic:iron_chest',copper_ingrediant},
		{copper_ingrediant,copper_ingrediant,copper_ingrediant},
	}
})

minetest.register_craft({
	output = 'technic:copper_locked_chest 1',
	recipe = {
		{copper_ingrediant,copper_ingrediant,copper_ingrediant},
		{copper_ingrediant,'technic:iron_locked_chest',copper_ingrediant},
		{copper_ingrediant,copper_ingrediant,copper_ingrediant},
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

