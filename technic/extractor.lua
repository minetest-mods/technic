technic.extractor_recipes ={}

technic.register_extractor_recipe = function(src, dst)
				   technic.extractor_recipes[src] = dst
				   if unified_inventory then
				      unified_inventory.register_craft(
					 {
					    type = "extracting",
					    output = dst,
					    items = {src},
					    width = 0,
					 })
				   end
				end

-- Receive an ItemStack of result by an ItemStack input
technic.get_extractor_recipe = function(itemstack)
				local src_item  = itemstack:to_table()
				if src_item == nil then
				   return nil
				end
				local item_name = src_item["name"]
				if technic.extractor_recipes[item_name] then
				   return ItemStack(technic.extractor_recipes[item_name])
				else
				   return nil
				end
			     end



technic.register_extractor_recipe("technic:coal_dust","dye:black 2")
technic.register_extractor_recipe("default:cactus","dye:green 2")
technic.register_extractor_recipe("default:dry_shrub","dye:brown 2")
technic.register_extractor_recipe("flowers:geranium","dye:blue 2")
technic.register_extractor_recipe("flowers:dandelion_white","dye:white 2")
technic.register_extractor_recipe("flowers:dandelion_yellow","dye:yellow 2")
technic.register_extractor_recipe("flowers:tulip","dye:orange 2")
technic.register_extractor_recipe("flowers:rose","dye:red 2")
technic.register_extractor_recipe("flowers:viola","dye:violet 2")
technic.register_extractor_recipe("technic:raw_latex","technic:rubber 3")
technic.register_extractor_recipe("moretrees:rubber_tree_trunk_empty","technic:rubber 1")
technic.register_extractor_recipe("moretrees:rubber_tree_trunk","technic:rubber 1")

minetest.register_alias("extractor", "technic:extractor")
minetest.register_craft({
			   output = 'technic:extractor',
			   recipe = {
			      {'technic:treetap', 'technic:motor', 'technic:treetap'},
			      {'technic:treetap', 'technic:lv_cable', 'technic:treetap'},
			      {'','',''},
			   }
			})

minetest.register_craftitem("technic:extractor", {
			       description = "Extractor",
			       stack_max = 99,
			    })

local extractor_formspec =
   "invsize[8,9;]"..
   "label[0,0;Extractor]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,5;8,4;]"

minetest.register_node(
   "technic:extractor",
   {
      description = "Extractor",
      tiles = {"technic_lv_grinder_top.png", "technic_lv_grinder_bottom.png", "technic_lv_grinder_side.png",
	       "technic_lv_grinder_side.png", "technic_lv_grinder_side.png", "technic_lv_grinder_front.png"},
      paramtype2 = "facedir",
      groups = {cracky=2},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Extractor")
			meta:set_float("technic_power_machine", 1)
			meta:set_string("formspec", extractor_formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
			inv:set_size("dst", 4)
		     end,
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") or not inv:is_empty("dst") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

minetest.register_node(
   "technic:extractor_active",
   {
      description = "Extractor",
      tiles = {"technic_lv_grinder_top.png", "technic_lv_grinder_bottom.png", "technic_lv_grinder_side.png",
	       "technic_lv_grinder_side.png", "technic_lv_grinder_side.png", "technic_lv_grinder_front_active.png"},
      paramtype2 = "facedir",
      groups = {cracky=2,not_in_creative_inventory=1},
      legacy_facedir_simple = true,
      sounds = default.node_sound_wood_defaults(),
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") or not inv:is_empty("dst") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

minetest.register_abm(
   { nodenames = {"technic:extractor","technic:extractor_active"},
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
		 local eu_input     = meta:get_int("LV_EU_input")
		 local state        = meta:get_int("state")
		 local next_state   = state

		 -- Machine information
		 local machine_name         = "Extractor"
		 local machine_node         = "technic:extractor"
		 local machine_state_demand = { 50, 300 }
			 
		 -- Setup meta data if it does not exist. state is used as an indicator of this
		 if state == 0 then
		    meta:set_int("state", 1)
		    meta:set_int("LV_EU_demand", machine_state_demand[1])
		    meta:set_int("LV_EU_input", 0)
		    return
		 end
			 
		 -- Power off automatically if no longer connected to a switching station
		 technic.switching_station_timeout_count(pos, "LV")
			 
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

		    if state == 1 then
		       hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Idle")

		       local result = technic.get_extractor_recipe(inv:get_stack("src", 1))
		       if not empty and result and inv:room_for_item("dst",result) then
			  meta:set_int("src_time", 0)
			  next_state = 2
		       end

		    elseif state == 2 then
		       hacky_swap_node(pos, machine_node.."_active")
		       meta:set_string("infotext", machine_name.." Active")

		       if empty then
			  next_state = 1
		       else
			  meta:set_int("src_time", meta:get_int("src_time") + 1)
			  if meta:get_int("src_time") == 4 then -- 4 ticks per output
			     -- check if there's room for output in "dst" list
			     local result = technic.get_extractor_recipe(inv:get_stack("src", 1))

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
		    meta:set_int("LV_EU_demand", machine_state_demand[next_state])
		    meta:set_int("state", next_state)
		 end
	      end
  })

technic.register_LV_machine ("technic:extractor","RE")
technic.register_LV_machine ("technic:extractor_active","RE")

