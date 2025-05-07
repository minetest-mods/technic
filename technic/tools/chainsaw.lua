-- Configuration

local chainsaw_max_charge      = 30000 -- Maximum charge of the saw
-- Cut down tree leaves.  Leaf decay may cause slowness on large trees
-- if this is disabled.
local chainsaw_leaves = true

local chainsaw_efficiency = 0.92 -- Drops less items

-- Maximal dimensions of the tree to cut (giant sequoia)
local tree_max_radius = 10
local tree_max_height = 70

local S = technic.getter

--[[
Format: [node_name] = dig_cost

This table is filled automatically afterwards to support mods such as:

	cool_trees
	ethereal
	moretrees
]]
local tree_nodes = {
	-- For the sake of maintenance, keep this sorted alphabetically!
	["default:acacia_bush_stem"] = -1,
	["default:bush_stem"] = -1,
	["default:pine_bush_stem"] = -1,

	["default:cactus"] = -1,
	["default:papyrus"] = -1,

	-- dfcaves "fruits"
	["df_trees:blood_thorn_spike"] = -1,
	["df_trees:blood_thorn_spike_dead"] = -1,
	["df_trees:tunnel_tube_fruiting_body"] = -1,

	["ethereal:bamboo"] = -1,
}

local tree_nodes_by_cid = {
	-- content ID indexed table, data populated on mod load.
	-- Format: [node_name] = cost_number
}

-- Function to decide whether or not to cut a certain node (and at which energy cost)
local function populate_costs(name, def)
	repeat
		if tree_nodes[name] then
			break -- Manually specified node to chop
		end
		if (def.groups.tree or 0) > 0 then
			break -- Tree node
		end
		if (def.groups.leaves or 0) > 0 and chainsaw_leaves then
			break -- Leaves
		end
		if (def.groups.leafdecay_drop or 0) > 0 then
			break -- Food
		end
		return -- Abort function: do not dig this node

	-- luacheck: push ignore 511
	until 1
	-- luacheck: pop

	-- Add the node cost to the content ID indexed table
	local content_id = minetest.get_content_id(name)

	-- Make it so that the giant sequoia can be cut with a full charge
	local cost = tree_nodes[name] or 0
	if def.groups.choppy then
		cost = math.max(cost, def.groups.choppy * 14) -- trunks (usually 3 * 14)
	end
	if def.groups.snappy then
		cost = math.max(cost, def.groups.snappy * 2) -- leaves
	end
	tree_nodes_by_cid[content_id] = math.max(4, cost)
end

minetest.register_on_mods_loaded(function()
	local ndefs = minetest.registered_nodes
	-- Populate hardcoded nodes
	for name in pairs(tree_nodes) do
		local ndef = ndefs[name]
		if ndef and ndef.groups then
			populate_costs(name, ndef)
		end
	end

	-- Find all trees and leaves
	for name, def in pairs(ndefs) do
		if def.groups then
			populate_costs(name, def)
		end
	end
end)


technic.register_power_tool("technic:chainsaw", chainsaw_max_charge)

local pos9dir = {
	{ 1, 0,  0},
	{-1, 0,  0},
	{ 0, 0,  1},
	{ 0, 0, -1},
	{ 1, 0,  1},
	{-1, 0, -1},
	{ 1, 0, -1},
	{-1, 0,  1},
	{ 0, 1,  0}, -- up
}

local cutter = {
	-- See function cut_tree()
}

local safe_cut = minetest.settings:get_bool("technic_safe_chainsaw") ~= false
local c_air = minetest.get_content_id("air")
local function dig_recursive(x, y, z)
	local i = cutter.area:index(x, y, z)
	if cutter.seen[i] then
		return
	end
	cutter.seen[i] = 1 -- Mark as visited

	if safe_cut and cutter.param2[i] ~= 0 then
		-- Do not dig manually placed nodes
		-- Problem: moretrees' generated jungle trees use param2 = 2
		cutter.stopped_by_safe_cut = true
		return
	end

	local c_id = cutter.data[i]
	local cost = tree_nodes_by_cid[c_id]
	if not cost or cost > cutter.charge then
		return -- Cannot dig this node
	end

	-- Count dug nodes
	cutter.drops[c_id] = (cutter.drops[c_id] or 0) + 1
	cutter.seen[i] = 2 -- Mark as dug (for callbacks)
	cutter.data[i] = c_air
	cutter.charge = cutter.charge - cost

	-- Expand maximal bounds for area protection check
	if x < cutter.minp.x then cutter.minp.x = x end
	if y < cutter.minp.y then cutter.minp.y = y end
	if z < cutter.minp.z then cutter.minp.z = z end
	if x > cutter.maxp.x then cutter.maxp.x = x end
	if y > cutter.maxp.y then cutter.maxp.y = y end
	if z > cutter.maxp.z then cutter.maxp.z = z end

	-- Traverse neighbors
	local xn, yn, zn
	for _, offset in ipairs(pos9dir) do
		xn, yn, zn = x + offset[1], y + offset[2], z + offset[3]
		if cutter.area:contains(xn, yn, zn) then
			 dig_recursive(xn, yn, zn)
		end
	end
end

local handle_drops

local function chainsaw_dig(player, pos, remaining_charge)
	local minp = {
		x = pos.x - (tree_max_radius + 1),
		y = pos.y,
		z = pos.z - (tree_max_radius + 1)
	}
	local maxp = {
		x = pos.x + (tree_max_radius + 1),
		y = pos.y + tree_max_height,
		z = pos.z + (tree_max_radius + 1)
	}

	local vm = minetest.get_voxel_manip()
	local emin, emax = vm:read_from_map(minp, maxp)

	cutter = {
		area = VoxelArea:new{MinEdge=emin, MaxEdge=emax},
		data = vm:get_data(),
		param2 = vm:get_param2_data(),
		seen = {},
		drops = {}, -- [content_id] = count
		minp = vector.copy(pos),
		maxp = vector.copy(pos),
		charge = remaining_charge
	}

	dig_recursive(pos.x, pos.y, pos.z)

	-- Check protection
	local player_name = player:get_player_name()
	if minetest.is_area_protected(cutter.minp, cutter.maxp, player_name, 6) then
		minetest.chat_send_player(player_name, "The chainsaw cannot cut this tree. The cuboid " ..
			minetest.pos_to_string(cutter.minp) .. ", " .. minetest.pos_to_string(cutter.maxp) ..
			" contains protected nodes.")
		minetest.record_protection_violation(pos, player_name)
		return
	end

	if cutter.stopped_by_safe_cut then
		minetest.chat_send_player(player_name, S("The chainsaw could not dig all nodes" ..
			" because the safety mechanism was activated."))
	end

	minetest.sound_play("chainsaw", {
		pos = pos,
		gain = 1.0,
		max_hear_distance = 20
	})

	handle_drops(pos)

	vm:set_data(cutter.data)
	vm:write_to_map(true)
	vm:update_map()

	-- Update falling nodes
	for i, status in pairs(cutter.seen) do
		if status == 2 then -- actually dug
			minetest.check_for_falling(cutter.area:position(i))
		end
	end
end

-- Function to randomize positions for new node drops
local function get_drop_pos(pos)
	local drop_pos = {}

	for i = 0, 8 do
		-- Randomize position for a new drop
		drop_pos.x = pos.x + math.random(-3, 3)
		drop_pos.y = pos.y - 1
		drop_pos.z = pos.z + math.random(-3, 3)

		-- Move the randomized position upwards until
		-- the node is air or unloaded.
		for y = drop_pos.y, drop_pos.y + 5 do
			drop_pos.y = y
			local node = minetest.get_node_or_nil(drop_pos)

			if not node then
				-- If the node is not loaded yet simply drop
				-- the item at the original digging position.
				return pos
			elseif node.name == "air" then
				-- Add variation to the entity drop position,
				-- but don't let drops get too close to the edge
				drop_pos.x = drop_pos.x + (math.random() * 0.8) - 0.5
				drop_pos.z = drop_pos.z + (math.random() * 0.8) - 0.5
				return drop_pos
			end
		end
	end

	-- Return the original position if this takes too long
	return pos
end

local drop_inv = minetest.create_detached_inventory("technic:chainsaw_drops", {}, ":technic")
handle_drops = function(pos)
	local n_slots = 100
	drop_inv:set_size("main", n_slots)
	drop_inv:set_list("main", {})

	-- Put all dropped items into the detached inventory
	for c_id, count in pairs(cutter.drops) do
		local name = minetest.get_name_from_content_id(c_id)

		-- Add drops in bulk -> keep some randomness
		while count > 0 do
			local drops = minetest.get_node_drops(name, "")
			-- higher numbers are faster but return uneven sapling counts
			local decrement = math.ceil(count * 0.3)
			decrement = math.min(count, math.max(5, decrement))

			for _, stack in ipairs(drops) do
				stack = ItemStack(stack)
				local total = math.ceil(stack:get_count() * decrement * chainsaw_efficiency)
				local stack_max = stack:get_stack_max()

				-- Split into full stacks
				while total > 0 do
					local size = math.min(total, stack_max)
					stack:set_count(size)
					drop_inv:add_item("main", stack)
					total = total - size
				end
			end
			count = count - decrement
		end
	end

	-- Drop in random places
	for i = 1, n_slots do
		local stack = drop_inv:get_stack("main", i)
		if stack:is_empty() then
			break
		end
		minetest.add_item(get_drop_pos(pos), stack)
	end

	drop_inv:set_size("main", 0) -- free RAM
end


minetest.register_tool("technic:chainsaw", {
	description = S("Chainsaw"),
	inventory_image = "technic_chainsaw.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local meta = technic.get_stack_meta(itemstack)
		local charge = meta:get_int("technic:charge")

		local name = user:get_player_name()
		if minetest.is_protected(pointed_thing.under, name) then
			minetest.record_protection_violation(pointed_thing.under, name)
			return
		end

		-- Send current charge to digging function so that the
		-- chainsaw will stop after digging a number of nodes
		chainsaw_dig(user, pointed_thing.under, charge)
		charge = cutter.charge

		cutter = {} -- Free RAM

		if not technic.creative_mode then
			meta:set_int("technic:charge", charge)
			technic.set_RE_wear(itemstack, charge, chainsaw_max_charge)
		end
		return itemstack
	end,
})

local mesecons_button = minetest.get_modpath("mesecons_button")
local trigger = mesecons_button and "mesecons_button:button_off" or "default:mese_crystal_fragment"

minetest.register_craft({
	output = "technic:chainsaw",
	recipe = {
		{"technic:stainless_steel_ingot", trigger,                      "technic:battery"},
		{"basic_materials:copper_wire",      "basic_materials:motor",              "technic:battery"},
		{"",                              "",                           "technic:stainless_steel_ingot"},
	},
	replacements = { {"basic_materials:copper_wire", "basic_materials:empty_spool"}, },

})

