
local S = technic.getter

local extractor_formspec =
   "invsize[8,9;]"..
   "label[0,0;"..S("%s Extractor"):format("LV").."]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,5;8,4;]"

function technic.register_extractor(data)
	local tier = data.tier
	local ltier = string.lower(tier)

	local groups = {cracky = 2}
	local active_groups = {cracky = 2, not_in_creative_inventory = 1}
	if data.tube then
		groups.tubedevice = 1
		groups.tubedevice_receiver = 1
		active_groups.tubedevice = 1
		active_groups.tubedevice_receiver = 1
	end


	local formspec =
		"invsize[8,9;]"..
		"list[current_name;src;3,1;1,1;]"..
		"list[current_name;dst;5,1;2,2;]"..
		"list[current_player;main;0,5;8,4;]"..
		"label[0,0;"..S("%s Extractor"):format(tier).."]"
	
	if data.upgrade then
		formspec = formspec..
			"list[current_name;upgrade1;1,4;1,1;]"..
			"list[current_name;upgrade2;2,4;1,1;]"..
			"label[1,5;"..S("Upgrade Slots").."]"
	end

	minetest.register_node("technic:"..ltier.."_extractor", {
		description = S("%s Extractor"):format(tier),
		tiles = {"technic_"..ltier.."_extractor_top.png",  "technic_"..ltier.."_extractor_bottom.png",
			 "technic_"..ltier.."_extractor_side.png", "technic_"..ltier.."_extractor_side.png",
			 "technic_"..ltier.."_extractor_side.png", "technic_"..ltier.."_extractor_front.png"},
		paramtype2 = "facedir",
		groups = groups,
		tube = data.tube and tube or nil,
		legacy_facedir_simple = true,
		sounds = default.node_sound_wood_defaults(),
		on_construct = function(pos)
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", S("%s Extractor"):format(tier))
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

	minetest.register_node("technic:"..ltier.."_extractor_active",{
		description = S("%s Grinder"):format(tier),
		tiles = {"technic_"..ltier.."_extractor_top.png",  "technic_"..ltier.."_extractor_bottom.png",
			 "technic_"..ltier.."_extractor_side.png", "technic_"..ltier.."_extractor_side.png",
			 "technic_"..ltier.."_extractor_side.png", "technic_"..ltier.."_extractor_front_active.png"},
		paramtype2 = "facedir",
		drop = "technic:"..ltier.."_extractor",
		groups = active_groups,
		legacy_facedir_simple = true,
		sounds = default.node_sound_wood_defaults(),
		tube = data.tube and tube or nil,
		can_dig = technic.machine_can_dig,
		allow_metadata_inventory_put = technic.machine_inventory_put,
		allow_metadata_inventory_take = technic.machine_inventory_take,
		allow_metadata_inventory_move = technic.machine_inventory_move,
	})

	minetest.register_abm({
		nodenames = {"technic:"..ltier.."_extractor","technic:"..ltier.."_extractor_active"},
		interval = 1,
		chance   = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta     = minetest.get_meta(pos)
			local inv      = meta:get_inventory()
			local eu_input = meta:get_int(tier.."_EU_input")

			local machine_name   = S("%s Extractor"):format(tier)
			local machine_node   = "technic:"..ltier.."_extractor"
			local machine_demand = data.demand

			-- Setup meta data if it does not exist.
			if not eu_input then
				meta:set_int(tier.."_EU_demand", machine_demand[1])
				meta:set_int(tier.."_EU_input", 0)
				return
			end
		
			-- Power off automatically if no longer connected to a switching station
			technic.switching_station_timeout_count(pos, tier)

			local EU_upgrade, tube_upgrade = 0, 0
			if data.upgrade then
				EU_upgrade, tube_upgrade = technic.handle_machine_upgrades(meta)
			end
			if data.tube then
				technic.handle_machine_pipeworks(pos, tube_upgrade)
			end

			local srcstack = inv:get_stack("src", 1)
			local result = technic.get_extractor_recipe(inv:get_stack("src", 1))

			if not result then
				technic.swap_node(pos, machine_node)
				meta:set_string("infotext", S("%s Idle"):format(machine_name))
				meta:set_int(tier.."_EU_demand", 0)
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

				meta:set_int("src_time", meta:get_int("src_time") + 1)
				if meta:get_int("src_time") >= result.time / data.speed then
					meta:set_int("src_time", 0)
					local result_stack = ItemStack(result.output)
					if inv:room_for_item("dst", result_stack) then
						srcstack = inv:get_stack("src", 1)
						srcstack:take_item(ItemStack(result.input):get_count())
						inv:set_stack("src", 1, srcstack)
						inv:add_item("dst", result_stack)
					end
				end
			end
			meta:set_int(tier.."_EU_demand", machine_demand[EU_upgrade+1])
		end
	})

	technic.register_machine(tier, "technic:"..ltier.."_extractor",        technic.receiver)
	technic.register_machine(tier, "technic:"..ltier.."_extractor_active", technic.receiver)

end -- End registration

