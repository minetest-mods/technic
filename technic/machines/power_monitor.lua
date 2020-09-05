-- POWER MONITOR
-- The power monitor can be used to monitor how much power is available on a network,
-- similarly to the old "slave" switching stations.

local S = technic.getter

local cable_entry = "^technic_cable_connection_overlay.png"

-- return the position of the associated switching station or nil
local function get_swpos(pos)
	local network_hash = technic.cables[minetest.hash_node_position(pos)]
	local network = network_hash and minetest.get_position_from_hash(network_hash)
	local swpos = network and {x=network.x,y=network.y+1,z=network.z}
	local is_powermonitor = swpos and minetest.get_node(swpos).name == "technic:switching_station"
	return is_powermonitor and swpos or nil
end

minetest.register_craft({
	output = "technic:power_monitor",
	recipe = {
		{"",                 "",                       ""},
		{"",                 "technic:machine_casing", "default:copper_ingot"},
		{"technic:lv_cable", "technic:lv_cable",       "technic:lv_cable"}
	}
})

minetest.register_node("technic:power_monitor",{
	description = S("Power Monitor"),
	tiles  = {
		"technic_power_monitor_sides.png",
		"technic_power_monitor_sides.png"..cable_entry,
		"technic_power_monitor_sides.png",
		"technic_power_monitor_sides.png",
		"technic_power_monitor_sides.png"..cable_entry,
		"technic_power_monitor_front.png"
	},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, technic_all_tiers=1, technic_machine=1},
	connect_sides = {"bottom", "back"},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Power Monitor"))
		meta:set_string("channel", "power_monitor"..minetest.pos_to_string(pos))
		meta:set_string("formspec", "field[channel;Channel;${channel}]")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if not fields.channel then
			return
		end
		local plname = sender:get_player_name()
    if minetest.is_protected(pos, plname) and not minetest.check_player_privs(sender, "protection_bypass") then
			minetest.record_protection_violation(pos, plname)
			return
		end
		local meta = minetest.get_meta(pos)
		meta:set_string("channel", fields.channel)
	end,
	digiline = {
		receptor = {
			rules = technic.digilines.rules,
			action = function() end
		},
		effector = {
			rules = technic.digilines.rules,
			action = function(pos, node, channel, msg)
				if msg ~= "GET" and msg ~= "get" then
					return
				end
				local meta = minetest.get_meta(pos)
				if channel ~= meta:get_string("channel") then
					return
				end

				local sw_pos = get_swpos(pos)
				if not sw_pos then
					return
				end

				local sw_meta = minetest.get_meta(sw_pos)
				digilines.receptor_send(pos, technic.digilines.rules, channel, {
					supply = sw_meta:get_int("supply"),
					demand = sw_meta:get_int("demand"),
					lag = sw_meta:get_int("lag"),
					battery_count = sw_meta:get_int("battery_count"),
					battery_charge = sw_meta:get_int("battery_charge"),
					battery_charge_max = sw_meta:get_int("battery_charge_max"),
				})
			end
		},
	},
})

minetest.register_abm({
	nodenames = {"technic:power_monitor"},
	label = "Machines: run power monitor",
	interval   = 1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local sw_pos = get_swpos(pos)
		local timeout = 0
		for tier in pairs(technic.machines) do
			timeout = math.max(technic.get_timeout(tier, pos),timeout)
		end
		if timeout > 0 and sw_pos then
			local sw_meta = minetest.get_meta(sw_pos)
			local supply = sw_meta:get_int("supply")
			local demand = sw_meta:get_int("demand")
			meta:set_string("infotext",
					S("Power Monitor. Supply: @1 Demand: @2",
					technic.EU_string(supply), technic.EU_string(demand)))
		else
			meta:set_string("infotext",S("Power Monitor Has No Network"))
		end
	end,
})

for tier in pairs(technic.machines) do
	-- RE in order to use the "timeout" functions, although it consumes 0 power
	technic.register_machine(tier, "technic:power_monitor", "RE")
end

