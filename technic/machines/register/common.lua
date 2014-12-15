
local S = technic.getter

function technic.handle_machine_upgrades(meta)
	-- Get the names of the upgrades
	local inv = meta:get_inventory()
	local upg_item1
	local upg_item2
	local srcstack = inv:get_stack("upgrade1", 1)
	if srcstack then
		upg_item1 = srcstack:to_table()
	end
	srcstack = inv:get_stack("upgrade2", 1)
	if srcstack then
		upg_item2 = srcstack:to_table()
	end

	-- Save some power by installing battery upgrades.
	-- Tube loading speed can be upgraded using control logic units.
	local EU_upgrade = 0
	local tube_upgrade = 0
	if upg_item1 then
		if     upg_item1.name == "technic:battery" then
			EU_upgrade = EU_upgrade + 1
		elseif upg_item1.name == "technic:control_logic_unit" then
			tube_upgrade = tube_upgrade + 1
		end
	end
	if upg_item2 then
		if     upg_item2.name == "technic:battery" then
			EU_upgrade = EU_upgrade + 1
		elseif upg_item2.name == "technic:control_logic_unit" then
			tube_upgrade = tube_upgrade + 1
		end
	end
	return EU_upgrade, tube_upgrade
end


function technic.send_items(pos, x_velocity, z_velocity, output_name)
	-- Send items on their way in the pipe system.
	if output_name == nil then
		output_name = "dst"
	end
	
	local meta = minetest.get_meta(pos) 
	local inv = meta:get_inventory()
	local i = 0
	for _, stack in ipairs(inv:get_list(output_name)) do
		i = i + 1
		if stack then
			local item0 = stack:to_table()
			if item0 then 
				item0["count"] = "1"
				technic.tube_inject_item(pos, pos, vector.new(x_velocity, 0, z_velocity), item0)
				stack:take_item(1)
				inv:set_stack(output_name, i, stack)
				return
			end
		end
	end
end


function technic.smelt_item(meta, result, speed)
	local inv = meta:get_inventory()
	meta:set_int("cook_time", meta:get_int("cook_time") + 1)
	if meta:get_int("cook_time") < result.time / speed then
		return
	end
	local result
	local afterfuel
	result, afterfuel = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})

	if result and result.item then
		meta:set_int("cook_time", 0)
		-- check if there's room for output in "dst" list
		if inv:room_for_item("dst", result.item) then
			inv:set_stack("src", 1, afterfuel.items[1])
			inv:add_item("dst", result.item)
		end
	end
end

function technic.handle_machine_pipeworks(pos, tube_upgrade, send_function)
	if send_function == nil then
		send_function = technic.send_items
	end
	
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local pos1 = vector.new(pos)
	local x_velocity = 0
	local z_velocity = 0

	-- Output is on the left side of the furnace
	if node.param2 == 3 then pos1.z = pos1.z - 1  z_velocity = -1 end
	if node.param2 == 2 then pos1.x = pos1.x - 1  x_velocity = -1 end
	if node.param2 == 1 then pos1.z = pos1.z + 1  z_velocity =  1 end
	if node.param2 == 0 then pos1.x = pos1.x + 1  x_velocity =  1 end

	local output_tube_connected = false
	local node1 = minetest.get_node(pos1) 
	if minetest.get_item_group(node1.name, "tubedevice") > 0 then
		output_tube_connected = true
	end
	local tube_time = meta:get_int("tube_time") + tube_upgrade
	if tube_time >= 2 then
		tube_time = 0
		if output_tube_connected then
			send_function(pos, x_velocity, z_velocity)
		end
	end
	meta:set_int("tube_time", tube_time)
end


function technic.machine_can_dig(pos, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if not inv:is_empty("src") or not inv:is_empty("dst") or
	   not inv:is_empty("upgrade1") or not inv:is_empty("upgrade2") then
		if player then
			minetest.chat_send_player(player:get_player_name(),
				S("Machine cannot be removed because it is not empty"))
		end
		return false
	else
		return true
	end
end

local function inv_change(pos, player, count)
	if minetest.is_protected(pos, player:get_player_name()) then
		minetest.chat_send_player(player:get_player_name(),
			S("Inventory move disallowed due to protection"))
		return 0
	end
	return count
end

function technic.machine_inventory_put(pos, listname, index, stack, player)
	return inv_change(pos, player, stack:get_count())
end

function technic.machine_inventory_take(pos, listname, index, stack, player)
	return inv_change(pos, player, stack:get_count())
end

function technic.machine_inventory_move(pos, from_list, from_index,
		to_list, to_index, count, player)
	return inv_change(pos, player, count)
end

