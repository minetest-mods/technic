dofile(minetest.get_modpath("item_drop").."/item_entity.lua")
time_pick = 3
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos = player:getpos()
		pos.y = pos.y+0.5
		local inv = player:get_inventory()
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
					if object:get_luaentity() and object:get_luaentity().timer > time_pick then
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
		end
		
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 3)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				--print(dump(object:getpos().y-player:getpos().y))
				if object:getpos().y-player:getpos().y > 0 then
					if object:get_luaentity().collect then
						if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							if object:get_luaentity().timer > time_pick then
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
							
						end
					else
						minetest.after(0.5, function(entity)
							entity.collect = true
						end, object:get_luaentity())
					end
				end
			end
		end
	end
end)

function minetest.handle_node_drops(pos, drops, digger)
	for _,item in ipairs(drops) do
		local count, name
		if type(item) == "string" then
			count = 1
			name = item
		else
			count = item:get_count()
			name = item:get_name()
		end
		for i=1,count do
			local obj = minetest.env:add_item(pos, name)
			if obj ~= nil then
				obj:get_luaentity().collect = true
				local x = math.random(1, 5)
				if math.random(1,2) == 1 then
					x = -x
				end
				local z = math.random(1, 5)
				if math.random(1,2) == 1 then
					z = -z
				end
				obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
				obj:get_luaentity().timer = time_pick
				-- FIXME this doesnt work for deactiveted objects
				if minetest.setting_get("remove_items") and tonumber(minetest.setting_get("remove_items")) then
					minetest.after(tonumber(minetest.setting_get("remove_items")), function(obj)
						obj:remove()
					end, obj)
				end
			end
		end
	end
end
--[[
minetest.register_on_dieplayer(function(name, pos)
	local inv = name:get_inventory()
	local pos = name:getpos()
	for i = 1, inv:get_size("main"), 1 do
		srcstack = inv:get_stack("main", i)
		if srcstack:to_string() ~= "" then
			pos.y = pos.y + 3
			local obj = minetest.env:add_item(pos, srcstack:to_string())
			local x = math.random(-5, 5)
			if x >= -2 and x <=0 then
				local x = x - 3
			end
			if x > 0 and x <= 2 then
				local x = x + 3
			end
			local y = math.random(3, 5)
			local z = math.random(-5, 5)
			if z >= -2 and z <= 0 then
				local z = z - 3
			end
			if z > 0 and z <= 2 then
				local z = z + 3
			end
			inv:set_stack("main", i, "")
			obj:setvelocity({x=x, y=y, z=z})
		end
		if i == 32 then
			break
		end
	end
end)
]]--
print("DROPS LOADED!")
