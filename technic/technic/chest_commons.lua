chest_groups1 = {snappy=2,choppy=2,oddly_breakable_by_hand=2,tubedevice=1,tubedevice_receiver=1}
chest_groups2 = {snappy=2,choppy=2,oddly_breakable_by_hand=2,tubedevice=1,tubedevice_receiver=1,not_in_creative_inventory=1}

tubes_properties = {insert_object=function(pos,node,stack,direction)
					local meta=minetest.env:get_meta(pos)
					local inv=meta:get_inventory()
					return inv:add_item("main",stack)
				end,
				can_insert=function(pos,node,stack,direction)
					local meta=minetest.env:get_meta(pos)
					local inv=meta:get_inventory()
					return inv:room_for_item("main",stack)
				end,
				input_inventory="main"}
				
chest_can_dig = function(pos,player)
local meta = minetest.env:get_meta(pos);
local inv = meta:get_inventory()
return inv:is_empty("main")
end

def_allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
local meta = minetest.env:get_meta(pos)
if not has_locked_chest_privilege(meta, player) then
	minetest.log("action", player:get_player_name()..
	" tried to access a locked chest belonging to "..
	meta:get_string("owner").." at "..
	minetest.pos_to_string(pos))
	return 0
	end
	return count
end

def_allow_metadata_inventory_put = function(pos, listname, index, stack, player)
local meta = minetest.env:get_meta(pos)
if not has_locked_chest_privilege(meta, player) then
	minetest.log("action", player:get_player_name()..
	" tried to access a locked chest belonging to "..
	meta:get_string("owner").." at "..
	minetest.pos_to_string(pos))
	return 0
end
return stack:get_count()
end

def_allow_metadata_inventory_take = function(pos, listname, index, stack, player)
local meta = minetest.env:get_meta(pos)
if not has_locked_chest_privilege(meta, player) then
	minetest.log("action", player:get_player_name()..
	" tried to access a locked chest belonging to "..
	meta:get_string("owner").." at "..
	minetest.pos_to_string(pos))
	return 0
	end
return stack:get_count()
end

def_on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	minetest.log("action", player:get_player_name()..
	" moves stuff in locked chest at "..minetest.pos_to_string(pos))
end

def_on_metadata_inventory_put = function(pos, listname, index, stack, player)
	minetest.log("action", player:get_player_name()..
	" moves stuff to locked chest at "..minetest.pos_to_string(pos))
end

def_on_metadata_inventory_take = function(pos, listname, index, stack, player)
	minetest.log("action", player:get_player_name()..
	" takes stuff from locked chest at "..minetest.pos_to_string(pos))
end

function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end
