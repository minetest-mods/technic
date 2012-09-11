minetest.register_craftitem( "technic:silicon_wafer", {
	description = "Silicon Wafer",
	inventory_image = "technic_silicon_wafer.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craftitem( "technic:doped_silicon_wafer", {
	description = "Doped Silicon Wafer",
	inventory_image = "technic_doped_silicon_wafer.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craft({
	output = 'pipeworks:tube_000000 8',
	recipe = {
		{'technic:stainless_steel_ingot', 'default:glass', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'default:glass', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'default:glass', 'technic:stainless_steel_ingot'},
	}
})

minetest.register_craftitem( "technic:diamond_drill_head", {
	description = "Diamond Drill Head",
	inventory_image = "technic_diamond_drill_head.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craft({
	output = 'technic:diamond_drill_head',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:diamond', 'technic:stainless_steel_ingot'},
		{'technic:diamond', '', 'technic:diamond'},
		{'technic:stainless_steel_ingot', 'technic:diamond', 'technic:stainless_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:diamond_block',
	recipe = {
		{'technic:diamond', 'technic:diamond', 'technic:diamond'},
		{'technic:diamond', 'technic:diamond', 'technic:diamond'},
		{'technic:diamond', 'technic:diamond', 'technic:diamond'},
	}
})

minetest.register_node( "technic:diamond_block", {
	description = "Diamond Block",
	tiles = { "technic_diamond_block.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = 'craft "technic:diamond_block" 1',
}) 

minetest.register_craft({
	output = 'technic:red_energy_crystal',
	recipe = {
		{'moreores:gold_ingot', 'technic:battery', 'dye:red'},
		{'technic:battery', 'technic:diamond_block', 'technic:battery'},
		{'dye:red', 'technic:battery', 'moreores:gold_ingot'},
	}
})

minetest.register_craftitem( "technic:red_energy_crystal", {
	description = "Red Energy Crystal",
	inventory_image = minetest.inventorycube("technic_diamond_block_red.png", "technic_diamond_block_red.png", "technic_diamond_block_red.png"),
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craft({
	output = 'technic:green_energy_crystal',
	recipe = {
		{'moreores:gold_ingot', 'technic:battery', 'dye:green'},
		{'technic:battery', 'technic:red_energy_crystal', 'technic:battery'},
		{'dye:green', 'technic:battery', 'moreores:gold_ingot'},
	}
})

minetest.register_craftitem( "technic:green_energy_crystal", {
	description = "Green Energy Crystal",
	inventory_image = minetest.inventorycube("technic_diamond_block_green.png", "technic_diamond_block_green.png", "technic_diamond_block_green.png"),
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craft({
	output = 'technic:blue_energy_crystal',
	recipe = {
		{'moreores:gold_ingot', 'technic:battery', 'dye:blue'},
		{'technic:battery', 'technic:green_energy_crystal', 'technic:battery'},
		{'dye:blue', 'technic:battery', 'moreores:gold_ingot'},
	}
})

minetest.register_craftitem( "technic:blue_energy_crystal", {
	description = "Blue Energy Crystal",
	inventory_image = minetest.inventorycube("technic_diamond_block_blue.png", "technic_diamond_block_blue.png", "technic_diamond_block_blue.png"),
	on_place_on_ground = minetest.craftitem_place_item,
})



