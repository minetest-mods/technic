-- LV Tool workshop
-- This machine repairs tools.
minetest.register_alias("tool_workshop", "technic:tool_workshop")
minetest.register_craft({
	output = 'technic:tool_workshop',
	recipe = {
		{'default:wood', 'technic:control_logic_unit', 'default:wood'},
		{'default:wood', 'default:diamond', 'default:wood'},
		{'default:steel_ingot', 'technic:lv_cable', 'default:steel_ingot'},
	}
})

minetest.register_craftitem("technic:tool_workshop", {
	description = "Tool Workshop",
	stack_max = 99,
}) 

local workshop_formspec =
   "invsize[8,9;]"..
   "list[current_name;src;3,1;1,1;]"..
   "label[0,0;Tool Workshop]"..
   "list[current_player;main;0,5;8,4;]"

minetest.register_node(
   "technic:tool_workshop",
   {
      description = "Tool Workshop",
      tiles = {"technic_workshop_top.png", "technic_machine_bottom.png", "technic_workshop_side.png",
	       "technic_workshop_side.png", "technic_workshop_side.png", "technic_workshop_side.png"},
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      sounds = default.node_sound_wood_defaults(),
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string("infotext", "Tool Workshop")
			meta:set_float("technic_power_machine", 1)
			meta:set_string("formspec", workshop_formspec)
			local inv = meta:get_inventory()
			inv:set_size("src", 1)
		     end,	
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   end
		   return true
		end,
   })

minetest.register_abm(
   { nodenames = {"technic:tool_workshop"},
     interval = 1,
     chance   = 1,
     action = function(pos, node, active_object_count, active_object_count_wider)
		 local meta         = minetest.env:get_meta(pos)
		 local eu_input     = meta:get_int("LV_EU_input")
		 local state        = meta:get_int("state")
		 local next_state   = state

		 -- Machine information
		 local machine_name         = "Tool Workshop"
		 local machine_node         = "technic:tool_workshop"
		 local machine_state_demand = { 50, 150 }
			 
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
		    -- Unpowered - go idle
		    --hacky_swap_node(pos, machine_node)
		    meta:set_string("infotext", machine_name.." Unpowered")
		    next_state = 1
		 elseif eu_input == machine_state_demand[state] then
		    -- Powered - do the state specific actions
		    local inv = meta:get_inventory()
			    
		    if state == 1 then
		       --hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Idle")
		       if not inv:is_empty("src") then
			  next_state = 2
		       end
		    elseif state == 2 then
		       --hacky_swap_node(pos, machine_node.."_active")
		       meta:set_string("infotext", machine_name.." Active")

		       if inv:is_empty("src") then
			  next_state = 1
		       else
			  srcstack = inv:get_stack("src", 1)
			  src_item=srcstack:to_table()
			  -- Cannot charge cans
			  if (src_item["name"]=="technic:water_can" or src_item["name"]=="technic:lava_can") then
			     return
			  end
			  local wear=tonumber(src_item["wear"])
			  wear = math.max(1, wear-2000) -- Improve the tool this much every tick
			  src_item["wear"]=tostring(wear)
			  inv:set_stack("src", 1, src_item)
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

technic.register_LV_machine ("technic:tool_workshop","RE")

