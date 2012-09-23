minetest.register_craft({
	output = 'technic:deployer_off 1',
	recipe = {
		{'default:wood', 'default:chest','default:wood'},
		{'default:stone', 'mesecons:piston','default:stone'},
		{'default:stone', 'mesecons:mesecon','default:stone'},

	}
})

minetest.register_node("technic:deployer_off", {
	description = "Deployer",
	tile_images = {"technic_deployer_top.png","technic_deployer_bottom.png","technic_deployer_side2.png","technic_deployer_side1.png",
			"technic_deployer_back.png","technic_deployer_front_off.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon_receptor_off = 1, mesecon_effector_off = 1, mesecon = 2,tubedevice=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	end,
	
})

minetest.register_node("technic:deployer_on", {
	description = "Deployer",
	tile_images = {"technic_deployer_top.png","technic_deployer_bottom.png","technic_deployer_side2.png","technic_deployer_side1.png",
			"technic_deployer_back.png","technic_deployer_front_on.png"},
	is_ground_content = true,
	paramtype2 = "facedir",
	tubelike=1,
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2, mesecon_receptor_off = 1, mesecon_effector_off = 1, mesecon = 2,tubedevice=1,not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
})

mesecon:register_on_signal_on(function(pos, node)
	if node.name == "technic:deployer_off" then
		minetest.env:add_node(pos, {name="technic:deployer_on", param2 = node.param2})
		nodeupdate(pos)
	end
end)

mesecon:register_on_signal_off(function(pos, node)
	if node.name == "technic:deployer_on" then
		minetest.env:add_node(pos, {name="technic:deployer_off", param2 = node.param2})
		nodeupdate(pos)
	end
end)

mesecon:register_effector("technic:deployer_on", "technic:deployer_off")


