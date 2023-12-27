-- LV Alloy furnace

-- FIXME: kpoppel: I'd like to introduce an induction heating element here...
minetest.register_craft({
	output = 'technic:lv_alloy_furnace',
	recipe = {
		{brick_block_ingredient, brick_block_ingredient,          brick_block_ingredient},
		{brick_block_ingredient, 'technic:machine_casing', brick_block_ingredient},
		{brick_block_ingredient, 'technic:lv_cable',       brick_block_ingredient},
	}
})

technic.register_alloy_furnace({tier = "LV", speed = 1, demand = {300}})

