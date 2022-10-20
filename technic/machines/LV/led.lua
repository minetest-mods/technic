-- LED
-- Intended primarily as a core component for LED lamps.

local S = technic.getter

local desc = S("@1 LED", S("LV"))
local active_desc = S("@1 Active", desc)
local unpowered_desc = S("@1 Unpowered", desc)
local demand = 5


local function led_run(pos, node)
	local meta = minetest.get_meta(pos)
	local eu_input = meta:get_int("LV_EU_input")

	if eu_input < demand and node.name == "technic:lv_led_active" then
		technic.swap_node(pos, "technic:lv_led")
		meta:set_string("infotext", unpowered_desc)
	elseif eu_input >= demand and node.name == "technic:lv_led" then
		technic.swap_node(pos, "technic:lv_led_active")
		meta:set_string("infotext", active_desc)
	end
end

local common_fields = {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {0.5, 0.5, 0.5, -0.5, 0.3, -0.5}
	},
	tiles = {
		"technic_lv_led_top.png",
		"technic_lv_led.png",
		"technic_lv_led_side.png",
		"technic_lv_led_side2.png",
		"technic_lv_led_side2.png",
		"technic_lv_led_side2.png",
	},

	connect_sides = {"front", "back", "left", "right", "top", "bottom"},
	can_dig = technic.machine_can_dig,
	technic_run = led_run,
}

local ndef

ndef = {
	description = desc,
	inventory_image = "technic_lv_led_inv.png",
	sunlight_propagates = true,
	groups = {cracky = 2, technic_machine = 1, technic_lv = 1},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", desc)
		meta:set_int("LV_EU_demand", demand)
	end,
}

for k, v in pairs(common_fields) do
	ndef[k] = v
end

minetest.register_node("technic:lv_led", ndef)


ndef = {
	description = active_desc,
	paramtype = "light",
	light_source = 9,
	drop = "technic:lv_led",
	groups = {cracky = 2, technic_machine = 1, technic_lv = 1, not_in_creative_inventory = 1},
	technic_on_disable = function(pos)
		technic.swap_node(pos, "technic:lv_led")
	end,
}

for k, v in pairs(common_fields) do
	ndef[k] = v
end

minetest.register_node("technic:lv_led_active", ndef)


technic.register_machine("LV", "technic:lv_led", technic.receiver)
technic.register_machine("LV", "technic:lv_led_active", technic.receiver)

minetest.register_craft({
	output = "technic:lv_led 2",
	recipe = {
		{"", "homedecor:plastic_sheeting", ""},
		{"homedecor:plastic_sheeting", "technic:doped_silicon_wafer", "homedecor:plastic_sheeting"},
		{"", "technic:fine_silver_wire", ""},
	}
})
