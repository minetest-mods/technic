water_can_max_load = 16

minetest.register_craft({
	output = 'technic:water_can 1',
	recipe = {
		{'technic:zinc_ingot', 'technic:rubber_fiber','technic:zinc_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'technic:zinc_ingot', 'default:steel_ingot', 'technic:zinc_ingot'},
	}
})

minetest.register_tool("technic:water_can", {
	description = "Water Can",
	inventory_image = "technic_water_can.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		
		if pointed_thing.type ~= "node" then
					return end
		
		n = minetest.env:get_node(pointed_thing.under)
		if n.name == "default:water_source" then
			item=itemstack:to_table()
			local load=tonumber((item["wear"])) 
			if  load==0 then load =65535 end
			load=get_RE_item_load(load,water_can_max_load)
			print ("Water can load"..load)
			if load+1<17 then
			minetest.env:add_node(pointed_thing.under, {name="air"})
			 load=load+1;	
			load=set_RE_item_load(load,water_can_max_load)
			item["wear"]=tostring(load)
			itemstack:replace(item)
			end
			return itemstack
		end
		item=itemstack:to_table()
			load=tonumber((item["wear"])) 
			if  load==0 then load =65535 end
			load=get_RE_item_load(load,water_can_max_load)
			if load==0 then return end
			n = minetest.env:get_node(pointed_thing.under)
			if minetest.registered_nodes[n.name].buildable_to then
			-- buildable
			minetest.env:add_node(pointed_thing.under, {name="default:water_source"})
			load=load-1;	
			load=set_RE_item_load(load,water_can_max_load)
			item["wear"]=tostring(load)
			itemstack:replace(item)
			return itemstack
			else
			n = minetest.env:get_node(pointed_thing.above)
			-- not buildable
			-- check if its allowed to replace the node
			if not minetest.registered_nodes[n.name].buildable_to then
			return
			end
			minetest.env:add_node(pointed_thing.above, {name="default:water_source"})
			load=load-1;	
			load=set_RE_item_load(load,water_can_max_load)
			item["wear"]=tostring(load)
			itemstack:replace(item)
			return itemstack
			end

	end,
})
