-- The supply converter is a generic device which can convert from
-- LV to MV and back, and HV to MV and back.
-- The machine is configured by the wiring below and above it.
--
-- It works like this:
--   The top side is setup as the receiver side, the bottom as the producer side.
--   Once the receiver side is powered it will deliver power to the other side.
--   Unused power is wasted just like any other producer!

local S = technic.getter

minetest.register_node("technic:supply_converter", {
	description = S("Supply Converter"),
	tiles  = {"technic_supply_converter_top.png", "technic_supply_converter_bottom.png",
	          "technic_supply_converter_side.png", "technic_supply_converter_side.png",
	          "technic_supply_converter_side.png", "technic_supply_converter_side.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", S("Supply Converter"))
		meta:set_float("active", false)
	end,
})

minetest.register_craft({
	output = 'technic:supply_converter 1',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:machine_casing', 'technic:stainless_steel_ingot'},
		{'technic:mv_transformer',        'technic:mv_cable0',      'technic:lv_transformer'},
		{'technic:mv_cable0',             'technic:rubber',         'technic:lv_cable0'},
	}
})

minetest.register_abm({
	nodenames = {"technic:supply_converter"},
	interval   = 1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local demand = 10000
		local remain = 0.9
		-- Machine information
		local machine_name  = S("Supply Converter")
		local meta          = minetest.get_meta(pos)

		local pos_up        = {x=pos.x, y=pos.y+1, z=pos.z}
		local pos_down      = {x=pos.x, y=pos.y-1, z=pos.z}
		local name_up       = minetest.get_node(pos_up).name
		local name_down     = minetest.get_node(pos_down).name

		local from = technic.get_cable_tier(name_up)
		local to   = technic.get_cable_tier(name_down)

		if from and to then
			technic.switching_station_timeout_count(pos, from)
			local input = meta:get_int(from.."_EU_input")
			meta:set_int(from.."_EU_demand", demand)
			meta:set_int(from.."_EU_supply", 0)
			meta:set_int(to.."_EU_demand", 0)
			meta:set_int(to.."_EU_supply", input * remain)
			meta:set_string("infotext", machine_name
				.." ("..input.." "..from.." -> "
				..input * remain.." "..to..")")
		else
			meta:set_string("infotext", S("%s Has Bad Cabling"):format(machine_name))
			return
		end

	end,
})

for tier, machines in pairs(technic.machines) do
	technic.register_machine(tier, "technic:supply_converter", technic.producer_receiver)
end

