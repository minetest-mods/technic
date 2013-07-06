minetest.register_craft({
	output = 'technic:mithril_chest 1',
	recipe = {
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','technic:gold_chest','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:mithril_locked_chest 1',
	recipe = {
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','technic:gold_locked_chest','moreores:mithril_ingot'},
		{'moreores:mithril_ingot','moreores:mithril_ingot','moreores:mithril_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:mithril_locked_chest 1',
	recipe = {
		{'default:steel_ingot'},
		{'technic:mithril_chest'},
	}
})

minetest.register_node(":technic:mithril_chest", {
	description = "Mithril Chest",
	tiles = {"technic_mithril_chest_top.png", "technic_mithril_chest_top.png", "technic_mithril_chest_side.png",
		"technic_mithril_chest_side.png", "technic_mithril_chest_side.png", "technic_mithril_chest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[13,10;]"..
				"label[0,0;Mithril Chest]"..
				"list[current_name;main;0,1;13,4;]"..
				"list[current_player;main;0,6;8,4;]"..
				"background[-0.19,-0.25;13.4,10.75;ui_form_bg.png]"..
				"background[0,1;13,4;ui_mithril_chest_inventory.png]"..
				"background[0,6;8,4;ui_main_inventory.png]")
		meta:set_string("infotext", "Mithril Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 13*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

    on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in chest at "..minetest.pos_to_string(pos))
		return minetest.node_metadata_inventory_move_allow_all(
				pos, from_list, from_index, to_list, to_index, count, player)
	end,
    on_metadata_inventory_offer = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to chest at "..minetest.pos_to_string(pos))
		return minetest.node_metadata_inventory_offer_allow_all(
				pos, listname, index, stack, player)
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from chest at "..minetest.pos_to_string(pos))
	end,
})

minetest.register_node(":technic:mithril_locked_chest", {
	description = "Mithril Locked Chest",
	tiles = {"technic_mithril_chest_top.png", "technic_mithril_chest_top.png", "technic_mithril_chest_side.png",
		"technic_mithril_chest_side.png", "technic_mithril_chest_side.png", "technic_mithril_chest_locked.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Mithril Locked Chest (owned by "..
				meta:get_string("owner")..")")
	end,
on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[13,10;]"..
				"label[0,0;Mithril Locked Chest]"..
				"list[current_name;main;0,1;13,4;]"..
				"list[current_player;main;0,6;8,4;]"..
				"background[-0.19,-0.25;13.4,10.75;ui_form_bg.png]"..
				"background[0,1;13,4;ui_mithril_chest_inventory.png]"..
				"background[0,6;8,4;ui_main_inventory.png]")
		meta:set_string("infotext", "Mithril Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 13*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to locked chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from locked chest at "..minetest.pos_to_string(pos))
	end,
})
