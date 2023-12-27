-- LV Alloy furnace

-- FIXME: kpoppel: I'd like to introduce an induction heating element here...
minetest.register_craft({
	output = 'technic:lv_alloy_furnace',
	recipe = {
		{technic.compat.brick_block_ingredient, technic.compat.brick_block_ingredient,          technic.compat.brick_block_ingredient},
		{technic.compat.brick_block_ingredient, 'technic:machine_casing', technic.compat.brick_block_ingredient},
		{technic.compat.brick_block_ingredient, 'technic:lv_cable',       technic.compat.brick_block_ingredient},
	}
})

technic.register_alloy_furnace({tier = "LV", speed = 1, demand = {300}})

