-- LV LED and LV LED Lamp
-- LED - a weak light source, intended primarily as a core component for LED lamps
-- LED Lamp - a powerful light source, illuminating a 7x7x3(H) volume below itself
-- with light bright as the sun.

local S = technic.getter


local illuminate = function(pos, mode)
	local loc = {}
-- 	loc.x, loc.y, loc.z = pos.x, pos.y, pos.z
	for y=1,3,1 do
		for x=-3,3,1 do
			for z = -3,3,1 do
				loc = {x = pos.x - x, y = pos.y - y, z = pos.z - z}
				if mode then
					if minetest.get_node(loc).name == "air" then
						minetest.swap_node(loc, {name = "technic:dummy_light_source"})
					end
				else
					if minetest.get_node(loc).name == "technic:dummy_light_source" then
						minetest.swap_node(loc, {name = "air"})
					end
				end
			end
		end
	end
end


local led_on = function(pos, node)
	local meta         = minetest.get_meta(pos)
	local eu_input     = meta:get_int("LV_EU_input")
	local machine_name = S("%s LED"):format("LV")
	local machine_node = "technic:lv_led"
	local demand       = 5

	if eu_input < demand then
		technic.swap_node(pos, machine_node)
		meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
	elseif eu_input >= demand then
		technic.swap_node(pos, machine_node.."_active")
		meta:set_string("infotext", S("%s Active"):format(machine_name))
	end
	meta:set_int("LV_EU_demand", demand)
end

local led_off = function(pos, node)
	local meta         = minetest.get_meta(pos)
	local eu_input     = meta:get_int("LV_EU_input")
	local machine_name = S("%s LED"):format("LV")
	local machine_node = "technic:lv_led"

	technic.swap_node(pos, machine_node)
	meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
	
	meta:set_int("LV_EU_demand", 0)
end



local lamp_on = function(pos, node)
	local meta         = minetest.get_meta(pos)
	local eu_input     = meta:get_int("LV_EU_input")
	local machine_name = S("%s Lamp"):format("LV")
	local machine_node = "technic:lv_lamp"
	local demand       = 50

	if eu_input < demand then
		technic.swap_node(pos, machine_node)
		meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
		illuminate(pos, false)
	elseif eu_input >= demand then
		technic.swap_node(pos, machine_node.."_active")
		meta:set_string("infotext", S("%s Active"):format(machine_name))
		illuminate(pos, true)
	end
	meta:set_int("LV_EU_demand", demand)
end

local lamp_off = function(pos, node)
	local meta         = minetest.get_meta(pos)
	local eu_input     = meta:get_int("LV_EU_input")
	local machine_name = S("%s Lamp"):format("LV")
	local machine_node = "technic:lv_lamp"

	illuminate(pos, false)
	technic.swap_node(pos, machine_node)
	meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
	meta:set_int("LV_EU_demand", 0)
end


minetest.register_node("technic:dummy_light_source", {
	description = S("Dummy light source node"),
	node_box = {
		type = "fixed",
		fixed = {}
		},
	collision_box = {
		type = "fixed",
		fixed = {}
		},
	selection_box = {
		type = "fixed",
		fixed = {}
		},
	drawtype = "airlike",
	buildable_to = true,
	light_source = 14,
	sunlight_propagates = true,
	diggable = false,
	walkable = false,
	groups = { not_in_creative_inventory = 1 }
})

minetest.register_node("technic:lv_led", {
	description = S("LV LED"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {0.2,0.2,0.2,-0.2,-0.2,-0.2}
		},
	collision_box = {
		type = "fixed",
		fixed = {0.2,0.2,0.2,-0.2,-0.2,-0.2}
		},
	selection_box = {
		type = "fixed",
		fixed = {0.2,0.2,0.2,-0.2,-0.2,-0.2}
		},
	tiles = {"technic_lv_led.png"},
	inventory_image = "technic_lv_led_inv.png",
	sunlight_propagates = true,
	groups = {cracky=2, technic_machine=1, technic_lv=1},
	connect_sides = {"front", "back", "left", "right", "top", "bottom"},
	can_dig = technic.machine_can_dig,
	technic_run = led_on,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s LED"):format("LV"))
	end,
	drop = "technic:lv_led"
})

minetest.register_node("technic:lv_led_active", {
	description = S("LV LED Active"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {0.2,0.2,0.2,-0.2,-0.2,-0.2}
		},
	collision_box = {
		type = "fixed",
		fixed = {0.2,0.2,0.2,-0.2,-0.2,-0.2}
		},
	selection_box = {
		type = "fixed",
		fixed = {0.2,0.2,0.2,-0.2,-0.2,-0.2}
		},
	tiles = {"technic_lv_led.png"},
	light_source = 9,
	sunlight_propagates = true,
	groups = {cracky=2, technic_machine=1, technic_lv=1, not_in_creative_inventory=1},
	connect_sides = {"front", "back", "left", "right", "top", "bottom"},
	can_dig = technic.machine_can_dig,
	technic_run = led_on,
	technic_on_disable = led_off,
	drop = "technic:lv_led"
})


minetest.register_node("technic:lv_lamp", {
	description = S("%s Lamp"):format("LV"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {0.5,0.5,0.5,-0.5,-0.2,-0.5}
		},
	collision_box = {
		type = "fixed",
		fixed = {0.5,0.5,0.5,-0.5,-0.2,-0.5}
		},
	selection_box = {
		type = "fixed",
		fixed = {0.5,0.5,0.5,-0.5,-0.2,-0.5}
		},
	tiles       = {"technic_lv_lamp_top.png", "technic_lv_lamp_bottom.png", "technic_lv_lamp_side.png",
	               "technic_lv_lamp_side.png", "technic_lv_lamp_side.png", "technic_lv_lamp_side.png"},
	groups = {cracky=2, technic_machine=1, technic_lv=1},
	connect_sides = {"front", "back", "left", "right", "top",},
	can_dig = technic.machine_can_dig,
	technic_run = lamp_on,
	on_destruct = lamp_off,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("%s Lamp"):format("LV"))
	end,
})


minetest.register_node("technic:lv_lamp_active", {
	description = S("%s Lamp Active"):format("LV"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {0.5,0.5,0.5,-0.5,-0.2,-0.5}
		},
	collision_box = {
		type = "fixed",
		fixed = {0.5,0.5,0.5,-0.5,-0.2,-0.5}
		},
	selection_box = {
		type = "fixed",
		fixed = {0.5,0.5,0.5,-0.5,-0.2,-0.5}
		},
	tiles       = {"technic_lv_lamp_top.png", "technic_lv_lamp_bottom.png", "technic_lv_lamp_side.png",
	               "technic_lv_lamp_side.png", "technic_lv_lamp_side.png", "technic_lv_lamp_side.png"},
	groups = {cracky=2, technic_machine=1, technic_lv=1, not_in_creative_inventory=1},
	connect_sides = {"front", "back", "left", "right", "top"},
	light_source = 1,
	can_dig = technic.machine_can_dig,
	technic_run = lamp_on,
	on_destruct = lamp_off,
	technic_on_disable = lamp_off,
})

minetest.register_craft({
	output = 'technic:lv_led 2',
	recipe = {
		{'',                           'homedecor:plastic_sheeting',  ''},
		{'homedecor:plastic_sheeting', 'technic:doped_silicon_wafer', 'homedecor:plastic_sheeting'},
		{'',                           'technic:fine_silver_wire',    ''},
	},
})

minetest.register_craft({
	output = 'technic:lv_lamp',
	recipe = {
		{'default:glass',           'default:glass',    'default:glass'},
		{'technic:lv_led',          'technic:lv_led',   'technic:lv_led'},
		{'mesecons_materials:glue', 'technic:lv_cable', 'mesecons_materials:glue'},
	},
})

technic.register_machine("LV", "technic:lv_lamp", technic.receiver)
technic.register_machine("LV", "technic:lv_lamp_active", technic.receiver)

technic.register_machine("LV", "technic:lv_led", technic.receiver)
technic.register_machine("LV", "technic:lv_led_active", technic.receiver)
