
local S = technic.getter

local quarry_dig_above_nodes = tonumber(minetest.settings:get("technic.quarry.dig_above_nodes") or "3")
local quarry_max_depth = tonumber(minetest.settings:get("technic.quarry.maxdepth") or "100")
local quarry_time_limit = tonumber(minetest.settings:get("technic.quarry.time_limit") or "5000")

local quarry_demand = 10000
local quarry_eject_dir = vector.new(0, 1, 0)
local machine_name = S("%s Quarry"):format("HV")
local quarry_formspec =
	"size[8,9]"..
	"item_image[7,0;1,1;technic:quarry]"..
	"list[context;cache;1,1;4,3;]"..
	"listring[context;cache]"..
	"list[current_player;main;0,5;8,4;]"..
	"listring[current_player;main]"..
	"label[0,0;"..machine_name.."]"..
	"button[5,1.9;2,1;restart;"..S("Restart").."]"

-- hard-coded spiral dig pattern for up to 17x17 dig area
local quarry_dig_pattern = {
	0,1,2,2,3,3,0,0,0,1,1,1,2,2,2,2,3,3,3,3,0,0,0,0,0,1,1,1,1,1,2,2,
	2,2,2,2,3,3,3,3,3,3,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,
	3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,
	2,2,2,2,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,
	1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,
	0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,
	2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
}

local function reset_quarry(pos)
	local meta = minetest.get_meta(pos)
	local node = technic.get_or_load_node(pos) or minetest.get_node(pos)
	meta:set_int("quarry_dir", node.param2)
	meta:set_string("quarry_pos", minetest.pos_to_string(pos))
	meta:set_string("dig_pos", "")
	meta:set_int("dig_level", pos.y + quarry_dig_above_nodes)
	local radius = meta:get_int("size")
	local diameter = (radius*2)+1
	meta:set_int("dig_steps", diameter*diameter)
	meta:set_int("dig_index", 0)
	meta:set_int("purge_on", 1)
	meta:set_int("finished", 0)
	meta:set_int("dug", 0)
end

local function set_quarry_status(pos)
	local meta = minetest.get_meta(pos)
	local formspec = quarry_formspec.."field[5.3,3.4;2,1;size;"..S("Radius:")..";"..meta:get_int("size").."]"
	local status = S("Digging not started")
	if meta:get_int("enabled") == 1 then
		formspec = formspec.."button[5,0.9;2,1;disable;"..S("Enabled").."]"
		if meta:get_int("purge_on") == 1 then
			status = S("Purging cache")
			meta:set_string("infotext", S("%s purging cache"):format(machine_name))
			meta:set_int("HV_EU_demand", 0)
		elseif meta:get_int("finished") == 1 then
			status = S("Digging finished")
			meta:set_string("infotext", S("%s Finished"):format(machine_name))
			meta:set_int("HV_EU_demand", 0)
		else
			local rel_y = meta:get_int("dig_level") - pos.y
			status = S("Digging %d m "..(rel_y > 0 and "above" or "below").." machine"):format(math.abs(rel_y))
			meta:set_string("infotext", S(meta:get_int("HV_EU_input") >= quarry_demand and "%s Active" or "%s Unpowered"):format(machine_name))
			meta:set_int("HV_EU_demand", quarry_demand)
		end
	else
		formspec = formspec.."button[5,0.9;2,1;enable;"..S("Disabled").."]"
		meta:set_string("infotext", S("%s Disabled"):format(machine_name))
		meta:set_int("HV_EU_demand", 0)
	end
	meta:set_string("formspec", formspec.."label[0,4.1;"..minetest.formspec_escape(status).."]")
end

local function quarry_receive_fields(pos, formname, fields, sender)
	local player_name = sender:get_player_name()
	if minetest.is_protected(pos, player_name) then
		minetest.chat_send_player(player_name, "You are not allowed to edit this!")
		minetest.record_protection_violation(pos, player_name)
		return
	end
	local meta = minetest.get_meta(pos)
	if fields.size and string.find(fields.size, "^[0-9]+$") then
		local size = tonumber(fields.size)
		if size >= 1 and size <= 8 and size ~= meta:get_int("size") then
			meta:set_int("size", size)
			reset_quarry(pos)
		end
	end
	if fields.enable then meta:set_int("enabled", 1) end
	if fields.disable then meta:set_int("enabled", 0) end
	if fields.restart then reset_quarry(pos) end
	set_quarry_status(pos)
end

local function quarry_handle_purge(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local cache = inv:get_list("cache")
	if not cache then
		inv:set_size("cache", 12)
		return
	end
	local i = 0
	for _,stack in ipairs(cache) do
		i = i + 1
		if stack then
			local item = stack:to_table()
			if item then
				technic.tube_inject_item(pos, pos, quarry_eject_dir, item)
				stack:clear()
				inv:set_stack("cache", i, stack)
				break
			end
		end
	end
	if inv:is_empty("cache") then
		meta:set_int("purge_on", 0)
	end
end

local function can_dig_node(pos, node, digger)
	if node.name == "air" or node.name == "vacuum:vacuum" then
		return false
	end
	local def = minetest.registered_nodes[node.name]
	if not def or not def.diggable then
		return false
	end
	if def.can_dig and not def.can_dig(pos, digger) then
		return false
	end
	return true
end

local function find_ground(quarry_pos, quarry_dir, meta)
	local dir = minetest.facedir_to_dir(quarry_dir % 4)
	local radius = meta:get_int("size")
	local dig_level = meta:get_int("dig_level")
	local middle_pos = vector.add(quarry_pos, vector.multiply(dir, radius + 1))
	local pos1 = vector.new(middle_pos.x - radius, dig_level, middle_pos.z - radius)
	local pos2 = vector.new(middle_pos.x + radius, dig_level, middle_pos.z + radius)
	local nodes = minetest.find_nodes_in_area(pos1, pos2, {"air", "vacuum:vacuum"})
	if #nodes < meta:get_int("dig_steps") then
		return vector.new(middle_pos.x, dig_level, middle_pos.z)
	end
	meta:set_int("dig_level", dig_level - 1)
	return nil
end

local function get_dig_pos(quarry_pos, quarry_dir, dig_pos, dig_index, dig_steps, meta)
	if dig_index > 0 and dig_index < dig_steps then
		local facedir = (quarry_dir + quarry_dig_pattern[dig_index]) % 4
		dig_pos = vector.add(dig_pos, minetest.facedir_to_dir(facedir))
	elseif dig_index >= dig_steps then
		local dig_level = meta:get_int("dig_level")
		if (quarry_pos.y - dig_level) >= quarry_max_depth then
			return nil, dig_index
		end
		local dir = minetest.facedir_to_dir(quarry_dir % 4)
		dig_pos = vector.add(quarry_pos, vector.multiply(dir, meta:get_int("size") + 1))
		dig_pos.y = dig_level - 1
		meta:set_int("dig_level", dig_pos.y)
		dig_index = 0
	end
	dig_index = dig_index + 1
	return dig_pos, dig_index
end

local function execute_dig(pos, node, meta)
	local dig_pos = minetest.string_to_pos(meta:get_string("dig_pos"))
	local quarry_dir = meta:get_int("quarry_dir")
	if not dig_pos then
		-- quarry has not hit ground yet
		dig_pos = find_ground(pos, quarry_dir, meta)
	else
		local owner = meta:get_string("owner")
		local digger = pipeworks.create_fake_player({name = owner})
		local dig_steps = meta:get_int("dig_steps")
		local dig_index = meta:get_int("dig_index")
		local t0 = minetest.get_us_time()
		local us_used = 0
		-- search for something to dig
		while us_used < quarry_time_limit do
			dig_pos, dig_index = get_dig_pos(pos, quarry_dir, dig_pos, dig_index, dig_steps, meta)
			if not dig_pos then
				-- finished digging
				meta:set_int("finished", 1)
				meta:set_int("purge_on", 1)
				break
			end
			if not minetest.is_protected(dig_pos, owner) then
				local dig_node = technic.get_or_load_node(dig_pos) or minetest.get_node(dig_pos)
				if can_dig_node(dig_pos, dig_node, digger) then
					-- found something to dig, dig it and stop searching
					minetest.remove_node(dig_pos)
					local inv = meta:get_inventory()
					local drops = minetest.get_node_drops(dig_node.name, "")
					for _, dropped_item in ipairs(drops) do
						local left = inv:add_item("cache", dropped_item)
						while not left:is_empty() do
							meta:set_int("purge_on", 1)
							quarry_handle_purge(pos)
							left = inv:add_item("cache", left)
						end
					end
					local dug_nodes = meta:get_int("dug") + 1
					meta:set_int("dug", dug_nodes)
					if dug_nodes % 100 == 0 then
						meta:set_int("purge_on", 1)
					end
					break
				end
			end
			us_used = minetest.get_us_time() - t0
		end
		meta:set_int("dig_index", dig_index)
	end
	if dig_pos then
		meta:set_string("dig_pos", minetest.pos_to_string(dig_pos))
	end
end

local function quarry_run(pos, node)
	local meta = minetest.get_meta(pos)
	if minetest.pos_to_string(pos) ~= meta:get_string("quarry_pos") then
		-- quarry has been moved since last dig
		reset_quarry(pos)
	elseif meta:get_int("purge_on") == 1 then
		quarry_handle_purge(pos)
	elseif meta:get_int("enabled") and meta:get_int("HV_EU_input") >= quarry_demand and meta:get_int("finished") == 0 then
		execute_dig(pos, node, meta)
	elseif not meta:get_inventory():is_empty("cache") then
		meta:set_int("purge_on", 1)
	end
	set_quarry_status(pos)
end

minetest.register_node("technic:quarry", {
	description = S("%s Quarry"):format("HV"),
	tiles = {
		"technic_carbon_steel_block.png^pipeworks_tube_connection_metallic.png",
		"technic_carbon_steel_block.png^technic_cable_connection_overlay.png",
		"technic_carbon_steel_block.png^technic_cable_connection_overlay.png",
		"technic_carbon_steel_block.png^technic_cable_connection_overlay.png",
		"technic_carbon_steel_block.png^default_tool_mesepick.png",
		"technic_carbon_steel_block.png^technic_cable_connection_overlay.png"
	},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1, technic_machine=1, technic_hv=1},
	connect_sides = {"bottom", "front", "left", "right"},
	tube = {
		connect_sides = {top = 1},
		-- lower priority than other tubes, so that quarries will prefer any
		-- other tube to another quarry, which could lead to server freezes
		-- in certain quarry placements (2x2 for example would never eject)
		priority = 10,
		can_go = function(pos, node, velocity, stack)
			-- always eject the same, even if items came in another way
			-- this further mitigates loops and generally avoids random sideway movement
			-- that can be expected in certain quarry placements
			return { quarry_eject_dir }
		end
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("size", 4)
		meta:get_inventory():set_size("cache", 12)
		reset_quarry(pos)
		set_quarry_status(pos)
	end,
	after_place_node = function(pos, placer, itemstack)
		minetest.get_meta(pos):set_string("owner", placer:get_player_name())
		pipeworks.scan_for_tube_objects(pos)
	end,
	can_dig = function(pos,player)
		return minetest.get_meta(pos):get_inventory():is_empty("cache")
	end,
	after_dig_node = pipeworks.scan_for_tube_objects,
	on_receive_fields = quarry_receive_fields,
	technic_run = quarry_run,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return minetest.is_protected(pos, player:get_player_name()) and 0 or count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return minetest.is_protected(pos, player:get_player_name()) and 0 or stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return minetest.is_protected(pos, player:get_player_name()) and 0 or stack:get_count()
	end,
	mesecons = {
		effector = {
			action_on = function(pos)
				local meta = minetest.get_meta(pos)
				meta:set_int("enabled", 1)
				set_quarry_status(pos)
			end,
			action_off = function(pos)
				local meta = minetest.get_meta(pos)
				meta:set_int("enabled", 0)
				set_quarry_status(pos)
			end
		}
	}
})

minetest.register_craft({
	recipe = {
		{"technic:carbon_plate", "pipeworks:filter", "technic:composite_plate"},
		{"basic_materials:motor", "technic:machine_casing", "technic:diamond_drill_head"},
		{"technic:carbon_steel_block", "technic:hv_cable", "technic:carbon_steel_block"}},
	output = "technic:quarry"
})

technic.register_machine("HV", "technic:quarry", technic.receiver)
