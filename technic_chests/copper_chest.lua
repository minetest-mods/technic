minetest.register_craft({
	output = 'technic:copper_chest 1',
	recipe = {
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
		{'default:copper_ingot','technic:iron_chest','default:copper_ingot'},
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:copper_locked_chest 1',
	recipe = {
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
		{'default:copper_ingot','technic:iron_locked_chest','default:copper_ingot'},
		{'default:copper_ingot','default:copper_ingot','default:copper_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:copper_locked_chest 1',
	recipe = {
		{'default:steel_ingot'},
		{'technic:copper_chest'},
	}
})

minetest.register_craftitem(":technic:copper_chest", {
	description = "Copper Chest",
	stack_max = 99,
})
minetest.register_craftitem(":technic:copper_locked_chest", {
	description = "Copper Locked Chest",
	stack_max = 99,
})

minetest.register_node(":technic:copper_chest", {
	description = "Copper Chest",
	tiles = {"technic_copper_chest_top.png", "technic_copper_chest_top.png", "technic_copper_chest_side.png",
		"technic_copper_chest_side.png", "technic_copper_chest_side.png", "technic_copper_chest_front.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[10,10;]"..
				"label[0,0;Copper Chest]"..
				"list[current_name;main;0,1;10,4;]"..
				"list[current_player;main;0,6;8,4;]"..
				"background[-0.19,-0.25;10.4,10.75;ui_form_bg.png]"..
				"background[0,1;10,4;ui_copper_chest_inventory.png]"..
				"background[0,6;8,4;ui_main_inventory.png]")
		meta:set_string("infotext", "Copper Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,

	can_dig = chest_can_dig,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
  
minetest.register_node(":technic:copper_locked_chest", {
	description = "Copper Locked Chest",
	tiles = {"technic_copper_chest_top.png", "technic_copper_chest_top.png", "technic_copper_chest_side.png",
		"technic_copper_chest_side.png", "technic_copper_chest_side.png", "technic_copper_chest_locked.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,legacy_facedir_simple = true,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Copper Locked Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[10,10;]"..
				"label[0,0;Copper Locked Chest]"..
				"list[current_name;main;0,1;10,4;]"..
				"list[current_player;main;0,6;8,4;]"..
				"background[-0.19,-0.25;10.4,10.75;ui_form_bg.png]"..
				"background[0,1;10,4;ui_copper_chest_inventory.png]"..
				"background[0,6;8,4;ui_main_inventory.png]")
		meta:set_string("infotext", "Copper Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,

	can_dig = chest_can_dig,
	allow_metadata_inventory_move = def_allow_metadata_inventory_move,
	allow_metadata_inventory_put = def_allow_metadata_inventory_put,
	allow_metadata_inventory_take = def_allow_metadata_inventory_take,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
