mining_drill_max_charge=60000
mining_drill_mk2_max_charge=240000
mining_drill_mk3_max_charge=960000
mining_drill_power_usage=200
mining_drill_mk2_power_usage=600
mining_drill_mk3_power_usage=1800

minetest.register_craft({
	output = 'technic:mining_drill',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:diamond_drill_head', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'technic:motor', 'technic:stainless_steel_ingot'},
		{'', 'technic:red_energy_crystal', 'moreores:copper_ingot'},
	}
})
minetest.register_craft({
	output = 'technic:mining_drill_mk2',
	recipe = {
		{'technic:diamond_drill_head', 'technic:diamond_drill_head', 'technic:diamond_drill_head'},
		{'technic:stainless_steel_ingot', 'technic:mining_drill', 'technic:stainless_steel_ingot'},
		{'', 'technic:green_energy_crystal', ''},
	}
})
minetest.register_craft({
	output = 'technic:mining_drill_mk3',
	recipe = {
		{'technic:diamond_drill_head', 'technic:diamond_drill_head', 'technic:diamond_drill_head'},
		{'technic:stainless_steel_ingot', 'technic:mining_drill_mk2', 'technic:stainless_steel_ingot'},
		{'', 'technic:blue_energy_crystal', ''},
	}
})

function drill_dig_it (pos, player,drill_type,mode)
	
	local charge

	if mode==1 then
		drill_dig_it0 (pos,player)
	end
	
	if mode==2 then -- 3 deep
		dir=drill_dig_it1(player)
		if dir==0 then -- x+
			drill_dig_it0 (pos,player)
			pos.x=pos.x+1
			drill_dig_it0 (pos,player)
			pos.x=pos.x+1
			drill_dig_it0 (pos,player)
		end
		if dir==1 then  -- x-
			drill_dig_it0 (pos,player)
			pos.x=pos.x-1
			drill_dig_it0 (pos,player)
			pos.x=pos.x-1
			drill_dig_it0 (pos,player)
		end
		if dir==2 then  -- z+
			drill_dig_it0 (pos,player)
			pos.z=pos.z+1
			drill_dig_it0 (pos,player)
			pos.z=pos.z+1
			drill_dig_it0 (pos,player)
		end
		if dir==3 then  -- z-
			drill_dig_it0 (pos,player)
			pos.z=pos.z+1
			drill_dig_it0 (pos,player)
			pos.z=pos.z+1
			drill_dig_it0 (pos,player)
		end
	end
	
	if mode==3 then -- 3 wide
		dir=drill_dig_it1(player)
		if dir==0 or dir==1 then -- x
			drill_dig_it0 (pos,player)
			pos.z=pos.z+1
			drill_dig_it0 (pos,player)
			pos.z=pos.z-2
			drill_dig_it0 (pos,player)
		end
		if dir==2 or dir==3 then  -- z
			drill_dig_it0 (pos,player)
			pos.x=pos.x+1
			drill_dig_it0 (pos,player)
			pos.x=pos.x-2
			drill_dig_it0 (pos,player)
		end
	end
	
	if mode==4 then -- 3 tall, selected in the middle
		drill_dig_it0 (pos,player)
		pos.y=pos.y+1
		drill_dig_it0 (pos,player)
		pos.y=pos.y-2
		drill_dig_it0 (pos,player)
	end

	if mode==5 then -- 3 x 3
		local dir=player:get_look_dir()
		if math.abs(dir.y)<0.5 then
			dir=drill_dig_it1(player)
				if dir==0 or dir==1 then -- x
					drill_dig_it2(pos,player)
				end
				if dir==2 or dir==3 then  -- z
					drill_dig_it3(pos,player)
				end
		else
		drill_dig_it4(pos,player)
		end
	end
	
	if drill_type==1 then charge=mining_drill_power_usage end
	if drill_type==2 then 
		if  mode==1 then charge=mining_drill_mk2_power_usage end
		if (mode==2 or mode==3 or mode==4) then charge=mining_drill_mk2_power_usage*3 end
	end
	if drill_type==3 then 
		if  mode==1 then charge=mining_drill_power_usage end
		if (mode==2 or mode==3 or mode==4) then charge=mining_drill_mk2_power_usage*6 end
		if mode==5 then charge=mining_drill_mk2_power_usage*9 end
	end
	minetest.sound_play("mining_drill", {pos = pos, gain = 1.0, max_hear_distance = 10,})
	return charge
end

function drill_dig_it0 (pos,player)
	local node=minetest.env:get_node(pos)
	if node.name == "air" or node.name == "ignore" then return end
	if node.name == "default:lava_source" then return end
	if node.name == "default:lava_flowing" then return end
	if node.name == "default:water_source" then minetest.env:remove_node(pos) return end
	if node.name == "default:water_flowing" then minetest.env:remove_node(pos) return end
	minetest.node_dig(pos,node,player)
end

function drill_dig_it1 (player)
	local dir=player:get_look_dir()
	if math.abs(dir.x)>math.abs(dir.z) then 
		if dir.x>0 then return 0 end
		return 1
	end
	if dir.z>0 then return 2 end
	return 3
end

function drill_dig_it2 (pos,player)
	drill_dig_it0 (pos,player)
	pos.z=pos.z+1
	drill_dig_it0 (pos,player)
	pos.z=pos.z-2
	drill_dig_it0 (pos,player)
	pos.z=pos.z+1
	pos.y=pos.y+1
	drill_dig_it0 (pos,player)
	pos.z=pos.z+1
	drill_dig_it0 (pos,player)
	pos.z=pos.z-2
	drill_dig_it0 (pos,player)
	pos.z=pos.z+1
	pos.y=pos.y-2
	drill_dig_it0 (pos,player)
	pos.z=pos.z+1
	drill_dig_it0 (pos,player)
	pos.z=pos.z-2
	drill_dig_it0 (pos,player)
end
function drill_dig_it3 (pos,player)
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x-2
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	pos.y=pos.y+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x-2
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	pos.y=pos.y-2
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x-2
	drill_dig_it0 (pos,player)
end

function drill_dig_it4 (pos,player)
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x-2
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	pos.z=pos.z+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x-2
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	pos.z=pos.z-2
	drill_dig_it0 (pos,player)
	pos.x=pos.x+1
	drill_dig_it0 (pos,player)
	pos.x=pos.x-2
	drill_dig_it0 (pos,player)
end

register_power_tool ("technic:mining_drill",mining_drill_max_charge)
minetest.register_tool("technic:mining_drill", {
	description = "Mining Drill Mk1",
	inventory_image = "technic_mining_drill.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" then 
		local item=itemstack:to_table()
		local meta=get_item_meta(item["metadata"])
		if meta==nil then return end --tool not charghed
		if meta["charge"]==nil then return end
		local charge=meta["charge"]
		if charge-mining_drill_power_usage>0 then
			charge_to_take=drill_dig_it(minetest.get_pointed_thing_position(pointed_thing, above),user,1,1)
			charge =charge-mining_drill_power_usage;
			meta["charge"]=charge
			item["metadata"]=set_item_meta(meta)
			set_RE_wear(item,charge,mining_drill_max_charge)
			itemstack:replace(item)
			end
		return itemstack
		end
	end,
})

minetest.register_tool("technic:mining_drill_mk2", {
	description = "Mining Drill Mk2",
	inventory_image = "technic_mining_drill_mk2.png",
	on_use = function(itemstack, user, pointed_thing)
	mining_drill_mk2_handler(itemstack,user,pointed_thing)
	return itemstack
	end,
})
register_power_tool ("technic:mining_drill_mk2",mining_drill_mk2_max_charge)

for i=1,4,1 do
register_power_tool ("technic:mining_drill_mk2_"..i,mining_drill_mk2_max_charge)
minetest.register_tool("technic:mining_drill_mk2_"..i, {
	description = "Mining Drill Mk2 in Mode "..i,
	inventory_image = "technic_mining_drill_mk2.png^technic_tool_mode"..i..".png",
	wield_image = "technic_mining_drill_mk2.png",
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, user, pointed_thing)
	mining_drill_mk2_handler(itemstack,user,pointed_thing)
	return itemstack
	end,
})
end

minetest.register_tool("technic:mining_drill_mk3", {
	description = "Mining Drill Mk3",
	inventory_image = "technic_mining_drill_mk3.png",
	on_use = function(itemstack, user, pointed_thing)
	mining_drill_mk3_handler(itemstack,user,pointed_thing)
	return itemstack
	end,
})
register_power_tool ("technic:mining_drill_mk3",mining_drill_mk3_max_charge)

for i=1,5,1 do
register_power_tool ("technic:mining_drill_mk3_"..i,mining_drill_mk3_max_charge)
minetest.register_tool("technic:mining_drill_mk3_"..i, {
	description = "Mining Drill Mk3 in Mode "..i,
	inventory_image = "technic_mining_drill_mk3.png^technic_tool_mode"..i..".png",
	wield_image = "technic_mining_drill_mk3.png",
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, user, pointed_thing)
	mining_drill_mk3_handler(itemstack,user,pointed_thing)
	return itemstack
	end,
})
end

function mining_drill_mk2_handler (itemstack,user,pointed_thing)
	local keys=user:get_player_control()
	local player_name=user:get_player_name()
	local item=itemstack:to_table()
	local meta=get_item_meta(item["metadata"])
	if meta==nil or keys["sneak"]==true then return mining_drill_mk2_setmode(user,itemstack) end
	if meta["mode"]==nil then return mining_drill_mk2_setmode(user,itemstack) end
	if pointed_thing.type~="node" then return end
	if meta["charge"]==nil then return end
	charge=meta["charge"]
	if charge-mining_drill_power_usage>0 then
		local charge_to_take=drill_dig_it(minetest.get_pointed_thing_position(pointed_thing, above),user,2,meta["mode"])
		charge=charge-charge_to_take;
		if charge<0 then charge=0 end
		meta["charge"]=charge
		item["metadata"]=set_item_meta(meta)
		set_RE_wear(item,charge,mining_drill_mk2_max_charge)
		itemstack:replace(item)
	end
	return itemstack
end

function mining_drill_mk3_handler (itemstack,user,pointed_thing)
	local keys=user:get_player_control()
	local player_name=user:get_player_name()
	local item=itemstack:to_table()
	local meta=get_item_meta(item["metadata"])
	if meta==nil or keys["sneak"]==true then return mining_drill_mk3_setmode(user,itemstack) end
	if meta["mode"]==nil then return mining_drill_mk3_setmode(user,itemstack) end
	if pointed_thing.type~="node" then return end
	if meta["charge"]==nil then return end
	local charge=meta["charge"]
	if charge-mining_drill_power_usage>0 then
		local charge_to_take=drill_dig_it(minetest.get_pointed_thing_position(pointed_thing, above),user,3,meta["mode"])
		charge=charge-charge_to_take;
		if charge<0 then charge=0 end
		meta["charge"]=charge
		item["metadata"]=set_item_meta(meta)
		set_RE_wear(item,charge,mining_drill_mk3_max_charge)
		itemstack:replace(item)
	end
	return itemstack
end

mining_drill_mode_text={
{"Single node."},
{"3 nodes deep."},
{"3 modes wide."},
{"3 modes tall."},
{"3x3 nodes."},
}

function mining_drill_mk2_setmode(user,itemstack)
	local player_name=user:get_player_name()
	local item=itemstack:to_table()
	local meta=get_item_meta(item["metadata"])
	if meta==nil then
		meta={}
		mode=0
	end
	if meta["mode"]==nil then
		minetest.chat_send_player(player_name,"Hold shift and use to change Mining Drill Mk2 modes.")
		meta["mode"]=0
		mode=0
	end
	mode=(meta["mode"])
	mode=mode+1
	if mode>=5 then mode=1 end
	minetest.chat_send_player(player_name, "Mining Drill Mk2 mode : "..mode.." - "..mining_drill_mode_text[mode][1] )
	item["name"]="technic:mining_drill_mk2_"..mode
	meta["mode"]=mode
	item["metadata"]=set_item_meta(meta)
	itemstack:replace(item)
	return itemstack
end

function mining_drill_mk3_setmode(user,itemstack)
	local player_name=user:get_player_name()
	local item=itemstack:to_table()
	local meta=get_item_meta(item["metadata"])
	if meta==nil then
		meta={}
		mode=0
	end
	if meta["mode"]==nil then
		minetest.chat_send_player(player_name,"Hold shift and use to change Mining Drill Mk3 modes.")
		meta["mode"]=0
		mode=0
	end
	mode=(meta["mode"])
	mode=mode+1
	if mode>=6 then mode=1 end
	minetest.chat_send_player(player_name, "Mining Drill Mk3 mode : "..mode.." - "..mining_drill_mode_text[mode][1] )
	item["name"]="technic:mining_drill_mk3_"..mode
	meta["mode"]=mode
	item["metadata"]=set_item_meta(meta)
	itemstack:replace(item)
	return itemstack
end
