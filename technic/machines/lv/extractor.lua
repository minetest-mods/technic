technic.extractor_recipes ={}

technic.register_extractor_recipe = function(src, src_count, dst, dst_count)
				   technic.extractor_recipes[src] = {src_count = src_count, dst_name = dst, dst_count = dst_count}
				   if unified_inventory then
				      unified_inventory.register_craft(
					 {
					    type = "extracting",
					    output = dst.." "..dst_count,
					    items = {src.." "..src_count},
					    width = 0,
					 })
				   end
				end

-- Receive an ItemStack of result by an ItemStack input
technic.get_extractor_recipe = function(item)
				if technic.extractor_recipes[item.name]
				   and item.count >= technic.extractor_recipes[item.name].src_count then
				   return technic.extractor_recipes[item.name]
				else
				   return nil
				end
			     end



technic.register_extractor_recipe("technic:coal_dust", 1, "dye:black", 2)
technic.register_extractor_recipe("default:cactus", 1, "dye:green", 2)
technic.register_extractor_recipe("default:dry_shrub", 1, "dye:brown", 2)
technic.register_extractor_recipe("flowers:geranium", 1, "dye:blue", 2)
technic.register_extractor_recipe("flowers:dandelion_white", 1, "dye:white", 2)
technic.register_extractor_recipe("flowers:dandelion_yellow", 1, "dye:yellow", 2)
technic.register_extractor_recipe("flowers:tulip", 1, "dye:orange", 2)
technic.register_extractor_recipe("flowers:rose", 1, "dye:red", 2)
technic.register_extractor_recipe("flowers:viola", 1, "dye:violet", 2)
technic.register_extractor_recipe("technic:raw_latex", 1, "technic:rubber", 3)
technic.register_extractor_recipe("moretrees:rubber_tree_trunk_empty", 1, "technic:rubber", 1)
technic.register_extractor_recipe("moretrees:rubber_tree_trunk", 1, "technic:rubber", 1)
technic.register_extractor_recipe("technic:uranium", 5, "technic:enriched_uranium", 1)

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
		    local srcstack  = inv:get_stack("src", 1)
		    local src_item = nil
		    local recipe = nil
		    local result = nil
		    
		    if srcstack then
		       src_item = srcstack:to_table()
		    end
		    if src_item then
		       recipe = technic.get_extractor_recipe(src_item)
		    end
		    if recipe then
		       result = {name=recipe.dst_name, count=recipe.dst_count}
		    end 
		    
		    if state == 1 then
		       hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Idle")

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

			     meta:set_int("src_time", 0)
			     if recipe and inv:room_for_item("dst",result) then
				-- take stuff from "src" list
				srcstack:take_item(recipe.src_count)
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

