
local S = technic.getter

local function get_light(param1)
	local alight = (param1-param1%16)/16
	local sunlight = (param1%16 ~= alight and param1%16) or 0
	return sunlight, alight
end

function technic.register_solar_array(data)
	local tier = data.tier
	local ltier = string.lower(tier)

	local function run(pos, node)
		local pos1 = vector.new(pos)
		pos1.y = pos1.y + 1
		local machine_name = S("Arrayed Solar %s Generator"):format(tier)

		local node1 = technic.get_or_load_node(pos1) or minetest.get_node(pos)
		local light = get_light(node1.param1)
		local time_of_day = minetest.get_timeofday()
		local meta = minetest.get_meta(pos)

		-- turn on array only during day time and if sufficient light
		if light >= 12 and time_of_day >= 0.24 and time_of_day <= 0.76 then
			local charge_to_give = math.floor((light + pos.y) * data.power)
			charge_to_give = math.max(charge_to_give, 0)
			charge_to_give = math.min(charge_to_give, data.power * 50)
			meta:set_string("infotext", S("@1 Active (@2 EU)", machine_name, technic.pretty_num(charge_to_give)))
			meta:set_int(tier.."_EU_supply", charge_to_give)
		else
			meta:set_string("infotext", S("%s Idle"):format(machine_name))
			meta:set_int(tier.."_EU_supply", 0)
		end
	end

	minetest.register_node("technic:solar_array_"..ltier, {
		tiles = {"technic_"..ltier.."_solar_array_top.png",  "technic_"..ltier.."_solar_array_bottom.png",
			 "technic_"..ltier.."_solar_array_side.png", "technic_"..ltier.."_solar_array_side.png",
			 "technic_"..ltier.."_solar_array_side.png", "technic_"..ltier.."_solar_array_side.png"},
		groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, technic_machine=1, ["technic_"..ltier]=1},
		connect_sides = {"bottom"},
		sounds = default.node_sound_wood_defaults(),
		description = S("Arrayed Solar %s Generator"):format(tier),
		active = false,
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int(tier.."_EU_supply", 0)
		end,
		technic_run = run,
	})

	technic.register_machine(tier, "technic:solar_array_"..ltier, technic.producer)
end

