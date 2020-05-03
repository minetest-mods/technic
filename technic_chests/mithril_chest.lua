if minetest.get_modpath("moreores") then
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
end

minetest.register_craft({
	output = 'technic:mithril_locked_chest 1',
	type = "shapeless",
	recipe = {
		'basic_materials:padlock',
		'technic:mithril_chest',
	}
})

technic.chests:register("Mithril", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = false,
})

technic.chests:register("Mithril", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = false,
	color = false,
	locked = true,
})

