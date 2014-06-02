minetest.register_node("factory:belt", {
	description = "Conveyor Belt",
	tiles = {{name="factory_belt_top_animation.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.4}}, "factory_belt_bottom.png", "factory_belt_side.png",
		"factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png"},
	groups = {cracky=1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	node_box = {
			type = "fixed",
			fixed = {{-0.5,-0.5,-0.5,0.5,0.0625,0.5},}
		},
})

minetest.register_abm({
	nodenames = {"factory:belt"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local all_objects = minetest.get_objects_inside_radius(pos, 1)
		local _,obj
		for _,obj in ipairs(all_objects) do
			if not obj:is_player() and obj:get_luaentity() and obj:get_luaentity().name == "__builtin:item" then
				local a = minetest.facedir_to_dir(minetest.get_node(pos).param2)
				local b = {x = obj:getpos().x + (a.x / 3.5), y = obj:getpos().y, z = obj:getpos().z + (a.z / 3.5),}
				obj:moveto(b, false)
			end
		end
	end,
})

minetest.register_node("factory:arm",{
	drawtype = "nodebox",
	tiles = {"factory_steel_noise.png"},
	paramtype = "light",
	description = "Pneumatic Mover",
	groups = {cracky=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.4375,0.5}, --base1
			{-0.125,-0.5,-0.375,0.125,0.0625,0.375}, --base2
			{-0.125,0.25,-0.5,0.125,0.3125,0.375}, --tube
			{-0.375,-0.5,-0.0625,0.375,0.0625,0.0625}, --base3
			{-0.125,-0.125,0.375,0.125,0.125,0.5}, --tube2
			{-0.125,0.0625,0.3125,0.125,0.25,0.375}, --NodeBox6
			{-0.125,0.0625,-0.5,-0.0625,0.25,0.3125}, --NodeBox7
			{0.0625,0.0625,-0.5,0.125,0.25,0.3125}, --NodeBox8
			{-0.0625,0.0625,-0.5,0.0625,0.125,0.3125}, --NodeBox9
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.5,0.5},
		}
	},
})

minetest.register_abm({
	nodenames = {"factory:arm"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local all_objects = minetest.get_objects_inside_radius(pos, 0.8)
		local _,obj
		for _,obj in ipairs(all_objects) do
			if not obj:is_player() and obj:get_luaentity() and obj:get_luaentity().name == "__builtin:item" then
				local a = minetest.facedir_to_dir(minetest.get_node(pos).param2)
				local b = {x = pos.x + a.x, y = pos.y + a.y, z = pos.z + a.z,}
				local target = minetest.get_node(b)
				local stack = ItemStack(obj:get_luaentity().itemstring)
				if target.name == "default:chest" or target.name == "default:chest_locked" then
					local meta = minetest.env:get_meta(b)
					local inv = meta:get_inventory()
					if inv:room_for_item("main", stack) then
						inv:add_item("main", stack)
						obj:remove()
					else
						obj:moveto({x = pos.x + (a.x * 2), y = pos.y + 0.5, z = pos.z + (a.z * 2)}, false)
					end
				end
				for i,v in ipairs(armDevicesFurnacelike) do
					if target.name == v then
						local a = minetest.facedir_to_dir(minetest.get_node(pos).param2)
						local b = {x = pos.x + a.x, y = pos.y + a.y, z = pos.z + a.z,}
						local meta = minetest.env:get_meta(b)
						local inv = meta:get_inventory()

						if minetest.dir_to_facedir({x = -a.x, y = -a.y, z = -a.z}) == minetest.get_node(b).param2 then
							-- back, fuel
							if inv:room_for_item("fuel", stack) then
								inv:add_item("fuel", stack)
								obj:remove()
							else
								obj:moveto({x = pos.x + (a.x * 2), y = pos.y + 0.5, z = pos.z + (a.z * 2)}, false)
							end
						else
							-- everytin else, src
							if inv:room_for_item("src", stack) then
								inv:add_item("src", stack)
								obj:remove()
							else
								obj:moveto({x = pos.x + (a.x * 2), y = pos.y + 0.5, z = pos.z + (a.z * 2)}, false)
							end
						end
					end
				end
			end
		end
	end,
})

function factory.register_taker(prefix, suffix, speed, name, ctiles)
	minetest.register_node("factory:"..prefix.."taker"..suffix,{
		drawtype = "nodebox",
		tiles = ctiles,
		paramtype = "light",
		description = name,
		groups = {cracky=3},
		paramtype2 = "facedir",
		legacy_facedir_simple = true,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.5,0.5,-0.4375,0.5}, --base1
				{-0.125,-0.5,-0.375,0.125,0.0625,0.375}, --base2
				{-0.125,0.25,-0.5,0.125,0.3125,0.375}, --tube
				{-0.375,-0.5,-0.0625,0.375,0.0625,0.0625}, --base3
				{-0.125,-0.125,0.375,0.125,0.125,0.5}, --tube2
				{-0.125,0.0625,0.3125,0.125,0.25,0.375}, --NodeBox6
				{-0.125,0.0625,-0.5,-0.0625,0.25,0.3125}, --NodeBox7
				{0.0625,0.0625,-0.5,0.125,0.25,0.3125}, --NodeBox8
				{-0.0625,0.0625,-0.5,0.0625,0.125,0.3125}, --NodeBox9
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.5,0.5,0.5,0.5},
			}
		},
	})

	minetest.register_abm({
		nodenames = {"factory:"..prefix.."taker"..suffix},
		neighbors = nil,
		interval = speed,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local a = minetest.facedir_to_dir(minetest.get_node(pos).param2)
			local b = {x = pos.x + a.x, y = pos.y + a.y, z = pos.z + a.z,}
			local target = minetest.get_node(b)
			if target.name == "default:chest" or target.name == "default:chest_locked" then
				local meta = minetest.env:get_meta(b)
				local inv = meta:get_inventory()
				if not inv:is_empty("main") then
					local list = inv:get_list("main")
					local i,item
					for i,item in ipairs(inv:get_list("main")) do
						if item:get_name() ~= "" then
							local droppos = {x = pos.x - (a.x/1.5), y = pos.y + 0.5, z = pos.z - (a.z/1.5)}
							if factory.logTaker then print(name.." at "..pos.x..", "..pos.y..", "..pos.z.." takes "..item:get_name().." from "..target.name) end
							minetest.item_drop(item:peek_item(1), "", droppos)
							item:take_item()
							inv:set_stack("main", i, item)
							return
						end
					end
				end
			end
			for i,v in ipairs(takerDevicesFurnacelike) do
				if target.name == v then
					local meta = minetest.env:get_meta(b)
					local inv = meta:get_inventory()
					if not inv:is_empty("dst") then
						local list = inv:get_list("dst")
						for k,item in ipairs(inv:get_list("dst")) do
							if item:get_name() ~= "" then
								local droppos = {x = pos.x - (a.x/1.5), y = pos.y + 0.5, z = pos.z - (a.z/1.5)}
								if factory.logTaker then print(name.." at "..pos.x..", "..pos.y..", "..pos.z.." takes "..item:get_name().." from "..target.name) end
								minetest.item_drop(item:peek_item(1), "", droppos)
								item:take_item()
								inv:set_stack("dst", k, item)
								return
							end
						end
					end
				end
			end
		end,
	})
end

factory.register_taker("", "", 2.5, "Pneumatic Taker", {"factory_steel_noise_red.png"})
factory.register_taker("", "_gold", 1.8, "Pneumatic Taker Mk II", {"factory_steel_noise_gold.png"})
factory.register_taker("", "_diamond", 1.2, "Pneumatic Taker MK III", {"factory_steel_noise_diamond.png"})

minetest.register_node("factory:smoke_tube", {
	drawtype = "nodebox",
	tiles = {"factory_machine_brick_1.png"},
	paramtype = "light",
	description = "Smoke Tube",
	groups = {cracky=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125,-0.5,0.3125,0.125,0.5,0.375}, 
			{-0.125,-0.5,-0.375,0.125,0.5,-0.3125},
			{0.3125,-0.5,-0.125,0.375,0.5,0.125}, 
			{-0.375,-0.5,-0.125,-0.3125,0.5,0.125},
			{0.125,-0.5,0.25,0.25,0.5,0.3125},
			{0.25,-0.5,0.125,0.3125,0.5,0.25},
			{0.25,-0.5,-0.25,0.3125,0.5,-0.125},
			{0.125,-0.5,-0.3125,0.25,0.5,-0.25},
			{-0.25,-0.5,-0.3125,-0.125,0.5,-0.25},
			{-0.3125,-0.5,-0.25,-0.25,0.5,-0.125},
			{-0.3125,-0.5,0.125,-0.25,0.5,0.25},
			{-0.25,-0.5,0.25,-0.125,0.5,0.3125},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.375,-0.5,-0.375,0.375,0.5,0.375},
		}
	},
})

function qarm_handle (a, b, target, stack, minv, obj)
	if target.name == "default:chest" or target.name == "default:chest_locked" then
		local meta = minetest.env:get_meta(b)
		local inv = meta:get_inventory()

		if inv:room_for_item("main", stack) then
			inv:add_item("main", stack)
			if obj~=nil then obj:remove() end
		elseif minv:room_for_item("main", stack) then
			minv:add_item("main", stack)
			if obj~=nil then obj:remove() end
		else  
			if obj~=nil then obj:moveto({x = pos.x + (a.x * 2), y = pos.y + 0.5, z = pos.z + (a.z * 2)}, false) end
		end
	end
	for i,v in ipairs(armDevicesFurnacelike) do
		if target.name == v then
			local meta = minetest.env:get_meta(b)
			local inv = meta:get_inventory()

			if minetest.dir_to_facedir({x = -a.x, y = -a.y, z = -a.z}) == minetest.get_node(b).param2 then
				-- back, fuel
				if inv:room_for_item("fuel", stack) then
					inv:add_item("fuel", stack)
					if obj~=nil then obj:remove() end
				elseif minv:room_for_item("main", stack) then
					minv:add_item("main", stack)
					if obj~=nil then obj:remove() end
				else
					if obj~=nil then obj:moveto({x = pos.x + (a.x * 2), y = pos.y + 0.5, z = pos.z + (a.z * 2)}, false) end
				end
			else
				-- everytin else, src
				if inv:room_for_item("src", stack) then
					inv:add_item("src", stack)
					if obj~=nil then obj:remove() end
				elseif minv:room_for_item("main", stack) then
					minv:add_item("main", stack)
					if obj~=nil then obj:remove() end
				else
					if obj~=nil then obj:moveto({x = pos.x + (a.x * 2), y = pos.y + 0.5, z = pos.z + (a.z * 2)}, false) end
				end
			end
		end
	end
end

factory.qformspec =
	"size[8,8.5]"..
	factory_gui_bg..
	factory_gui_bg_img..
	factory_gui_slots..
	"list[current_name;main;0,0.3;8,3;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	factory.get_hotbar_bg(0,4.25)

minetest.register_node("factory:queuedarm",{
	drawtype = "nodebox",
	tiles = {"factory_steel_noise.png"},
	paramtype = "light",
	description = "Queued Pneumatic Mover",
	groups = {cracky=3},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.4375,0.5}, --base1
			{-0.125,-0.5,-0.375,0.125,0.0625,0.375}, --base2
			{-0.125,0.25,-0.5,0.125,0.3125,0.375}, --tube
			{-0.375,-0.5,-0.1875,0.375,0.0625,0.0625}, --base3
			{-0.125,-0.125,0.375,0.125,0.125,0.5}, --tube2
			{-0.125,0.0625,0.3125,0.125,0.25,0.375}, --nodebox6
			{-0.125,0.0625,-0.5,-0.0625,0.25,0.3125}, --nodebox7
			{0.0625,0.0625,-0.5,0.125,0.25,0.3125}, --nodebox8
			{-0.0625,0.0625,-0.5,0.0625,0.125,0.3125}, --nodebox9
			{-0.25,0.3125,-0.125,0.25,0.8,0.375}, --NodeBox10
			{-0.1875,0.1875,-0.5,-0.125,0.3125,0.375}, --NodeBox11
			{0.125,0.1875,-0.5,0.1875,0.3125,0.375}, --NodeBox12
			{-0.125,0.3125,-0.4375,0.125,0.5,-0.125}, --NodeBox13
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,0.5,0.5},
		}
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",factory.qformspec)
		meta:set_string("infotext", "Queued Pneumatic Mover")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*3)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in queued mover at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to queued mover at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from queued mover at "..minetest.pos_to_string(pos))
	end,
})

minetest.register_abm({
	nodenames = {"factory:queuedarm"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local mmeta = minetest.env:get_meta(pos)
		local minv = mmeta:get_inventory()
		local all_objects = minetest.get_objects_inside_radius(pos, 0.8)
		local a = minetest.facedir_to_dir(minetest.get_node(pos).param2)
		local b = {x = pos.x + a.x, y = pos.y + a.y, z = pos.z + a.z,}
		local target = minetest.get_node(b)
		for _,obj in ipairs(all_objects) do
			if not obj:is_player() and obj:get_luaentity() and obj:get_luaentity().name == "__builtin:item" then
				local stack = ItemStack(obj:get_luaentity().itemstring)
				qarm_handle(a, b, target, stack, minv, obj)
			end
		end
		for i,stack in ipairs(minv:get_list("main")) do
			if stack:get_name() ~= "" then
				minv:remove_item("main", stack)
				qarm_handle(a, b, target, stack, minv, nil)
				return
			end
		end	
	end,
})

minetest.register_node("factory:factory_brick", {
	description = "Factory Brick",
	tiles = {"factory_brick.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})