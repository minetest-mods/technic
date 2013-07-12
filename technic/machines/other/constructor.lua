
minetest.register_craft({
	type = "shapeless",
	output = 'technic:constructor_mk1_off 1',
	recipe = {'technic:nodebreaker_off', 'technic:deployer_off'},

})
minetest.register_craft({
	type = "shapeless",
	output = 'technic:constructor_mk2_off 1',
	recipe = {'technic:constructor_mk1_off', 'technic:constructor_mk1_off'},

})

minetest.register_craft({
	type = "shapeless",
	output = 'technic:constructor_mk3_off 1',
	recipe = {'technic:constructor_mk2_off', 'technic:constructor_mk2_off'},

})

mk1_on = function(pos, node)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local pos1={}
	pos1.x=pos.x
	pos1.y=pos.y
	pos1.z=pos.z
	if node.param2==3 then pos1.x=pos1.x+1 end
	if node.param2==2 then pos1.z=pos1.z+1 end
	if node.param2==1 then pos1.x=pos1.x-1 end
	if node.param2==0 then pos1.z=pos1.z-1 end

	if node.name == "technic:constructor_mk1_off" then
		hacky_swap_node(pos,"technic:constructor_mk1_on")
		nodeupdate(pos)
		local node1=minetest.env:get_node(pos1)
		deploy_node (inv,"slot1",pos1,node1,node)
	end
end

mk1_off = function(pos, node)
	if node.name == "technic:constructor_mk1_on" then
		hacky_swap_node(pos,"technic:constructor_mk1_off")
		nodeupdate(pos)
	end
end


minetest.register_node("technic:constructor_mk1_off", {
	description = "Constructor MK1",
	tile_images = {"technic_constructor_mk1_top_off.png","technic_constructor_mk1_bottom_off.png","technic_constructor_mk1_side2_off.png","technic_constructor_mk1_side1_off.png",
			"technic_constructor_back.png","technic_constructor_front_off.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon_receptor_off = 1, mesecon_effector_off = 1, mesecon = 2},
	mesecons= {effector={action_on=mk1_on}},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"label[0,0;Constructor MK1]"..
				"label[5,0;Slot 1]"..
				"list[current_name;slot1;6,0;1,1;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Constructor MK1")
		local inv = meta:get_inventory()
		inv:set_size("slot1", 1)
	end,

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("slot1")
	end,	
})

minetest.register_node("technic:constructor_mk1_on", {
	description = "Constructor MK1",
	tile_images = {"technic_constructor_mk1_top_on.png","technic_constructor_mk1_bottom_on.png","technic_constructor_mk1_side2_on.png","technic_constructor_mk1_side1_on.png",
			"technic_constructor_back.png","technic_constructor_front_on.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,mesecon = 2,not_in_creative_inventory=1},
	mesecons= {effector={action_off=mk1_off}},
	sounds = default.node_sound_stone_defaults(),
})


--Constructor MK2

mk2_on = function(pos, node)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	local pos1={}
	local pos2={}
	pos1.x=pos.x
	pos1.y=pos.y
	pos1.z=pos.z
	pos2.x=pos.x
	pos2.y=pos.y
	pos2.z=pos.z
	if node.param2==3 then pos1.x=pos1.x+1 pos2.x=pos2.x+2 end
	if node.param2==2 then pos1.z=pos1.z+1 pos2.z=pos2.z+2 end
	if node.param2==1 then pos1.x=pos1.x-1 pos2.x=pos2.x-2 end
	if node.param2==0 then pos1.z=pos1.z-1 pos2.z=pos2.z-2 end

	if node.name == "technic:constructor_mk2_off" then
		hacky_swap_node(pos,"technic:constructor_mk2_on")
		nodeupdate(pos)
		local node1=minetest.env:get_node(pos1)
		deploy_node (inv,"slot1",pos1,node1,node)
		local node1=minetest.env:get_node(pos2)	
		deploy_node (inv,"slot2",pos2,node1,node)
	end
end

mk2_off = function(pos, node)
	if node.name == "technic:constructor_mk2_on" then
		hacky_swap_node(pos,"technic:constructor_mk2_off")
		nodeupdate(pos)
	end
end

minetest.register_node("technic:constructor_mk2_off", {
	description = "Constructor MK2",
	tile_images = {"technic_constructor_mk2_top_off.png","technic_constructor_mk2_bottom_off.png","technic_constructor_mk2_side2_off.png","technic_constructor_mk2_side1_off.png",
			"technic_constructor_back.png","technic_constructor_front_off.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon = 2},
	mesecons= {effector={action_on=mk2_on}},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"label[0,0;Constructor MK2]"..
				"label[5,0;Slot 1]"..
				"list[current_name;slot1;6,0;1,1;]"..
				"label[5,1;Slot 2]"..
				"list[current_name;slot2;6,1;1,1;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Constructor MK2")
		local inv = meta:get_inventory()
		inv:set_size("slot1", 1)
		inv:set_size("slot2", 1)
	end,

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("slot1")==false or inv:is_empty("slot2")==false then return false end
		return true
	end,	
})

minetest.register_node("technic:constructor_mk2_on", {
	description = "Constructor MK2",
	tile_images = {"technic_constructor_mk2_top_on.png","technic_constructor_mk2_bottom_on.png","technic_constructor_mk2_side2_on.png","technic_constructor_mk2_side1_on.png",
			"technic_constructor_back.png","technic_constructor_front_on.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon = 2, not_in_creative_inventory=1},
	mesecons= {effector={action_off=mk2_off}},
	sounds = default.node_sound_stone_defaults(),
})


-- Constructor MK3
mk3_on = function(pos, node)
	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	
	local pos1={}
	local pos2={}
	local pos3={}
	local pos4={}
	
	pos1.x=pos.x
	pos1.y=pos.y
	pos1.z=pos.z
	
	pos2.x=pos.x
	pos2.y=pos.y
	pos2.z=pos.z
	
	pos3.x=pos.x
	pos3.y=pos.y
	pos3.z=pos.z

	pos4.x=pos.x
	pos4.y=pos.y
	pos4.z=pos.z

	if node.param2==3 then pos1.x=pos1.x+1 pos2.x=pos2.x+2 pos3.x=pos3.x+3 pos4.x=pos4.x+4 end
	if node.param2==2 then pos1.z=pos1.z+1 pos2.z=pos2.z+2 pos3.z=pos3.z+3 pos4.z=pos4.z+4 end
	if node.param2==1 then pos1.x=pos1.x-1 pos2.x=pos2.x-2 pos3.x=pos3.x-3 pos4.x=pos4.x-4 end
	if node.param2==0 then pos1.z=pos1.z-1 pos2.z=pos2.z-2 pos3.z=pos3.z-3 pos4.z=pos4.z-4 end

	if node.name == "technic:constructor_mk3_off" then
		hacky_swap_node(pos,"technic:constructor_mk3_on")
		nodeupdate(pos)
		local node1=minetest.env:get_node(pos1)
		deploy_node (inv,"slot1",pos1,node1,node)
		local node1=minetest.env:get_node(pos2)	
		deploy_node (inv,"slot2",pos2,node1,node)
		local node1=minetest.env:get_node(pos3)	
		deploy_node (inv,"slot3",pos3,node1,node)
		local node1=minetest.env:get_node(pos4)	
		deploy_node (inv,"slot4",pos4,node1,node)
	end
end

mk3_off = function(pos, node)
	if node.name == "technic:constructor_mk3_on" then
		hacky_swap_node(pos,"technic:constructor_mk3_off")
		nodeupdate(pos)
	end
end

minetest.register_node("technic:constructor_mk3_off", {
	description = "Constructor MK3",
	tile_images = {"technic_constructor_mk3_top_off.png","technic_constructor_mk3_bottom_off.png","technic_constructor_mk3_side2_off.png","technic_constructor_mk3_side1_off.png",
			"technic_constructor_back.png","technic_constructor_front_off.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon = 2},
	mesecons= {effector={action_on=mk3_on}},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"label[0,0;Constructor MK2]"..
				"label[5,0;Slot 1]"..
				"list[current_name;slot1;6,0;1,1;]"..
				"label[5,1;Slot 2]"..
				"list[current_name;slot2;6,1;1,1;]"..
				"label[5,2;Slot 3]"..
				"list[current_name;slot3;6,2;1,1;]"..
				"label[5,3;Slot 4]"..
				"list[current_name;slot4;6,3;1,1;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Constructor MK3")
		local inv = meta:get_inventory()
		inv:set_size("slot1", 1)
		inv:set_size("slot2", 1)
		inv:set_size("slot3", 1)
		inv:set_size("slot4", 1)

	end,

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("slot1")==false or inv:is_empty("slot2")==false or inv:is_empty("slot3")==false or inv:is_empty("slot4")==false then return false end
		return true
	end,	
})

minetest.register_node("technic:constructor_mk3_on", {
	description = "Constructor MK3",
	tile_images = {"technic_constructor_mk3_top_on.png","technic_constructor_mk3_bottom_on.png","technic_constructor_mk3_side2_on.png","technic_constructor_mk3_side1_on.png",
			"technic_constructor_back.png","technic_constructor_front_on.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon = 2,not_in_creative_inventory=1},
	mesecons= {effector={action_off=mk3_off}},
	sounds = default.node_sound_stone_defaults(),
})


deploy_node =function (inv, slot_name, pos1, node1, node)
	if node1.name == "air" then 
		if not inv:is_empty(slot_name) then
			stack1=inv:get_list(slot_name)
			local def = stack1[1]:get_definition()
			if def.type == "node" then
				node_to_be_placed={name=stack1[1]:get_name(), param1=0, param2=node.param2}
				minetest.env:set_node(pos1,node_to_be_placed)
				stack1[1]:take_item()
				inv:set_stack(slot_name, 1, stack1[1])
			elseif def.type == "craft" then
				if def.on_place then
					-- print("deploy_node: item has on_place. trying...")
					local ok, stk = pcall(def.on_place, stack1[1], nil, {
						-- Fake pointed_thing
						type = "node",
						above = pos1,
						under = { x=pos1.x, y=pos1.y-1, z=pos1.z },
					})
					if ok then
						-- print("deploy_node: on_place succeeded!")
						inv:set_stack(slot_name, 1, stk or stack1[1])
						return
					-- else
						-- print("deploy_node: WARNING: error while running on_place: "..tostring(stk))
					end
				end
				minetest.item_place_object(stack1[1], nil, {
					-- Fake pointed_thing
					type = "node",
					above = pos1,
					under = pos1,
				})
				inv:set_stack(slot_name, 1, nil)
			end
		end
		return 
	end
	if node1.name == "ignore" or
	   node1.name == "default:lava_source" or
	   node1.name == "default:lava_flowing" or
	   node1.name == "default:water_source" or
	   node1.name == "default:water_flowing" 
	   then return end
	if inv:room_for_item(slot_name,node1) then
		local def = minetest.registered_nodes[node1.name]
		if not def then return end
		local drop = def.drop or node1.name
		if type(drop) == "table" then
			local pr = PseudoRandom(math.random())
			local c = 0
			local loop = 0 -- Prevent infinite loop
			while (c < (drop.max_items or 1)) and (loop < 1000) do
				local i = math.floor(pr:next(1, #drop.items))
				if pr:next(1, drop.items[i].rarity or 1) == 1 then
					for _,item in ipairs(drop.items[i].items) do
						inv:add_item(slot_name,item)
					end
					c = c + 1
				end
				loop = loop + 1
			end
			minetest.env:remove_node(pos1)
		elseif type(drop) == "string" then
			inv:add_item(slot_name,drop)
			minetest.env:remove_node(pos1)
		end
	end

end
