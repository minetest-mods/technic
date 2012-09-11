mining_drill_max_charge=60000

minetest.register_tool("technic:mining_drill", {
	description = "Mining Drill",
	inventory_image = "technic_mining_drill.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" then 
		item=itemstack:to_table()
		local charge=tonumber((item["wear"])) 
		if charge ==0 then charge =65535 end
		charge=get_RE_item_load(charge,mining_drill_max_charge)
		if charge-200>0 then
		 drill_dig_it(minetest.get_pointed_thing_position(pointed_thing, above),user)
		 charge =charge-200;	
		charge=set_RE_item_load(charge,mining_drill_max_charge)
		item["wear"]=tostring(charge)
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
		{'technic:stainless_steel_ingot', 'technic:red_energy_crystal', 'technic:stainless_steel_ingot'},
		{'', 'moreores:copper_ingot', ''},
	}
})






function drill_dig_it (pos, player)		
	local node=minetest.env:get_node(pos)
	if node.name == "air" then return end
	if node.name == "default:lava_source" then return end
	if node.name == "default:lava_flowing" then return end
	if node.name == "default:water_source" then minetest.env:remove_node(pos) return end
	if node.name == "default:water_flowing" then minetest.env:remove_node(pos) return end
	if node.name == "ignore" then minetest.env:remove_node(pos) return end

	if player then 
	local drops = minetest.get_node_drops(node.name, "default:pick_mese")
	if player:get_inventory() then
		local _, dropped_item
		for _, dropped_item in ipairs(drops) do
			player:get_inventory():add_item("main", dropped_item)
		end
	end
	minetest.env:remove_node(pos)
	end

end