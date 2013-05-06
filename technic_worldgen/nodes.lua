minetest.register_node( ":technic:mineral_uranium", {
	description = "Uranium Ore",
	tiles = { "default_stone.png^technic_mineral_uranium.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:uranium" 1',
}) 

minetest.register_node( ":technic:mineral_chromium", {
	description = "Chromium Ore",
	tiles = { "default_stone.png^technic_mineral_chromium.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:chromium_lump" 1',
}) 

minetest.register_node( ":technic:mineral_zinc", {
	description = "Zinc Ore",
	tile_images = { "default_stone.png^technic_mineral_zinc.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:zinc_lump" 1',
})

minetest.register_node( ":technic:granite", {
	description = "Granite",
	tiles = { "technic_granite.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
}) 

minetest.register_node( ":technic:marble", {
	description = "Marble",
	tiles = { "technic_marble.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
}) 

minetest.register_node( ":technic:marble_bricks", {
	description = "Marble Bricks",
	tiles = { "technic_marble_bricks.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
}) 

minetest.register_craft({
	output = 'technic:marble_bricks 4',
	recipe = {
		{'technic:marble','technic:marble'},
		{'technic:marble','technic:marble'}
	}
})

minetest.register_alias("technic:diamond_block", "default:diamondblock")
