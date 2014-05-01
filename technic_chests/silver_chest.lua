minetest.register_craft({
	output = 'technic:silver_chest',
	recipe = {
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		{'moreores:silver_ingot','technic:copper_chest','moreores:silver_ingot'},
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:silver_locked_chest',
	recipe = {
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		{'moreores:silver_ingot','technic:copper_locked_chest','moreores:silver_ingot'},
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:silver_locked_chest',
	recipe = {
		{'default:steel_ingot'},
		{'technic:silver_chest'},
	}
})

technic.chests:register("Silver", {
	width = 11,
	sort = true,
	autosort = true,
	infotext = true,
	color = false,
	locked = false,
})

technic.chests:register("Silver", {
	width = 11,
	sort = true,
	autosort = true,
	infotext = true,
	color = false,
	locked = true,
})

