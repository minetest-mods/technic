
local has_monitoring_mod = minetest.get_modpath("monitoring")

local switches = {} -- pos_hash -> time_us

local active_switching_stations_metric, switching_stations_usage_metric

if has_monitoring_mod then
	active_switching_stations_metric = monitoring.gauge(
		"technic_active_switching_stations",
		"Number of active switching stations"
	)

	switching_stations_usage_metric = monitoring.counter(
		"technic_switching_stations_usage",
		"usage in microseconds cpu time"
	)
end


minetest.register_abm({
	nodenames = {"technic:switching_station"},
	label = "Switching Station",
	interval   = 1,
	chance     = 1,
	action = function(pos)
		local hash = minetest.hash_node_position(pos)
		local time_us = minetest.get_us_time()
		switches[hash] = time_us
	end
})

local off_delay_seconds = 60

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1.0 then
		return
	end
	timer = 0

	local now = minetest.get_us_time()
	local off_delay_micros = off_delay_seconds*1000*1000
	local active_switches = 0

	for hash, time_us in pairs(switches) do
		local pos = minetest.get_position_from_hash(hash)
		local diff = now - time_us

		minetest.get_voxel_manip(pos, pos)
		local node = minetest.get_node(pos)

		if node.name ~= "technic:switching_station" then
			-- station vanished
			switches[hash] = nil

		elseif diff < off_delay_micros then
			-- station active
			active_switches = active_switches + 1
			technic.switching_station_run(pos)

		else
			-- station timed out
			switches[hash] = nil

		end
	end

	local time_usage = minetest.get_us_time() - now

	if has_monitoring_mod then
		active_switching_stations_metric.set(active_switches)
		switching_stations_usage_metric.inc(time_usage)
	end


end)
