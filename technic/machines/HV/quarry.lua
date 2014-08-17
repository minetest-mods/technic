
local S = technic.getter

minetest.register_craft({
	recipe = {
		{"technic:carbon_plate",       "pipeworks:filter",       "technic:composite_plate"},
		{"technic:motor",              "technic:machine_casing", "technic:diamond_drill_head"},
		{"technic:carbon_steel_block", "technic:hv_cable0",      "technic:carbon_steel_block"}},
	output = "technic:quarry",
})

local quarry_dig_above_nodes = 3 -- How far above the quarry we will dig nodes
local quarry_max_depth       = 100
local quarry_demand = 10000

local function set_quarry_formspec(meta)
	local radius = meta:get_int("size")
	local formspec = "size[6,2.5]"..
		"item_image[0,0;1,1;technic:quarry]"..
		"label[1,0;"..S("%s Quarry"):format("HV").."]"..
		"field[0.3,1.5;2,1;size;"..S("Radius:")..";"..radius.."]"
	if meta:get_int("enabled") == 0 then
		formspec = formspec.."button[4,1.2;2,1;enable;"..S("Disabled").."]"
	else
		formspec = formspec.."button[4,1.2;2,1;disable;"..S("Enabled").."]"
	end
	local diameter = radius*2 + 1
	local nd = meta:get_int("dug")
	local rel_y = quarry_dig_above_nodes - math.floor(nd / (diameter*diameter))
	formspec = formspec.."label[0,2;"..minetest.formspec_escape(
			nd == 0 and S("Digging not started") or
			(rel_y < -quarry_max_depth and S("Digging finished") or
				S("Digging %d m "..(rel_y > 0 and "above" or "below").." machine")
					:format(math.abs(rel_y)))
			).."]"
	formspec = formspec.."button[4,2;2,1;restart;"..S("Restart").."]"
	meta:set_string("formspec", formspec)
end

local function set_quarry_demand(meta)
	local radius = meta:get_int("size")
	local diameter = radius*2 + 1
	local machine_name = S("%s Quarry"):format("HV")
	if meta:get_int("enabled") == 0 then
		meta:set_string("infotext", S("%s Disabled"):format(machine_name))
		meta:set_int("HV_EU_demand", 0)
	elseif meta:get_int("dug") == diameter*diameter * (quarry_dig_above_nodes+1+quarry_max_depth) then
		meta:set_string("infotext", S("%s Finished"):format(machine_name))
		meta:set_int("HV_EU_demand", 0)
	else
		meta:set_string("infotext", S(meta:get_int("HV_EU_input") >= quarry_demand and "%s Active" or "%s Unpowered"):format(machine_name))
		meta:set_int("HV_EU_demand", quarry_demand)
	end
end

local function quarry_receive_fields(pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)
	if fields.size and string.find(fields.size, "^[0-9]+$") then
		local size = tonumber(fields.size)
		if size >= 2 and size <= 8 and size ~= meta:get_int("size") then
			meta:set_int("size", size)
			meta:set_int("dug", 0)
		end
	end
	if fields.enable then meta:set_int("enabled", 1) end
	if fields.disable then meta:set_int("enabled", 0) end
	if fields.restart then meta:set_int("dug", 0) end
	set_quarry_formspec(meta)
	set_quarry_demand(meta)
end

local function quarry_run(pos, node)
	local meta = minetest.get_meta(pos)
	if meta:get_int("enabled") and meta:get_int("HV_EU_input") >= quarry_demand then
		local pdir = minetest.facedir_to_dir(node.param2)
		local qdir = pdir.x == 1 and vector.new(0,0,-1) or
			(pdir.z == -1 and vector.new(-1,0,0) or
			(pdir.x == -1 and vector.new(0,0,1) or
			vector.new(1,0,0)))
		local radius = meta:get_int("size")
		local diameter = radius*2 + 1
		local startpos = vector.add(vector.add(vector.add(pos,
			vector.new(0, quarry_dig_above_nodes, 0)),
			pdir),
			vector.multiply(qdir, -radius))
		local endpos = vector.add(vector.add(vector.add(startpos,
			vector.new(0, -quarry_dig_above_nodes-quarry_max_depth, 0)),
			vector.multiply(pdir, diameter-1)),
			vector.multiply(qdir, diameter-1))
		local vm = VoxelManip()
		local minpos, maxpos = vm:read_from_map(startpos, endpos)
		local area = VoxelArea:new({MinEdge=minpos, MaxEdge=maxpos})
		local data = vm:get_data()
		local c_air = minetest.get_content_id("air")
		local owner = meta:get_string("owner")
		local nd = meta:get_int("dug")
		while nd ~= diameter*diameter * (quarry_dig_above_nodes+1+quarry_max_depth) do
			local ry = math.floor(nd / (diameter*diameter))
			local ndl = nd % (diameter*diameter)
			if ry % 2 == 1 then
				ndl = diameter*diameter - 1 - ndl
			end
			local rq = math.floor(ndl / diameter)
			local rp = ndl % diameter
			if rq % 2 == 1 then rp = diameter - 1 - rp end
			local digpos = vector.add(vector.add(vector.add(startpos,
				vector.new(0, -ry, 0)),
				vector.multiply(pdir, rp)),
				vector.multiply(qdir, rq))
			local can_dig = true
			for ay = startpos.y, digpos.y+1, -1 do
				if data[area:index(digpos.x, ay, digpos.z)] ~= c_air then
					can_dig = false
					break
				end
			end
			if can_dig and minetest.is_protected and minetest.is_protected(digpos, owner) then
				can_dig = false
			end
			local dignode
			if can_dig then
				dignode = minetest.get_node(digpos)
				local dignodedef = minetest.registered_nodes[dignode.name] or {diggable=false}
				if not dignodedef.diggable or (dignodedef.can_dig and not dignodedef.can_dig(digpos, nil)) then
					can_dig = false
				end
			end
			nd = nd + 1
			if can_dig then
				minetest.remove_node(digpos)
				for _, item in ipairs(minetest.get_node_drops(dignode.name, "")) do
					technic.tube_inject_item(pos, pos, vector.new(0, 1, 0), item)
				end
				break
			end
		end
		meta:set_int("dug", nd)
	end
	set_quarry_formspec(meta)
	set_quarry_demand(meta)
end

minetest.register_node("technic:quarry", {
	description = S("%s Quarry"):format("HV"),
	tiles = {"technic_carbon_steel_block.png", "technic_carbon_steel_block.png",
	         "technic_carbon_steel_block.png", "technic_carbon_steel_block.png",
	         "technic_carbon_steel_block.png^default_tool_mesepick.png", "technic_carbon_steel_block.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1, technic_machine = 1},
	tube = {
		connect_sides = {top = 1},
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s Quarry"):format("HV"))
		meta:set_int("size", 4)
		set_quarry_formspec(meta)
		set_quarry_demand(meta)
	end,
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		pipeworks.scan_for_tube_objects(pos)
	end,
	after_dig_node = pipeworks.scan_for_tube_objects,
	on_receive_fields = quarry_receive_fields,
	technic_run = quarry_run,
})

technic.register_machine("HV", "technic:quarry", technic.receiver)

