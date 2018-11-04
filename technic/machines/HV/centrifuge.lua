minetest.register_craft({
	output = "technic:hv_centrifuge",
	recipe = {
		{"technic:stainless_steel_ingot", "technic:mv_centrifuge",  "technic:stainless_steel_ingot" },
		{"pipeworks:tube_1",              "technic:hv_transformer", "pipeworks:tube_1" },
		{"technic:stainless_steel_ingot", "technic:hv_cable",       "technic:stainless_steel_ingot" },
	}
})

technic.register_centrifuge({
	tier = "HV",
	demand = { 12000, 10500, 8000 },
	speed = 4,
	upgrade = 1,
	tube = 1,
})
