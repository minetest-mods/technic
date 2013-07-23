-- MV alloy furnace

minetest.register_craft({
	output = 'technic:mv_alloy_furnace',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:alloy_furnace', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_000000', 'technic:mv_transformer', 'pipeworks:tube_000000'},
		{'technic:stainless_steel_ingot', 'technic:mv_cable', 'technic:stainless_steel_ingot'},
	}
})

local mv_alloy_furnace_formspec =
	"invsize[8,10;]"..
	"label[0,0;MV Alloy Furnace]"..
        "list[current_name;src;3,1;1,2;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,6;8,4;]"..
	"list[current_name;upgrade1;1,4;1,1;]"..
	"list[current_name;upgrade2;2,4;1,1;]"..
	"label[1,5;Upgrade Slots]"
	
minetest.register_node(
   "technic:mv_alloy_furnace",
   {description = "MV Alloy Furnace",
    tiles = {"technic_mv_alloy_furnace_top.png", "technic_mv_alloy_furnace_bottom.png", "technic_mv_alloy_furnace_side_tube.png",
	     "technic_mv_alloy_furnace_side_tube.png", "technic_mv_alloy_furnace_side.png", "technic_mv_alloy_furnace_front.png"},
    paramtype2 = "facedir",
    groups = {cracky=2, tubedevice=1,tubedevice_receiver=1},
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
    sounds = default.node_sound_stone_defaults(),
    on_construct = function(pos)
		      local meta = minetest.env:get_meta(pos)
		      meta:set_string("infotext", "MV Alloy furnace")
		      meta:set_float("technic_mv_power_machine", 1)
		      meta:set_int("tube_time",  0)
		      meta:set_string("formspec", mv_alloy_furnace_formspec)
		      local inv = meta:get_inventory()
		      inv:set_size("src", 2)
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
   "technic:mv_alloy_furnace_active",
   {description = "MV Alloy Furnace",
    tiles = {"technic_mv_alloy_furnace_top.png", "technic_mv_alloy_furnace_bottom.png", "technic_mv_alloy_furnace_side_tube.png",
	     "technic_mv_alloy_furnace_side_tube.png", "technic_mv_alloy_furnace_side.png", "technic_mv_alloy_furnace_front_active.png"},
    paramtype2 = "facedir",
    light_source = 8,
    drop = "technic:mv_alloy_furnace",
    groups = {cracky=2, tubedevice=1,tubedevice_receiver=1,not_in_creative_inventory=1},
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
    sounds = default.node_sound_stone_defaults(),
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

local send_cooked_items = function(pos,x_velocity,z_velocity)
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

local smelt_item = function(pos)
		      local meta=minetest.env:get_meta(pos) 
		      local inv = meta:get_inventory()
		      meta:set_int("src_time", meta:get_int("src_time") + 3) -- Cooking time 3x faster
		      local result = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})
		      dst_stack={}
		      dst_stack["name"]=alloy_recipes[dst_index].dst_name
		      dst_stack["count"]=alloy_recipes[dst_index].dst_count

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
   {nodenames = {"technic:mv_alloy_furnace","technic:mv_alloy_furnace_active"},
    interval = 1,
    chance = 1,

    action = function(pos, node, active_object_count, active_object_count_wider)
		local meta         = minetest.env:get_meta(pos)
		local eu_input     = meta:get_int("MV_EU_input")
		local state        = meta:get_int("state")
		local next_state   = state

		-- Machine information
		local machine_name         = "MV Alloy Furnace"
		local machine_node         = "technic:mv_alloy_furnace"
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
			 send_cooked_items(pos,x_velocity,z_velocity)
		      end
		   end
		   meta:set_int("tube_time", tube_time)

		   -- The machine shuts down if we have nothing to smelt and no tube is connected
		   -- or if we have nothing to send with a tube connected.
		   if    (not output_tube_connected and inv:is_empty("src"))
		      or (    output_tube_connected and inv:is_empty("dst")) then
		      next_state = 1
		   end
		   ----------------------
		   local empty  = 1
		   local recipe = nil
		   local result = nil

		   -- Get what to cook if anything
		   local srcstack  = inv:get_stack("src", 1)
		   local src2stack = inv:get_stack("src", 2)
		   local src_item1 = nil
		   local src_item2 = nil
		   if srcstack and src2stack then
		      src_item1 = srcstack:to_table()
		      src_item2 = src2stack:to_table()
		      empty     = 0
		   end
		   
		   if src_item1 and src_item2 then
		      recipe = technic.get_alloy_recipe(src_item1,src_item2)
		   end
		   if recipe then
		      result = { name=recipe.dst_name, count=recipe.dst_count}
		   end
		   
		   if state == 1 then
		      hacky_swap_node(pos, machine_node)
		      meta:set_string("infotext", machine_name.." Idle")
		      
		      local meta=minetest.env:get_meta(pos) 
		      local inv = meta:get_inventory()
		      if not inv:is_empty("src") then
			 if empty == 0 and recipe and inv:room_for_item("dst", result) then
			    meta:set_string("infotext", machine_name.." Active")
			    meta:set_int("src_time",     0)
			    next_state = 2+EU_saving_upgrade -- Next state is decided by the battery upgrade (state 2= 0 batteries, state 3 = 1 battery, 4 = 2 batteries)
			 end
		      end
		      
		   elseif state == 2 or state == 3 or state == 4 then
		      hacky_swap_node(pos, machine_node.."_active")
		      meta:set_int("src_time", meta:get_int("src_time") + 1)
		      if meta:get_int("src_time") == 4 then -- 4 ticks per output
			 meta:set_string("src_time", 0)
			 -- check if there's room for output in "dst" list and that we have the materials
			 if recipe and inv:room_for_item("dst", result) then
			    -- Take stuff from "src" list
			    srcstack:take_item(recipe.src1_count)
			    inv:set_stack("src", 1, srcstack)
			    src2stack:take_item(recipe.src2_count)
			    inv:set_stack("src2", 1, src2stack)
			    -- Put result in "dst" list
			    inv:add_item("dst",result)
			 else
			    next_state = 1
			 end
		      end
		   end
		end
		-- Change state?
		if next_state ~= state then
		   meta:set_int("MV_EU_demand", machine_state_demand[next_state])
		   meta:set_int("state", next_state)
		end



	     ------------------------------------

--	     local pos1={}
--	     pos1.x=pos.x
--	     pos1.y=pos.y
--	     pos1.z=pos.z
--	     local x_velocity=0
--	     local z_velocity=0
--
--	     -- output is on the left side of the furnace
--	     if node.param2==3 then pos1.z=pos1.z-1 z_velocity =-1 end
--	     if node.param2==2 then pos1.x=pos1.x-1 x_velocity =-1 end
--	     if node.param2==1 then pos1.z=pos1.z+1 z_velocity = 1 end
--	     if node.param2==0 then pos1.x=pos1.x+1 x_velocity = 1 end
--
--	     local output_tube_connected = false
--	     local meta=minetest.env:get_meta(pos1) 
--	     if meta:get_int("tubelike")==1 then output_tube_connected=true end
--	     meta = minetest.env:get_meta(pos)
--	     local inv = meta:get_inventory()
--	     local upg_item1
--	     local upg_item1_name=""
--	     local upg_item2
--	     local upg_item2_name=""
--	     local srcstack = inv:get_stack("upgrade1", 1)
--	     if srcstack then upg_item1=srcstack:to_table() end
--	     srcstack = inv:get_stack("upgrade2", 1)
--	     if srcstack then upg_item2=srcstack:to_table() end
--	     if upg_item1 then upg_item1_name=upg_item1.name end
--	     if upg_item2 then upg_item2_name=upg_item2.name end
--
--	     local speed=0
--	     if upg_item1_name=="technic:control_logic_unit" then speed=speed+1 end
--	     if upg_item2_name=="technic:control_logic_unit" then speed=speed+1 end
--	     tube_time=meta:get_float("tube_time")
--	     tube_time=tube_time+speed
--	     if tube_time>3 then 
--		tube_time=0
--		if output_tube_connected then send_cooked_items(pos,x_velocity,z_velocity) end
--	     end
--	     meta:set_float("tube_time", tube_time)
--
--	     local extra_buffer_size = 0
--	     if upg_item1_name=="technic:battery" then extra_buffer_size =extra_buffer_size + 10000 end
--	     if upg_item2_name=="technic:battery" then extra_buffer_size =extra_buffer_size + 10000 end
--	     local internal_EU_buffer_size=2000+extra_buffer_size
--	     meta:set_float("internal_EU_buffer_size",internal_EU_buffer_size)
--
--	     internal_EU_buffer=meta:get_float("internal_EU_buffer")
--	     if internal_EU_buffer > internal_EU_buffer_size then internal_EU_buffer = internal_EU_buffer_size end
--	     local meta = minetest.env:get_meta(pos)
--	     local load = math.floor(internal_EU_buffer/internal_EU_buffer_size * 100)
--	     meta:set_string("formspec",
--			     MV_alloy_furnace_formspec..
--				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
--				(load)..":technic_power_meter_fg.png]")
--
--	     local inv = meta:get_inventory()
--
--	     local furnace_is_cookin = meta:get_int("furnace_is_cookin")
--
--	     local srclist = inv:get_list("src")
--	     local srclist2 = inv:get_list("src2")
--	     
--	     srcstack = inv:get_stack("src", 1)
--	     if srcstack then src_item1=srcstack:to_table() end
--	     srcstack = inv:get_stack("src", 2)
--	     if srcstack then src_item2=srcstack:to_table() end
--	     dst_index=nil
--
--	     if src_item1 and src_item2 then 
--		dst_index=get_cook_result(src_item1,src_item2) 
--	     end
--
--
--	     if (furnace_is_cookin == 1) then
--		if internal_EU_buffer>=150 then
--		   internal_EU_buffer=internal_EU_buffer-150;
--		   meta:set_float("internal_EU_buffer",internal_EU_buffer)
--		   meta:set_float("src_time", meta:get_float("src_time") + 1)
--		   if dst_index and meta:get_float("src_time") >= 4 then
--		      -- check if there's room for output in "dst" list
--		      dst_stack={}
--		      dst_stack["name"]=alloy_recipes[dst_index].dst_name
--		      dst_stack["count"]=alloy_recipes[dst_index].dst_count
--		      if inv:room_for_item("dst",dst_stack) then
--			 -- Put result in "dst" list
--			 inv:add_item("dst",dst_stack)
--			 -- take stuff from "src" list
--			 for i=1,alloy_recipes[dst_index].src1_count,1 do
--			    srcstack = inv:get_stack("src", 1)
--			    srcstack:take_item()
--			    inv:set_stack("src", 1, srcstack)
--			 end
--			 for i=1,alloy_recipes[dst_index].src2_count,1 do
--			    srcstack = inv:get_stack("src", 2)
--			    srcstack:take_item()
--			    inv:set_stack("src", 2, srcstack)
--			 end
--
--		      else
--			 print("Furnace inventory full!")
--		      end
--		      meta:set_string("src_time", 0)
--		   end
--		end
--	     end
--
--	     if dst_index and meta:get_int("furnace_is_cookin")==0 then
--		hacky_swap_node(pos,"technic:mv_alloy_furnace_active")
--		meta:set_string("infotext","MV Alloy Furnace active")
--		meta:set_int("furnace_is_cookin",1)
--		meta:set_string("src_time", 0)
--		return
--	     end
--
--	     if meta:get_int("furnace_is_cookin")==0 or dst_index==nil then
--		hacky_swap_node(pos,"technic:mv_alloy_furnace")
--		meta:set_string("infotext","MV Alloy Furnace inactive")
--		meta:set_int("furnace_is_cookin",0)
--		meta:set_string("src_time", 0)
--	     end
--
	  end,
 })

technic.register_MV_machine ("technic:mv_alloy_furnace","RE")
technic.register_MV_machine ("technic:mv_alloy_furnace_active","RE")
