local S = technic.getter

local cable_tier = {}

function technic.is_tier_cable(name, tier)
	return cable_tier[name] == tier
end

function technic.get_cable_tier(name)
	return cable_tier[name]
end

local function check_connections(pos)
	-- Build a table of all machines
	local machines = {}
	for tier, list in pairs(technic.machines) do
		for k, v in pairs(list) do
			machines[k] = v
		end
	end
	local connections = {}
	local positions = {
		{ x = pos.x + 1, y = pos.y, z = pos.z },
		{ x = pos.x - 1, y = pos.y, z = pos.z },
		{ x = pos.x, y = pos.y + 1, z = pos.z },
		{ x = pos.x, y = pos.y - 1, z = pos.z },
		{ x = pos.x, y = pos.y, z = pos.z + 1 },
		{ x = pos.x, y = pos.y, z = pos.z - 1 }
	}
	for _, connected_pos in pairs(positions) do
		local name = minetest.get_node(connected_pos).name
		if machines[name] or technic.get_cable_tier(name) then
			table.insert(connections, connected_pos)
		end
	end
	return connections
end

local function clear_networks(pos)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local placed = node.name ~= "air"
	local positions = check_connections(pos)
	if #positions < 1 then return end
	local dead_end = #positions == 1
	for _, connected_pos in pairs(positions) do
		local net = technic.cables[minetest.hash_node_position(connected_pos)]
		if net and technic.networks[net] then
			if dead_end and placed then
				-- Dead end placed, add it to the network
				-- Get the network
				local network_id = technic.cables[minetest.hash_node_position(positions[1])]
				if not network_id then
					-- We're evidently not on a network, nothing to add ourselves to
					return
				end
				local sw_pos = minetest.get_position_from_hash(network_id)
				sw_pos.y = sw_pos.y + 1
				local network = technic.networks[network_id]
				local tier = network.tier

				-- Actually add it to the (cached) network
				-- This is similar to check_node_subp
				technic.cables[minetest.hash_node_position(pos)] = network_id
				pos.visited = 1
				if technic.is_tier_cable(name, tier) then
					table.insert(network.all_nodes, pos)
				elseif technic.machines[tier][node.name] then
					meta:set_string(tier .. "_network", minetest.pos_to_string(sw_pos))
					if technic.machines[tier][node.name] == technic.producer then
						table.insert(network.PR_nodes, pos)
					elseif technic.machines[tier][node.name] == technic.receiver then
						table.insert(network.RE_nodes, pos)
					elseif technic.machines[tier][node.name] == technic.producer_receiver then
						table.insert(network.PR_nodes, pos)
						table.insert(network.RE_nodes, pos)
					elseif technic.machines[tier][node.name] == "SPECIAL" and
							(pos.x ~= sw_pos.x or pos.y ~= sw_pos.y or pos.z ~= sw_pos.z) and
							from_below then
						table.insert(network.SP_nodes, pos)
					elseif technic.machines[tier][node.name] == technic.battery then
						table.insert(network.BA_nodes, pos)
					end
				end
			elseif dead_end and not placed then
				-- Dead end removed, remove it from the network
				-- Get the network
				local network_id = technic.cables[minetest.hash_node_position(positions[1])]
				if not network_id then
					-- We're evidently not on a network, nothing to add ourselves to
					return
				end
				local network = technic.networks[network_id]

				-- Search for and remove machine
				technic.cables[minetest.hash_node_position(pos)] = nil
				for tblname, table in pairs(network) do
					if tblname ~= "tier" then
						for machinenum, machine in pairs(table) do
							if machine.x == pos.x
									and machine.y == pos.y
									and machine.z == pos.z then
								table[machinenum] = nil
							end
						end
					end
				end
			else
				-- Not a dead end, so the whole network needs to be recalculated
				for _, v in pairs(technic.networks[net].all_nodes) do
					local pos1 = minetest.hash_node_position(v)
					technic.cables[pos1] = nil
				end
				technic.networks[net] = nil
			end
		end
	end
end

function technic.register_cable(tier, size)
	local ltier = string.lower(tier)
	cable_tier["technic:" .. ltier .. "_cable"] = tier

	local groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 }

	local node_box = {
		type = "connected",
		fixed = { -size, -size, -size, size, size, size },
		connect_top = { -size, -size, -size, size, 0.5, size }, -- y+
		connect_bottom = { -size, -0.5, -size, size, size, size }, -- y-
		connect_front = { -size, -size, -0.5, size, size, size }, -- z-
		connect_back = { -size, -size, size, size, size, 0.5 }, -- z+
		connect_left = { -0.5, -size, -size, size, size, size }, -- x-
		connect_right = { -size, -size, -size, 0.5, size, size }, -- x+
	}

	minetest.register_node("technic:" .. ltier .. "_cable", {
		description = S("%s Cable"):format(tier),
		tiles = { "technic_" .. ltier .. "_cable.png" },
		inventory_image = "technic_" .. ltier .. "_cable_wield.png",
		wield_image = "technic_" .. ltier .. "_cable_wield.png",
		groups = groups,
		sounds = default.node_sound_wood_defaults(),
		drop = "technic:" .. ltier .. "_cable",
		paramtype = "light",
		sunlight_propagates = true,
		drawtype = "nodebox",
		node_box = node_box,
		connects_to = {
			"technic:" .. ltier .. "_cable",
			"group:technic_" .. ltier, "group:technic_all_tiers"
		},
		on_construct = clear_networks,
		on_destruct = clear_networks,
	})
end


local function clear_nets_if_machine(pos, node)
	for tier, machine_list in pairs(technic.machines) do
		if machine_list[node.name] ~= nil then
			return clear_networks(pos)
		end
	end
end

minetest.register_on_placenode(clear_nets_if_machine)
minetest.register_on_dignode(clear_nets_if_machine)

