-- A water mill produces LV EUs by exploiting flowing water across it
-- It is a LV EU supplier and fairly low yield (max 180EUs)
-- It is a little over half as good as the thermal generator.

local S = technic.getter

local cable_entry = "^technic_cable_connection_overlay.png"

minetest.register_alias("water_mill", "technic:water_mill")

minetest.register_craft({
	output = 'technic:water_mill',
	recipe = {
		{'technic:marble', 'default:diamond',        'technic:marble'},
		{'group:wood',     'technic:machine_casing', 'group:wood'},
		{'technic:marble', 'technic:lv_cable',       'technic:marble'},
	}
})

local function check_node_around_mill(pos)
	local node = minetest.get_node(pos)
	if node.name == "default:water_flowing"
	  or node.name == "default:river_water_flowing" then
		return node.param2 -- returns approx. water flow, if any
	end
	return false
end

local run = function(pos, node)
	local meta             = minetest.get_meta(pos)
	local water_flow       = 0
	local production_level
	local eu_supply
	local max_output       = 4 * 45 -- keeping it around 180, little more than previous 150 :)

	local positions = {
		{x=pos.x+1, y=pos.y, z=pos.z},
		{x=pos.x-1, y=pos.y, z=pos.z},
		{x=pos.x,   y=pos.y, z=pos.z+1},
		{x=pos.x,   y=pos.y, z=pos.z-1},
	}

	for _, p in pairs(positions) do
		local check = check_node_around_mill(p)
		if check then
			water_flow = water_flow + check
		end
	end

	eu_supply = math.min(4 * water_flow, max_output)
	production_level = math.floor(100 * eu_supply / max_output)

	meta:set_int("LV_EU_supply", eu_supply)

	meta:set_string("infotext",
		S("Hydro %s Generator"):format("LV").." ("..production_level.."%)")

	if production_level > 0 and
	   minetest.get_node(pos).name == "technic:water_mill" then
		technic.swap_node (pos, "technic:water_mill_active")
		meta:set_int("LV_EU_supply", 0)
		return
	end
	if production_level == 0 then
		technic.swap_node(pos, "technic:water_mill")
	end
end

minetest.register_node("technic:water_mill", {
	description = S("Hydro %s Generator"):format("LV"),
	tiles = {
		"technic_water_mill_top.png",
		"technic_machine_bottom.png"..cable_entry,
		"technic_water_mill_side.png",
		"technic_water_mill_side.png",
		"technic_water_mill_side.png",
		"technic_water_mill_side.png"
	},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		technic_machine=1, technic_lv=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Hydro %s Generator"):format("LV"))
		meta:set_int("LV_EU_supply", 0)
	end,
	technic_run = run,
})

minetest.register_node("technic:water_mill_active", {
	description = S("Hydro %s Generator"):format("LV"),
	tiles = {"technic_water_mill_top_active.png", "technic_machine_bottom.png",
	         "technic_water_mill_side.png",       "technic_water_mill_side.png",
	         "technic_water_mill_side.png",       "technic_water_mill_side.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		technic_machine=1, technic_lv=1, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:water_mill",
	technic_run = run,
	technic_disabled_machine_name = "technic:water_mill",
})

technic.register_machine("LV", "technic:water_mill",        technic.producer)
technic.register_machine("LV", "technic:water_mill_active", technic.producer)

