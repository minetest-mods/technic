-- LV Electric Furnace
-- This is a faster version of the stone furnace which runs on EUs

-- FIXME: kpoppel I'd like to introduce an induction heating element here also
minetest.register_craft(
   {output = 'technic:electric_furnace',
    recipe = {
       {'default:cobble',      'default:cobble',        'default:cobble'},
       {'default:cobble',      '',                      'default:cobble'},
       {'default:steel_ingot', 'moreores:copper_ingot', 'default:steel_ingot'},
    }
 })

local electric_furnace_formspec =
   "invsize[8,9;]"..
   "list[current_name;src;3,1;1,1;]"..
   "list[current_name;dst;5,1;2,2;]"..
   "list[current_player;main;0,5;8,4;]"..
   "label[0,0;Electric Furnace]"..
   "label[1,3;Power level]"

minetest.register_node(
   "technic:electric_furnace",
   {description = "Electric furnace",
    tiles = {"technic_electric_furnace_top.png", "technic_electric_furnace_bottom.png", "technic_electric_furnace_side.png",
	     "technic_electric_furnace_side.png", "technic_electric_furnace_side.png", "technic_electric_furnace_front.png"},
    paramtype2 = "facedir",
    groups = {cracky=2},
    legacy_facedir_simple = true,
    sounds = default.node_sound_stone_defaults(),
    on_construct = function(pos)
		      local meta = minetest.env:get_meta(pos)
		      meta:set_string("infotext", "Electric Furnace")
		      meta:set_float("technic_power_machine", 1)
		      meta:set_string("formspec", electric_furnace_formspec)
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
   "technic:electric_furnace_active",
   {description = "Electric Furnace",
    tiles = {"technic_electric_furnace_top.png", "technic_electric_furnace_bottom.png", "technic_electric_furnace_side.png",
	     "technic_electric_furnace_side.png", "technic_electric_furnace_side.png", "technic_electric_furnace_front_active.png"},
    paramtype2 = "facedir",
    light_source = 8,
    drop = "technic:electric_furnace",
    groups = {cracky=2, not_in_creative_inventory=1},
    legacy_facedir_simple = true,
    sounds = default.node_sound_stone_defaults(),
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
   { nodenames = {"technic:electric_furnace","technic:electric_furnace_active"},
     interval = 1,
     chance   = 1,
     action = function(pos, node, active_object_count, active_object_count_wider)
		 local meta         = minetest.env:get_meta(pos)
		 local eu_input     = meta:get_int("LV_EU_input")
		 local state        = meta:get_int("state")
		 local next_state   = state

		 -- Machine information
		 local machine_name         = "Electric furnace"
		 local machine_node         = "technic:electric_furnace"
		 local machine_state_demand = { 50, 1000 }
			 
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
		    hacky_swap_node(pos, machine_node)
		    meta:set_string("infotext", machine_name.." Unpowered")
		    next_state = 1
		 elseif eu_input == machine_state_demand[state] then
		    -- Powered - do the state specific actions
			    
		    -- Execute always if powered logic
		    local inv    = meta:get_inventory()
		    local empty  = inv:is_empty("src")

		    if state == 1 then
		       hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Idle")

		       local result = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})
		       if not empty and result and inv:room_for_item("dst",result) then
			  next_state = 2
		       end

		    elseif state == 2 then
		       hacky_swap_node(pos, machine_node.."_active")
		       meta:set_string("infotext", machine_name.." Active")

		       if empty then
			  next_state = 1
		       else
			  meta:set_int("src_time", meta:get_int("src_time") + 3) -- Cooking time 3x
			  local result = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})
			  if result and result.item and meta:get_int("src_time") >= result.time then
			     -- check if there's room for output in "dst" list
			     meta:set_int("src_time", 0)
			     if inv:room_for_item("dst",result.item) then
				-- take stuff from "src" list
				srcstack = inv:get_stack("src", 1)
				srcstack:take_item()
				inv:set_stack("src", 1, srcstack)
				-- Put result in "dst" list
				inv:add_item("dst", result.item)
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
	      end,
  })

technic.register_LV_machine ("technic:electric_furnace","RE")
technic.register_LV_machine ("technic:electric_furnace_active","RE")
