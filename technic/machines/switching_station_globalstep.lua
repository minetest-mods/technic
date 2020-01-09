
local has_monitoring_mod = minetest.get_modpath("monitoring")

local switches = {} -- pos_hash -> { time = time_us }

local function get_switch_data(pos)
	local hash = minetest.hash_node_position(pos)
	local switch = switches[hash]

	if not switch then
		switch = {
			time = 0,
			skip = 0
		}
		switches[hash] = switch
	end

	return switch
end

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
		local switch = get_switch_data(pos)
		switch.time = minetest.get_us_time()
	end
})

local off_delay_seconds = 180

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

	for hash, switch in pairs(switches) do
		local pos = minetest.get_position_from_hash(hash)
		local diff = now - switch.time

		minetest.get_voxel_manip(pos, pos)
		local node = minetest.get_node(pos)

		if node.name ~= "technic:switching_station" then
			-- station vanished
			switches[hash] = nil

		elseif diff < off_delay_micros then
			-- station active
			active_switches = active_switches + 1

			if switch.skip < 1 then

				local start = minetest.get_us_time()
				technic.switching_station_run(pos)
				local switch_diff = minetest.get_us_time() - start


				local meta = minetest.get_meta(pos)

				-- overload detection
				if switch_diff > 250000 then
					switch.skip = 30
				elseif switch_diff > 100000 then
					switch.skip = 20
				elseif switch_diff > 50000 then
					switch.skip = 10
				elseif switch_diff > 25000 then
					switch.skip = 2
				end

				if switch.skip > 0 then
					local efficiency = math.floor(1/switch.skip*100)
					meta:set_string("infotext", "Polyfuse triggered, current efficiency: " ..
						efficiency .. "% generated lag : " .. math.floor(switch_diff/1000) .. " ms")
				end

			else
				switch.skip = math.max(switch.skip - 1, 0)
			end


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
