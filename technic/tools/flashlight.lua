-- Original code comes from walkin_light mod by Echo
-- http://minetest.net/forum/viewtopic.php?id=2621

local flashlight_max_charge = 30000

local S = technic.getter

technic.register_power_tool("technic:flashlight", flashlight_max_charge)

minetest.register_alias("technic:light_off", "air")

minetest.register_tool("technic:flashlight", {
	description = S("Flashlight"),
	inventory_image = "technic_flashlight.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
})

minetest.register_craft({
	output = "technic:flashlight",
	recipe = {
		{"technic:rubber",                "default:glass",   "technic:rubber"},
		{"technic:stainless_steel_ingot", "technic:battery", "technic:stainless_steel_ingot"},
		{"",                              "technic:battery", ""}
	}
})


local player_positions = {}
local was_wielding = {}

local function check_for_flashlight(player)
	if player == nil then
		return false
	end
	local inv = player:get_inventory()
	local hotbar = inv:get_list("main")
	for i = 1, 8 do
		if hotbar[i]:get_name() == "technic:flashlight" then
			local meta = minetest.deserialize(hotbar[i]:get_metadata())
			if meta and meta.charge and meta.charge >= 2 then
				if not technic.creative_mode then
					meta.charge = meta.charge - 2;
					technic.set_RE_wear(hotbar[i], meta.charge, flashlight_max_charge)
					hotbar[i]:set_metadata(minetest.serialize(meta))
					inv:set_stack("main", i, hotbar[i])
				end
				return true
			end
		end
	end
	return false
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local pos = player:get_pos()
	local rounded_pos = vector.round(pos)
	rounded_pos.y = rounded_pos.y + 1
	player_positions[player_name] = rounded_pos
	was_wielding[player_name] = true
end)


minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	local pos = player_positions[player_name]
	local nodename = minetest.get_node(pos).name
	if nodename == "technic:light" then
		minetest.remove_node(pos)
	end
	player_positions[player_name] = nil
end)

minetest.register_globalstep(function(dtime)
	for i, player in pairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		local flashlight_weared = check_for_flashlight(player)
		local pos = player:get_pos()
		local rounded_pos = vector.round(pos)
		rounded_pos.y = rounded_pos.y + 1
		local old_pos = player_positions[player_name]
		local player_moved = old_pos and not vector.equals(old_pos, rounded_pos)
		if not old_pos then
			old_pos = rounded_pos
			player_moved = true
		end

		-- Remove light, flashlight weared out or was removed from hotbar
		if was_wielding[player_name] and not flashlight_weared then
			was_wielding[player_name] = false
			local node = minetest.get_node_or_nil(old_pos)
			if node and node.name == "technic:light" then
				minetest.remove_node(old_pos)
			end
		elseif (player_moved or not was_wielding[player_name]) and flashlight_weared then
			local node = minetest.get_node_or_nil(rounded_pos)
			if node and node.name == "air" then
				minetest.set_node(rounded_pos, {name="technic:light"})
			end
			node = minetest.get_node_or_nil(old_pos)
			if node and node.name == "technic:light" then
				minetest.remove_node(old_pos)
			end
			player_positions[player_name] = rounded_pos
			was_wielding[player_name] = true
		end
	end
end)

minetest.register_node("technic:light", {
	drawtype = "glasslike",
	tiles = {"technic_light.png"},
	paramtype = "light",
	groups = {not_in_creative_inventory = 1},
	drop = "",
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	light_source = minetest.LIGHT_MAX,
	pointable = false,
})
