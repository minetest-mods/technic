minetest.register_node("technic:nodebreaker_off", {
	description = "Node Breaker",
	tile_images = {"technic_nodebreaker_top.png","technic_nodebreaker_bottom.png","technic_nodebreaker_side2.png","technic_nodebreaker_side1.png",
			"technic_nodebreaker_back.png","technic_nodebreaker_front_off.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon_receptor_off = 1, mesecon_effector_off = 1, mesecon = 2,tubedevice=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	end,
	
})

minetest.register_node("technic:nodebreaker_on", {
	description = "Node Breaker",
	tile_images = {"technic_nodebreaker_top.png","technic_nodebreaker_bottom.png","technic_nodebreaker_side2.png","technic_nodebreaker_side1.png",
			"technic_nodebreaker_back.png","technic_nodebreaker_front_on.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	tubelike=1,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon_receptor_off = 1, mesecon_effector_off = 1, mesecon = 2,tubedevice=1},
	sounds = default.node_sound_stone_defaults(),
})

mesecon:register_on_signal_on(function(pos, node)
	if node.name == "technic:nodebreaker_off" then
		minetest.env:add_node(pos, {name="technic:nodebreaker_on", param2 = node.param2})
		break_node (pos,node.param2)
		nodeupdate(pos)
	end
end)

mesecon:register_on_signal_off(function(pos, node)
	if node.name == "technic:nodebreaker_on" then
		minetest.env:add_node(pos, {name="technic:nodebreaker_off", param2 = node.param2})
		nodeupdate(pos)
	end
end)

mesecon:register_effector("technic:nodebreaker_on", "technic:nodebreaker_off")

function break_node (pos,n_param)		
	local pos1={}
	local pos2={}
	pos1.x=pos.x
	pos1.y=pos.y
	pos1.z=pos.z
	pos2.x=pos.x
	pos2.y=pos.y
	pos2.z=pos.z

	--param2 3=x+ 1=x- 2=z+ 0=z-
	local x_velocity=0
	local z_velocity=0

	if n_param==3 then pos2.x=pos2.x+1 pos1.x=pos1.x-1 x_velocity=-1 end
	if n_param==2 then pos2.z=pos2.z+1 pos1.z=pos1.z-1 z_velocity=-1 end
	if n_param==1 then pos2.x=pos2.x-1 pos1.x=pos1.x+1 x_velocity=1 end
	if n_param==0 then pos2.z=pos2.z-1 pos1.x=pos1.z+1 z_velocity=1 end

	local node=minetest.env:get_node(pos2)
	local meta = minetest.env:get_meta(pos1)
	tubelike=meta:get_int("tubelike")
	--if tubelike==1 then
	if node.name == "air" then return nil end
	if node.name == "default:lava_source" then return nil end
	if node.name == "default:lava_flowing" then return nil end
	if node.name == "default:water_source" then minetest.env:remove_node(pos2) return nil end
	if node.name == "default:water_flowing" then minetest.env:remove_node(pos2) return nil end
	if node.name == "ignore" then minetest.env:remove_node(pos2) return nil end
	local drops = minetest.get_node_drops(node.name, "default:pick_mese")
		local _, dropped_item
		for _, dropped_item in ipairs(drops) do
			local item1=tube_item({x=pos.x,y=pos.y,z=pos.z},dropped_item)
			item1:get_luaentity().start_pos = {x=pos.x,y=pos.y,z=pos.z}
			item1:setvelocity({x=x_velocity, y=0, z=z_velocity})
			item1:setacceleration({x=0, y=0, z=0})
--			minetest.item_drop(dropped_item, "", pos1)
		end
	minetest.env:remove_node(pos2)
	--end
end

