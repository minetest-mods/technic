
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
			"label[1,5;"..S("Upgrade Slots").."]"
	end

	minetest.register_node("technic:"..ltier.."_electric_furnace", {
		description = S("%s Electric Furnace"):format(tier),
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
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local name = minetest.get_node(pos).name
			meta:set_string("infotext", S("%s Electric Furnace"):format(tier))
			meta:set_int("tube_time",  0)
			meta:set_string("formspec", formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 4)
			inv:set_size("upgrade1", 1)
			inv:set_size("upgrade2", 1)
		end,
		can_dig = technic.machine_can_dig,
		allow_metadata_inventory_put = technic.machine_inventory_put,
		allow_metadata_inventory_take = technic.machine_inventory_take,
		allow_metadata_inventory_move = technic.machine_inventory_move,
	})

	minetest.register_node("technic:"..ltier.."_electric_furnace_active", {
		description = tier.." Electric Furnace",
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
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local name = minetest.get_node(pos).name
			local data = minetest.registered_nodes[name].technic
			meta:set_string("infotext", S("%s Electric Furnace"):format(tier))
			meta:set_int("tube_time",  0)
			meta:set_string("formspec", formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 4)
			inv:set_size("upgrade1", 1)
			inv:set_size("upgrade2", 1)
		end,
		can_dig = technic.machine_can_dig,
		allow_metadata_inventory_put = technic.machine_inventory_put,
		allow_metadata_inventory_take = technic.machine_inventory_take,
		allow_metadata_inventory_move = technic.machine_inventory_move,
	})

	minetest.register_abm({
		nodenames = {"technic:"..ltier.."_electric_furnace",
		             "technic:"..ltier.."_electric_furnace_active"},
		interval = 1,
		chance   = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta     = minetest.get_meta(pos)
			local inv      = meta:get_inventory()
			local eu_input = meta:get_int(tier.."_EU_input")

			-- Machine information
			local machine_name   = S("%s Electric Furnace"):format(tier)
			local machine_node   = "technic:"..ltier.."_electric_furnace"
			local machine_demand = data.demand

			-- Power off automatically if no longer connected to a switching station
			technic.switching_station_timeout_count(pos, tier)

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
				meta:set_int(tier.."_EU_demand", 0)
				technic.swap_node(pos, machine_node)
				meta:set_string("infotext", S("%s Idle"):format(machine_name))
				return
			end

			if eu_input < machine_demand[EU_upgrade+1] then
				-- Unpowered - go idle
				technic.swap_node(pos, machine_node)
				meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
			elseif eu_input >= machine_demand[EU_upgrade+1] then
				-- Powered
				technic.swap_node(pos, machine_node.."_active")
				meta:set_string("infotext", S("%s Active"):format(machine_name))
				technic.smelt_item(meta, result, data.speed)

			end
			meta:set_int(tier.."_EU_demand", machine_demand[EU_upgrade+1])
		end,
	})

	technic.register_machine(tier, "technic:"..ltier.."_electric_furnace",        technic.receiver)
	technic.register_machine(tier, "technic:"..ltier.."_electric_furnace_active", technic.receiver)

end -- End registration

