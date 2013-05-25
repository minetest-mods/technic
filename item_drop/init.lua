dofile(minetest.get_modpath("item_drop").."/item_entity.lua")
time_pick = 3

if technic.config:getBool("enable_item_pickup") then
	minetest.register_globalstep(function(dtime)
		for _,player in ipairs(minetest.get_connected_players()) do
			if player and player:get_hp() > 0 then
			local pos = player:getpos()
			pos.y = pos.y+0.5
			local inv = player:get_inventory()
			for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 2)) do
				if not object:is_player() and object:get_luaentity() then
					local obj=object:get_luaentity()
					if obj.name == "__builtin:item" then
						if inv:room_for_item("main", ItemStack(obj.itemstring)) then
							if obj.timer > time_pick then
								inv:add_item("main", ItemStack(obj.itemstring))
								if obj.itemstring ~= "" then
									minetest.sound_play("item_drop_pickup",{pos = pos, gain = 1.0, max_hear_distance = 10}) 
								end
								if object:get_luaentity() then
									object:get_luaentity().itemstring = ""
									object:remove()
								end
							end
						end
					end
				end
			end
			end
		end
	end)
end

if technic.config:getBool("enable_item_drop") then
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
