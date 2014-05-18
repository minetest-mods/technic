
local S = technic.getter

minetest.register_craft({
	recipe = {
		{"technic:carbon_steel_block", "pipeworks:filter",           "technic:carbon_steel_block"},
		{"technic:carbon_steel_block", "technic:motor",              "technic:carbon_steel_block"},
		{"technic:carbon_steel_block", "technic:diamond_drill_head", "technic:carbon_steel_block"}},
	output = "technic:quarry",
})

local quarry_dig_above_nodes = 3 -- How far above the quarry we will dig nodes
local quarry_max_depth       = 100

local function get_quarry_formspec(size)
	return "size[3,1.5]"..
		"field[1,0.5;2,1;size;Radius;"..size.."]"..
		"button[0,1;3,1;toggle;"..S("Enable/Disable").."]"
end

local function quarry_receive_fields(pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)
	local size = tonumber(fields.size) or 0

	if fields.toggle then
		if meta:get_int("enabled") == 0 then
			meta:set_int("enabled", 1)
		else
			meta:set_int("enabled", 0)
		end
	end

	-- Smallest size is 2. Largest is 8.
	size = math.max(size, 2)
	size = math.min(size, 8)

	if meta:get_int("size") ~= size then
		meta:set_int("size", size)
		meta:set_string("formspec", get_quarry_formspec(size))
	end
end

local function get_quarry_center(pos, size)
	local node     = minetest.get_node(pos)
	local back_dir = minetest.facedir_to_dir(node.param2)
	local relative_center = vector.multiply(back_dir, size + 1)
	local center = vector.add(pos, relative_center)
	return center
end

local function gen_next_digpos(center, digpos, size)
	digpos.x = digpos.x + 1
	if digpos.x > center.x + size then
		digpos.x = center.x - size
		digpos.z = digpos.z + 1
	end
	if digpos.z > center.z + size then
		digpos.x = center.x - size
		digpos.z = center.z - size
		digpos.y = digpos.y - 1
	end
end

local function find_next_digpos(data, area, center, dig_y, size)
	local c_air = minetest.get_content_id("air")

	for y = center.y + quarry_dig_above_nodes, dig_y - 1, -1 do
	for z = center.z - size, center.z + size do
	for x = center.x - size, center.x + size do
		if data[area:index(x, y, z)] ~= c_air then
			return vector.new(x, y, z)
		end
	end
	end
	end
end

local function quarry_dig(pos, center, size)
	local meta = minetest.get_meta(pos)
	local drops = {}
	local dig_y = meta:get_int("dig_y")
	local owner = meta:get_string("owner")

	local vm = VoxelManip()
	local p1 = vector.new(
			center.x - size,
			center.y + quarry_dig_above_nodes,
			center.z - size)
	local p2 = vector.new(
			center.x + size,
			dig_y - 1, -- One node lower in case we have finished the current layer
			center.z + size)
	local e1, e2 = vm:read_from_map(p1, p2)
	local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local data = vm:get_data()

	local digpos = find_next_digpos(data, area, center, dig_y, size)

	if digpos then
		if digpos.y < pos.y - quarry_max_depth then
			meta:set_int("dig_y", digpos.y)
			return drops
		end
		if minetest.is_protected and minetest.is_protected(digpos, owner) then
			meta:set_int("enabled", 0)
			return {}
		end
		dig_y = digpos.y
		local node = minetest.get_node(digpos)
		local node_def = minetest.registered_nodes[node.name] or { diggable = false }
		if node_def.diggable and ((not node_def.can_dig) or node_def.can_dig(digpos, nil)) then
			minetest.remove_node(digpos)
			drops = minetest.get_node_drops(node.name, "")
		end
	elseif not (dig_y < pos.y - quarry_max_depth) then
		dig_y = dig_y - 16
	end

	meta:set_int("dig_y", dig_y)
	return drops
end

local function send_items(items, pos, node)
	for _, item in pairs(items) do
		local tube_item = pipeworks.tube_item(vector.new(pos), item)
		tube_item:get_luaentity().start_pos = vector.new(pos)
		tube_item:setvelocity(vector.new(0, 1, 0))
		tube_item:setacceleration({x=0, y=0, z=0})
	end
end

minetest.register_node("technic:quarry", {
	description = S("Quarry"),
	tiles = {"technic_carbon_steel_block.png", "technic_carbon_steel_block.png",
	         "technic_carbon_steel_block.png", "technic_carbon_steel_block.png",
	         "technic_carbon_steel_block.png^default_tool_mesepick.png", "technic_carbon_steel_block.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1},
	tube = {
		connect_sides = {top = 1},
	},
	on_construct = function(pos)
		local size = 4
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Quarry"))
		meta:set_string("formspec", get_quarry_formspec(4))
		meta:set_int("size", size)
		meta:set_int("dig_y", pos.y)
	end,
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		pipeworks.scan_for_tube_objects(pos)
	end,
	after_dig_node = pipeworks.scan_for_tube_objects,
	on_receive_fields = quarry_receive_fields,
})

minetest.register_abm({
	nodenames = {"technic:quarry"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local size = meta:get_int("size")
		local eu_input = meta:get_int("HV_EU_input")
		local demand = 10000
		local center = get_quarry_center(pos, size)
		local dig_y = meta:get_int("dig_y")
		local machine_name = S("Quarry")

		technic.switching_station_timeout_count(pos, "HV")

		if meta:get_int("enabled") == 0 then
			meta:set_string("infotext", S("%s Disabled"):format(machine_name))
			meta:set_int("HV_EU_demand", 0)
			return
		end

		if eu_input < demand then
			meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
		elseif eu_input >= demand then
			meta:set_string("infotext", S("%s Active"):format(machine_name))

			local items = quarry_dig(pos, center, size)
			send_items(items, pos, node)

			if dig_y < pos.y - quarry_max_depth then
				meta:set_string("infotext", S("%s Finished"):format(machine_name))
			end
		end
		meta:set_int("HV_EU_demand", demand)
	end
})

technic.register_machine("HV", "technic:quarry", technic.receiver)

