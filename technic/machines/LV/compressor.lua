
minetest.register_alias("compressor", "technic:lv_compressor")

minetest.register_craft({
	output = 'technic:lv_compressor',
	recipe = {
		{stone_ingrediant,            'basic_materials:motor',          stone_ingrediant},
		{'mesecons:piston',          'technic:machine_casing', 'mesecons:piston'},
		{'basic_materials:silver_wire', 'technic:lv_cable',       'basic_materials:silver_wire'},
	},
	replacements = {
		{"basic_materials:silver_wire", "basic_materials:empty_spool"},
		{"basic_materials:silver_wire", "basic_materials:empty_spool"}
	},
})

technic.register_compressor({tier = "LV", demand = {300}, speed = 1})
