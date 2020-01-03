

minetest.register_abm({
	nodenames = {"technic:switching_station"},
	label = "Switching Station",
	interval   = 1.1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		technic.switching_station_run(pos)
	end
})
