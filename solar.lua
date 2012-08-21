minetest.register_abm(
	{nodenames = {"technic:solar_panel"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		
		local pos1={}
		pos1.y=pos.y+1
		pos1.x=pos.x
		pos1.z=pos.z

		local light = minetest.env:get_node_light(pos1, nil)
		local meta = minetest.env:get_meta(pos)
		if light == nil then light = 0 end
		if light >= 12 then
			meta:set_string("infotext", "Solar Panel is active ")
			meta:set_float("active",1)
		else
			meta:set_string("infotext", "Solar Panel is inactive");
			meta:set_float("active",0)
		end
	end,
}) 