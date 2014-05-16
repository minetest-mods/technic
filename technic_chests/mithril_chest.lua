minetest.register_craft({
	output = 'technic:mithril_chest 1',
	recipe = {
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','technic:gold_chest','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:mithril_locked_chest 1',
	recipe = {
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','technic:gold_locked_chest','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:mithril_locked_chest 1',
	recipe = {
		{'technic:wrought_iron_ingot'},
		{'technic:mithril_chest'},
	}
})

technic.chests:register("Mithril", {
	width = 13,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = false,
})

technic.chests:register("Mithril", {
	width = 13,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = true,
})

