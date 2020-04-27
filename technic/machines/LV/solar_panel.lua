-- Solar panels are the building blocks of LV solar arrays
-- They can however also be used separately but with reduced efficiency due to the missing transformer.
-- Individual panels are less efficient than when the panels are combined into full arrays.

local S = technic.getter


minetest.register_craft({
	output = 'technic:solar_panel',
	recipe = {
		{'technic:doped_silicon_wafer', 'technic:doped_silicon_wafer', 'technic:doped_silicon_wafer'},
		{'basic_materials:silver_wire',    'technic:lv_cable',            'mesecons_materials:glue'},
	},
	replacements = { {"basic_materials:silver_wire", "basic_materials:empty_spool"}, },
})


local run = function(pos, node)
	-- The action here is to make the solar panel prodice power
	-- Power is dependent on the light level and the height above ground
	-- There are many ways to cheat by using other light sources like lamps.
	-- As there is no way to determine if light is sunlight that is just a shame.
	-- To take care of some of it solar panels do not work outside daylight hours or if
	-- built below 0m
	local pos1 = {x=pos.x, y=pos.y+1, z=pos.z}
	local machine_name = S("Small Solar %s Generator"):format("LV")

	local light = minetest.get_node_light(pos1, nil)
	local time_of_day = minetest.get_timeofday()
	local meta = minetest.get_meta(pos)
	if light == nil then light = 0 end
	-- turn on panel only during day time and if sufficient light
        -- I know this is counter intuitive when cheating by using other light sources underground.
	if light >= 12 and time_of_day >= 0.24 and time_of_day <= 0.76 and pos.y > -10 then
		local charge_to_give = math.floor((light + pos1.y) * 3)
		charge_to_give = math.max(charge_to_give, 0)
		charge_to_give = math.min(charge_to_give, 200)
		meta:set_string("infotext", S("@1 Active (@2)", machine_name,
			technic.EU_string(charge_to_give)))
		meta:set_int("LV_EU_supply", charge_to_give)
	else
		meta:set_string("infotext", S("%s Idle"):format(machine_name))
		meta:set_int("LV_EU_supply", 0)
	end
end

minetest.register_node("technic:solar_panel", {
	tiles = {"technic_solar_panel_top.png",  "technic_solar_panel_bottom.png", "technic_solar_panel_side.png",
	         "technic_solar_panel_side.png", "technic_solar_panel_side.png",   "technic_solar_panel_side.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		technic_machine=1, technic_lv=1},
	connect_sides = {"bottom"},
	sounds = default.node_sound_wood_defaults(),
	description = S("Small Solar %s Generator"):format("LV"),
	active = false,
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = true,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("LV_EU_supply", 0)
		meta:set_string("infotext", S("Small Solar %s Generator"):format("LV"))
	end,
	technic_run = run,
})

technic.register_machine("LV", "technic:solar_panel", technic.producer)

