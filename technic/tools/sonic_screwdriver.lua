local sonic_screwdriver_max_charge = 15000

local S = technic.getter

technic.register_power_tool("technic:sonic_screwdriver", sonic_screwdriver_max_charge)

-- screwdriver handler code reused from minetest/minetest_game screwdriver @a9ac480
local ROTATE_FACE = 1
local ROTATE_AXIS = 2

local function nextrange(x, max)
	x = x + 1
	if x > max then
		x = 0
	end
	return x
end

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
	if (
		paramtype2 == nil or
		paramtype2 == "color" or
		paramtype2 == "meshoptions" or
		paramtype2 == "leveled" or
		paramtype2 == "flowingliquid" or
		paramtype2 == "glasslikeliquidlevel" or
		paramtype2 == "wallmounted" or
		paramtype2 == "colorwallmounted"
	) then
		return
	end

	-- contrary to the default screwdriver, do not check for can_dig, to allow rotating machines with CLU's in them
	-- this is consistent with the previous sonic screwdriver

	local meta = technic.get_stack_meta(itemstack)
	local charge = meta:get_int("technic:charge")
	if charge < 100 then
		return
	end

	minetest.sound_play("technic_sonic_screwdriver", {pos = pos, gain = 0.3, max_hear_distance = 10})

	-- Set param2
	local new_param2
	local param2 = node.param2

	local floor = math.floor
	if (paramtype2 == "facedir") or (paramtype2 == "colorfacedir") then
		local aux = floor(param2 / 32)
		local rotation = param2 % 32

		if mode == ROTATE_FACE then
			rotation = (floor(param2 / 4)) * 4 + ((rotation + 1) % 4)
		elseif mode == ROTATE_AXIS then
			rotation = ((floor(param2 / 4) + 1) * 4) % 24
		end

		new_param2 = aux * 32 + rotation
	elseif (paramtype2 == "4dir") or (paramtype2 == "color4dir") then
		local aux = floor(param2 / 4)
		local rotation = param2 % 4

		if mode == ROTATE_FACE then
			rotation = (rotation + 1) % 4
		elseif mode == ROTATE_AXIS then
			rotation = 0
		end
		
		new_param2 = aux * 4 + rotation
	elseif (paramtype2 == "degrotate") then
		if mode == ROTATE_FACE then
			new_param2 = rotation + 1
		elseif mode == ROTATE_AXIS then
			new_param2 = rotation + 20
		end
		new_param2 = new_param2 % 240
	elseif (paramtype2 == "colordegrotate") then
		local aux = floor(param2 / 32)
		local rotation = param2 % 32

		if mode == ROTATE_FACE then
			rotation = rotation + 1
		elseif mode == ROTATE_AXIS then
			rotation = rotation + 4
		end
		rotation = rotation % 24

		new_param2 = aux * 32 + rotation
	end

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

