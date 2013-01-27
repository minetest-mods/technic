minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		pos.y = pos.y+0.5
		local inv = player:get_inventory()
		
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
					inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
					if object:get_luaentity().itemstring ~= "" then
						minetest.sound_play("item_drop_pickup", {
							to_player = player:get_player_name(),
						})
					end
					object:get_luaentity().itemstring = ""
					object:remove()
				end
			end
		end
		
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 2)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				if object:get_luaentity().collect then
					if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
						local pos1 = pos
						pos1.y = pos1.y+0.2
						local pos2 = object:getpos()
						local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
						vec.x = vec.x*3
						vec.y = vec.y*3
						vec.z = vec.z*3
						object:setvelocity(vec)
						
						minetest.after(1, function(args)
							local lua = object:get_luaentity()
							if object == nil or lua == nil or lua.itemstring == nil then
								return
							end
							if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
								inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
								if object:get_luaentity().itemstring ~= "" then
									minetest.sound_play("item_drop_pickup", {
										to_player = player:get_player_name(),
									})
								end
								object:get_luaentity().itemstring = ""
								object:remove()
							else
								object:setvelocity({x=0,y=0,z=0})
							end
						end, {player, object})
						
					end
				else
					minetest.after(0.5, function(entity)
						entity.collect = true
					end, object:get_luaentity())
				end
			end
		end
	end
end)
