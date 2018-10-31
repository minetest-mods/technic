
minetest.register_alias("extractor", "technic:lv_extractor")

minetest.register_craft({
	output = 'technic:lv_extractor',
	recipe = {
		{'technic:treetap', 'basic_materials:motor',          'technic:treetap'},
		{'technic:treetap', 'technic:machine_casing', 'technic:treetap'},
		{'',                'technic:lv_cable',       ''},
	}
})

technic.register_extractor({tier = "LV", demand = {300}, speed = 1})
