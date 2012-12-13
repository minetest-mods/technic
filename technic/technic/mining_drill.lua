mining_drill_max_charge=60000

minetest.register_tool("technic:mining_drill", {
	description = "Mining Drill",
	inventory_image = "technic_mining_drill.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" then 
		item=itemstack:to_table()
		if item["metadata"]=="" or item["metadata"]=="0" then return end --tool not charged 
		charge=tonumber(item["metadata"]) 
		if charge-200>0 then
		 drill_dig_it(minetest.get_pointed_thing_position(pointed_thing, above),user)
		 charge =charge-200;	
		item["metadata"]=tostring(charge)
		set_RE_wear(item,charge,mining_drill_max_charge)
		itemstack:replace(item)
		end
		return itemstack
		end
	end,
})

minetest.register_craft({
	output = 'technic:mining_drill',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:diamond_drill_head', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'technic:motor', 'technic:stainless_steel_ingot'},
		{'', 'technic:red_energy_crystal', 'moreores:copper_ingot'},
	}
})






function drill_dig_it (pos, player)		
	local node=minetest.env:get_node(pos)
	if node.name == "air" or node.name == "ignore" then return end
	if node.name == "default:lava_source" then return end
	if node.name == "default:lava_flowing" then return end
	if node.name == "default:water_source" then minetest.env:remove_node(pos) return end
	if node.name == "default:water_flowing" then minetest.env:remove_node(pos) return end

	minetest.sound_play("mining_drill", {pos = pos, gain = 1.0, max_hear_distance = 10,})
	minetest.node_dig(pos,node,player)

end