water_can_max_load = 16
lava_can_max_load = 8

minetest.register_craft({
	output = 'technic:water_can 1',
	recipe = {
		{'technic:zinc_ingot', 'technic:rubber','technic:zinc_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'technic:zinc_ingot', 'default:steel_ingot', 'technic:zinc_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:lava_can 1',
	recipe = {
		{'technic:zinc_ingot', 'technic:stainless_steel_ingot','technic:zinc_ingot'},
		{'technic:stainless_steel_ingot', '', 'technic:stainless_steel_ingot'},
		{'technic:zinc_ingot', 'technic:stainless_steel_ingot', 'technic:zinc_ingot'},
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
		
		item=itemstack:to_table()
		local load=nil
		if item["metadata"]=="" then load=0 
		else load=tonumber(item["metadata"]) 
		end
		
		if n.name == "default:water_source" then
			if load+1<17 then
			minetest.env:add_node(pointed_thing.under, {name="air"})
			 load=load+1;	
			item["metadata"]=tostring(load)
			set_RE_wear(item,load,water_can_max_load)
			itemstack:replace(item)
			end
			return itemstack
		end
		item=itemstack:to_table()
		if load==0 then return end
			
		if n.name == "default:water_flowing" then
			minetest.env:add_node(pointed_thing.under, {name="default:water_source"})
			load=load-1;	
			item["metadata"]=tostring(load)
			set_RE_wear(item,load,water_can_max_load)
			itemstack:replace(item)
			return itemstack
			end

		n = minetest.env:get_node(pointed_thing.above)
		if n.name == "air" then
			minetest.env:add_node(pointed_thing.above, {name="default:water_source"})
			load=load-1;	
			item["metadata"]=tostring(load)
			set_RE_wear(item,load,water_can_max_load)
			itemstack:replace(item)
			return itemstack
			end		
	end,
})

minetest.register_tool("technic:lava_can", {
	description = "Lava Can",
	inventory_image = "technic_lava_can.png",
	stack_max = 1,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then return end
		n = minetest.env:get_node(pointed_thing.under)
		item=itemstack:to_table()
		local load=nil
		if item["metadata"]=="" then load=0 
		else load=tonumber(item["metadata"]) 
		end
		
		if n.name == "default:lava_source" then
			if load+1<17 then
			minetest.env:add_node(pointed_thing.under, {name="air"})
			 load=load+1;
			item["metadata"]=tostring(load)
			set_RE_wear(item,load,lava_can_max_load)
			itemstack:replace(item)
			end
			return itemstack
		end
		item=itemstack:to_table()
		if load==0 then return end
			
		if n.name == "default:lava_flowing" then
			minetest.env:add_node(pointed_thing.under, {name="default:lava_source"})
			load=load-1;	
			item["metadata"]=tostring(load)
			set_RE_wear(item,load,lava_can_max_load)
			itemstack:replace(item)
			return itemstack
			end

		n = minetest.env:get_node(pointed_thing.above)
		if n.name == "air" then
			minetest.env:add_node(pointed_thing.above, {name="default:lava_source"})
			load=load-1;	
			item["metadata"]=tostring(load)
			set_RE_wear(item,load,lava_can_max_load)
			itemstack:replace(item)
			return itemstack
			end	
	end,
})
