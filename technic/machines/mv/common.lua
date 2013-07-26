technic.mv_can_dig =
	function(pos, player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") or not inv:is_empty("dst") or not inv:is_empty("upgrade1") or not inv:is_empty("upgrade2") then
			minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
			return false
		else
			return true
		end
	end

technic.mv_send_tube_items =
	function(pos,x_velocity,z_velocity)
		-- Send items on their way in the pipe system.
		local meta=minetest.env:get_meta(pos) 
		local inv = meta:get_inventory()
		local i=0
		for _,stack in ipairs(inv:get_list("dst")) do
			i=i+1
			if stack then
				local item0=stack:to_table()
				if item0 then
					item0["count"]="1"
					local item1=tube_item({x=pos.x,y=pos.y,z=pos.z},item0)
					item1:get_luaentity().start_pos = {x=pos.x,y=pos.y,z=pos.z}
					item1:setvelocity({x=x_velocity, y=0, z=z_velocity})
					item1:setacceleration({x=0, y=0, z=0})
					stack:take_item(1);
					inv:set_stack("dst", i, stack)
					return
				end
			end
		end
	end

technic.mv_tube_definitions = {
	insert_object=function(pos,node,stack,direction)
		local meta=minetest.env:get_meta(pos)
		local inv=meta:get_inventory()
		return inv:add_item("src",stack)
	end,
	can_insert=function(pos,node,stack,direction)
		local meta=minetest.env:get_meta(pos)
		local inv=meta:get_inventory()
		return inv:room_for_item("src",stack)
	end,
	connect_sides = {left = 1, right = 1, back = 1, top = 1, bottom = 1},
}

technic.mv_groups_inactive = {
	cracky = 2,
	tubedevice = 1,
	tubedevice_receiver = 1
}

technic.mv_groups_active = {
	cracky = 2,
	tubedevice = 1,
	tubedevice_receiver = 1,
	not_in_creative_inventory = 1,
}