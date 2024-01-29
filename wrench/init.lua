--[[
Wrench mod

Adds a wrench that allows the player to pickup nodes that contain an inventory
with items or metadata that needs perserving.
The wrench has the same tool capability as the normal hand.
To pickup a node simply right click on it. If the node contains a formspec,
you will need to shift+right click instead.
Because it enables arbitrary nesting of chests, and so allows the player
to carry an unlimited amount of material at once, this wrench is not
available to survival-mode players.
--]]

local LATEST_SERIALIZATION_VERSION = 1

-- Check if mcl_core or default is installed
if not minetest.get_modpath("mcl_core") and not minetest.get_modpath("default") then
	error(minetest.get_current_modname().." ".."requires mcl_core or default to be installed (please install MTG or MCL2, or compatible games)")
end

wrench = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/support.lua")
dofile(modpath.."/technic.lua")

-- Boilerplate to support localized strings if intllib mod is installed.
local S = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end

local function get_meta_type(name, metaname)
	local def = wrench.registered_nodes[name]
	return def and def.metas and def.metas[metaname] or nil
end

local function get_pickup_name(name)
	return "wrench:picked_up_"..(name:gsub(":", "_"))
end

local function restore(pos, placer, itemstack)
	local data = itemstack:get_meta():get_string("data")
	data = (data ~= "" and data) or	itemstack:get_metadata()
	data = minetest.deserialize(data)

	if not data then
		minetest.remove_node(pos)
		minetest.log("error", placer:get_player_name().." wanted to place "..
				itemstack:get_name().." at "..minetest.pos_to_string(pos)..
				", but it had no data.")
		minetest.log("verbose", "itemstack: "..itemstack:to_string())
		return true
	end

	local node = minetest.get_node(pos)
	minetest.set_node(pos, {name = data.name, param2 = node.param2})

	-- Apply stored metadata to the current node
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for key, value in pairs(data.metas) do
		local meta_type = get_meta_type(data.name, key)
		if meta_type == wrench.META_TYPE_INT then
			meta:set_int(key, value)
		elseif meta_type == wrench.META_TYPE_FLOAT then
			meta:set_float(key, value)
		elseif meta_type == wrench.META_TYPE_STRING then
			meta:set_string(key, value)
		end
	end

	for listname, list in pairs(data.lists) do
		inv:set_list(listname, list)
	end
	itemstack:take_item()
	return itemstack
end

minetest.register_on_mods_loaded(function()
	-- Delayed registration for foreign mod support
	for name, info in pairs(wrench.registered_nodes) do
		local olddef = minetest.registered_nodes[name]
		if olddef then
			local newdef = {}
			for key, value in pairs(olddef) do
				newdef[key] = value
			end
			newdef.stack_max = 1
			newdef.description = S("%s with items"):format(newdef.description)
			newdef.groups = {}
			newdef.groups.not_in_creative_inventory = 1
			newdef.on_construct = nil
			newdef.on_destruct = nil
			newdef.after_place_node = restore
			minetest.register_node(":"..get_pickup_name(name), newdef)
		end
	end
end)

minetest.register_tool("wrench:wrench", {
	description = S("Wrench"),
	inventory_image = "technic_wrench.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40},
						uses=0, maxlevel=3}
		},
		damage_groups = {fleshy=1},
	},
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.under
		if not placer or not pos then
			return
		end
		local player_name = placer:get_player_name()
		if minetest.is_protected(pos, player_name) then
			minetest.record_protection_violation(pos, player_name)
			return
		end
		local node_name = minetest.get_node(pos).name
		local def = wrench.registered_nodes[node_name]
		if not def then
			return
		end

		local stack_pickup = ItemStack(get_pickup_name(node_name))
		local player_inv = placer:get_inventory()
		if not player_inv:room_for_item("main", stack_pickup) then
			return
		end
		local meta = minetest.get_meta(pos)
		if def.owned and not minetest.check_player_privs(placer, "protection_bypass") then
			local owner = meta:get_string("owner")
			if owner and owner ~= player_name then
				minetest.log("action", player_name..
					" tried to pick up an owned node belonging to "..
					owner.." at "..
					minetest.pos_to_string(pos))
				return
			end
		end

		-- Do the actual pickup:
		local metadata = {}
		metadata.name = node_name
		metadata.version = LATEST_SERIALIZATION_VERSION

		-- Serialize inventory lists + items
		local inv = meta:get_inventory()
		local lists = {}
		for _, listname in pairs(def.lists or {}) do
			local list = inv:get_list(listname)
			for i, stack in pairs(list) do
				list[i] = stack:to_string()
			end
			lists[listname] = list
		end
		metadata.lists = lists

		-- Serialize node metadata fields
		local item_meta = stack_pickup:get_meta()
		metadata.metas = {}
		for key, meta_type in pairs(def.metas or {}) do
			if meta_type == wrench.META_TYPE_INT then
				metadata.metas[key] = meta:get_int(key)
			elseif meta_type == wrench.META_TYPE_FLOAT then
				metadata.metas[key] = meta:get_float(key)
			elseif meta_type == wrench.META_TYPE_STRING then
				metadata.metas[key] = meta:get_string(key)
			end
		end

		item_meta:set_string("data", minetest.serialize(metadata))
		minetest.remove_node(pos)
		itemstack:add_wear(65535 / 20)
		player_inv:add_item("main", stack_pickup)
		return itemstack
	end,
})
