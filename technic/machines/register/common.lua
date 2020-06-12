
local S = technic.getter

-- handles the machine upgrades every tick
function technic.handle_machine_upgrades(meta)
	-- Get the names of the upgrades
	local inv = meta:get_inventory()

	local srcstack = inv:get_stack("upgrade1", 1)
	local upg_item1 = srcstack and srcstack:get_name()

	srcstack = inv:get_stack("upgrade2", 1)
	local upg_item2 = srcstack and srcstack:get_name()

	-- Save some power by installing battery upgrades.
	-- Tube loading speed can be upgraded using control logic units.
	local EU_upgrade = 0
	local tube_upgrade = 0

	if upg_item1 == "technic:control_logic_unit" then
		tube_upgrade = tube_upgrade + 1
	elseif upg_item1 == "technic:battery" then
		EU_upgrade = EU_upgrade + 1
	end

	if upg_item2 == "technic:control_logic_unit" then
		tube_upgrade = tube_upgrade + 1
	elseif  upg_item2 == "technic:battery" then
		EU_upgrade = EU_upgrade + 1
	end

	return EU_upgrade, tube_upgrade
end

-- handles the machine upgrades when set or removed
local function on_machine_upgrade(meta, stack)
	local stack_name = stack:get_name()
	if stack_name == "default:chest" then
		meta:set_int("public", 1)
		return 1
	elseif stack_name ~= "technic:control_logic_unit"
	   and stack_name ~= "technic:battery" then
		return 0
	end
	return 1
end

-- something is about to be removed
local function on_machine_downgrade(meta, stack, list)
	if stack:get_name() == "default:chest" then
		local inv = meta:get_inventory()
		local upg1, upg2 = inv:get_stack("upgrade1", 1), inv:get_stack("upgrade2", 1)

		-- only set 0 if theres not a nother chest in the other list too
		if (not upg1 or not upg2 or upg1:get_name() ~= upg2:get_name()) then
			meta:set_int("public", 0)
		end
	end
	return 1
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
				item0["count"] = 1
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
	if not inv:is_empty("src") or not inv:is_empty("dst") then
		if player then
			minetest.chat_send_player(player:get_player_name(),
				S("Machine cannot be removed because it is not empty"))
		end
		return false
	end

	return true
end

function technic.machine_after_dig_node(pos, oldnode, oldmetadata, player)
	if oldmetadata.inventory then
		if oldmetadata.inventory.upgrade1 and oldmetadata.inventory.upgrade1[1] then
			local stack = ItemStack(oldmetadata.inventory.upgrade1[1])
			if not stack:is_empty() then
				minetest.add_item(pos, stack)
			end
		end
		if oldmetadata.inventory.upgrade2 and oldmetadata.inventory.upgrade2[1] then
			local stack = ItemStack(oldmetadata.inventory.upgrade2[1])
			if not stack:is_empty() then
				minetest.add_item(pos, stack)
			end
		end
	end

	if minetest.registered_nodes[oldnode.name].tube then
		pipeworks.after_dig(pos, oldnode, oldmetadata, player)
	end
end

local function inv_change(pos, player, count, from_list, to_list, stack)
	local playername = player:get_player_name()
	local meta = minetest.get_meta(pos);
	local public = (meta:get_int("public") == 1)
	local to_upgrade = to_list == "upgrade1" or to_list == "upgrade2"
	local from_upgrade = from_list == "upgrade1" or from_list == "upgrade2"

	if (not public or to_upgrade or from_upgrade) and minetest.is_protected(pos, playername) then
		minetest.chat_send_player(playername, S("Inventory move disallowed due to protection"))
		return 0
	end
	if to_upgrade then
		-- only place a single item into it, if it's empty
		local empty = meta:get_inventory():is_empty(to_list)
		if empty then
			return on_machine_upgrade(meta, stack)
		end
		return 0
	elseif from_upgrade then
		-- only called on take (not move)
		on_machine_downgrade(meta, stack, from_list)
	end
	return count
end

function technic.machine_inventory_put(pos, listname, index, stack, player)
	return inv_change(pos, player, stack:get_count(), nil, listname, stack)
end

function technic.machine_inventory_take(pos, listname, index, stack, player)
	return inv_change(pos, player, stack:get_count(), listname, nil, stack)
end

function technic.machine_inventory_move(pos, from_list, from_index,
		to_list, to_index, count, player)
	local stack = minetest.get_meta(pos):get_inventory():get_stack(from_list, from_index)
	return inv_change(pos, player, count, from_list, to_list, stack)
end

