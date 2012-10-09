local chest_mark_colors = {
    '_black',
    '_blue', 
    '_brown',
    '_cyan',
    '_dark_green',
    '_dark_grey',
    '_green',
    '_grey',
    '_magenta',
    '_orange',
    '_pink',
    '_red',
    '_violet',
    '_white',
    '_yellow',
}

minetest.register_craft({
	output = 'technic:gold_chest 1',
	recipe = {
		{'moreores:gold_ingot','moreores:gold_ingot','moreores:gold_ingot'},
		{'moreores:gold_ingot','technic:silver_chest','moreores:gold_ingot'},
		{'moreores:gold_ingot','moreores:gold_ingot','moreores:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:gold_locked_chest 1',
	recipe = {
		{'moreores:gold_ingot','moreores:gold_ingot','moreores:gold_ingot'},
		{'moreores:gold_ingot','technic:silver_locked_chest','moreores:gold_ingot'},
		{'moreores:gold_ingot','moreores:gold_ingot','moreores:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:gold_locked_chest 1',
	recipe = {
		{'default:steel_ingot'},
		{'technic:gold_chest'},
	}
})

minetest.register_craftitem("technic:gold_chest", {
	description = "Gold Chest",
	stack_max = 99,
})
minetest.register_craftitem("technic:gold_locked_chest", {
	description = "Gold Locked Chest",
	stack_max = 99,
})

minetest.register_node("technic:gold_chest", {
	description = "Gold Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Gold Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 12*4)
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	
	on_punch = function (pos, node, puncher)
	chest_punched (pos,node,puncher);
	end,
	
	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos);
      		fields.text = fields.text or ""
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')

		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
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

for i, state in ipairs(chest_mark_colors) do
minetest.register_node("technic:gold_chest".. state, {
	description = "Gold Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_front"..state..".png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, not_in_creative_inventory=1,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:gold_chest",
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Gold Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 12*4)
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	
	on_punch = function (pos, node, puncher)
	chest_punched (pos,node,puncher);
	end,
	
	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos);
      		fields.text = fields.text or ""
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')

		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
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
end


local function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end

minetest.register_node("technic:gold_locked_chest", {
	description = "Gold Locked Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_locked.png"},
	paramtype2 = "facedir",
	drop = "technic:gold_locked_chest",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Gold Locked Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Gold Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 12*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	on_punch = function (pos, node, puncher)
	        local meta = minetest.env:get_meta(pos);
		if (has_locked_chest_privilege(meta, puncher)) then
		locked_chest_punched (pos,node,puncher);
		end
       end,
	
	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos);
      		fields.text = fields.text or ""
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')

		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
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

for i, state in ipairs(chest_mark_colors) do
minetest.register_node("technic:gold_locked_chest".. state, {
	description = "Gold Locked Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_locked"..state..".png"},
	paramtype2 = "facedir",
	drop = "technic:gold_locked_chest",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, not_in_creative_inventory=1,tubedevice=1,tubedevice_receiver=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Gold Locked Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Gold Locked Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 12*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	on_punch = function (pos, node, puncher)
	        local meta = minetest.env:get_meta(pos);
		if (has_locked_chest_privilege(meta, puncher)) then
		locked_chest_punched (pos,node,puncher);
		end
       end,
	
	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos);
      		fields.text = fields.text or ""
		meta:set_string("text", fields.text)
		meta:set_string("infotext", '"'..fields.text..'"')

		meta:set_string("formspec",
				"invsize[12,9;]"..
				"list[current_name;main;0,0;12,4;]"..
				"list[current_player;main;0,5;8,4;]")
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
end

function chest_punched (pos,node,puncher)
	
	local player_tool = puncher:get_wielded_item();
	local item=player_tool:get_name();
	if item == "dye:black" then
		if (hacky_swap_node(pos,"technic:gold_chest_black")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:blue" then
		if (hacky_swap_node(pos,"technic:gold_chest_blue")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:brown" then
		if (hacky_swap_node(pos,"technic:gold_chest_brown")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:cyan" then
		if (hacky_swap_node(pos,"technic:gold_chest_cyan")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:dark_green" then
		if (hacky_swap_node(pos,"technic:gold_chest_dark_green")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:dark_grey" then
		if (hacky_swap_node(pos,"technic:gold_chest_dark_grey")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:green" then
		if (hacky_swap_node(pos,"technic:gold_chest_green")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:grey" then
		if (hacky_swap_node(pos,"technic:gold_chest_grey")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:magenta" then
		if (hacky_swap_node(pos,"technic:gold_chest_magenta")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:orange" then
		if (hacky_swap_node(pos,"technic:gold_chest_orange")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:pink" then
		if (hacky_swap_node(pos,"technic:gold_chest_pink")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:red" then
		if (hacky_swap_node(pos,"technic:gold_chest_red")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:violet" then
		if (hacky_swap_node(pos,"technic:gold_chest_violet")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:white" then
		if (hacky_swap_node(pos,"technic:gold_chest_white")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:yellow" then
		if (hacky_swap_node(pos,"technic:gold_chest_yellow")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end

		local meta = minetest.env:get_meta(pos);
                meta:set_string("formspec", "hack:sign_text_input")
	end


function locked_chest_punched (pos,node,puncher)
	
	local player_tool = puncher:get_wielded_item();
	local item=player_tool:get_name();
	if item == "dye:black" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_black")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:blue" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_blue")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:brown" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_brown")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:cyan" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_cyan")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:dark_green" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_dark_green")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:dark_grey" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_dark_grey")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:green" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_green")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:grey" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_grey")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:magenta" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_magenta")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:orange" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_orange")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:pink" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_pink")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:red" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_red")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:violet" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_violet")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:white" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_white")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end
	if item == "dye:yellow" then
		if (hacky_swap_node(pos,"technic:gold_locked_chest_yellow")) then
			player_tool:take_item(1);
			puncher:set_wielded_item(player_tool);
			return
		   end
		end

		local meta = minetest.env:get_meta(pos);
                meta:set_string("formspec", "hack:sign_text_input")
	end
	