frames = {}

-- Helpers

local function get_face(pos,ppos,pvect)
	-- Raytracer to get which face has been clicked
	ppos={x=ppos.x-pos.x,y=ppos.y-pos.y+1.5,z=ppos.z-pos.z}
	if pvect.x>0 then
		local t=(-0.5-ppos.x)/pvect.x
		local y_int=ppos.y+t*pvect.y
		local z_int=ppos.z+t*pvect.z
		if y_int>-0.4 and y_int<0.4 and z_int>-0.4 and z_int<0.4 then return 1 end 
	elseif pvect.x<0 then
		local t=(0.5-ppos.x)/pvect.x
		local y_int=ppos.y+t*pvect.y
		local z_int=ppos.z+t*pvect.z
		if y_int>-0.4 and y_int<0.4 and z_int>-0.4 and z_int<0.4 then return 2 end 
	end
	if pvect.y>0 then
		local t=(-0.5-ppos.y)/pvect.y
		local x_int=ppos.x+t*pvect.x
		local z_int=ppos.z+t*pvect.z
		if x_int>-0.4 and x_int<0.4 and z_int>-0.4 and z_int<0.4 then return 3 end 
	elseif pvect.y<0 then
		local t=(0.5-ppos.y)/pvect.y
		local x_int=ppos.x+t*pvect.x
		local z_int=ppos.z+t*pvect.z
		if x_int>-0.4 and x_int<0.4 and z_int>-0.4 and z_int<0.4 then return 4 end 
	end
	if pvect.z>0 then
		local t=(-0.5-ppos.z)/pvect.z
		local x_int=ppos.x+t*pvect.x
		local y_int=ppos.y+t*pvect.y
		if x_int>-0.4 and x_int<0.4 and y_int>-0.4 and y_int<0.4 then return 5 end 
	elseif pvect.z<0 then
		local t=(0.5-ppos.z)/pvect.z
		local x_int=ppos.x+t*pvect.x
		local y_int=ppos.y+t*pvect.y
		if x_int>-0.4 and x_int<0.4 and y_int>-0.4 and y_int<0.4 then return 6 end 
	end
end

local function pos_in_list(l,pos)
	for _,p in ipairs(l) do
		if p.x==pos.x and p.y==pos.y and p.z==pos.z then return true end
	end
	return false
end

local function add_table(table,toadd)
	local i=1
	while true do
		o=table[i]
		if o==toadd then return end
		if o==nil then break end
		i=i+1
	end
	table[i]=toadd
end

local function move_nodes_vect(poslist,vect,must_not_move,owner)
	if minetest.is_protected then
		for _,pos in ipairs(poslist) do
			local npos=vector.add(pos,vect)
			if minetest.is_protected(pos, owner) or minetest.is_protected(npos, owner) then
				return
			end
		end
	end
	for _,pos in ipairs(poslist) do
		local npos=vector.add(pos,vect)
		local name = minetest.env:get_node(npos).name
		if (name~="air" and minetest.registered_nodes[name].liquidtype=="none") and not(pos_in_list(poslist,npos)) then
			return
		end
		--[[if pos.x==must_not_move.x and pos.y==must_not_move.y and pos.z==must_not_move.z then
			return
		end]]
	end
	nodelist={}
	for _,pos in ipairs(poslist) do
		local node=minetest.env:get_node(pos)
		local meta=minetest.env:get_meta(pos):to_table()
		nodelist[#(nodelist)+1]={pos=pos,node=node,meta=meta}
	end
	objects={}
	for _,pos in ipairs(poslist) do
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
			add_table(objects,object)
		end
	end
	for _,obj in ipairs(objects) do
		obj:setpos(vector.add(obj:getpos(),vect))
		le=obj:get_luaentity()
		if le and le.name == "pipeworks:tubed_item" then
			le.start_pos=vector.add(le.start_pos,vect)
		end
	end
	for _,n in ipairs(nodelist) do
		local npos=vector.add(n.pos,vect)
		minetest.env:set_node(npos,n.node)
		local meta=minetest.env:get_meta(npos)
		meta:from_table(n.meta)
		for __,pos in ipairs(poslist) do
			if npos.x==pos.x and npos.y==pos.y and npos.z==pos.z then
				table.remove(poslist, __)
				break
			end
		end
	end
	for __,pos in ipairs(poslist) do
		minetest.env:remove_node(pos)
	end
end



-- Frames
for xm=0,1 do
for xp=0,1 do
for ym=0,1 do
for yp=0,1 do
for zm=0,1 do
for zp=0,1 do

local a=8/16
local b=7/16
local nodeboxes= {
	{ -a, -a, -a, -b,  a, -b },
	{ -a, -a,  b, -b,  a,  a },
	{  b, -a,  b,  a,  a,  a },
	{  b, -a, -a,  a,  a, -b },

	{ -b,  b, -a,  b,  a, -b },
	{ -b, -a, -a,  b, -b, -b },
	
	{ -b,  b,  b,  b,  a,  a },
	{ -b, -a,  b,  b, -b,  a },

	{  b,  b, -b,  a,  a,  b },
	{  b, -a, -b,  a, -b,  b },

	{ -a,  b, -b, -b,  a,  b },
	{ -a, -a, -b, -b, -b,  b },
	}
	
	if yp==0 then
		table.insert(nodeboxes, {-b,b,-b, b,a,b})
	end
	if ym==0 then
		table.insert(nodeboxes, {-b,-a,-b, b,-b,b})
	end
	if xp==0 then
		table.insert(nodeboxes, {b,b,b,a,-b,-b})
	end
	if xm==0 then
		table.insert(nodeboxes, {-a,-b,-b,-b,b,b})
	end
	if zp==0 then
		table.insert(nodeboxes, {-b,-b,b, b,b,a})
	end
	if zm==0 then
		table.insert(nodeboxes, {-b,-b,-a, b,b,-b})
	end
	
	local nameext=tostring(xm)..tostring(xp)..tostring(ym)..tostring(yp)..tostring(zm)..tostring(zp)
	local groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2}
	if nameext~="111111" then groups.not_in_creative_inventory=1 end
	

	minetest.register_node("technic:frame_"..nameext,{
		description = "Frame",
		tiles = {"technic_frame.png"},
		groups=groups,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
		fixed=nodeboxes,
		},
		selection_box = {
			type="fixed",
			fixed={-0.5,-0.5,-0.5,0.5,0.5,0.5}
		},
		paramtype = "light",
		frame=1,
		drop="technic:frame_111111",
		frame_connect_all=function(pos)
			local nodename=minetest.env:get_node(pos).name
			l2={}
			l1={{x=-1,y=0,z=0},{x=1,y=0,z=0},{x=0,y=-1,z=0},{x=0,y=1,z=0},{x=0,y=0,z=-1},{x=0,y=0,z=1}}
			for i,dir in ipairs(l1) do
				if string.sub(nodename,-7+i,-7+i)=="1" then
					l2[#(l2)+1]=dir
				end
			end
			return l2
		end,
		on_punch=function(pos,node,puncher)
			local ppos=puncher:getpos()
			local pvect=puncher:get_look_dir()
			local pface=get_face(pos,ppos,pvect)
			if pface==nil then return end
			local nodename=node.name
			local newstate=tostring(1-tonumber(string.sub(nodename,-7+pface,-7+pface)))
			if pface<=5 then
				nodename=string.sub(nodename,1,-7+pface-1)..newstate..string.sub(nodename,-7+pface+1)
			else
				nodename=string.sub(nodename,1,-2)..newstate
			end
			node.name=nodename
			minetest.env:set_node(pos,node)
		end
	})

end
end
end
end
end
end




-- Frame motor
local function connected(pos,c,adj)
	for _,vect in ipairs(adj) do
		local pos1=vector.add(pos,vect)
		local nodename=minetest.env:get_node(pos1).name
		if not(pos_in_list(c,pos1)) and nodename~="air" and
		(minetest.registered_nodes[nodename].frames_can_connect==nil or
		minetest.registered_nodes[nodename].frames_can_connect(pos1,vect)) then
			c[#(c)+1]=pos1
			if minetest.registered_nodes[nodename].frame==1 then
				local adj=minetest.registered_nodes[nodename].frame_connect_all(pos1)
				connected(pos1,c,adj)
			end
		end
	end
end

local function get_connected_nodes(pos)
	c={pos}
	local nodename=minetest.env:get_node(pos).name
	connected(pos,c,minetest.registered_nodes[nodename].frame_connect_all(pos))
	return c
end

local function frame_motor_on(pos, node)
	local dirs = {{x=0,y=1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=-1,z=0}}
	local nnodepos = vector.add(pos, dirs[math.floor(node.param2/4)+1])
	local dir = minetest.facedir_to_dir(node.param2)
	local nnode=minetest.get_node(nnodepos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	if minetest.registered_nodes[nnode.name].frame==1 then
		local connected_nodes=get_connected_nodes(nnodepos)
		move_nodes_vect(connected_nodes,dir,pos,owner)
	end
end

minetest.register_node("technic:frame_motor",{
	description = "Frame motor",
	tiles = {"pipeworks_filter_top.png^[transformR90", "technic_lv_cable.png", "technic_lv_cable.png",
		"technic_lv_cable.png", "technic_lv_cable.png", "technic_lv_cable.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,mesecon=2},
	paramtype2 = "facedir",
	mesecons={effector={action_on=frame_motor_on}},
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
	end,
	frames_can_connect=function(pos,dir)
		local node = minetest.get_node(pos)
		local dir2 = ({{x=0,y=1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=-1,z=0}})[math.floor(node.param2/4)+1]
		return dir2.x~=-dir.x or dir2.y~=-dir.y or dir2.z~=-dir.z
	end
})



-- Templates
local function template_connected(pos,c)
	for _,vect in ipairs({{x=0,y=1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=-1,z=0}}) do
		local pos1=vector.add(pos,vect)
		local nodename=minetest.get_node(pos1).name
		if not(pos_in_list(c,pos1)) and nodename=="technic:template" then
			local meta = minetest.get_meta(pos1)
			if meta:get_string("connected") == "" then
				c[#(c)+1]=pos1
				template_connected(pos1,c)
			end
		end
	end
end

local function get_templates(pos)
	c={pos}
	template_connected(pos,c)
	return c
end

local function save_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "air" or node.name == "technic:template" then return end
	local meta = minetest.get_meta(pos)
	local meta0 = meta:to_table()
	for _, list in pairs(meta0.inventory) do
		for key, stack in pairs(list) do
			list[key] = stack:to_string()
		end
	end
	node.meta = meta0
	return node
end

local function restore_node(pos, node)
	minetest.set_node(pos, node)
	local meta = minetest.get_meta(pos)
	for _, list in pairs(node.meta.inventory) do
		for key, stack in pairs(list) do
			list[key] = ItemStack(stack)
		end
	end
	meta:from_table(node.meta)
end

local function expand_template(pos)
	local meta = minetest.get_meta(pos)
	local c = meta:get_string("connected")
	if c == "" then return end
	meta:set_string("connected", "")
	c = minetest.deserialize(c)
	for _, vect in ipairs(c) do
		if vect.x ~= 0 or vect.y ~= 0 or vect.z ~= 0 then
			local pos1 = vector.add(pos, vect)
			local saved_node = save_node(pos1)
			minetest.set_node(pos1, {name="technic:template"})
			local meta1 = minetest.get_meta(pos1)
			if saved_node ~= nil then
				meta1:set_string("saved_node", minetest.serialize(saved_node))
			else
				meta1:set_string("saved_node", "")
			end
		end
	end
end

local function template_drops(pos, node, oldmeta, digger)
	local c = oldmeta.fields.connected
	local drops
	if c == "" or c == nil then
		drops = {"technic:template 1"}
	else
		local stack_max = 99
		local num = #(minetest.deserialize(c))
		drops = {}
		while num > stack_max do
			drops[#drops+1] = "technic:template "..stack_max
			num = num - stack_max
		end
		drops[#drops+1] = "technic:template "..num
	end
	print(dump(drops))
	minetest.handle_node_drops(pos, drops, digger)
end

minetest.register_node("technic:template",{
	description = "Template",
	tiles = {"technic_mv_cable.png"},
	drop = "",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_destruct = function(pos, node)
		local meta = minetest.get_meta(pos)
		local saved_node = meta:get_string("saved_node")
		if saved_node ~= "" then
			local nnode = minetest.deserialize(saved_node)
			minetest.after(0, restore_node, pos, nnode)
		end
	end,
	after_dig_node = template_drops,
	on_punch = function(pos,node,puncher)
		hacky_swap_node(pos, "technic:template_disabled")
	end
})

minetest.register_node("technic:template_disabled",{
	description = "Template",
	tiles = {"technic_hv_cable.png"},
	drop = "",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_destruct = function(pos, node)
		local meta = minetest.get_meta(pos)
		local saved_node = meta:get_string("saved_node")
		if saved_node ~= "" then
			local nnode = minetest.deserialize(saved_node)
			minetest.after(0, restore_node, pos, nnode)
		end
	end,
	after_dig_node = template_drops,
	on_punch = function(pos,node,puncher)
		hacky_swap_node(pos, "technic:template")
	end
})

minetest.register_craftitem("technic:template_replacer",{
	description = "Template (replacing)",
	inventory_image = "technic_template_replacer.png",
	on_place = function(itemstack, placer, pointed_thing)
		local p = pointed_thing.under
		if minetest.is_protected and minetest.is_protected(p, placer:get_player_name()) then
			return nil
		end
		local node = minetest.get_node(p)
		if node.name == "technic:template" then return end
		local saved_node = save_node(p)
		minetest.set_node(p, {name="technic:template"})
		itemstack:take_item()
		if saved_node ~= nil then
			local meta = minetest.get_meta(p)
			meta:set_string("saved_node", minetest.serialize(saved_node))
		end
		return itemstack
	end
})

minetest.register_tool("technic:template_tool",{
	description = "Template tool",
	inventory_image = "technic_template_tool.png",
	on_use = function(itemstack, puncher, pointed_thing)
		local pos = pointed_thing.under
		if pos == nil or (minetest.is_protected and minetest.is_protected(pos, placer:get_player_name())) then
			return nil
		end
		local node = minetest.get_node(pos)
		if node.name ~= "technic:template" then return end
		local meta = minetest.get_meta(pos)
		local c2 = meta:get_string("connected")
		if c2 ~= "" then
			expand_template(pos)
			return
		end
		local templates = get_templates(pos)
		local c = {}
		for _,p in ipairs(templates) do
			local np = {x=p.x-pos.x, y=p.y-pos.y, z=p.z-pos.z}
			if not pos_in_list(c,np) then
				c[#c+1] = np
			end
			if p.x ~= pos.x or p.y ~= pos.y or p.z ~= pos.z then
				minetest.set_node(p, {name = "air"})
			end
		end
		meta:set_string("connected", minetest.serialize(c))
	end
})



-- Template motor
local function get_template_nodes(pos)
	local meta = minetest.get_meta(pos)
	local connected = meta:get_string("connected")
	if connected == "" then return {} end
	local adj = minetest.deserialize(connected)
	local c = {}
	for _,vect in ipairs(adj) do
		local pos1=vector.add(pos,vect)
		local nodename=minetest.env:get_node(pos1).name
		if not(pos_in_list(c,pos1)) and nodename~="air" then
			c[#(c)+1]=pos1
		end
	end
	return c
end

local function template_motor_on(pos, node)
	local dirs = {{x=0,y=1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=-1,z=0}}
	local nnodepos = vector.add(pos, dirs[math.floor(node.param2/4)+1])
	local dir = minetest.facedir_to_dir(node.param2)
	local nnode=minetest.get_node(nnodepos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	if nnode.name == "technic:template" then
		local connected_nodes=get_template_nodes(nnodepos)
		move_nodes_vect(connected_nodes,dir,pos,owner)
	end
end

minetest.register_node("technic:template_motor",{
	description = "Template motor",
	tiles = {"pipeworks_filter_top.png^[transformR90", "technic_lv_cable.png", "technic_lv_cable.png",
		"technic_lv_cable.png", "technic_lv_cable.png", "technic_lv_cable.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,mesecon=2},
	paramtype2 = "facedir",
	mesecons={effector={action_on=template_motor_on}},
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
	end,
})
