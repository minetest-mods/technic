technic.chests.groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		tubedevice=1, tubedevice_receiver=1}
technic.chests.groups_noinv = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		tubedevice=1, tubedevice_receiver=1, not_in_creative_inventory=1}

technic.chests.tube = {
	insert_object = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:add_item("main",stack)
	end,
	can_insert = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if meta:get_int("splitstacks") == 1 then
			stack = stack:peek_item(1)
		end
		return inv:room_for_item("main",stack)
	end,
	input_inventory = "main",
	connect_sides = {left=1, right=1, front=1, back=1, top=1, bottom=1},
}

technic.chests.can_dig = function(pos, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

local function inv_change(pos, count, player)
	-- Skip check for pipeworks (fake player)
	if minetest.is_player(player) and
			not default.can_interact_with_node(player, pos) then
		return 0
	end
	return count
end

function technic.chests.inv_move(pos, from_list, from_index, to_list, to_index, count, player)
	return inv_change(pos, count, player)
end
function technic.chests.inv_put(pos, listname, index, stack, player)
	return inv_change(pos, stack:get_count(), player)
end
function technic.chests.inv_take(pos, listname, index, stack, player)
	return inv_change(pos, stack:get_count(), player)
end

function technic.chests.on_inv_move(pos, from_list, from_index, to_list, to_index, count, player)
	minetest.log("action", player:get_player_name()..
		" moves stuff in chest at "
		..minetest.pos_to_string(pos))
end

function technic.chests.on_inv_put(pos, listname, index, stack, player)
	minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to chest at " .. minetest.pos_to_string(pos))
end

function technic.chests.on_inv_take(pos, listname, index, stack, player)
	minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name()  ..
			" from chest at " .. minetest.pos_to_string(pos))
end

