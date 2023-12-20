-- The electric generator.
-- A simple device to get started on the electric machines.
-- Inefficient and expensive in fuel (200EU per tick)
-- Also only allows for LV machinery to run.

minetest.register_alias("lv_generator", "technic:lv_generator")

minetest.register_craft({
	output = 'technic:lv_generator',
	recipe = {
		{stone_ingrediant, furnace_ingrediant,        stone_ingrediant},
		{stone_ingrediant, 'technic:machine_casing', stone_ingrediant},
		{stone_ingrediant, 'technic:lv_cable',       stone_ingrediant},
	}
})

technic.register_generator({tier="LV", supply=200})

