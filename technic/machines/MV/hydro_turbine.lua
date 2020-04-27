-- A Hydro Turbine produces MV EUs by exploiting flowing water across it
-- It is a MV EU supplier and fairly high yield (max 1800EUs)

local S = technic.getter

local cable_entry = "^technic_cable_connection_overlay.png"

minetest.register_alias("hydro_turbine", "technic:hydro_turbine")

minetest.register_craft({
	output = 'technic:hydro_turbine',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:water_mill', 'technic:stainless_steel_ingot'},
		{'technic:water_mill', 'technic:mv_transformer', 'technic:water_mill'},
		{'technic:stainless_steel_ingot', 'technic:mv_cable', 'technic:stainless_steel_ingot'},
	}
})

local function get_water_flow(pos)
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "water") == 3 and string.find(node.name, "flowing") then
		return node.param2 -- returns approx. water flow, if any
	end
	return 0
end

---
-- 10 times better than LV hydro because of 2 extra water mills and 4 stainless steel, a transformer and whatnot ;P.
-- Man hydro turbines are tough and long lasting. So, give it some value :)
local run = function(pos, node)
	local meta             = minetest.get_meta(pos)
	local water_flow       = 0
	local production_level
	local eu_supply
	local max_output       = 40 * 45 -- Generates 1800EU/s

	local positions = {
		{x=pos.x+1, y=pos.y, z=pos.z},
		{x=pos.x-1, y=pos.y, z=pos.z},
		{x=pos.x,   y=pos.y, z=pos.z+1},
		{x=pos.x,   y=pos.y, z=pos.z-1},
	}

	for _, p in pairs(positions) do
		water_flow = water_flow + get_water_flow(p)
	end

	eu_supply = math.min(40 * water_flow, max_output)
	production_level = math.floor(100 * eu_supply / max_output)

	meta:set_int("MV_EU_supply", eu_supply)

	meta:set_string("infotext",
	S("Hydro %s Generator"):format("MV").." ("..production_level.."%)")
	if production_level > 0 and
		minetest.get_node(pos).name == "technic:hydro_turbine" then
		technic.swap_node(pos, "technic:hydro_turbine_active")
		meta:set_int("MV_EU_supply", 0)
		return
	end
	if production_level == 0 then
		technic.swap_node(pos, "technic:hydro_turbine")
	end
end

minetest.register_node("technic:hydro_turbine", {
	description = S("Hydro %s Generator"):format("MV"),
	tiles = {
		"technic_hydro_turbine_top.png",
		"technic_machine_bottom.png"..cable_entry,
		"technic_hydro_turbine_side.png",
		"technic_hydro_turbine_side.png",
		"technic_hydro_turbine_side.png",
		"technic_hydro_turbine_side.png"
	},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
	technic_machine=1, technic_mv=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Hydro %s Generator"):format("MV"))
		meta:set_int("MV_EU_supply", 0)
	end,
	technic_run = run,
})

minetest.register_node("technic:hydro_turbine_active", {
	description = S("Hydro %s Generator"):format("MV"),
	tiles = {"technic_hydro_turbine_top_active.png", "technic_machine_bottom.png",
			"technic_hydro_turbine_side.png", "technic_hydro_turbine_side.png",
			"technic_hydro_turbine_side.png", "technic_hydro_turbine_side.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
			technic_machine=1, technic_mv=1, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:hydro_turbine",
	technic_run = run,
	technic_disabled_machine_name = "technic:hydro_turbine",
})

technic.register_machine("MV", "technic:hydro_turbine",        technic.producer)
technic.register_machine("MV", "technic:hydro_turbine_active", technic.producer)
