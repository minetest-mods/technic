-- The supply converter is a generic device which can convert from
-- LV to MV and back, and HV to MV and back.
-- The machine is configured by the wiring below and above it.
--
-- It works like this:
--   The top side is setup as the receiver side, the bottom as the producer side.
--   Once the receiver side is powered it will deliver power to the other side.
--   Unused power is wasted just like any other producer!

local S = technic.getter

local run = function(pos, node)
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
		local input = meta:get_int(from.."_EU_input")
		meta:set_int(from.."_EU_demand", demand)
		meta:set_int(from.."_EU_supply", 0)
		meta:set_int(to.."_EU_demand", 0)
		meta:set_int(to.."_EU_supply", input * remain)
		meta:set_string("infotext", S("@1 (@2 @3 -> @4 @5)", machine_name, technic.pretty_num(input), from, technic.pretty_num(input * remain), to))
	else
		meta:set_string("infotext", S("%s Has Bad Cabling"):format(machine_name))
		if to then
			meta:set_int(to.."_EU_supply", 0)
		end
		if from then
			meta:set_int(from.."_EU_demand", 0)
		end
		return
	end

end

minetest.register_node("technic:supply_converter", {
	description = S("Supply Converter"),
	tiles  = {"technic_supply_converter_top.png", "technic_supply_converter_bottom.png",
	          "technic_supply_converter_side.png", "technic_supply_converter_side.png",
	          "technic_supply_converter_side.png", "technic_supply_converter_side.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,
		technic_machine=1, technic_all_tiers=1},
	connect_sides = {"top", "bottom"},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Supply Converter"))
		meta:set_float("active", false)
	end,
	technic_run = run,
})

minetest.register_craft({
	output = 'technic:supply_converter 1',
	recipe = {
		{'technic:fine_gold_wire', 'technic:rubber',         'technic:doped_silicon_wafer'},
		{'technic:mv_transformer', 'technic:machine_casing', 'technic:lv_transformer'},
		{'technic:mv_cable',       'technic:rubber',         'technic:lv_cable'},
	}
})

for tier, machines in pairs(technic.machines) do
	technic.register_machine(tier, "technic:supply_converter", technic.producer_receiver)
end

