minetest.register_craft({
	output = "technic:mv_centrifuge",
	recipe = {
		{"basic_materials:motor",          "technic:copper_plate",   "technic:diamond_drill_head"},
		{"technic:copper_plate",   "technic:machine_casing", "technic:copper_plate"      },
		{"pipeworks:one_way_tube", "technic:mv_cable",       "pipeworks:mese_filter"     },
	}
})

technic.register_centrifuge({
	tier = "MV",
	demand = { 8000, 7000, 6000 },
	speed = 2,
	upgrade = 1,
	tube = 1,
})
