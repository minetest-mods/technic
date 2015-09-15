
local S = technic.getter

frames = {}

local infinite_stacks = minetest.setting_getbool("creative_mode") and minetest.get_modpath("unified_inventory") == nil

-- localize these functions from vector_extras with small names because they work fairly fast
local get = vector.get_data_from_pos
local set = vector.set_data_to_pos
local remove = vector.remove_data_from_pos

local frames_pos = {}

local function get_frame(pos)
	return get(frames_pos, pos.z,pos.y,pos.x)
end

local function set_frame(pos, data)
	return set(frames_pos, pos.z,pos.y,pos.x, data)
end

local function remove_frame(pos)
	remove(frames_pos, pos.z,pos.y,pos.x)
end


-- Helpers

local function get_face(pos, ppos, pvect)
	-- Raytracer to get which face has been clicked
	ppos={x=ppos.x-pos.x,y=ppos.y-pos.y+1.5,z=ppos.z-pos.z}
	if pvect.x>0 then
		local t=(-0.5-ppos.x)/pvect.x
		local y_int=ppos.y+t*pvect.y
		local z_int=ppos.z+t*pvect.z
		if y_int>-0.45 and y_int<0.45 and z_int>-0.45 and z_int<0.45 then return 1 end
	elseif pvect.x<0 then
		local t=(0.5-ppos.x)/pvect.x
		local y_int=ppos.y+t*pvect.y
		local z_int=ppos.z+t*pvect.z
		if y_int>-0.45 and y_int<0.45 and z_int>-0.45 and z_int<0.45 then return 2 end
	end
	if pvect.y>0 then
		local t=(-0.5-ppos.y)/pvect.y
		local x_int=ppos.x+t*pvect.x
		local z_int=ppos.z+t*pvect.z
		if x_int>-0.45 and x_int<0.45 and z_int>-0.45 and z_int<0.45 then return 3 end
	elseif pvect.y<0 then
		local t=(0.5-ppos.y)/pvect.y
		local x_int=ppos.x+t*pvect.x
		local z_int=ppos.z+t*pvect.z
		if x_int>-0.45 and x_int<0.45 and z_int>-0.45 and z_int<0.45 then return 4 end
	end
	if pvect.z>0 then
		local t=(-0.5-ppos.z)/pvect.z
		local x_int=ppos.x+t*pvect.x
		local y_int=ppos.y+t*pvect.y
		if x_int>-0.45 and x_int<0.45 and y_int>-0.45 and y_int<0.45 then return 5 end
	elseif pvect.z<0 then
		local t=(0.5-ppos.z)/pvect.z
		local x_int=ppos.x+t*pvect.x
		local y_int=ppos.y+t*pvect.y
		if x_int>-0.45 and x_int<0.45 and y_int>-0.45 and y_int<0.45 then return 6 end
	end
end

local function pos_in_list(l,pos)
	for _,p in ipairs(l) do
		if vector.equals(pos, p) then
			return true
		end
	end
	return false
end

local function table_empty(table)
	return next(table) == nil
end

local function add_table(table,toadd)
	local i = 1
	while true do
		o = table[i]
		if o == toadd then return end
		if o == nil then break end
		i = i+1
	end
	table[i] = toadd
end

-- don't use minetest. Get node more times at the same position
local nodes_cache = {}

local function get_node(pos)
	local node = get(nodes_cache, pos.z,pos.y,pos.x)
	if node then
		return node
	end
	node = minetest.get_node(pos)
	set(nodes_cache, pos.z,pos.y,pos.x, node)
	return node
end

local function set_node(pos, node)
	set(nodes_cache, pos.z,pos.y,pos.x, node)
	minetest.set_node(pos, node)
end

local function remove_node(pos)
	set(nodes_cache, pos.z,pos.y,pos.x, {name="air", param1=0, param2=0})
	minetest.remove_node(pos)
end

local function move_nodes_vect(poslist, vect, must_not_move, owner)
	local dones = {}
	local oldps = {}
	for _,pos in pairs(poslist) do
		if not get(dones, pos.z,pos.y,pos.x) then
			if minetest.is_protected(pos, owner) then
				nodes_cache = {}
				return
			end
			set(dones, pos.z,pos.y,pos.x, true)
			set(oldps, pos.z,pos.y,pos.x, true)
		end
		local pos = vector.add(pos, vect)
		if not get(dones, pos.z,pos.y,pos.x) then
			if minetest.is_protected(pos, owner) then
				nodes_cache = {}
				return
			end
			set(dones, pos.z,pos.y,pos.x, true)
		end
	end
	dones = nil

	-- search for blocking at the new positions where it moves to
	for _,pos in pairs(poslist) do
		local npos = vector.add(pos,vect)
		if not get(oldps, npos.z,npos.y,npos.x) then
			if get_frame(npos) then
				-- blocking alien frame
				nodes_cache = {}
				return
			end
			local name = get_node(npos).name
			if name ~= "air" then
				name = minetest.registered_nodes[name]
				if not name
				or not name.buildable_to then
					-- another blocking node
					nodes_cache = {}
					return
				end
			end
		end
	end
	oldps = nil

	-- move objects
	for _,pos in pairs(poslist) do
		for _,obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
			local entity = obj:get_luaentity()
			if not entity
			or not mesecon.is_mvps_unmov(entity.name) then
				obj:moveto(vector.add(obj:getpos(), vect))
			end
		end
	end

	-- store current node information
	local nodelist = {}
	for n,pos in pairs(poslist) do
		nodelist[n] = {oldpos=pos, pos=vector.add(pos, vect), node=get_node(pos), meta=minetest.get_meta(pos):to_table()}
	end

	-- set new nodes
	local newps = {}
	for _,n in pairs(nodelist) do
		local npos = n.pos
		local current_node = get_node(npos)
		local node = n.node
		if current_node.name ~= node.name
		or current_node.param1 ~= node.param1
		or current_node.param2 ~= node.param2 then
			set_node(npos, n.node)
		end
		minetest.get_meta(npos):from_table(n.meta)
		set(newps, npos.z,npos.y,npos.x, true)
	end

	-- remove old ones
	for _,pos in pairs(poslist) do
		if not get(newps, pos.z,pos.y,pos.x)
		and get_node(pos).name ~= "air" then
			remove_node(pos)
		end
	end
	nodes_cache = {}

	-- update mesecons
	for _,callback in ipairs(mesecon.on_mvps_move) do
		callback(nodelist)
	end
end

-- tells if it's a node which could be put into a frame
local function is_supported_node(name)
	local def = minetest.registered_nodes[name]
	if not def
	or not def.tube then
		return false
	end
	return string.find(name, "tube") and string.find(name, "pipeworks") ~= nil
end


-- Frames

local function connect_frame(nodename)
	l2={}
	l1={{x=-1,y=0,z=0},{x=1,y=0,z=0},{x=0,y=-1,z=0},{x=0,y=1,z=0},{x=0,y=0,z=-1},{x=0,y=0,z=1}}
	for i,dir in ipairs(l1) do
		if string.sub(nodename,-7+i,-7+i) == "1" then
			l2[#(l2)+1] = dir
		end
	end
	return l2
end

local function punch_frame(pos, node, puncher)
	local pface = get_face(pos, puncher:getpos(), puncher:get_look_dir())
	if not pface then
		return
	end
	local nodename = node.name
	local newstate = tostring(1-tonumber(string.sub(nodename,-7+pface,-7+pface)))
	if pface <= 5 then
		nodename = string.sub(nodename,1,-7+pface-1)..newstate..string.sub(nodename,-7+pface+1)
	else
		nodename = string.sub(nodename,1,-2)..newstate
	end
	node.name = nodename
	minetest.set_node(pos,node)
end

local function place_frame(itemstack, placer, pt)
	local pos = pt.above
	if not pos then
		return itemstack
	end

	local pname = placer:get_player_name()
	local nodename = itemstack:get_name()
	if minetest.is_protected(pos, pname) then
		minetest.log("action", pname
			.. " tried to place " .. nodename
			.. " at protected position "
			.. minetest.pos_to_string(pos))
		minetest.record_protection_violation(pos, pname)
		return itemstack
	end

	local name = minetest.get_node(pos).name
	local def = minetest.registered_nodes[name]
	if not def then
		return itemstack
	end

	if def.buildable_to then
		minetest.set_node(pos, {name = nodename})
	elseif is_supported_node(name) then
		obj = minetest.add_entity(pos, "technic:frame_entity")
		obj:get_luaentity():set_node({name=nodename})
	else
		-- don't take an item when no frame is placed
		return itemstack
	end
	if not infinite_stacks then
		itemstack:take_item()
	end
	return itemstack
end

local function rightclick_frame(pos, node, placer, itemstack, pointed_thing)
	local nodename = itemstack:get_name()
	if not is_supported_node(nodename) then
		if pointed_thing then
			return minetest.item_place_node(itemstack, placer, pointed_thing)
		end
	end

	local pname = placer:get_player_name()
	if minetest.is_protected(pos, pname) then
		minetest.log("action", pname
			.. " tried to rightglick with " .. nodename
			.. " at protected position "
			.. minetest.pos_to_string(pos))
		minetest.record_protection_violation(pos, pname)
		return itemstack
	end

	minetest.remove_node(pos)
	itemstack,success = minetest.item_place_node(itemstack, placer, pointed_thing)

	if not success then
		-- this shouldn't happen
		minetest.set_node(pos, node)
		return itemstack
	end

	minetest.add_entity(pos, "technic:frame_entity"):get_luaentity():set_node(node)

	return itemstack
end


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

	local nameext = string.format("%01o/%01o/%01o/%01o/%01o/%01o", xm, xp, ym, yp, zm, zp))
	local groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2}
	local place_function
	if nameext ~= "111111" then
		groups.not_in_creative_inventory = 1
	else
		place_function = place_frame
	end


	minetest.register_node("technic:frame_"..nameext,{
		description = S("Frame"),
		tiles = {"technic_frame.png"},
		paramtype = "light",
		sunlight_propagates = true,
		frame = 1,
		drop = "technic:frame_111111",
		selection_box = true,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = nodeboxes,
		},
		groups = groups,
		frame_connect_all = connect_frame,
		on_punch = punch_frame,
		on_place = place_function,
		on_rightclick = rightclick_frame,
	})

end
end
end
end
end
end

minetest.register_entity("technic:frame_entity", {
	initial_properties = {
		physical = true,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
		visual = "wielditem",
		textures = {},
		visual_size = {x=0.667, y=0.667},
	},

	node = {},

	set_node = function(self, node)
		self.node = node
		set_frame(vector.round(self.object:getpos()), node.name)
		self.object:set_properties({
			is_visible = true,
			textures = {node.name},
		})
	end,

	get_staticdata = function(self)
		return self.node.name
	end,

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({immortal=1})
		self:set_node({name=staticdata})
	end,

	dig = function(self)
		minetest.handle_node_drops(self.object:getpos(), {ItemStack("technic:frame_111111")}, self.last_puncher)
		local pos = vector.round(self.object:getpos())
		remove_frame(pos)
		self.object:remove()
	end,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		local pos = self.object:getpos()
		if self.damage_object == nil then
			self.damage_object = minetest.add_entity(pos, "technic:damage_entity")
			self.damage_object:get_luaentity().remaining_time = 0.25
			self.damage_object:get_luaentity().frame_object = self
			self.damage_object:get_luaentity().texture_index = 0
			self.damage_object:get_luaentity().texture_change_time = 0.15
		else
			self.damage_object:get_luaentity().remaining_time = 0.25
		end
		self.last_puncher = puncher
		local pface = get_face(pos, puncher:getpos(), puncher:get_look_dir())
		if not pface then
			return
		end
		local nodename = self.node.name
		local newstate = tostring(1-tonumber(string.sub(nodename, -7+pface, -7+pface)))
		if pface <= 5 then
			nodename = string.sub(nodename, 1, -7+pface-1)..newstate..string.sub(nodename, -7+pface+1)
		else
			nodename = string.sub(nodename, 1, -2)..newstate
		end
		self.node.name = nodename
		self:set_node(self.node)
	end,

	on_rightclick = function(self, clicker)
		local pos = self.object:getpos()
		local pface = get_face(pos, clicker:getpos(), clicker:get_look_dir())
		if not pface then
			return
		end
		pos = vector.round(pos)
		local pos_above = vector.new(pos)
		local index = ({"x", "y", "z"})[math.floor((pface+1)/2)]
		pos_above[index] = pos_above[index] + 2*((pface+1)%2) - 1
		local pointed_thing = {type = "node", under = pos, above = pos_above}

		local itemstack = clicker:get_wielded_item()
		local itemdef = minetest.registered_items[itemstack:get_name()]
		if itemdef then
			itemdef.on_place(itemstack, clicker, pointed_thing)
		end
		clicker:set_wielded_item(itemstack)
	end,
})

local crack = "crack_anylength.png^[verticalframe:5:0"
minetest.register_entity("technic:damage_entity", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.01, y=1.01},
		textures = {crack, crack, crack, crack, crack, crack},
		collisionbox = {0, 0, 0, 0, 0, 0},
		physical = false,
	},
	on_step = function(self, dtime)
		if not self.remaining_time then
			self.object:remove()
			self.frame_object.damage_object = nil
			return
		end
		self.remaining_time = self.remaining_time - dtime
		if self.remaining_time < 0 then
			self.object:remove()
			self.frame_object.damage_object = nil
			return
		end
		self.texture_change_time = self.texture_change_time - dtime
		if self.texture_change_time >= 0 then
			return
		end
		local pos = self.object:getpos()
		self.texture_index = self.texture_index + 1
		if self.texture_index == 5 then
			self.object:remove()
			self.frame_object.damage_object = nil
			self.frame_object:dig()
			minetest.sound_play("default_dug_node", {pos = pos})
			return
		end
		minetest.sound_play("default_dig_choppy", {pos = pos})
		self.texture_change_time = self.texture_change_time + 0.15
		local ct = "crack_anylength.png^[verticalframe:5:"..self.texture_index
		self.object:set_properties({textures = {ct, ct, ct, ct, ct, ct}})
	end,
})

mesecon.register_mvps_unmov("technic:frame_entity")
mesecon.register_mvps_unmov("technic:damage_entity")
mesecon.register_on_mvps_move(function(moved_nodes)
	local to_move = {}
	for _, n in ipairs(moved_nodes) do
		local name = get_frame(n.oldpos)
		if name then
			to_move[#to_move+1] = {pos = n.pos, oldpos = n.oldpos, name = name}
			remove_frame(n.oldpos)
		end
	end
	if not next(to_move) then
		return
	end
	for _, t in ipairs(to_move) do
		set_frame(t.pos, t.name)
		local objects = minetest.get_objects_inside_radius(t.oldpos, 0.1)
		for _, obj in ipairs(objects) do
			local entity = obj:get_luaentity()
			if entity
			and (entity.name == "technic:frame_entity" or entity.name == "technic:damage_entity") then
				obj:setpos(t.pos)
			end
		end
	end
end)

minetest.register_on_dignode(function(pos, node)
	local name = get_frame(pos)
	if not name then
		return
	end
	minetest.set_node(pos, {name = name})
	remove_frame(pos)
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.1)) do
		local entity = obj:get_luaentity()
		if entity
		and (entity.name == "technic:frame_entity" or entity.name == "technic:damage_entity") then
			obj:remove()
		end
	end
end)

-- Frame motor
local function get_connected_nodes(pos)
	local nodename = get_frame(pos) or get_node(pos).name
	local poslist,num = {},1
	local dones = {}
	local todo = {{pos, minetest.registered_nodes[nodename].frame_connect_all(nodename)}}
	while next(todo) do
		for n,data in pairs(todo) do
			local pos, adj = unpack(data)
			for _,vect in pairs(adj) do
				local p = vector.add(pos, vect)
				if not get(dones, p.z,p.y,p.x) then
					local nodename = get_frame(p) or get_node(p).name
					if nodename ~= "air" then
						local def = minetest.registered_nodes[nodename]
						if not def then
							-- unknown nodes found
							return {}
						end
						local frame_can_connect = def.frames_can_connect
						if not frame_can_connect -- ← no frame node
						or frame_can_connect(p, vect) then
							poslist[num] = p
							num = num+1
							if minetest.registered_nodes[nodename].frame == 1 then
								table.insert(todo, {p, minetest.registered_nodes[nodename].frame_connect_all(nodename)})
							end
						end
					end
				end
			end
			todo[n] = nil
		end
	end
	return poslist
end

local motor_dirs = {{x=0,y=1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=-1,z=0}}
local function frame_motor_on(pos, node)
	local meta = minetest.get_meta(pos)
	if meta:get_int("last_moved") == minetest.get_gametime() then
		return
	end
	local dirs = motor_dirs
	local nnodepos = vector.add(pos, dirs[math.floor(node.param2/4)+1])
	local name = get_frame(nnodepos) or minetest.get_node(nnodepos).name
	local dir = minetest.facedir_to_dir(node.param2)
	if minetest.registered_nodes[name].frame == 1 then
		move_nodes_vect(get_connected_nodes(nnodepos), dir, pos, meta:get_string("owner"))
	end
	minetest.get_meta(vector.add(pos, dir)):set_int("last_moved", minetest.get_gametime())
end

minetest.register_node("technic:frame_motor",{
	description = S("Frame Motor"),
	tiles = {"pipeworks_filter_top.png^[transformR90", "technic_lv_cable.png", "technic_lv_cable.png",
		"technic_lv_cable.png", "technic_lv_cable.png", "technic_lv_cable.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,mesecon=2},
	paramtype2 = "facedir",
	mesecons={effector={action_on=frame_motor_on}},
	after_place_node = function(pos, placer)
		minetest.get_meta(pos):set_string("owner", placer:get_player_name())
	end,
	frames_can_connect = function(pos, dir)
		local dir2 = motor_dirs[math.floor(minetest.get_node(pos).param2/4)+1]
		return dir2.x~=-dir.x or dir2.y~=-dir.y or dir2.z~=-dir.z
	end
})



-- Templates
local function template_connected(pos,c,connectors)
	for _,vect in ipairs({{x=0,y=1,z=0},{x=0,y=0,z=1},{x=0,y=0,z=-1},{x=1,y=0,z=0},{x=-1,y=0,z=0},{x=0,y=-1,z=0}}) do
		local pos1=vector.add(pos,vect)
		local nodename=minetest.get_node(pos1).name
		if not(pos_in_list(c,pos1))
		and (nodename=="technic:template" or nodename == "technic:template_connector")then
			local meta = minetest.get_meta(pos1)
			if meta:get_string("connected") == "" then
				c[#(c)+1]=pos1
				template_connected(pos1,c,connectors)
				if nodename == "technic:template_connector" then
					connectors[#connectors+1] = pos1
				end
			end
		end
	end
end

local function get_templates(pos)
	local c = {pos}
	local connectors
	if minetest.get_node(pos).name == "technic:template_connector" then
		connectors = {pos}
	else
		connectors = {}
	end
	template_connected(pos,c,connectors)
	return c, connectors
end

local function swap_template(pos, new)
	local meta = minetest.get_meta(pos)
	local saved_node = meta:get_string("saved_node")
	meta:set_string("saved_node", "")
	technic.swap_node(pos, new)
	local meta = minetest.get_meta(pos)
	meta:set_string("saved_node", saved_node)
end

local function save_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "air" then
		minetest.set_node(pos, {name="technic:template"})
		return
	end
	if node.name == "technic:template" then
		swap_template(pos, "technic:template_connector")
		local meta = minetest.get_meta(pos)
		meta:set_string("connected", "")
		return
	end
	local meta = minetest.get_meta(pos)
	local meta0 = meta:to_table()
	for _, list in pairs(meta0.inventory) do
		for key, stack in pairs(list) do
			list[key] = stack:to_string()
		end
	end
	node.meta = meta0
	minetest.set_node(pos, {name="technic:template"})
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
	c = minetest.deserialize(c)
	for _, vect in ipairs(c) do
		local pos1 = vector.add(pos, vect)
		local saved_node = save_node(pos1)
		local meta1 = minetest.get_meta(pos1)
		if saved_node ~= nil then
			meta1:set_string("saved_node", minetest.serialize(saved_node))
		else
			--meta1:set_string("saved_node", "")
		end
	end
end

local function pos_to_string(pos)
	if pos.x == 0 then pos.x = 0 end -- Fix for signed 0
	if pos.y == 0 then pos.y = 0 end -- Fix for signed 0
	if pos.z == 0 then pos.z = 0 end -- Fix for signed 0
	return tostring(pos.x).."\n"..tostring(pos.y).."\n"..tostring(pos.z)
end

local function compress_templates(pos)
	local templates, connectors = get_templates(pos)
	if #connectors == 0 then
		connectors = {pos}
	end
	for _, cn in ipairs(connectors) do
		local meta = minetest.get_meta(cn)
		local c = {}
		for _,p in ipairs(templates) do
			local np = vector.subtract(p, cn)
			if not pos_in_list(c,np) then
				c[#c+1] = np
			end
		end
		local cc = {}
		for _,p in ipairs(connectors) do
			local np = vector.subtract(p, cn)
			if (np.x ~= 0 or np.y ~= 0 or np.z ~= 0) then
				cc[pos_to_string(np)] = true
			end
		end
		swap_template(cn, "technic:template")
		meta:set_string("connected", minetest.serialize(c))
		meta:set_string("connectors_connected", minetest.serialize(cc))
	end

	for _,p in ipairs(templates) do
		if not pos_in_list(connectors, p) then
			minetest.set_node(p, {name = "air"})
		end
	end
end

local function lines(str)
	local t = {}
	local function helper(line) table.insert(t, line) return "" end
	helper((str:gsub("(.-)\r?\n", helper)))
	return t
end

local function pos_from_string(str)
	local l = lines(str)
	return {x = tonumber(l[1]), y = tonumber(l[2]), z = tonumber(l[3])}
end

local function template_drops(pos, node, oldmeta, digger)
	local c = oldmeta.fields.connected
	local cc = oldmeta.fields.connectors_connected
	local drops
	if c == "" or c == nil then
		drops = {"technic:template 1"}
	else
		if cc == "" or cc == nil then
			drops = {"technic:template 1"}
		else
			local dcc = minetest.deserialize(cc)
			if not table_empty(dcc) then
				drops = {}
				for sp, _ in pairs(dcc) do
					local ssp = pos_from_string(sp)
					local p = vector.add(ssp, pos)
					local meta = minetest.get_meta(p)
					local d = minetest.deserialize(meta:get_string("connectors_connected"))
					if d ~= nil then
						d[pos_to_string({x=-ssp.x, y=-ssp.y, z=-ssp.z})] = nil
						meta:set_string("connectors_connected", minetest.serialize(d))
					end
				end
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
		end
	end
	minetest.handle_node_drops(pos, drops, digger)
end

local function template_on_destruct(pos, node)
	local meta = minetest.get_meta(pos)
	local saved_node = meta:get_string("saved_node")
	if saved_node ~= "" then
		local nnode = minetest.deserialize(saved_node)
		minetest.after(0, restore_node, pos, nnode)
	end
end

minetest.register_node("technic:template",{
	description = S("Template"),
	tiles = {"technic_mv_cable.png"},
	drop = "",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	on_destruct = template_on_destruct,
	after_dig_node = template_drops,
	on_punch = function(pos,node,puncher)
		swap_template(pos, "technic:template_disabled")
	end
})

minetest.register_node("technic:template_disabled",{
	description = S("Template"),
	tiles = {"technic_hv_cable.png"},
	drop = "",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	on_destruct = template_on_destruct,
	after_dig_node = template_drops,
	on_punch = function(pos,node,puncher)
	local meta = minetest.get_meta(pos)
		swap_template(pos, "technic:template_connector")
	end
})

minetest.register_node("technic:template_connector",{
	description = S("Template"),
	tiles = {"technic_lv_cable.png"},
	drop = "",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	on_destruct = template_on_destruct,
	after_dig_node = template_drops,
	on_punch = function(pos,node,puncher)
		swap_template(pos, "technic:template")
	end
})

minetest.register_craftitem("technic:template_replacer",{
	description = S("Template (replacing)"),
	inventory_image = "technic_flashlight.png^[mask:technic_mv_cable.png^[transformR180", --"technic_template_replacer.png",
	on_place = function(itemstack, placer, pointed_thing)
		local p = pointed_thing.under
		if minetest.is_protected and minetest.is_protected(p, placer:get_player_name()) then
			return nil
		end
		local node = minetest.get_node(p)
		if node.name == "technic:template" then return end
		local saved_node = save_node(p)
		itemstack:take_item()
		if saved_node ~= nil then
			local meta = minetest.get_meta(p)
			meta:set_string("saved_node", minetest.serialize(saved_node))
		end
		return itemstack
	end
})

minetest.register_tool("technic:template_tool",{
	description = S("Template Tool"),
	inventory_image = "technic_screwdriver.png^[mask:technic_mv_cable.png", --"technic_template_tool.png",
	on_use = function(itemstack, puncher, pointed_thing)
		local pos = pointed_thing.under
		if pos == nil or (minetest.is_protected and minetest.is_protected(pos, puncher:get_player_name())) then
			return nil
		end
		local node = minetest.get_node(pos)
		if node.name ~= "technic:template" and node.name ~= "technic:template_connector" then return end
		local meta = minetest.get_meta(pos)
		local c2 = meta:get_string("connected")
		if c2 ~= "" then
			expand_template(pos)
		else
			compress_templates(pos)
		end

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
		local nodename=minetest.get_node(pos1).name
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
	if meta:get_int("last_moved") == minetest.get_gametime() then
		return
	end
	local owner = meta:get_string("owner")
	if nnode.name == "technic:template" then
		local connected_nodes=get_template_nodes(nnodepos)
		move_nodes_vect(connected_nodes,dir,pos,owner)
	end
	minetest.get_meta(vector.add(pos, dir)):set_int("last_moved", minetest.get_gametime())
end

minetest.register_node("technic:template_motor",{
	description = S("Template Motor"),
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

-- Crafts
minetest.register_craft({
	output = 'technic:frame_111111',
	recipe = {
		{'',			'default:stick',	''},
		{'default:stick',	'technic:brass_ingot',	'default:stick'},
		{'',			'default:stick',	''},
	}
})

minetest.register_craft({
	output = 'technic:frame_motor',
	recipe = {
		{'',					'technic:frame_111111',	''},
		{'group:mesecon_conductor_craftable',	'technic:motor',	'group:mesecon_conductor_craftable'},
		{'',					'technic:frame_111111',	''},
	}
})

minetest.register_craft({
	output = 'technic:template 10',
	recipe = {
		{'',			'technic:brass_ingot',	''},
		{'technic:brass_ingot',	'default:mese_crystal',	'technic:brass_ingot'},
		{'',			'technic:brass_ingot',	''},
	}
})

minetest.register_craft({
	output = 'technic:template_replacer',
	recipe = {{'technic:template'}}
})

minetest.register_craft({
	output = 'technic:template',
	recipe = {{'technic:template_replacer'}}
})

minetest.register_craft({
	output = 'technic:template_motor',
	recipe = {
		{'',					'technic:template',	''},
		{'group:mesecon_conductor_craftable',	'technic:motor',	'group:mesecon_conductor_craftable'},
		{'',					'technic:template',	''},
	}
})

minetest.register_craft({
	output = 'technic:template_tool',
	recipe = {
		{'',				'technic:template',	''},
		{'default:mese_crystal',	'default:stick',	'default:mese_crystal'},
		{'',				'default:stick',	''},
	}
})
