local sonic_screwdriver_max_charge = 15000

local S = technic.getter

technic.register_power_tool("technic:sonic_screwdriver", sonic_screwdriver_max_charge)

-- screwdriver handler code reused from minetest/minetest_game screwdriver @a9ac480
local ROTATE_FACE = 1
local ROTATE_AXIS = 2

-- Handles rotation
local function screwdriver_handler(itemstack, user, pointed_thing, mode)
	if pointed_thing.type ~= "node" then
		return
	end

	local pos = pointed_thing.under

	if minetest.is_protected(pos, user:get_player_name()) then
		minetest.record_protection_violation(pos, user:get_player_name())
		return
	end

	local node = minetest.get_node(pos)
	local ndef = minetest.registered_nodes[node.name]

	if not ndef then return end

	local paramtype2 = ndef.paramtype2

	-- contrary to the default screwdriver, do not check for can_dig, to allow rotating machines with CLU's in them
	-- this is consistent with the previous sonic screwdriver

	-- Set param2
	local new_param2
	local param2 = node.param2

	local dirs_per_axis = 4

	local dir_components = {
		-- 2^5, 5 bits
		facedir = 32,
		colorfacedir = 32,
		colordegrotate = 32,

		-- 2^2, 2 bits
		["4dir"] = 4, -- lua doesn't like it when vars start with a digit
		color4dir = 4,
	}

	local dir_component = dir_components[paramtype2]

	local floor = math.floor
	-- non-direction data is preserved whether it be color or otherwise
	if (paramtype2 == "facedir") or (paramtype2 == "colorfacedir") then
		local aux = floor(param2 / dir_component)
		local dir = param2 % dir_component

		if mode == ROTATE_FACE then
			dir = (floor(param2 / dirs_per_axis)) * dirs_per_axis + ((dir + 1) % dirs_per_axis)
		elseif mode == ROTATE_AXIS then
			dir = ((floor(param2 / dirs_per_axis) + 1) * dirs_per_axis) % 24
		end

		new_param2 = aux * dir_component + dir
	elseif (paramtype2 == "4dir") or (paramtype2 == "color4dir") then
		local aux = floor(param2 / dir_component)
		local dir = param2 % dir_component

		if mode == ROTATE_FACE then
			dir = (dir + 1) % dirs_per_axis
		elseif mode == ROTATE_AXIS then
			dir = 0
		end

		new_param2 = aux * dir_component + dir
	elseif (paramtype2 == "degrotate") then
		if mode == ROTATE_FACE then
			new_param2 = param2 + 1
		elseif mode == ROTATE_AXIS then
			new_param2 = param2 + 20
		end
		new_param2 = new_param2 % 240
	elseif (paramtype2 == "colordegrotate") then
		local aux = floor(param2 / dir_component)
		local rotation = param2 % dir_component

		if mode == ROTATE_FACE then
			rotation = rotation + 1
		elseif mode == ROTATE_AXIS then
			rotation = rotation + 4
		end
		rotation = rotation % 24

		new_param2 = aux * dir_component + rotation
	else
		return
	end

	local meta = technic.get_stack_meta(itemstack)
	local charge = meta:get_int("technic:charge")
	if charge < 100 then
		return
	end

	minetest.sound_play("technic_sonic_screwdriver", {pos = pos, gain = 0.3, max_hear_distance = 10})

	node.param2 = new_param2
	minetest.swap_node(pos, node)

	if not technic.creative_mode then
		charge = charge - 100
		meta:set_int("technic:charge", charge)
		technic.set_RE_wear(itemstack, charge, sonic_screwdriver_max_charge)
	end

	return itemstack
end

minetest.register_tool("technic:sonic_screwdriver", {
	description = S("Sonic Screwdriver (left-click rotates face, right-click rotates axis)"),
	inventory_image = "technic_sonic_screwdriver.png",
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		screwdriver_handler(itemstack, user, pointed_thing, ROTATE_FACE)
		return itemstack
	end,
	on_place = function(itemstack, user, pointed_thing)
		screwdriver_handler(itemstack, user, pointed_thing, ROTATE_AXIS)
		return itemstack
	end,
})

minetest.register_craft({
	output = "technic:sonic_screwdriver",
	recipe = {
		{"",                         "default:diamond",        ""},
		{"mesecons_materials:fiber", "technic:battery",        "mesecons_materials:fiber"},
		{"mesecons_materials:fiber", "moreores:mithril_ingot", "mesecons_materials:fiber"}
	}
})

