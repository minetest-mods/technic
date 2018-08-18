local S = technic.getter

minetest.register_abm({
	nodenames = {"group:technic_lv", "group:technic_mv", "group:technic_hv"},
	label = "Run Machines",
	interval   = 1,
	chance     = 1,
	action = function(pos,node)
		local meta = minetest.get_meta(pos)
		local pos1 = {x=pos.x, y=pos.y-1, z=pos.z}
		local tier = technic.get_cable_tier(minetest.get_node(pos1).name)
		local meta = minetest.get_meta(pos)
		if not tier then
			meta:set_int("active", 0)
			return
		end
		meta:set_int("active", 1)
		meta:set_int("LV_EU_input", meta:get_int("LV_EU_demand"))
		meta:set_int("MV_EU_input", meta:get_int("MV_EU_demand"))
		meta:set_int("HV_EU_input", meta:get_int("HV_EU_demand"))
		local nodedef = minetest.registered_nodes[node.name]
		if nodedef and nodedef.technic_run then
			nodedef.technic_run(pos, node)
		end
	end,
})

minetest.register_lbm({
	nodenames = {"technic:switching_station", "technic:power_monitor"},
	name = "technic:update_infotext",
	label = "Update switching station / power monitor infotext",
	run_at_every_load = true,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		if node.name == "technic:switching_station" then
			meta:set_string("infotext", S("Switching Station"))
		elseif node.name == "technic:power_monitor" then
			meta:set_string("infotext", S("Power Monitor"))
		end
	end,
})
