-- MV Electric Furnace
-- This is a faster version of the stone furnace which runs on EUs
-- In addition to this it can be upgraded with microcontrollers and batteries
-- This new version uses the batteries to lower the power consumption of the machine
-- Also in addition this furnace can be attached to the pipe system from the pipeworks mod.

-- FIXME: kpoppel I'd like to introduce an induction heating element here also
minetest.register_craft(
   {output = 'technic:mv_electric_furnace',
    recipe = {
       {'technic:stainless_steel_ingot', 'technic:electric_furnace', 'technic:stainless_steel_ingot'},
       {'pipeworks:tube_000000', 'technic:mv_transformer', 'pipeworks:tube_000000'},
       {'technic:stainless_steel_ingot', 'technic:mv_cable', 'technic:stainless_steel_ingot'},
    }
 })

local mv_electric_furnace_formspec =
   "invsize[8,10;]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,6;8,4;]"..
   "label[0,0;MV Electric Furnace]"..
   "list[current_name;upgrade1;1,4;1,1;]"..
   "list[current_name;upgrade2;2,4;1,1;]"..
   "label[1,5;Upgrade Slots]"

minetest.register_node(
   "technic:mv_electric_furnace",
   {description = "MV Electric furnace",
    tiles = {"technic_mv_electric_furnace_top.png", "technic_mv_electric_furnace_bottom.png", "technic_mv_electric_furnace_side_tube.png",
	     "technic_mv_electric_furnace_side_tube.png", "technic_mv_electric_furnace_side.png", "technic_mv_electric_furnace_front.png"},
    paramtype2 = "facedir",
    groups = technic.mv_groups_inactive,
    tube = technic.mv_tube_definitions,
    legacy_facedir_simple = true,
    sounds = default.node_sound_stone_defaults(),
    on_construct = function(pos)
		      local meta = minetest.env:get_meta(pos)
		      meta:set_string("infotext", "MV Electric furnace")
		      meta:set_float("technic_mv_power_machine", 1)
		      meta:set_int("tube_time",  0)
		      meta:set_string("formspec", mv_electric_furnace_formspec)
		      local inv = meta:get_inventory()
		      inv:set_size("src", 1)
		      inv:set_size("dst", 4)
		      inv:set_size("upgrade1", 1)
		      inv:set_size("upgrade2", 1)
		   end,
    can_dig = technic.mv_can_dig,
 })

minetest.register_node(
   "technic:mv_electric_furnace_active",
   {description = "MV Electric Furnace",
    tiles = {"technic_mv_electric_furnace_top.png", "technic_mv_electric_furnace_bottom.png", "technic_mv_electric_furnace_side_tube.png",
	     "technic_mv_electric_furnace_side_tube.png", "technic_mv_electric_furnace_side.png", "technic_mv_electric_furnace_front_active.png"},
    paramtype2 = "facedir",
    light_source = 8,
    drop = "technic:mv_electric_furnace",
    groups = technic.mv_groups_active,
    tube = technic.mv_tube_definitions,
    legacy_facedir_simple = true,
    sounds = default.node_sound_stone_defaults(),
    can_dig = technic.mv_can_dig,
    -- These three makes sure upgrades are not moved in or out while the furnace is active.
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

local smelt_item = function(pos)
		      local meta=minetest.env:get_meta(pos) 
		      local inv = meta:get_inventory()
		      meta:set_int("src_time", meta:get_int("src_time") + 3) -- Cooking time 3x faster
		      local result = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})
		      if result and result.item and meta:get_int("src_time") >= result.time then
			 meta:set_int("src_time", 0)
			 -- check if there's room for output in "dst" list
			 if inv:room_for_item("dst",result) then
			    -- take stuff from "src" list
			    srcstack = inv:get_stack("src", 1)
			    srcstack:take_item()
			    inv:set_stack("src", 1, srcstack)
			    -- Put result in "dst" list
			    inv:add_item("dst", result.item)
			    return 1
			 else
			    return 0 -- done
			 end
		      end
		      return 0 -- done
		   end

minetest.register_abm(
   {nodenames = {"technic:mv_electric_furnace","technic:mv_electric_furnace_active"},
    interval = 1,
    chance   = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
		local meta         = minetest.env:get_meta(pos)
		local eu_input     = meta:get_int("MV_EU_input")
		local state        = meta:get_int("state")
		local next_state   = state

		-- Machine information
		local machine_name         = "MV Electric Furnace"
		local machine_node         = "technic:mv_electric_furnace"
		local machine_state_demand = { 50, 2000, 1500, 1000 }
			 
		-- Setup meta data if it does not exist. state is used as an indicator of this
		if state == 0 then
		   meta:set_int("state", 1)
		   meta:set_int("MV_EU_demand", machine_state_demand[1])
		   meta:set_int("MV_EU_input", 0)
		   return
		end
			 
		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "MV")
		
		-- Execute always logic
		-- CODE HERE --
		
		-- State machine
		if eu_input == 0 then
		   -- Unpowered - go idle
		   hacky_swap_node(pos, machine_node)
		   meta:set_string("infotext", machine_name.." Unpowered")
		   next_state = 1
		elseif eu_input == machine_state_demand[state] then
		   -- Powered - do the state specific actions
			    
		   -- Execute always if powered logic
		   local meta=minetest.env:get_meta(pos) 
			  
		   -- Get the names of the upgrades
		   local meta=minetest.env:get_meta(pos) 
		   local inv = meta:get_inventory()
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
			 technic.mv_send_tube_items(pos,x_velocity,z_velocity)
		      end
		   end
		   meta:set_int("tube_time", tube_time)
		   
		   -- The machine shuts down if we have nothing to smelt and no tube is connected
		   -- or if we have nothing to send with a tube connected.
		   if inv:is_empty("src") and (not output_tube_connected or inv:is_empty("dst")) then
		   next_state = 1
		end
		----------------------
		
		if state == 1 then
		   hacky_swap_node(pos, machine_node)
		   meta:set_string("infotext", machine_name.." Idle")
		   
		   local meta=minetest.env:get_meta(pos) 
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") then
		      local result = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})
		      if result then
			 meta:set_string("infotext", machine_name.." Active")
			 meta:set_int("src_time",     0)
			 next_state = 2+EU_saving_upgrade -- Next state is decided by the battery upgrade (state 2= 0 batteries, state 3 = 1 battery, 4 = 2 batteries)
		      end
		   else
		      meta:set_string("infotext", "Electric Furnace Idle")
		   end
		   
		elseif state == 2 or state == 3 or state == 4 then
		   hacky_swap_node(pos, machine_node.."_active")
		   meta:set_string("infotext", machine_name.." Active")
		   result = smelt_item(pos, data)
		   if result == 0 then
		      next_state = 1
		   end
		end
	     end
	     -- Change state?
	     if next_state ~= state then
		meta:set_int("MV_EU_demand", machine_state_demand[next_state])
		meta:set_int("state", next_state)
	     end
	  end,
 })

technic.register_MV_machine ("technic:mv_electric_furnace","RE")
technic.register_MV_machine ("technic:mv_electric_furnace_active","RE")
