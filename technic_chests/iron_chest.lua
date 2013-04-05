minetest.register_craft({
	output = 'technic:iron_chest 1',
	recipe = {
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
		{'default:steel_ingot','default:chest','default:steel_ingot'},
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
		{'default:steel_ingot','default:chest_locked','default:steel_ingot'},
		{'default:steel_ingot','default:steel_ingot','default:steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:iron_locked_chest 1',
	recipe = {
		{'default:steel_ingot'},
		{'technic:iron_chest'},
	}
})


minetest.register_craftitem(":technic:iron_chest", {
	description = "Iron Chest",
	stack_max = 99,
})
minetest.register_craftitem(":technic:iron_locked_chest", {
	description = "Iron Locked Chest",
	stack_max = 99,
})

minetest.register_node(":technic:iron_chest", {
	description = "Iron Chest",
	tiles = {"technic_iron_chest_top.png", "technic_iron_chest_top.png", "technic_iron_chest_side.png",
		"technic_iron_chest_side.png", "technic_iron_chest_side.png", "technic_iron_chest_front.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[9,9;]"..
				"list[current_name;main;0,0;9,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Iron Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 9*4)
	end,
	can_dig = chest_can_dig,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})

minetest.register_node(":technic:iron_locked_chest", {
	description = "Iron Locked Chest",
	tiles = {"technic_iron_chest_top.png", "technic_iron_chest_top.png", "technic_iron_chest_side.png",
		"technic_iron_chest_side.png", "technic_iron_chest_side.png", "technic_iron_chest_locked.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Locked Iron Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[9,9;]"..
				"list[current_name;main;0,0;9,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Iron Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 9*4)
	end,
	can_dig = chest_can_dig,
	allow_metadata_inventory_move = def_allow_metadata_inventory_move,
	allow_metadata_inventory_put = def_allow_metadata_inventory_put,
	allow_metadata_inventory_take = def_allow_metadata_inventory_take,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
