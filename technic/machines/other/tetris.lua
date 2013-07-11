minetest.register_node("technic:tetris_machine_node1", {
	tiles = {"tetris_machine_top.png", "technic_mv_battery_box_bottom.png", "tetris_machine_front1.png",
		"tetris_machine_side1B.png", "tetris_machine_side1P.png", "tetris_machine_side1L.png"},
	tile_images = {"technic_tetris_machine.png",},
	is_ground_content = true,
	groups = {cracky=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("technic:tetris_machine_node2", {
	tiles = {"tetris_machine_top.png", "technic_mv_battery_box_bottom.png", "tetris_machine_front2.png",
		"tetris_machine_side2B.png", "tetris_machine_side2P.png", "tetris_machine_side2L.png"},
	tile_images = {"technic_tetris_machine.png",},
	is_ground_content = true,
	groups = {cracky=1},
	sounds = default.node_sound_stone_defaults(),
})
