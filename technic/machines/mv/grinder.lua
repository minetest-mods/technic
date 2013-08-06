-- MV grinder

minetest.register_craft({
	output = 'technic:mv_grinder',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:grinder', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_000000', 'technic:mv_transformer', 'pipeworks:tube_000000'},
		{'technic:stainless_steel_ingot', 'technic:mv_cable', 'technic:stainless_steel_ingot'},
	}
})
minetest.register_craftitem("technic:mv_grinder", {
	description = "MV Grinder",
	stack_max = 99,
})

local mv_grinder_formspec =
   "invsize[8,10;]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,6;8,4;]"..
   "label[0,0;MV Grinder]"..
   "list[current_name;upgrade1;1,4;1,1;]"..
   "list[current_name;upgrade2;2,4;1,1;]"..
   "label[1,5;Upgrade Slots]"

minetest.register_node(
"technic:mv_grinder",
{
	description = "MV Grinder",
	tiles = {"technic_mv_grinder_top.png", "technic_mv_grinder_bottom.png", "technic_mv_grinder_side_tube.png",
			"technic_mv_grinder_side_tube.png", "technic_mv_grinder_side.png", "technic_mv_grinder_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1,tubedevice_receiver=1,},
	tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("src",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("src",stack)
		end,
		connect_sides = {left=1, right=1, back=1, top=1, bottom=1},
	},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "MV Grinder")
		meta:set_float("technic_mv_power_machine", 1)
		meta:set_int("tube_time",  0)
		meta:set_string("formspec", mv_grinder_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		inv:set_size("upgrade1", 1)
		inv:set_size("upgrade2", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") or not inv:is_empty("dst") or not inv:is_empty("upgrade1") or not inv:is_empty("upgrade2") then
			minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
			return false
		else
			return true
		end
	end,
})

minetest.register_node(
	"technic:mv_grinder_active",
	{
		description = "Grinder",
		tiles = {"technic_mv_grinder_top.png", "technic_mv_grinder_bottom.png", "technic_mv_grinder_side_tube.png",
			"technic_mv_grinder_side_tube.png", "technic_mv_grinder_side.png", "technic_mv_grinder_front_active.png"},
		paramtype2 = "facedir",
		groups = {cracky=2,tubedevice=1,tubedevice_receiver=1,not_in_creative_inventory=1},
		tube={	insert_object=function(pos,node,stack,direction)
				local meta=minetest.env:get_meta(pos)
				local inv=meta:get_inventory()
				return inv:add_item("src",stack)
			end,
			can_insert=function(pos,node,stack,direction)
				local meta=minetest.env:get_meta(pos)
				local inv=meta:get_inventory()
				return inv:room_for_item("src",stack)
			end,
			connect_sides = {left=1, right=1, back=1, top=1, bottom=1},
		},
		legacy_facedir_simple = true,
		sounds = default.node_sound_wood_defaults(),
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if not inv:is_empty("src") or not inv:is_empty("dst") or not inv:is_empty("upgrade1") or not inv:is_empty("upgrade2") then
				minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
				return false
			else
				return true
			end
		end,
		-- These three makes sure upgrades are not moved in or out while the grinder is active.
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			if listname == "src" or listname == "dst" then
				return 99
			else
				return 0 -- Disallow the move
			end
		end,
		allow_metadata_inventory_take = function(pos, listname, index, stack, player)
			if listname == "src" or listname == "dst" then
				return 99
			else
				return 0 -- Disallow the move
			end
		end,
		allow_metadata_inventory_move = function(pos, from_list, to_list, to_list, to_index, count, player)
			return 0
		end,
	})

local send_grinded_items = function(pos,x_velocity,z_velocity)
	-- Send items on their way in the pipe system.
	local meta=minetest.env:get_meta(pos) 
	local inv = meta:get_inventory()
	local i=0
	for _,stack in ipairs(inv:get_list("dst")) do
		i=i+1
		if stack then
			local item0=stack:to_table()
			if item0 then 
				item0["count"]="1"
				local item1=tube_item({x=pos.x,y=pos.y,z=pos.z},item0)
				item1:get_luaentity().start_pos = {x=pos.x,y=pos.y,z=pos.z}
				item1:setvelocity({x=x_velocity, y=0, z=z_velocity})
				item1:setacceleration({x=0, y=0, z=0})
				stack:take_item(1);
				inv:set_stack("dst", i, stack)
				return
			end
		end
	end
end

minetest.register_abm(
	{ nodenames = {"technic:mv_grinder","technic:mv_grinder_active"},
	interval = 1,
	chance   = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		-- Run a machine through its states. Takes the same arguments as the ABM action
		-- and adds the machine's states and any extra data which is needed by the machine.
		-- A machine is characterized by running through a set number of states (usually 2:
		-- Idle and active) in some order. A state decides when to move to the next one
		-- and the machine only changes state if it is powered correctly.
		-- The machine will automatically shut down if disconnected from power in some fashion.
		local meta         = minetest.env:get_meta(pos)
		local eu_input     = meta:get_int("MV_EU_input")
		local state        = meta:get_int("state")
		local next_state   = state

		-- Machine information
		local machine_name         = "MV Grinder"
		local machine_node         = "technic:mv_grinder"
		local machine_state_demand = { 50, 600, 450, 300 }

		-- Setup meta data if it does not exist. state is used as an indicator of this
		if state == 0 then
			meta:set_int("state", 1)
			meta:set_int("MV_EU_demand", machine_state_demand[1])
			meta:set_int("MV_EU_input", 0)
			return
		end
	
		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "MV")
	
		-- State machine
		if eu_input == 0 then
			-- unpowered - go idle
			hacky_swap_node(pos, machine_node)
			meta:set_string("infotext", machine_name.." Unpowered")
			next_state = 1
		elseif eu_input == machine_state_demand[state] then
			-- Powered - do the state specific actions
		
			local inv    = meta:get_inventory()
			local empty  = inv:is_empty("src")
			
			-- get the names of the upgrades
			local upg_item1
			local upg_item1_name=""
			local upg_item2
			local upg_item2_name=""
			local srcstack = inv:get_stack("upgrade1", 1)
			if  srcstack then upg_item1=srcstack:to_table() end
			srcstack = inv:get_stack("upgrade2", 1)
			if  srcstack then upg_item2=srcstack:to_table() end
			if upg_item1 then upg_item1_name=upg_item1.name end
			if upg_item2 then upg_item2_name=upg_item2.name end

			-- Save some power by installing battery upgrades. Fully upgraded makes this
			-- furnace use the same amount of power as the LV version
			local EU_saving_upgrade = 0
			if upg_item1_name=="technic:battery" then EU_saving_upgrade = EU_saving_upgrade + 1 end
			if upg_item2_name=="technic:battery" then EU_saving_upgrade = EU_saving_upgrade + 1 end

			-- Tube loading speed can be upgraded using control logic units
			local tube_speed_upgrade = 0
			if upg_item1_name=="technic:control_logic_unit" then tube_speed_upgrade = tube_speed_upgrade + 1 end
			if upg_item2_name=="technic:control_logic_unit" then tube_speed_upgrade = tube_speed_upgrade + 1 end

			-- Handle pipeworks (consumes tube_speed_upgrade)
			local pos1={x=pos.x, y=pos.y, z=pos.z}
			local x_velocity=0
			local z_velocity=0

			-- Output is on the left side of the furnace
			if node.param2==3 then pos1.z=pos1.z-1 z_velocity =-1 end
			if node.param2==2 then pos1.x=pos1.x-1 x_velocity =-1 end
			if node.param2==1 then pos1.z=pos1.z+1 z_velocity = 1 end
			if node.param2==0 then pos1.x=pos1.x+1 x_velocity = 1 end

			local output_tube_connected = false
			local meta1 = minetest.env:get_meta(pos1) 
			if meta1:get_int("tubelike") == 1 then
				output_tube_connected=true
			end
			tube_time = meta:get_int("tube_time")
			tube_time = tube_time + tube_speed_upgrade
			if tube_time > 3 then
				tube_time = 0
				if output_tube_connected then
					send_grinded_items(pos,x_velocity,z_velocity)
				end
			end
			meta:set_int("tube_time", tube_time)

			-- The machine shuts down if we have nothing to smelt since we tube stuff
			-- out while being idle.
			if inv:is_empty("src") then
				next_state = 1
			end

			if state == 1 then
				hacky_swap_node(pos, machine_node)
				meta:set_string("infotext", machine_name.." Idle")

				local result = technic.get_grinder_recipe(inv:get_stack("src", 1))
				if not empty and result and inv:room_for_item("dst",result) then
					meta:set_int("src_time", 0)
					next_state = 2+EU_saving_upgrade
				end

			elseif state == 2 or state == 3 or state == 4 then
				hacky_swap_node(pos, machine_node.."_active")
				meta:set_string("infotext", machine_name.." Active")

				if empty then
					next_state = 1
				else
					meta:set_int("src_time", meta:get_int("src_time") + 2) -- 2x faster
					if meta:get_int("src_time") == 4 then -- 4 ticks per output
						-- check if there's room for output in "dst" list
						local result = technic.get_grinder_recipe(inv:get_stack("src", 1))

						meta:set_int("src_time", 0)
						if inv:room_for_item("dst",result) then
							-- take stuff from "src" list
							srcstack = inv:get_stack("src", 1)
							srcstack:take_item()
							inv:set_stack("src", 1, srcstack)
							-- Put result in "dst" list
							inv:add_item("dst", result)
						else
							-- all full: go idle
							next_state = 1
						end
					end
				end
			end
		end
		-- Change state?
		if next_state ~= state then
			meta:set_int("MV_EU_demand", machine_state_demand[next_state])
			meta:set_int("state", next_state)
		end
	end
})

technic.register_MV_machine ("technic:mv_grinder","RE")
technic.register_MV_machine ("technic:mv_grinder_active","RE")