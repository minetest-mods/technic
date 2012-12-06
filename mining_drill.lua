-- Max charge for the three different drills.

-- Low power drill variable

mining_drill_r_max_charge=60000

-- Medium power drill variable

mining_drill_g_max_charge=120000

-- High power drill variable.

mining_drill_b_max_charge=240000

-- Lov voltage mining drill

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
		set_RE_wear(item,charge,mining_drill_r_max_charge)
		itemstack:replace(item)
		end
		return itemstack
		end
	end,
})

-- Medium Voltage mining drill

minetest.register_tool("technic:mining_drill_g", {
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
		set_RE_wear(item,charge,mining_drill_g_max_charge)
		itemstack:replace(item)
		end
		return itemstack
		end
	end,
})

-- High voltage mining drill

minetest.register_tool("technic:mining_drill_b", {
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
		set_RE_wear(item,charge,mining_drill_b_max_charge)
		itemstack:replace(item)
		end
		return itemstack
		end
	end,
})

-- Create a craftitem drill

minetest.register_craftitem( "technic:mining_drill_empty", {
	description = "Mining Drill",
	inventory_image = "technic_mining_drill.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

-- Low Power mining drill

minetest.register_craft({
	output = 'technic:mining_drill',
	recipe = {
		{'', 'technic:mining_drill_empty', ''},
		{'', 'technic:red_energy_crystal', ''},
	}
})

-- Medium power mining drill

minetest.register_craft({
	output = 'technic:mining_drill_g',
	recipe = {
		{'', 'technic:mining_drill_empty', ''},
		{'', 'technic:green_energy_crystal', ''},
	}
})

-- High power mining drill

minetest.register_craft({
	output = 'technic:mining_drill_b',
	recipe = {
		{'', 'technic:mining_drill_empty', ''},
		{'', 'technic:blue_energy_crystal', ''},
	}
})

-- Register a craft for the useless mining drill.

minetest.register_craft({
	output = 'technic:mining_drill_empty',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:diamond_drill_head', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', '', 'technic:stainless_steel_ingot'},
		{'', 'moreores:copper_ingot', ''},
	}
})

-- These return the energy crystal and the empty mining drill

minetest.register_craft({
	output = 'technic:red_energy_crystal',
	recipe = {
		{'', 'technic:mining_drill', ''},
	},
	replacements = { { 'technic:mining_drill', 'technic:mining_drill_empty' }, },
})

minetest.register_craft({
	output = 'technic:green_energy_crystal',
	recipe = {
		{'', 'technic:mining_drill_g', ''},
	},
	replacements = { { 'technic:mining_drill_g', 'technic:mining_drill_empty' }, },
})

minetest.register_craft({
	output = 'technic:blue_energy_crystal',
	recipe = {
		{'', 'technic:mining_drill_b', ''},
	},
	replacements = { { 'technic:mining_drill_b', 'technic:mining_drill_empty' }, },
})


-- Function for digging blocks that is not either lava or water.

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