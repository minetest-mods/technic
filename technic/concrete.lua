
minetest.register_craft({
	output = 'technic:rebar 6',
	recipe = {
		{'','', 'default:steel_ingot'},
		{'','default:steel_ingot',''},
		{'default:steel_ingot', '', ''},
	}
})

minetest.register_craft({
	output = 'technic:concrete 5',
	recipe = {
		{'default:stone','technic:rebar','default:stone'},
		{'technic:rebar','default:stone','technic:rebar'},
		{'default:stone','technic:rebar','default:stone'},
	}
})

minetest.register_craft({
	output = 'technic:concrete_post 4',
	recipe = {
		{'default:stone','technic:rebar','default:stone'},
		{'default:stone','technic:rebar','default:stone'},
		{'default:stone','technic:rebar','default:stone'},
}
})

minetest.register_craftitem("technic:rebar", {
	description = "Rebar",
	inventory_image = "technic_rebar.png",
	stack_max = 99,
})

minetest.register_craftitem("technic:concrete", {
	description = "Concrete Block",
	inventory_image = "technic_concrete_block.png",
	stack_max = 99,
})

minetest.register_craftitem("technic:concrete_post", {
	description = "Concrete Post",
	inventory_image = "technic_concrete_post.png",
	stack_max = 99,
})



-- NODES:

minetest.register_node("technic:concrete", {
	description = "Concrete Block",
	tile_images = {"technic_concrete_block.png",},
	is_ground_content = true,
	groups = {cracky=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("technic:concrete_post", {
	description = "Concrete Post",
	drawtype = "fencelike",
	tiles = {"technic_concrete_block.png"},
	inventory_image = "default_fence.png",
	wield_image = "default_fence.png",
	paramtype = "light",
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},

	groups = {cracky=1},
	sounds = default.node_sound_stone_defaults(),
})
if type(register_stair_and_slab_and_panel_and_micro) == "function" then
register_stair_and_slab_and_panel_and_micro(":stairsplus", "concrete", "technic:concrete",
		{cracky=3},
		{"technic_concrete_block.png"},
		"Concrete Stairs",
		"Concrete Slab",
		"Concrete Panel",
		"Concrete Microblock",
		"concrete")
end
if type(register_stair_slab_panel_micro) == "function" then
register_stair_slab_panel_micro(":stairsplus", "concrete", "technic:concrete",
		{cracky=3},
		{"technic_concrete_block.png"},
		"Concrete Stairs",
		"Concrete Slab",
		"Concrete Panel",
		"Concrete Microblock",
		"concrete")
end
