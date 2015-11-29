
local S = technic.getter



-- A function to normalize a value. The output floating-point value should
-- always be in the range [0, 1].
function technic.normalize_value(value, lower, upper)
	value = value - lower
	upper = upper - lower
	return value / upper
end



-- This function is defined because the same compatibility code needs to be run
-- in three different places. This function can be removed once we are
-- reasonably sure that everyone is updated.
function technic.transfer_upgrades_to_new_upgrade_inventory(meta, new_formspec, new_inv_size)
	local inv = meta:get_inventory()

	-- Compatibility code. Move upgrade items from the (now depreciated)
	-- upgrade inventory lists into the new unified upgrade list. This code
	-- assumes that the new upgrade inventory size is at least 2.
	if inv:get_size("upgrade1") > 0 then
		assert(new_inv_size >= 2)
		local upg1 = "upgrade1"
		local upg2 = "upgrade2"
		local new_list = "upgrades"
		inv:set_size(new_list, new_inv_size)
		local stack1 = inv:get_stack(upg1, 1)
		local stack2 = inv:get_stack(upg2, 1)
		if stack1 and stack1:get_count() > 0 then
			inv:set_stack(new_list, 1, stack1)
			inv:remove_item(upg1, stack1)
		end
		if stack2 and stack2:get_count() > 0 then
			inv:set_stack(new_list, 2, stack2)
			inv:remove_item(upg2, stack2)
		end
		-- Update the formspec.
		meta:set_string("formspec", new_formspec)
		inv:set_size(upg1, 0)
		inv:set_size(upg2, 0)
	end
end



-- Calculates the number & type of machine upgrades.
function technic.handle_machine_upgrades(meta)
	local inv = meta:get_inventory()
	local clu = "technic:control_logic_unit"
	local bat = "technic:battery"
	local bat_upgrades = 0
	local clu_upgrades = 0
	local upgrade_list = "upgrades"
	local num_upgrade_slots = inv:get_size(upgrade_list)

	for i = 1, num_upgrade_slots, 1 do
		local stack = inv:get_stack(upgrade_list, i)
		if stack then
			local item = stack:get_name()
			-- Assume that each inv slot cannot have more than 1 upgrade item.
			if item == bat then bat_upgrades = bat_upgrades + 1 end
			if item == clu then clu_upgrades = clu_upgrades + 1 end
		end
	end

	return bat_upgrades, clu_upgrades
end



-- Machine upgrade callback. Called when something is about to be added. Returns
-- 'true' if the upgrade can be added, 'false' if not.
local function on_machine_upgrade(player, meta, to_index, stack)
	local clu = "technic:control_logic_unit"
	local bat = "technic:battery"
	local chest = "default:chest"
	local player_name = player:get_player_name()
	local inv = meta:get_inventory()

	local item = stack:get_name()
	if item == chest then
		meta:set_int("public", 1)
		return true
	elseif item == clu then 
		return true
	elseif item == bat then 
		return true
	end

	minetest.chat_send_player(player_name, S("That is not a valid upgrade item!"))
	return false
end



-- Machine downgrade callback. Called just before something is removed.
local function on_machine_downgrade(player, meta, from_index, stack)
	local chest = "default:chest"
	if stack:get_name() == chest then
		local inv = meta:get_inventory()

		local upgrade_list = "upgrades"
		local num_upgrade_slots = inv:get_size(upgrade_list)

		-- Check if any of the upgrade slots contain a chest.
		local has_chest = false
		for i = 1, num_upgrade_slots, 1 do
			if i ~= from_index then -- Skip the chest that's about to be removed.
				local stack = inv:get_stack(upgrade_list, i)
				if stack then
					local item = stack:get_name()
					if item == chest then 
						has_chest = true
						break -- If one chest is found, we don't need to look for more.
					end
				end
			end
		end

		-- If none of the upgrade slots contains a chest, the machine is no longer
		-- publicly accessible.
		if has_chest == false then meta:set_int("public", 0) end
	end
end



function technic.send_items(pos, x_velocity, z_velocity, output_name, item_count)
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
				-- Calculate how many items to move. Don't move more items than exist.
				-- Basically, 'item_count' is the maximum number of items to move.
				local num_items = item_count or 1
				if stack:get_count() < num_items then num_items = stack:get_count() end

				item0["count"] = tostring(num_items)
				technic.tube_inject_item(pos, pos, vector.new(x_velocity, 0, z_velocity), item0)
				stack:take_item(num_items)
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

function technic.handle_machine_pipeworks(pos, tube_upgrade, send_function, items_processed_this_cycle)
	if send_function == nil then
		send_function = technic.send_items
	end

	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local pos1 = vector.new(pos)
	local x_velocity = 0
	local z_velocity = 0

	if node.param2 == 3 then pos1.z = pos1.z - 1  z_velocity = -1 end
	if node.param2 == 2 then pos1.x = pos1.x - 1  x_velocity = -1 end
	if node.param2 == 1 then pos1.z = pos1.z + 1  z_velocity =  1 end
	if node.param2 == 0 then pos1.x = pos1.x + 1  x_velocity =  1 end

	local output_tube_connected = false
	local node1 = minetest.get_node(pos1) 
	if minetest.get_item_group(node1.name, "tubedevice") > 0 then
		output_tube_connected = true
	end

	items_processed_this_cycle = items_processed_this_cycle or 1
	local eject_count = meta:get_int("eject_count") + items_processed_this_cycle
	meta:set_int("eject_count", eject_count)

	local num_upgrade_slots = inv:get_size("upgrades")
	local norm_tube_upgrade = technic.normalize_value(tube_upgrade, 0, num_upgrade_slots)
	local stack_size = 11
	local tube_time = meta:get_int("tube_time") + 1

	if tube_time >= 10 then
		tube_time = 0

		if output_tube_connected then
			-- Calculate how many items to eject during this run. Eject none if no
			-- tube upgrades exist, and eject as many as were produced if the max
			-- number of tube upgrades exist.
			-- Always try to eject at least 5 to 10 items per execution. This is the
			-- fallback behavior for when the machine isn't producing anything (and
			-- thus 'eject_count' is 0).
			if eject_count < 10 then eject_count = 10 end
			eject_count = eject_count * norm_tube_upgrade

			if eject_count > 0 then
				-- Eject items. Use multiple stacks if needed, to avoid ejecting a
				-- monolithic stack.
				while eject_count >= stack_size do
					send_function(pos, x_velocity, z_velocity, nil, stack_size)
					eject_count = eject_count - stack_size
				end
				send_function(pos, x_velocity, z_velocity, nil, eject_count)
			end
		end

		meta:set_int("eject_count", 0)
	end

	meta:set_int("tube_time", tube_time)
end

function technic.machine_can_dig(pos, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	if not inv:is_empty("src") or not inv:is_empty("dst") then
		if player then
			local name = player:get_player_name()
			minetest.chat_send_player(
				name, S("Machine cannot be removed because it is not empty"))
		end
		return false
	end

	return true
end

function technic.machine_after_dig_node(pos, oldnode, oldmetadata, player)
	if oldmetadata.inventory then
		if oldmetadata.inventory.upgrades then
			local num_upgrade_slots = #(oldmetadata.inventory.upgrades)
			for i = 1, num_upgrade_slots, 1 do
				if oldmetadata.inventory.upgrades[i] then
					local stack = ItemStack(oldmetadata.inventory.upgrades[i])
					if not stack:is_empty() then
						minetest.add_item(pos, stack)
					end
				end
			end
		end
	end

	if minetest.registered_nodes[oldnode.name].tube then
		pipeworks.after_dig(pos, oldnode, oldmetadata, player)
	end
end



local function inv_change(pos, player, count, from_list, from_index, to_list, to_index, stack)
	local player_name = player:get_player_name()
	local meta = minetest.get_meta(pos)
	local public = (meta:get_int("public") == 1)
	local is_upgrade = (to_list == "upgrades")
	local is_downgrade = (from_list == "upgrades")

	if (not public or is_upgrade or is_downgrade) and minetest.is_protected(pos, player_name) then
		minetest.chat_send_player(player_name, S("Inventory move disallowed due to protection"))
		return 0
	end

	if is_upgrade then
		local previous_stack = meta:get_inventory():get_stack("upgrades", to_index)
		-- Only place a single item into the upgrade slot, if it is empty.
		if previous_stack:get_count() == 0 then
			if on_machine_upgrade(player, meta, to_index, stack) then
				count = 1
			else
				count = 0
			end
		else
			count = 0
		end
	elseif is_downgrade then
		-- Only called on take (not move).
		on_machine_downgrade(player, meta, from_index, stack)
	end

	return count
end



function technic.machine_inventory_put(pos, to_list, to_index, stack, player)
	return inv_change(pos, player, stack:get_count(), nil, nil, to_list, to_index, stack)
end

function technic.machine_inventory_take(pos, from_list, from_index, stack, player)
	return inv_change(pos, player, stack:get_count(), from_list, from_index, nil, nil, stack)
end

function technic.machine_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local stack = minetest.get_meta(pos):get_inventory():get_stack(from_list, from_index)
	return inv_change(pos, player, count, from_list, from_index, to_list, to_index, stack)
end

