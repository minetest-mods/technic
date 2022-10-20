
-- LV Lamp
-- Illuminates a 7x7x3(H) volume below itself with light bright as the sun.


local S = technic.getter

local desc = S("@1 Lamp", S("LV"))
local active_desc = S("@1 Active", desc)
local unpowered_desc = S("@1 Unpowered", desc)
local off_desc = S("@1 Off", desc)
local demand = 50


-- Invisible light source node used for illumination
minetest.register_node("technic:dummy_light_source", {
	description = S("Dummy light source node"),
	inventory_image = "technic_dummy_light_source.png",
	wield_image = "technic_dummy_light_source.png",
	paramtype = "light",
	drawtype = "airlike",
	light_source = 14,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	diggable = false,
	pointable = false,
	--drop = "",  -- Intentionally allowed to drop itself
	groups = {not_in_creative_inventory = 1}
})


local function illuminate(pos, active)
	local pos1 = {x = pos.x - 3, y = pos.y - 1, z = pos.z - 3}
	local pos2 = {x = pos.x + 3, y = pos.y - 3, z = pos.z + 3}

	local find_node = active and "air" or "technic:dummy_light_source"
	local set_node = {name = (active and "technic:dummy_light_source" or "air")}

	for _,p in pairs(minetest.find_nodes_in_area(pos1, pos2, find_node)) do
		minetest.set_node(p, set_node)
	end
end

local function lamp_run(pos, node)
	local meta = minetest.get_meta(pos)

	if meta:get_int("LV_EU_demand") == 0 then
		return  -- Lamp is turned off
	end

	local eu_input = meta:get_int("LV_EU_input")

	if node.name == "technic:lv_lamp_active" then
		if eu_input < demand then
			technic.swap_node(pos, "technic:lv_lamp")
			meta:set_string("infotext", unpowered_desc)
			illuminate(pos, false)
		else
			illuminate(pos, true)
		end
	elseif node.name == "technic:lv_lamp" then
		if eu_input >= demand then
			technic.swap_node(pos, "technic:lv_lamp_active")
			meta:set_string("infotext", active_desc)
			illuminate(pos, true)
		end
	end
end

local function lamp_toggle(pos, node, player)
	if not player or minetest.is_protected(pos, player:get_player_name()) then
		return
	end
	local meta = minetest.get_meta(pos)
	if meta:get_int("LV_EU_demand") == 0 then
		meta:set_string("infotext", active_desc)
		meta:set_int("LV_EU_demand", demand)
	else
		illuminate(pos, false)
		technic.swap_node(pos, "technic:lv_lamp")
		meta:set_string("infotext", off_desc)
		meta:set_int("LV_EU_demand", 0)
	end
end

local common_fields = {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {0.5,0.5,0.5,-0.5,-0.2,-0.5}
	},
	tiles = {
		"technic_lv_lamp_top.png",
		"technic_lv_lamp_bottom.png",
		"technic_lv_lamp_side.png",
		"technic_lv_lamp_side.png",
		"technic_lv_lamp_side.png",
		"technic_lv_lamp_side.png"
	},
	connect_sides = {"front", "back", "left", "right", "top"},
	can_dig = technic.machine_can_dig,
	technic_run = lamp_run,
	on_destruct = illuminate,
	on_rightclick = lamp_toggle
}

local ndef

ndef = {
	description = desc,
	groups = {cracky = 2, technic_machine = 1, technic_lv = 1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", desc)
		meta:set_int("LV_EU_demand", demand)
	end
}

for k, v in pairs(common_fields) do
	ndef[k] = v
end

minetest.register_node("technic:lv_lamp", ndef)


ndef = {
	description = active_desc,
	paramtype = "light",
	light_source = 14,
	drop = "technic:lv_lamp",
	groups = {cracky = 2, technic_machine = 1, technic_lv = 1, not_in_creative_inventory = 1},
	technic_on_disable = function(pos)
		illuminate(pos, false)
		technic.swap_node(pos, "technic:lv_lamp")
	end,
}

for k, v in pairs(common_fields) do
	ndef[k] = v
end

minetest.register_node("technic:lv_lamp_active", ndef)


technic.register_machine("LV", "technic:lv_lamp", technic.receiver)
technic.register_machine("LV", "technic:lv_lamp_active", technic.receiver)

minetest.register_craft({
	output = "technic:lv_lamp",
	recipe = {
		{"default:glass", "default:glass", "default:glass"},
		{"technic:lv_led", "technic:lv_led", "technic:lv_led"},
		{"mesecons_materials:glue", "technic:lv_cable", "mesecons_materials:glue"},
	}
})
