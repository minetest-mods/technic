
local S = technic.getter

local tube = {
	insert_object = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:add_item("src",stack)
	end,
	can_insert = function(pos, node, stack, direction)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:room_for_item("src", stack)
	end,
	connect_sides = {left=1, right=1, back=1, top=1, bottom=1},
}

function technic.register_electric_furnace(data)
	local tier = data.tier
	local ltier = string.lower(tier)

	local tube_side_texture = data.tube and "technic_"..ltier.."_electric_furnace_side_tube.png"
			or "technic_"..ltier.."_electric_furnace_side.png"

	local groups = {cracky=2}
	local active_groups = {cracky=2, not_in_creative_inventory=1}
	if data.tube then
		groups.tubedevice = 1
		groups.tubedevice_receiver = 1
		active_groups.tubedevice = 1
		active_groups.tubedevice_receiver = 1
	end

	local formspec =
		"invsize[8,10;]"..
		"list[current_name;src;3,1;1,1;]"..
		"list[current_name;dst;5,1;2,2;]"..
		"list[current_player;main;0,6;8,4;]"..
		"label[0,0;"..S("%s Electric Furnace"):format(tier).."]"
	if data.upgrade then
		formspec = formspec..
			"list[current_name;upgrade1;1,4;1,1;]"..
			"list[current_name;upgrade2;2,4;1,1;]"..
			"label[1,5;Upgrade Slots]"
	end

	data.formspec = formspec

	minetest.register_node("technic:"..ltier.."_electric_furnace", {
		description = S("%s Electric furnace"):format(tier),
		tiles = {"technic_"..ltier.."_electric_furnace_top.png",
		         "technic_"..ltier.."_electric_furnace_bottom.png",
		         tube_side_texture,
			 tube_side_texture,
			 "technic_"..ltier.."_electric_furnace_side.png",
		         "technic_"..ltier.."_electric_furnace_front.png"},
		paramtype2 = "facedir",
		groups = groups,
		legacy_facedir_simple = true,
		sounds = default.node_sound_stone_defaults(),
		tube = data.tube and tube or nil,
		technic = data,
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local name = minetest.get_node(pos).name
			local data = minetest.registered_nodes[name].technic
			meta:set_string("infotext", S("%s Electric furnace"):format(data.tier))
			meta:set_int("tube_time",  0)
			meta:set_string("formspec", data.formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 4)
			inv:set_size("upgrade1", 1)
			inv:set_size("upgrade2", 1)
		end,
		can_dig = function(pos, player)
			local meta = minetest.get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("src") or not inv:is_empty("dst") or
			   not inv:is_empty("upgrade1") or not inv:is_empty("upgrade2") then
				minetest.chat_send_player(player:get_player_name(),
					S("Machine cannot be removed because it is not empty"))
				return false
			else
				return true
			end
		end,
	})

	minetest.register_node("technic:"..ltier.."_electric_furnace_active", {
		description = tier.." Electric furnace",
		tiles = {"technic_"..ltier.."_electric_furnace_top.png",
		         "technic_"..ltier.."_electric_furnace_bottom.png",
		         tube_side_texture,
		         tube_side_texture,
		         "technic_"..ltier.."_electric_furnace_side.png",
		         "technic_"..ltier.."_electric_furnace_front_active.png"},
		paramtype2 = "facedir",
		groups = active_groups,
		light_source = 8,
		legacy_facedir_simple = true,
		sounds = default.node_sound_stone_defaults(),
		tube = data.tube and tube or nil,
		technic = data,
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local name = minetest.get_node(pos).name
			local data = minetest.registered_nodes[name].technic
			meta:set_string("infotext", S("%s Electric furnace", data.tier))
			meta:set_int("tube_time",  0)
			meta:set_string("formspec", data.formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 4)
			inv:set_size("upgrade1", 1)
			inv:set_size("upgrade2", 1)
		end,
		can_dig = function(pos, player)
			local meta = minetest.get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("src") or not inv:is_empty("dst") or
			   not inv:is_empty("upgrade1") or not inv:is_empty("upgrade2") then
				minetest.chat_send_player(player:get_player_name(),
					S("Machine cannot be removed because it is not empty"))
				return false
			else
				return true
			end
		end,
		-- These three makes sure upgrades are not moved in or out while the furnace is active.
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			if listname == "src" or listname == "dst" then
				return stack:get_stack_max()
			else
				return 0 -- Disallow the move
			end
		end,
		allow_metadata_inventory_take = function(pos, listname, index, stack, player)
			if listname == "src" or listname == "dst" then
				return stack:get_stack_max()
			else
				return 0 -- Disallow the move
			end
		end,
		allow_metadata_inventory_move = function(pos, from_list, to_list, to_list, to_index, count, player)
			return 0
		end,
	})

	minetest.register_abm({
		nodenames = {"technic:"..ltier.."_electric_furnace",
		             "technic:"..ltier.."_electric_furnace_active"},
		interval = 1,
		chance   = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local data     = minetest.registered_nodes[node.name].technic
			local meta     = minetest.get_meta(pos)
			local inv      = meta:get_inventory()
			local eu_input = meta:get_int(data.tier.."_EU_input")

			-- Machine information
			local machine_name   = S("%s Electric Furnace"):format(data.tier)
			local machine_node   = "technic:"..string.lower(data.tier).."_electric_furnace"
			local machine_demand = data.demand

			-- Power off automatically if no longer connected to a switching station
			technic.switching_station_timeout_count(pos, data.tier)

			-- Check upgrade slots
			local EU_upgrade, tube_upgrade = 0, 0
			if data.upgrade then
				EU_upgrade, tube_upgrade = technic.handle_machine_upgrades(meta)
			end
			if data.tube then
				technic.handle_machine_pipeworks(pos, tube_upgrade)
			end

			local result = minetest.get_craft_result({
					method = "cooking",
					width = 1,
					items = inv:get_list("src")})
			if not result or result.time == 0 or
			   not inv:room_for_item("dst", result.item) then
				meta:set_int(data.tier.."_EU_demand", 0)
				hacky_swap_node(pos, machine_node)
				meta:set_string("infotext", S("%s Idle"):format(machine_name))
				return
			end

			if eu_input < machine_demand[EU_upgrade+1] then
				-- Unpowered - go idle
				hacky_swap_node(pos, machine_node)
				meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
			elseif eu_input >= machine_demand[EU_upgrade+1] then
				-- Powered
				hacky_swap_node(pos, machine_node.."_active")
				meta:set_string("infotext", S("%s Active"):format(machine_name))
				technic.smelt_item(meta, result, data.speed)

			end
			meta:set_int(data.tier.."_EU_demand", machine_demand[EU_upgrade+1])
		end,
	})

	technic.register_machine(tier, "technic:"..ltier.."_electric_furnace",        technic.receiver)
	technic.register_machine(tier, "technic:"..ltier.."_electric_furnace_active", technic.receiver)

end -- End registration

