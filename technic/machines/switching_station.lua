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

minetest.register_craft({
	output = "technic:switching_station",
	recipe = {
		{"default:steel_ingot",  "technic:lv_transformer", "default:steel_ingot"},
		{"default:copper_ingot", "technic:lv_cable0",      "default:copper_ingot"},
		{"default:steel_ingot",  "technic:lv_cable0",      "default:steel_ingot"}
	}
})

minetest.register_node("technic:switching_station",{
	description = "Switching Station",
	tiles  = {"technic_water_mill_top_active.png", "technic_water_mill_top_active.png",
                  "technic_water_mill_top_active.png", "technic_water_mill_top_active.png",
	          "technic_water_mill_top_active.png", "technic_water_mill_top_active.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Switching Station")
	end,
})

--------------------------------------------------
-- Functions to help the machines on the electrical network
--------------------------------------------------
-- This one provides a timeout for a node in case it was disconnected from the network
-- A node must be touched by the station continuously in order to function
function technic.switching_station_timeout_count(pos, tier)
	local meta = minetest.get_meta(pos)
	timeout = meta:get_int(tier.."_EU_timeout")
	if timeout == 0 then
		meta:set_int(tier.."_EU_input", 0)
	else
		meta:set_int(tier.."_EU_timeout", timeout - 1)
	end
end

--------------------------------------------------
-- Functions to traverse the electrical network
--------------------------------------------------

-- Add a wire node to the LV/MV/HV network
local add_new_cable_node = function(nodes, pos)
	-- Ignore if the node has already been added
	for i = 1, #nodes do
		if pos.x == nodes[i].x and
		   pos.y == nodes[i].y and
		   pos.z == nodes[i].z then
			return false
		end
	end
	table.insert(nodes, {x=pos.x, y=pos.y, z=pos.z, visited=1})
	return true
end

-- Generic function to add found connected nodes to the right classification array
local check_node_subp = function(PR_nodes, RE_nodes, BA_nodes, all_nodes, pos, machines, tier)
	local meta = minetest.get_meta(pos)
	local name = minetest.get_node(pos).name

	if technic.is_tier_cable(name, tier) then
		add_new_cable_node(all_nodes, pos)
	elseif machines[name] then
		--dprint(name.." is a "..machines[name])
		if     machines[name] == technic.producer then
			add_new_cable_node(PR_nodes, pos)
		elseif machines[name] == technic.receiver then
			add_new_cable_node(RE_nodes, pos)
		elseif machines[name] == technic.battery then
			add_new_cable_node(BA_nodes, pos)
		end

		meta:set_int(tier.."_EU_timeout", 2) -- Touch node
	end
end

-- Traverse a network given a list of machines and a cable type name
local traverse_network = function(PR_nodes, RE_nodes, BA_nodes, all_nodes, i, machines, tier)
	local pos = all_nodes[i]
	local positions = {
		{x=pos.x+1, y=pos.y,   z=pos.z},
		{x=pos.x-1, y=pos.y,   z=pos.z},
		{x=pos.x,   y=pos.y+1, z=pos.z},
		{x=pos.x,   y=pos.y-1, z=pos.z},
		{x=pos.x,   y=pos.y,   z=pos.z+1},
		{x=pos.x,   y=pos.y,   z=pos.z-1}}
	--print("ON")
	for i, cur_pos in pairs(positions) do
		check_node_subp(PR_nodes, RE_nodes, BA_nodes, all_nodes, cur_pos, machines, tier)
	end
end

-----------------------------------------------
-- The action code for the switching station --
-----------------------------------------------
minetest.register_abm({
	nodenames = {"technic:switching_station"},
	interval   = 1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta             = minetest.get_meta(pos)
		local meta1            = nil
		local pos1             = {}
		local PR_EU            = 0 -- EUs from PR nodes
		local BA_PR_EU         = 0 -- EUs from BA nodes (discharching)
		local BA_RE_EU         = 0 -- EUs to BA nodes (charging)
		local RE_EU            = 0 -- EUs to RE nodes

		local tier      = ""
		local all_nodes = {}
		local PR_nodes  = {}
		local BA_nodes  = {} 
		local RE_nodes  = {}

		-- Which kind of network are we on:
		pos1 = {x=pos.x, y=pos.y-1, z=pos.z}
		all_nodes[1] = pos1

		local name = minetest.get_node(pos1).name
		local tier = technic.get_cable_tier(name)
		if tier then
			local i = 1
			repeat
				traverse_network(PR_nodes, RE_nodes, BA_nodes, all_nodes,
						i, technic.machines[tier], tier)
				i = i + 1
			until all_nodes[i] == nil
		else
			--dprint("Not connected to a network")
			meta:set_string("infotext", "Switching Station - no network")
			return
		end
		--dprint("nodes="..table.getn(all_nodes)
		--		.." PR="..table.getn(PR_nodes)
		--		.." BA="..table.getn(BA_nodes)
		--		.." RE="..table.getn(RE_nodes))

		-- Strings for the meta data
		local eu_demand_str    = tier.."_EU_demand"
		local eu_input_str     = tier.."_EU_input"
		local eu_supply_str    = tier.."_EU_supply"

		-- Get all the power from the PR nodes
		local PR_eu_supply = 0 -- Total power
		for _, pos1 in pairs(PR_nodes) do
			meta1 = minetest.get_meta(pos1)
			PR_eu_supply = PR_eu_supply + meta1:get_int(eu_supply_str)
		end
		--dprint("Total PR supply:"..PR_eu_supply)

		-- Get all the demand from the RE nodes
		local RE_eu_demand = 0
		for _, pos1 in pairs(RE_nodes) do
			meta1 = minetest.get_meta(pos1)
			RE_eu_demand = RE_eu_demand + meta1:get_int(eu_demand_str)
		end
		--dprint("Total RE demand:"..RE_eu_demand)

		-- Get all the power from the BA nodes
		local BA_eu_supply = 0
		for _, pos1 in pairs(BA_nodes) do
			meta1 = minetest.get_meta(pos1)
			BA_eu_supply = BA_eu_supply + meta1:get_int(eu_supply_str)
		end
		--dprint("Total BA supply:"..BA_eu_supply)

		-- Get all the demand from the BA nodes
		local BA_eu_demand = 0
		for _, pos1 in pairs(BA_nodes) do
			meta1 = minetest.get_meta(pos1)
			BA_eu_demand = BA_eu_demand + meta1:get_int(eu_demand_str)
		end
		--dprint("Total BA demand:"..BA_eu_demand)

		meta:set_string("infotext",
				"Switching Station. Supply: "..PR_eu_supply
				.." Demand: "..RE_eu_demand)

		-- If the PR supply is enough for the RE demand supply them all
		if PR_eu_supply >= RE_eu_demand then
		--dprint("PR_eu_supply"..PR_eu_supply.." >= RE_eu_demand"..RE_eu_demand)
			for _, pos1 in pairs(RE_nodes) do
				meta1 = minetest.get_meta(pos1)
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
			for n, pos1 in pairs(BA_nodes) do
				meta1 = minetest.get_meta(pos1)
				local eu_demand = meta1:get_int(eu_demand_str)
				meta1:set_int(eu_input_str, math.floor(eu_demand * charge_factor))
				--dprint("Charging battery:"..math.floor(eu_demand*charge_factor))
			end
			return
		end

		-- If the PR supply is not enough for the RE demand we will discharge the batteries too
		if PR_eu_supply + BA_eu_supply >= RE_eu_demand then
			--dprint("PR_eu_supply "..PR_eu_supply.."+BA_eu_supply "..BA_eu_supply.." >= RE_eu_demand"..RE_eu_demand)
			for _, pos1 in pairs(RE_nodes) do
				meta1  = minetest.get_meta(pos1)
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
				meta1 = minetest.get_meta(pos1)
				local eu_supply = meta1:get_int(eu_supply_str)
				meta1:set_int(eu_input_str, math.floor(eu_supply * charge_factor))
				--dprint("Discharging battery:"..math.floor(eu_supply*charge_factor))
			end
			return
		end

		-- If the PR+BA supply is not enough for the RE demand: Power only the batteries
		local charge_factor = 0 -- Assume all batteries fully charged
		if BA_eu_demand > 0 then
			charge_factor = PR_eu_supply / BA_eu_demand
		end
		for n, pos1 in pairs(BA_nodes) do
			meta1 = minetest.get_meta(pos1)
			local eu_demand = meta1:get_int(eu_demand_str)
			meta1:set_int(eu_input_str, math.floor(eu_demand * charge_factor))
		end
		for n, pos1 in pairs(RE_nodes) do
			meta1 = minetest.get_meta(pos1)
			meta1:set_int(eu_input_str, 0)
		end
	end,
})

for tier, machines in pairs(technic.machines) do
	-- SPECIAL will not be traversed
	technic.register_machine(tier, "technic:switching_station", "SPECIAL")
end

