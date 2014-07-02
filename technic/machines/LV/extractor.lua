
minetest.register_alias("extractor", "technic:lv_extractor")

minetest.register_craft({
	output = 'technic:lv_extractor',
	recipe = {
		{'technic:treetap', 'technic:motor',     'technic:treetap'},
		{'technic:treetap', 'technic:lv_cable0', 'technic:treetap'},
		{'',                '',                  ''},
	}
})

technic.register_extractor({tier = "LV", demand = {300}, speed = 1})
