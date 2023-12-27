-- The electric generator.
-- A simple device to get started on the electric machines.
-- Inefficient and expensive in fuel (200EU per tick)
-- Also only allows for LV machinery to run.

minetest.register_alias("lv_generator", "technic:lv_generator")

minetest.register_craft({
	output = 'technic:lv_generator',
	recipe = {
		{technic.compat.stone_ingredient, technic.compat.furnace_ingredient,        technic.compat.stone_ingredient},
		{technic.compat.stone_ingredient, 'technic:machine_casing', technic.compat.stone_ingredient},
		{technic.compat.stone_ingredient, 'technic:lv_cable',       technic.compat.stone_ingredient},
	}
})

technic.register_generator({tier="LV", supply=200})

