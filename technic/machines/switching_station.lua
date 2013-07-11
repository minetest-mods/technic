-- SWITCHING STATION
-- The switching station is the center of all power distribution on an electric network.
-- The station will collect all produced power from producers (PR) and batteries (BA)
-- and distribute it to receivers (RE) and depleted batteries (BA).
--
-- It works like this:
--  All PR,BA,RE nodes are indexed and tagged with the switching station.
-- The tagging is to allow more stations to be built without allowing a cheat
-- with duplicating power.
--  All the RE nodes are queried for their current EU demand. Those which are off
-- would require no or a small standby EU demand, while those which are on would
-- require more.
-- If the total demand is less than the available power they are all updated with the
-- demand number.
-- If any surplus exists from the PR nodes the batteries will be charged evenly with this.
-- If the total demand requires draw on the batteries they will be discharged evenly.
--
-- If the total demand is more than the available power all RE nodes will be shut down.
-- We have a brown-out situation.
--
-- Hence all the power distribution logic resides in this single node.
--
--  Nodes connected to the network will have one or more of these parameters as meta data:
--   <LV|MV|HV>_EU_supply : Exists for PR and BA node types. This is the EU value supplied by the node. Output
--   <LV|MV|HV>_EU_demand : Exists for RE and BA node types. This is the EU value the node requires to run. Output
--   <LV|MV|HV>_EU_input  : Exists for RE and BA node types. This is the actual EU value the network can give the node. Input
--
--  The reason the LV|MV|HV type is prepended toe meta data is because some machine could require several supplies to work.
--  This way the supplies are separated per network.
technic.DBG = 1
local dprint = technic.dprint

minetest.register_craft(
   {
      output = 'technic:switching_station 1',
      recipe = {
	 {'technic:lv_transformer', 'technic:mv_transformer', 'technic:hv_transformer'},
	 {'technic:lv_transformer', 'technic:mv_transformer', 'technic:hv_transformer'},
	 {'technic:lv_cable',       'technic:mv_cable',       'technic:hv_cable'},
      }
   })

minetest.register_node(
   "technic:switching_station",
   {description = "Switching Station",
    tiles  = {"technic_water_mill_top_active.png", "technic_water_mill_top_active.png", "technic_water_mill_top_active.png",
	      "technic_water_mill_top_active.png", "technic_water_mill_top_active.png", "technic_water_mill_top_active.png"},
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
    sounds = default.node_sound_wood_defaults(),
    drawtype = "nodebox",
    paramtype = "light",
    is_ground_content = true,
    node_box = {
	 type = "fixed",
       fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    selection_box = {
       type = "fixed",
       fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    on_construct = function(pos)
		      local meta = minetest.env:get_meta(pos)
		      meta:set_string("infotext", "Switching Station")
--			minetest.chat_send_player(puncher:get_player_name(), "Switching station constructed. Punch the station to shut down the network.");
--			meta:set_int("active", 1)
		   end,
--      on_punch = function(pos, node, puncher)
--		    local meta   = minetest.env:get_meta(pos)
--		    local active = meta:get_int("active")
--		    if active == 1 then
--		       meta:set_int("active", 0)
--		       minetest.chat_send_player(puncher:get_player_name(), "Electrical network shut down. Punch again to turn it on.");
--		    else
--		       meta:set_int("active", 1)
--		       minetest.chat_send_player(puncher:get_player_name(), "Electrical network turned on. Punch again to shut it down.");
--		    end
--		 end
 })

--------------------------------------------------
-- Functions to help the machines on the electrical network
--------------------------------------------------
-- This one provides a timeout for a node in case it was disconnected from the network
-- A node must be touched by the station continuously in order to function
technic.switching_station_timeout_count = function(pos, machine_tier)
					     local meta = minetest.env:get_meta(pos)
					     timeout =  meta:get_int(machine_tier.."_EU_timeout")
					     --print("Counting timeout "..timeout)
					     if timeout == 0 then
						--print("OFF")
						meta:set_int(machine_tier.."_EU_input", 0)
					     else
						--print("ON")
						meta:set_int(machine_tier.."_EU_timeout", timeout-1)
					     end
					  end

--------------------------------------------------
-- Functions to traverse the electrical network
--------------------------------------------------

-- Add a wire node to the LV/MV/HV network
local add_new_cable_node = function(nodes,pos)
			      local i = 1
			      repeat
				 if nodes[i]==nil then break end
				 if pos.x==nodes[i].x and pos.y==nodes[i].y and pos.z==nodes[i].z then return false end
				 i=i+1
			      until false
			      nodes[i] = {x=pos.x, y=pos.y, z=pos.z, visited=1} -- copy position
			      return true
			   end

-- Generic function to add found connected nodes to the right classification array
local check_node_subp = function(PR_nodes,RE_nodes,BA_nodes,all_nodes,pos,machines,cablename)
			   local meta = minetest.env:get_meta(pos)
			   local name = minetest.env:get_node(pos).name
			   if meta:get_float(cablename)==1 then
			      add_new_cable_node(all_nodes,pos)
			   elseif machines[name] then
			      --dprint(name.." is a "..machines[name])
			      if     machines[name] == "PR" then
				 add_new_cable_node(PR_nodes,pos)
			      elseif machines[name] == "RE" then
				 add_new_cable_node(RE_nodes,pos)
			      elseif machines[name] == "BA" then
				 add_new_cable_node(BA_nodes,pos)
			      end
			      if cablename == "cablelike" then
				 meta:set_int("LV_EU_timeout", 2) -- Touch node
			      elseif cablename == "mv_cablelike" then
				 meta:set_int("MV_EU_timeout", 2) -- Touch node
			      elseif cablename == "hv_cablelike" then
				 meta:set_int("HV_EU_timeout", 2) -- Touch node
			      end
			   end
			end

-- Traverse a network given a list of machines and a cable type name
local traverse_network = function(PR_nodes,RE_nodes,BA_nodes,all_nodes, i, machines, cablename)
			    local pos = {x=all_nodes[i].x, y=all_nodes[i].y, z=all_nodes[i].z} -- copy position
			    pos.x=pos.x+1
			    check_node_subp(PR_nodes,RE_nodes,BA_nodes,all_nodes,pos, machines, cablename)
			    pos.x=pos.x-2
			    check_node_subp(PR_nodes,RE_nodes,BA_nodes,all_nodes,pos, machines, cablename)
			    pos.x=pos.x+1
			    
			    pos.y=pos.y+1
			    check_node_subp(PR_nodes,RE_nodes,BA_nodes,all_nodes,pos, machines, cablename)
			    pos.y=pos.y-2
			    check_node_subp(PR_nodes,RE_nodes,BA_nodes,all_nodes,pos, machines, cablename)
			    pos.y=pos.y+1
			    
			    pos.z=pos.z+1
			    check_node_subp(PR_nodes,RE_nodes,BA_nodes,all_nodes,pos, machines, cablename)
			    pos.z=pos.z-2
			    check_node_subp(PR_nodes,RE_nodes,BA_nodes,all_nodes,pos, machines, cablename)
			    pos.z=pos.z+1
		      end

----------------------------------------------
-- The action code for the switching station
----------------------------------------------
minetest.register_abm(
	{nodenames = {"technic:switching_station"},
	interval   = 1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		    local meta             = minetest.env:get_meta(pos)
		    local meta1            = nil
		    local pos1             = {}
		    local PR_EU            = 0 -- EUs from PR nodes
		    local BA_PR_EU         = 0 -- EUs from BA nodes (discharching)
		    local BA_RE_EU         = 0 -- EUs to BA nodes (charging)
		    local RE_EU            = 0 -- EUs to RE nodes

		    local network   = ""
		    local all_nodes = {}
		    local PR_nodes  = {}
		    local BA_nodes  = {} 
		    local RE_nodes  = {}

--		    -- Possible to turn off the entire network
--		    if meta:get_int("active") == 0 then
--		       for _,pos1 in pairs(RE_nodes) do
--			  meta1  = minetest.env:get_meta(pos1)
--			  meta1:set_int("EU_input", 0)
--		       end
--		       for _,pos1 in pairs(BA_nodes) do
--			  meta1  = minetest.env:get_meta(pos1)
--			  meta1:set_int("EU_input", 0)
--		       end
--		       return
--		    end

		    -- Which kind of network are we on:
		    pos1 = {x=pos.x, y=pos.y-1, z=pos.z}
		    all_nodes[1] = pos1

		    meta1  = minetest.env:get_meta(pos1)
		    if meta1:get_float("cablelike") ==1 then
		       -- LV type
		       --dprint("LV type")
		       network = "LV"
		       local table_index = 1
		       repeat
			  traverse_network(PR_nodes,RE_nodes,BA_nodes,all_nodes,table_index, technic.LV_machines, "cablelike")
			  table_index = table_index + 1
			  if all_nodes[table_index] == nil then break end
		       until false
		    elseif meta1:get_float("mv_cablelike") ==1 then
		       -- MV type
		       --dprint("MV type")
		       network = "MV"
		       local table_index = 1
		       repeat
			  traverse_network(PR_nodes,RE_nodes,BA_nodes,all_nodes,table_index, technic.MV_machines, "mv_cablelike")
			  table_index = table_index + 1
			  if all_nodes[table_index] == nil then break end
		       until false
		    elseif meta1:get_float("hv_cablelike") ==1 then
		       -- HV type
		       --dprint("HV type")
		       network = "HV"
		       local table_index = 1
		       repeat
			  traverse_network(PR_nodes,RE_nodes,BA_nodes,all_nodes,table_index, technic.HV_machines, "hv_cablelike")
			  table_index = table_index + 1
			  if all_nodes[table_index] == nil then break end
		       until false
		    else
		       -- No type :-)
		       --dprint("Not connected to a network")
		       meta:set_string("infotext", "Switching Station - no network")
		       return
		    end
		    --dprint("nodes="..table.getn(all_nodes).." PR="..table.getn(PR_nodes).." BA="..table.getn(BA_nodes).." RE="..table.getn(RE_nodes))

		    -- Strings for the meta data
		    local eu_demand_str    = network.."_EU_demand"
		    local eu_input_str     = network.."_EU_input"
		    local eu_supply_str    = network.."_EU_supply"
		    local eu_from_fuel_str = network.."_EU_from_fuel"

		    -- Get all the power from the PR nodes
		    local PR_eu_supply = 0 -- Total power
		    for _,pos1 in pairs(PR_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       PR_eu_supply = PR_eu_supply + meta1:get_int(eu_supply_str)
		    end
		    --dprint("Total PR supply:"..PR_eu_supply)

		    -- Get all the demand from the RE nodes
		    local RE_eu_demand = 0
		    for _,pos1 in pairs(RE_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       RE_eu_demand = RE_eu_demand + meta1:get_int(eu_demand_str)
		    end
		    --dprint("Total RE demand:"..RE_eu_demand)

		    -- Get all the power from the BA nodes
		    local BA_eu_supply = 0
		    for _,pos1 in pairs(BA_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       BA_eu_supply = BA_eu_supply + meta1:get_int(eu_supply_str)
		    end
		    --dprint("Total BA supply:"..BA_eu_supply)

		    -- Get all the demand from the BA nodes
		    local BA_eu_demand = 0
		    for _,pos1 in pairs(BA_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       BA_eu_demand = BA_eu_demand + meta1:get_int(eu_demand_str)
		    end
		    --dprint("Total BA demand:"..BA_eu_demand)

		    meta:set_string("infotext", "Switching Station. PR("..(PR_eu_supply+BA_eu_supply)..") RE("..(RE_eu_demand+BA_eu_demand)..")")

		    -- If the PR supply is enough for the RE demand supply them all
		    if PR_eu_supply >= RE_eu_demand then
		       --dprint("PR_eu_supply"..PR_eu_supply.." >= RE_eu_demand"..RE_eu_demand)
		       for _,pos1 in pairs(RE_nodes) do
			  meta1  = minetest.env:get_meta(pos1)
			  local eu_demand = meta1:get_int(eu_demand_str)
			  meta1:set_int(eu_input_str, eu_demand)
		       end
		       -- We have a surplus, so distribute the rest equally to the BA nodes
		       -- Let's calculate the factor of the demand
		       PR_eu_supply = PR_eu_supply - RE_eu_demand
		       local charge_factor = 0 -- Assume all batteries fully charged
		       if BA_eu_demand > 0 then
			  charge_factor = PR_eu_supply / BA_eu_demand
		       end
		       for n,pos1 in pairs(BA_nodes) do
			  meta1  = minetest.env:get_meta(pos1)
			  local eu_demand = meta1:get_int(eu_demand_str)
			  meta1:set_int(eu_input_str, math.floor(eu_demand*charge_factor))
			  --dprint("Charging battery:"..math.floor(eu_demand*charge_factor))
		       end
		       -- If still a surplus we can start giving back to the fuel burning generators
		       -- Only full EU packages are given back. The rest is wasted.
		       if BA_eu_demand == 0 then
			  for _,pos1 in pairs(PR_nodes) do
			     meta1  = minetest.env:get_meta(pos1)
			     if meta1:get_int(eu_from_fuel_str) == 1 then
				local eu_supply = meta1:get_int(eu_supply_str)
				if PR_eu_supply < eu_supply then
				   break
				else
				   -- Set the supply to 0 if we did not require it.
				   meta1:set_int(eu_supply_str, 0)
				   PR_eu_supply = PR_eu_supply - eu_supply
				end
			     end
			  end
		       end
		       return
		    end

		    -- If the PR supply is not enough for the RE demand we will discharge the batteries too
		    if PR_eu_supply+BA_eu_supply >= RE_eu_demand then
		       --dprint("PR_eu_supply "..PR_eu_supply.."+BA_eu_supply "..BA_eu_supply.." >= RE_eu_demand"..RE_eu_demand)
		       for _,pos1 in pairs(RE_nodes) do
			  meta1  = minetest.env:get_meta(pos1)
			  local eu_demand = meta1:get_int(eu_demand_str)
			  meta1:set_int(eu_input_str, eu_demand)
		       end
		       -- We have a deficit, so distribute to the BA nodes
		       -- Let's calculate the factor of the supply
		       local charge_factor = 0 -- Assume all batteries depleted
		       if BA_eu_supply > 0 then
			  charge_factor = (PR_eu_supply - RE_eu_demand) / BA_eu_supply
		       end
		       for n,pos1 in pairs(BA_nodes) do
			  meta1  = minetest.env:get_meta(pos1)
			  local eu_supply = meta1:get_int(eu_supply_str)
			  meta1:set_int(eu_input_str, math.floor(eu_supply*charge_factor))
			  --dprint("Discharging battery:"..math.floor(eu_supply*charge_factor))
		       end
		       return
		    end

		    -- If the PR+BA supply is not enough for the RE demand: Shut everything down!
		    -- Note: another behaviour could also be imagined: provide the average power for all and let the node decide what happens.
		    -- This is much simpler though: Not enough power for all==no power for all
		    --print("NO POWER")
		    for _,pos1 in pairs(RE_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       meta1:set_int(eu_input_str, 0)
		    end
	end,
})
