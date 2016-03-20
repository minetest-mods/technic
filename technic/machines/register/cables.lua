
local S = technic.getter

local cable_tier = {}

function technic.is_tier_cable(name, tier)
	return cable_tier[name] == tier
end

function technic.get_cable_tier(name)
	return cable_tier[name]
end

local function clear_networks()
	technic.networks = {}
end

function technic.register_cable(tier, size)
	local ltier = string.lower(tier)
	cable_tier["technic:"..ltier.."_cable"] = tier

	local groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2}

	local node_box = {
		type = "connected",
		fixed          = {-size, -size, -size, size,  size, size},
		connect_top    = {-size, -size, -size, size,  0.5,  size}, -- y+
		connect_bottom = {-size, -0.5,  -size, size,  size, size}, -- y-
		connect_front  = {-size, -size, -0.5,  size,  size, size}, -- z-
		connect_back   = {-size, -size,  size, size,  size, 0.5 }, -- z+
		connect_left   = {-0.5,  -size, -size, size,  size, size}, -- x-
		connect_right  = {-size, -size, -size, 0.5,   size, size}, -- x+
	}

	minetest.register_node("technic:"..ltier.."_cable", {
		description = S("%s Cable"):format(tier),
		tiles = {"technic_"..ltier.."_cable.png"},
		inventory_image = "technic_"..ltier.."_cable_wield.png",
		wield_image = "technic_"..ltier.."_cable_wield.png",
		groups = groups,
		sounds = default.node_sound_wood_defaults(),
		drop = "technic:"..ltier.."_cable",
		paramtype = "light",
		sunlight_propagates = true,
		drawtype = "nodebox",
		node_box = node_box,
		connects_to = {"technic:"..ltier.."_cable",
			"group:technic_"..ltier, "group:technic_all_tiers"},
		on_construct = clear_networks,
		on_destruct = clear_networks,
	})
end


local function clear_nets_if_machine(pos, node)
	for tier, machine_list in pairs(technic.machines) do
		if machine_list[node.name] ~= nil then
			return clear_networks()
		end
	end
end

minetest.register_on_placenode(clear_nets_if_machine)
minetest.register_on_dignode(clear_nets_if_machine)

