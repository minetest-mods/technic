minetest.register_craft({
	output = 'technic:silver_chest 1',
	recipe = {
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		{'moreores:silver_ingot','technic:copper_chest','moreores:silver_ingot'},
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:silver_locked_chest 1',
	recipe = {
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		{'moreores:silver_ingot','technic:copper_locked_chest','moreores:silver_ingot'},
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:silver_locked_chest 1',
	recipe = {
		{'default:steel_ingot'},
		{'technic:silver_chest'},
	}
})

minetest.register_craftitem(":technic:silver_chest", {
	description = "Silver Chest",
	stack_max = 99,
})
minetest.register_craftitem(":technic:silver_locked_chest", {
	description = "Silver Locked Chest",
	stack_max = 99,
})

minetest.register_node(":technic:silver_chest", {
	description = "Silver Chest",
	tiles = {"technic_silver_chest_top.png", "technic_silver_chest_top.png", "technic_silver_chest_side.png",
		"technic_silver_chest_side.png", "technic_silver_chest_side.png", "technic_silver_chest_front.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[11,9;]"..
				"list[current_name;main;0,0;11,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Silver Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 11*4)
	end,
	can_dig = chest_can_dig,

	on_punch = function (pos, node, puncher)
	        local meta = minetest.env:get_meta(pos);
                meta:set_string("formspec", "hack:sign_text_input")
	end,
	
	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos);
      		fields.text = fields.text or ""
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')

		meta:set_string("formspec",
				"invsize[11,9;]"..
				"list[current_name;main;0,0;11,4;]"..
				"list[current_player;main;0,5;8,4;]")
	end,

	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})

minetest.register_node(":technic:silver_locked_chest", {
	description = "Silver Locked Chest",
	tiles = {"technic_silver_chest_top.png", "technic_silver_chest_top.png", "technic_silver_chest_side.png",
		"technic_silver_chest_side.png", "technic_silver_chest_side.png", "technic_silver_chest_locked.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Silver Locked Chest (owned by "..
			meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[11,9;]"..
				"list[current_name;main;0,0;11,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Silver Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 11*4)
	end,
	can_dig = chest_can_dig,

	on_punch = function (pos, node, puncher)
	        local meta = minetest.env:get_meta(pos);
                meta:set_string("formspec", "hack:sign_text_input")
	end,
	
	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos);
      		fields.text = fields.text or ""
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')

		meta:set_string("formspec",
				"invsize[11,9;]"..
				"list[current_name;main;0,0;11,4;]"..
				"list[current_player;main;0,5;8,4;]")
	end,


	allow_metadata_inventory_move = def_allow_metadata_inventory_move,
	allow_metadata_inventory_put = def_allow_metadata_inventory_put,
	allow_metadata_inventory_take = def_allow_metadata_inventory_take,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
