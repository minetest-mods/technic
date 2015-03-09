
local S = technic.getter

local cable_itstr_to_tier = {}

function technic.register_cable(tier, size)
	local ltier = string.lower(tier)

	for x1 = 0, 1 do
	for x2 = 0, 1 do
	for y1 = 0, 1 do
	for y2 = 0, 1 do
	for z1 = 0, 1 do
	for z2 = 0, 1 do
		local id = technic.get_cable_id({x1, x2, y1, y2, z1, z2})

		cable_itstr_to_tier["technic:"..ltier.."_cable"..id] = tier

		local groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2}
		if id ~= 0 then
			groups.not_in_creative_inventory = 1
		end

		minetest.register_node("technic:"..ltier.."_cable"..id, {
			description = S("%s Cable"):format(tier),
			tiles = {"technic_"..ltier.."_cable.png"},
			inventory_image = "technic_"..ltier.."_cable_wield.png",
			wield_image = "technic_"..ltier.."_cable_wield.png",
			groups = groups,
			sounds = default.node_sound_wood_defaults(),
			drop = "technic:"..ltier.."_cable0",
			paramtype = "light",
			sunlight_propagates = true,
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = technic.gen_cable_nodebox(x1, y1, z1, x2, y2, z2, size)
			},
			on_construct = function()
				technic.networks = {}
			end,
			on_destruct = function()
				technic.networks = {}
			end,
			after_place_node = function(pos)
				local node = minetest.get_node(pos)
				technic.update_cables(pos, technic.get_cable_tier(node.name))
			end,
			after_dig_node = function(pos, oldnode)
				local tier = technic.get_cable_tier(oldnode.name)
				technic.update_cables(pos, tier, true)
			end
		})
	end
	end
	end
	end
	end
	end
end

minetest.register_on_placenode(function(pos, node)
	for tier, machine_list in pairs(technic.machines) do
		if machine_list[node.name] ~= nil then
			technic.update_cables(pos, tier, true)
			technic.networks = {}
		end
	end
end)


minetest.register_on_dignode(function(pos, node)
	for tier, machine_list in pairs(technic.machines) do
		if machine_list[node.name] ~= nil then
			technic.update_cables(pos, tier, true)
			technic.networks = {}
		end
	end
end)

function technic.get_cable_id(links)
	return (links[6] * 1) + (links[5] * 2)
			+ (links[4] * 4)  + (links[3] * 8)
			+ (links[2] * 16) + (links[1] * 32)
end

function technic.update_cables(pos, tier, no_set, secondrun)
	local link_positions = {
		{x=pos.x+1, y=pos.y,   z=pos.z},
		{x=pos.x-1, y=pos.y,   z=pos.z},
		{x=pos.x,   y=pos.y+1, z=pos.z},
		{x=pos.x,   y=pos.y-1, z=pos.z},
		{x=pos.x,   y=pos.y,   z=pos.z+1},
		{x=pos.x,   y=pos.y,   z=pos.z-1}}

	local links = {0, 0, 0, 0, 0, 0}

	for i, link_pos in pairs(link_positions) do
		local connect_type = technic.cables_should_connect(pos, link_pos, tier)
		if connect_type then
			links[i] = 1
			-- Have cables next to us update theirselves,
			-- but only once. (We don't want to update the entire
			-- network or start an infinite loop of updates)
			if not secondrun and connect_type == "cable" then
				technic.update_cables(link_pos, tier, false, true)
			end
		end
	end
	-- We don't want to set ourselves if we have been removed or we are
	-- updating a machine
	if not no_set then
		minetest.set_node(pos, {name="technic:"..string.lower(tier)
				.."_cable"..technic.get_cable_id(links)})

	end
end


function technic.is_tier_cable(name, tier)
	return cable_itstr_to_tier[name] and cable_itstr_to_tier[name] == tier
end


function technic.get_cable_tier(name)
	return cable_itstr_to_tier[name]
end


function technic.cables_should_connect(pos1, pos2, tier)
	local name = minetest.get_node(pos2).name

	if name == "technic:switching_station" then
		return pos2.y == pos1.y + 1 and "machine" or false
	elseif name == "technic:supply_converter" then
		return math.abs(pos2.y - pos1.y) == 1 and "machine" or false
	elseif technic.is_tier_cable(name, tier) then
		return "cable"
	elseif technic.machines[tier][name] then
		return "machine"
	end
	return false
end


function technic.gen_cable_nodebox(x1, y1, z1, x2, y2, z2, size)
	-- Nodeboxes
	local box_center = {-size, -size, -size, size,  size, size}
	local box_y1 =     {-size, -size, -size, size,  0.5,  size} -- y+
	local box_x1 =     {-size, -size, -size, 0.5,   size, size} -- x+
	local box_z1 =     {-size, -size,  size, size,  size, 0.5}  -- z+
	local box_z2 =     {-size, -size, -0.5,  size,  size, size} -- z-
	local box_y2 =     {-size, -0.5,  -size, size,  size, size} -- y-
	local box_x2 =     {-0.5,  -size, -size, size,  size, size} -- x-

	local box = {box_center}
	if x1 == 1 then
		table.insert(box, box_x1)
	end
	if y1 == 1 then
		table.insert(box, box_y1)
	end
	if z1 == 1 then
		table.insert(box, box_z1)
	end
	if x2 == 1 then
		table.insert(box, box_x2)
	end
	if y2 == 1 then
		table.insert(box, box_y2)
	end
	if z2 == 1 then
		table.insert(box, box_z2)
	end
	return box
end

