local mining_drill_max_charge      = 50000
local mining_drill_mk2_max_charge  = 200000
local mining_drill_mk3_max_charge  = 650000
local mining_drill_power_usage     = 200
local mining_drill_mk2_power_usage = 500
local mining_drill_mk3_power_usage = 800

local S = technic.getter

minetest.register_craft({
	output = 'technic:mining_drill',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:diamond_drill_head', 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'technic:motor',              'technic:stainless_steel_ingot'},
		{'',                              'technic:red_energy_crystal', 'moreores:copper_ingot'},
	}
})
minetest.register_craft({
	output = 'technic:mining_drill_mk2',
	recipe = {
		{'technic:diamond_drill_head',    'technic:diamond_drill_head',   'technic:diamond_drill_head'},
		{'technic:stainless_steel_ingot', 'technic:mining_drill',         'technic:stainless_steel_ingot'},
		{'',                              'technic:green_energy_crystal', ''},
	}
})
minetest.register_craft({
	output = 'technic:mining_drill_mk3',
	recipe = {
		{'technic:diamond_drill_head',    'technic:diamond_drill_head',  'technic:diamond_drill_head'},
		{'technic:stainless_steel_ingot', 'technic:mining_drill_mk2',    'technic:stainless_steel_ingot'},
		{'',                              'technic:blue_energy_crystal', ''},
	}
})
for i = 1, 4 do
	minetest.register_craft({
		output = 'technic:mining_drill_mk3',
		recipe = {
			{'technic:diamond_drill_head',    'technic:diamond_drill_head',   'technic:diamond_drill_head'},
			{'technic:stainless_steel_ingot', 'technic:mining_drill_mk2_'..i, 'technic:stainless_steel_ingot'},
			{'',                              'technic:blue_energy_crystal',  ''},
		}
	})
end

function drill_dig_it(pos, player, drill_type, mode)
	local charge

	if mode == 1 then
		drill_dig_it0(pos, player)
	end
	
	if mode == 2 then -- 3 deep
		dir = drill_dig_it1(player)
		if dir == 0 then -- x+
			drill_dig_it0(pos, player)
			pos.x = pos.x + 1
			drill_dig_it0(pos, player)
			pos.x = pos.x + 1
			drill_dig_it0(pos, player)
		end
		if dir == 1 then  -- x-
			drill_dig_it0(pos, player)
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
		if  mode==1 then charge=mining_drill_mk3_power_usage end
		if (mode==2 or mode==3 or mode==4) then charge=mining_drill_mk3_power_usage*6 end
		if mode==5 then charge=mining_drill_mk3_power_usage*9 end
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

technic.register_power_tool("technic:mining_drill", mining_drill_max_charge)
minetest.register_tool("technic:mining_drill", {
	description = S("Mining Drill Mk%d"):format(1),
	inventory_image = "technic_mining_drill.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local meta = get_item_meta(itemstack:get_metadata())
		if not meta or not meta.charge then
			return
		end
		if meta.charge - mining_drill_power_usage > 0 then
			local pos = minetest.get_pointed_thing_position(pointed_thing, above)
			charge_to_take = drill_dig_it(pos, user, 1, 1)
			meta.charge = meta.charge - mining_drill_power_usage
			itemstack:set_metadata(set_item_meta(meta))
			technic.set_RE_wear(itemstack, meta.charge, mining_drill_max_charge)
		end
		return itemstack
	end,
})

minetest.register_tool("technic:mining_drill_mk2", {
	description = S("Mining Drill Mk%d"):format(2),
	inventory_image = "technic_mining_drill_mk2.png",
	on_use = function(itemstack, user, pointed_thing)
		mining_drill_mk2_handler(itemstack, user, pointed_thing)
		return itemstack
	end,
})

technic.register_power_tool("technic:mining_drill_mk2", mining_drill_mk2_max_charge)

for i = 1, 4 do
	technic.register_power_tool("technic:mining_drill_mk2_"..i, mining_drill_mk2_max_charge)
	minetest.register_tool("technic:mining_drill_mk2_"..i, {
		description = S("Mining Drill Mk%d Mode %d"):format(2, i),
		inventory_image = "technic_mining_drill_mk2.png^technic_tool_mode"..i..".png",
		wield_image = "technic_mining_drill_mk2.png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
			mining_drill_mk2_handler(itemstack, user, pointed_thing)
			return itemstack
		end,
	})
end

minetest.register_tool("technic:mining_drill_mk3", {
	description = S("Mining Drill Mk%d"):format(3),
	inventory_image = "technic_mining_drill_mk3.png",
	on_use = function(itemstack, user, pointed_thing)
	mining_drill_mk3_handler(itemstack,user,pointed_thing)
	return itemstack
	end,
})

technic.register_power_tool("technic:mining_drill_mk3", mining_drill_mk3_max_charge)

for i=1,5,1 do
	technic.register_power_tool("technic:mining_drill_mk3_"..i, mining_drill_mk3_max_charge)
	minetest.register_tool("technic:mining_drill_mk3_"..i, {
		description = S("Mining Drill Mk%d Mode %d"):format(3, i),
		inventory_image = "technic_mining_drill_mk3.png^technic_tool_mode"..i..".png",
		wield_image = "technic_mining_drill_mk3.png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
		mining_drill_mk3_handler(itemstack,user,pointed_thing)
		return itemstack
		end,
	})
end

function mining_drill_mk2_handler(itemstack, user, pointed_thing)
	local keys = user:get_player_control()
	local player_name = user:get_player_name()
	local meta = get_item_meta(itemstack:get_metadata())
	if not meta or not meta.mode or keys.sneak then
		return mining_drill_mk2_setmode(user, itemstack)
	end
	if pointed_thing.type ~= "node" or not meta.charge then
		return
	end
	if meta.charge - mining_drill_power_usage > 0 then
		local pos = minetest.get_pointed_thing_position(pointed_thing, above)
		local charge_to_take = drill_dig_it(pos, user, 2, meta.mode)
		meta.charge = meta.charge - charge_to_take
		meta.charge = math.max(meta.charge, 0)
		itemstack:set_metadata(set_item_meta(meta))
		technic.set_RE_wear(itemstack, meta.charge, mining_drill_mk2_max_charge)
	end
	return itemstack
end

function mining_drill_mk3_handler(itemstack, user, pointed_thing)
	local keys = user:get_player_control()
	local player_name = user:get_player_name()
	local meta = get_item_meta(itemstack:get_metadata())
	if not meta or not meta.mode or keys.sneak then
		return mining_drill_mk3_setmode(user, itemstack)
	end
	if pointed_thing.type ~= "node" or not meta.charge then
		return
	end
	if meta.charge - mining_drill_power_usage > 0 then
		local pos = minetest.get_pointed_thing_position(pointed_thing, above)
		local charge_to_take = drill_dig_it(pos, user, 3, meta.mode)
		meta.charge = meta.charge - charge_to_take
		meta.charge = math.max(meta.charge, 0)
		itemstack:set_metadata(set_item_meta(meta))
		technic.set_RE_wear(itemstack, meta.charge, mining_drill_mk3_max_charge)
	end
	return itemstack
end

mining_drill_mode_text = {
	{S("Single node.")},
	{S("3 nodes deep.")},
	{S("3 nodes wide.")},
	{S("3 nodes tall.")},
	{S("3x3 nodes.")},
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
		minetest.chat_send_player(player_name, S("Hold shift and use to change Mining Drill Mk%d modes."):format(2))
		meta["mode"]=0
		mode=0
	end
	mode=(meta["mode"])
	mode=mode+1
	if mode>=5 then mode=1 end
	minetest.chat_send_player(player_name, S("Mining Drill Mk%d Mode %d"):format(2, mode)..": "..mining_drill_mode_text[mode][1])
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
		minetest.chat_send_player(player_name, S("Hold shift and use to change Mining Drill Mk%d modes."):format(3))
		meta["mode"]=0
		mode=0
	end
	mode=(meta["mode"])
	mode=mode+1
	if mode>=6 then mode=1 end
	minetest.chat_send_player(player_name, S("Mining Drill Mk%d Mode %d"):format(3, mode)..": "..mining_drill_mode_text[mode][1])
	item["name"]="technic:mining_drill_mk3_"..mode
	meta["mode"]=mode
	item["metadata"]=set_item_meta(meta)
	itemstack:replace(item)
	return itemstack
end

