
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	unified_inventory.players[player_name] = {}
	unified_inventory.current_index[player_name] = 1
	unified_inventory.filtered_items_list[player_name] = unified_inventory.items_list
	unified_inventory.activefilter[player_name] = ""
	unified_inventory.apply_filter(player, "")
	unified_inventory.alternate[player_name] = 1
	unified_inventory.current_item[player_name] = nil
	unified_inventory.set_inventory_formspec(player, unified_inventory.default)
	
	-- Crafting guide inventories
	local inv = minetest.create_detached_inventory(player:get_player_name().."craftrecipe", {
		allow_put = function(inv, listname, index, stack, player)
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			if unified_inventory.is_creative(player:get_player_name()) then
				return stack:get_count()
			else
				return 0
			end
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
	})
	inv:set_size("output", 1)
	inv:set_size("build", 3 * 3)

	-- Refill slot
	local refill = minetest.create_detached_inventory(player_name.."refill", {
		allow_put = function(inv, listname, index, stack, player)
			if unified_inventory.is_creative(player:get_player_name()) then
				return stack:get_count()
			else
				return 0
			end
		end,
		on_put = function(inv, listname, index, stack, player)
			local stacktable = stack:to_table()
			stacktable.count = stack:get_stack_max()
			inv:set_stack(listname, index, ItemStack(stacktable))
			minetest.sound_play("electricity", {to_player=player_name, gain = 1.0})
		end,
	})
	refill:set_size("main", 1)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local player_name = player:get_player_name()

	for i, def in pairs(unified_inventory.buttons) do
		if fields[def.name] then
			def.action(player)
			minetest.sound_play("click",
					{to_player=player_name, gain = 0.1})
			return
		end
	end
	
	-- Inventory page controls
	local start = math.floor(unified_inventory.current_index[player_name] / 80 + 1)
	local start_i = start
	local pagemax = math.floor((unified_inventory.filtered_items_list_size[player_name] - 1) / (80) + 1)
	
	if fields.start_list then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		start_i = 1
	end
	if fields.rewind1 then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		start_i = start_i - 1
	end
	if fields.forward1 then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		start_i = start_i + 1
	end
	if fields.rewind3 then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		start_i = start_i - 3
	end
	if fields.forward3 then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		start_i = start_i + 3
	end
	if fields.end_list then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		start_i = pagemax
	end
	if start_i < 1 then
		start_i = 1
	end
	if start_i > pagemax then
		start_i = pagemax
	end
	if not (start_i	== start) then
		unified_inventory.current_index[player_name] = (start_i - 1) * 80 + 1
		unified_inventory.set_inventory_formspec(player,
				unified_inventory.current_page[player_name])
	end

	-- Item list buttons
	local list_index = unified_inventory.current_index[player_name]
	local page = unified_inventory.current_page[player_name]
	for i = 0, 80 do
		local button = "item_button"..list_index
		if fields[button] then 
			minetest.sound_play("click",
					{to_player=player_name, gain = 0.1})
			if not unified_inventory.is_creative(player_name) then
				unified_inventory.set_inventory_formspec(player, "craftguide")
				page = "craftguide"
			end
			if page == "craftguide" then 
				unified_inventory.current_item[player_name] =
						unified_inventory.filtered_items_list
							[player_name][list_index] 
				unified_inventory.alternate[player_name] = 1
				unified_inventory.update_recipe(player,
						unified_inventory.filtered_items_list
							[player_name][list_index], 1)
				unified_inventory.set_inventory_formspec(player,
						unified_inventory.current_page[player_name])
			else
				if unified_inventory.is_creative(player_name) then
					local inv = player:get_inventory()
					dst_stack = {}
					dst_stack.name = unified_inventory.filtered_items_list
							[player_name][list_index] 
					dst_stack.count = 99
					if inv:room_for_item("main", dst_stack) then
						inv:add_item("main", dst_stack)
					end
				end
			end
		end
		list_index = list_index + 1
	end
	
	if fields.searchbutton then
		unified_inventory.apply_filter(player, fields.searchbox)
		unified_inventory.set_inventory_formspec(player,
				unified_inventory.current_page[player_name])
		minetest.sound_play("paperflip2",
				{to_player=player_name, gain = 1.0})
	end	
	
	-- alternate button
	if fields.alternate then
		minetest.sound_play("click",
				{to_player=player_name, gain = 0.1})
		local item_name = unified_inventory.current_item[player_name]
		if item_name then
			local alternates = 0
			local alternate = unified_inventory.alternate[player_name]
			local crafts = unified_inventory.crafts_table[item_name]
			if crafts ~= nil then
				alternates = #crafts
			end
			if alternates > 1 then
				alternate = alternate + 1
				if alternate > alternates then
					alternate = 1
				end
				unified_inventory.alternate[player_name] = alternate		
				unified_inventory.update_recipe(player,
						unified_inventory.current_item[player_name], alternate)
				unified_inventory.set_inventory_formspec(player,
						unified_inventory.current_page[player_name])
			end
		end
	end
end)

