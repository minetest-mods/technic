minetest.register_craft({
	output = 'technic:deployer_off 1',
	recipe = {
		{'default:wood', 'default:chest','default:wood'},
		{'default:stone', 'mesecons:piston','default:stone'},
		{'default:stone', 'mesecons:mesecon','default:stone'},

	}
})

deployer_signal_on = function(pos, node)
	local pos1={}
	pos1.x=pos.x
	pos1.y=pos.y
	pos1.z=pos.z
	if node.param2==3 then pos1.x=pos1.x+1 end
	if node.param2==2 then pos1.z=pos1.z+1 end
	if node.param2==1 then pos1.x=pos1.x-1 end
	if node.param2==0 then pos1.z=pos1.z-1 end

	if node.name == "technic:deployer_off" then
		local node1=minetest.env:get_node(pos1)
		if node1.name == "air" then 
			hacky_swap_node(pos,"technic:deployer_on")
			nodeupdate(pos)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			local i=0
			for _,stack in ipairs(inv:get_list("main")) do
			i=i+1
			if stack:get_name() ~=nil and minetest.registered_nodes[stack:get_name()]~=nil then 
				node1={name=stack:get_name(), param1=0, param2=node.param2}
				minetest.env:place_node(pos1,node1)
				stack:take_item(1);
				inv:set_stack("main", i, stack)
				return
				end
			end
	end
	end
end

deployer_signal_off = function(pos, node)
	if node.name == "technic:deployer_on" then
		hacky_swap_node(pos,"technic:deployer_off")
		nodeupdate(pos)
	end
end

minetest.register_node("technic:deployer_off", {
	description = "Deployer",
	tile_images = {"technic_deployer_top.png","technic_deployer_bottom.png","technic_deployer_side2.png","technic_deployer_side1.png",
			"technic_deployer_back.png","technic_deployer_front_off.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon = 2,tubedevice=1, tubedevice_receiver=1},
	mesecons = {effector={action_on=deployer_signal_on}},
	tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("main",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("main",stack)
		end,
		input_inventory="main"},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"label[0,0;Deployer]"..
				"list[current_name;main;4,1;3,3;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Deployer")
		local inv = meta:get_inventory()
		inv:set_size("main", 3*3)
	end,

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("main") then
			return false
		end
		return true
		end,
	
})

minetest.register_node("technic:deployer_on", {
	description = "Deployer",
	tile_images = {"technic_deployer_top.png","technic_deployer_bottom.png","technic_deployer_side2.png","technic_deployer_side1.png",
			"technic_deployer_back.png","technic_deployer_front_on.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon = 2,tubedevice=1, tubedevice_receiver=1,not_in_creative_inventory=1},
	mesecons = {effector={action_off=deployer_signal_off}},
		tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("main",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("main",stack)
		end,
		input_inventory="main"},
	sounds = default.node_sound_stone_defaults(),
})
