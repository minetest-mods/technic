local S = technic.getter

local infinite_stacks = minetest.settings:get_bool("creative_mode")
	and minetest.get_modpath("unified_inventory") == nil

local frames_pos = {}

-- Helpers

local function get_face(pos, ppos, pvect)
	-- Raytracer to get which face has been clicked
	ppos = { x = ppos.x - pos.x, y = ppos.y - pos.y + 1.5, z = ppos.z - pos.z }

	if pvect.x > 0 then
		local t = (-0.5 - ppos.x) / pvect.x
		local y_int = ppos.y + t * pvect.y
		local z_int = ppos.z + t * pvect.z
		if y_int > -0.45 and y_int < 0.45 and z_int > -0.45 and z_int < 0.45 then
			return 1
		end
	elseif pvect.x < 0 then
		local t = (0.5 - ppos.x) / pvect.x
		local y_int = ppos.y + t * pvect.y
		local z_int = ppos.z + t * pvect.z
		if y_int > -0.45 and y_int < 0.45 and z_int > -0.45 and z_int < 0.45 then
			return 2
		end
	end

	if pvect.y > 0 then
		local t = (-0.5 - ppos.y) / pvect.y
		local x_int = ppos.x + t * pvect.x
		local z_int = ppos.z + t * pvect.z
		if x_int > -0.45 and x_int < 0.45 and z_int > -0.45 and z_int < 0.45 then
			return 3
		end
	elseif pvect.y < 0 then
		local t = (0.5 - ppos.y) / pvect.y
		local x_int = ppos.x + t * pvect.x
		local z_int = ppos.z + t * pvect.z
		if x_int > -0.45 and x_int < 0.45 and z_int > -0.45 and z_int < 0.45 then
			return 4
		end
	end

	if pvect.z > 0 then
		local t = (-0.5 - ppos.z) / pvect.z
		local x_int = ppos.x + t * pvect.x
		local y_int = ppos.y + t * pvect.y
		if x_int > -0.45 and x_int < 0.45 and y_int > -0.45 and y_int < 0.45 then
			return 5
		end
	elseif pvect.z < 0 then
		local t = (0.5 - ppos.z) / pvect.z
		local x_int = ppos.x + t * pvect.x
		local y_int = ppos.y + t * pvect.y
		if x_int > -0.45 and x_int < 0.45 and y_int > -0.45 and y_int < 0.45 then
			return 6
		end
	end
end

local function lines(str)
	local t = {}
	local function helper(line) table.insert(t, line) return "" end
	helper(str:gsub("(.-)\r?\n", helper))
	return t
end

local function pos_to_string(pos)
	if pos.x == 0 then pos.x = 0 end -- Fix for signed 0
	if pos.y == 0 then pos.y = 0 end -- Fix for signed 0
	if pos.z == 0 then pos.z = 0 end -- Fix for signed 0
	return tostring(pos.x).."\n"..tostring(pos.y).."\n"..tostring(pos.z)
end

local function pos_from_string(str)
	local l = lines(str)
	return { x = tonumber(l[1]), y = tonumber(l[2]), z = tonumber(l[3]) }
end

local function pos_in_list(l, pos)
	for _, p in ipairs(l) do
		if p.x == pos.x and p.y == pos.y and p.z == pos.z then
			return true
		end
	end
	return false
end

local function table_empty(what)
	for _ in pairs(what) do
		return false
	end
	return true
end

local function add_table(what, toadd)
	local i = 1
	while true do
		local o = what[i]
		if o == toadd then return end
		if o == nil then break end
		i = i + 1
	end
	what[i] = toadd
end

local function move_nodes_vect(poslist, vect, must_not_move, owner)
	if minetest.is_protected then
		for _, pos in ipairs(poslist) do
			local npos = vector.add(pos, vect)
			if minetest.is_protected(pos, owner) or minetest.is_protected(npos, owner) then
				return
			end
		end
	end

	for _, pos in ipairs(poslist) do
		local npos = vector.add(pos, vect)
		local name = minetest.get_node(npos).name
		if (name ~= "air" and minetest.registered_nodes[name].liquidtype == "none" or
				frames_pos[pos_to_string(npos)]) and not pos_in_list(poslist, npos) then
			return
		end
	end

	local nodelist = {}
	for _, pos in ipairs(poslist) do
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos):to_table()
		local timer = minetest.get_node_timer(pos)
		nodelist[#nodelist + 1] = {
			oldpos = pos,
			pos = vector.add(pos, vect),
			node = node,
			meta = meta,
			timer = {
				timeout = timer:get_timeout(),
				elapsed = timer:get_elapsed()
			}
		}
	end

	local objects = {}
	for _, pos in ipairs(poslist) do
		for _, object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
			local entity = object:get_luaentity()
			if not entity or not mesecon.is_mvps_unmov(entity.name) then
				add_table(objects, object)
			end
		end
	end

	for _, obj in ipairs(objects) do
		obj:set_pos(vector.add(obj:get_pos(), vect))
	end

	for _, n in ipairs(nodelist) do
		local npos = n.pos
		minetest.set_node(npos, n.node)
		local meta = minetest.get_meta(npos)
		meta:from_table(n.meta)
		local timer = minetest.get_node_timer(npos)
		if n.timer.timeout ~= 0 or n.timer.elapsed ~= 0 then
			timer:set(n.timer.timeout, n.timer.elapsed)
		end
		for __, pos in ipairs(poslist) do
			if npos.x == pos.x and npos.y == pos.y and npos.z == pos.z then
				table.remove(poslist, __)
				break
			end
		end
	end

	for __, pos in ipairs(poslist) do
		minetest.remove_node(pos)
	end

	for _, callback in ipairs(mesecon.on_mvps_move) do
		callback(nodelist)
	end
end

local function is_supported_node(name)
	return string.find(name, "tube") and string.find(name, "pipeworks")
end

-- Frames
for xm = 0, 1 do
for xp = 0, 1 do
for ym = 0, 1 do
for yp = 0, 1 do
for zm = 0, 1 do
for zp = 0, 1 do

	local a = 8 / 16
	local b = 7 / 16
	local nodeboxes = {
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

	if yp == 0 then
		table.insert(nodeboxes, { -b, b, -b, b, a, b })
	end
	if ym == 0 then
		table.insert(nodeboxes, { -b, -a, -b, b, -b, b })
	end
	if xp == 0 then
		table.insert(nodeboxes, { b, b, b, a, -b, -b })
	end
	if xm == 0 then
		table.insert(nodeboxes, { -a, -b, -b, -b, b, b })
	end
	if zp == 0 then
		table.insert(nodeboxes, { -b, -b, b, b, b, a })
	end
	if zm == 0 then
		table.insert(nodeboxes, { -b, -b, -a, b, b, -b })
	end

	local nameext = string.format("%d%d%d%d%d%d", xm, xp, ym, yp, zm, zp)
	local groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 }
	if nameext ~= "111111" then groups.not_in_creative_inventory = 1 end


	minetest.register_node("technic:frame_"..nameext, {
		description = S("Frame"),
		tiles = { "technic_frame.png" },
		groups = groups,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = nodeboxes,
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 }
		},
		paramtype = "light",
		frame = 1,
		drop = "technic:frame_111111",
		sunlight_propagates = true,

		frame_connect_all = function(nodename)
			local l2 = {}
			local l1 = {
				{ x = -1, y = 0, z = 0 }, { x = 1, y = 0, z = 0 },
				{ x = 0, y = -1, z = 0 }, { x = 0, y = 1, z = 0 },
				{ x = 0, y = 0, z = -1 }, { x = 0, y = 0, z = 1 }
			}
			for i, dir in ipairs(l1) do
				if string.sub(nodename, -7 + i, -7 + i) == "1" then
					l2[#l2 + 1] = dir
				end
			end
			return l2
		end,

		on_punch = function(pos, node, puncher)
			local ppos = puncher:get_pos()
			local pvect = puncher:get_look_dir()
			local pface = get_face(pos, ppos, pvect)

			if pface == nil then return end

			local nodename = node.name
			local newstate = tostring(1 - tonumber(string.sub(nodename, pface - 7, pface - 7)))
			if pface <= 5 then
				nodename = string.sub(nodename, 1, pface - 7 - 1)..newstate..string.sub(nodename, pface - 7 + 1)
			else
				nodename = string.sub(nodename, 1, -2)..newstate
			end

			node.name = nodename
			minetest.set_node(pos, node)
		end,

		on_place = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.above

			if minetest.is_protected(pos, placer:get_player_name()) then
				minetest.log("action", placer:get_player_name()
					.. " tried to place " .. itemstack:get_name()
					.. " at protected position "
					.. minetest.pos_to_string(pos))
				minetest.record_protection_violation(pos, placer:get_player_name())
				return itemstack
			end

			if pos == nil then return end

			local node = minetest.get_node(pos)
			if node.name ~= "air" then
				if is_supported_node(node.name) then
					local obj = minetest.add_entity(pos, "technic:frame_entity")
					obj:get_luaentity():set_node({ name = itemstack:get_name() })
				end
			else
				minetest.set_node(pos, { name = itemstack:get_name() })
			end

			if not infinite_stacks then
				itemstack:take_item()
			end
			return itemstack
		end,

		on_rightclick = function(pos, node, placer, itemstack, pointed_thing)
			if is_supported_node(itemstack:get_name()) then
				if minetest.is_protected(pos, placer:get_player_name()) then
					minetest.log("action", placer:get_player_name()
						.. " tried to place " .. itemstack:get_name()
						.. " at protected position "
						.. minetest.pos_to_string(pos))
					minetest.record_protection_violation(pos, placer:get_player_name())
					return itemstack
				end

				minetest.set_node(pos, { name = itemstack:get_name() })

				local take_item = true
				local def = minetest.registered_items[itemstack:get_name()]
				-- Run callback
				if def.after_place_node then
					-- Copy place_to because callback can modify it
					local pos_copy = vector.new(pos)
					if def.after_place_node(pos_copy, placer, itemstack) then
						take_item = false
					end
				end

				-- Run script hook
				local callback = nil
				for _, _ in ipairs(minetest.registered_on_placenodes) do
					-- Copy pos and node because callback can modify them
					local pos_copy = { x = pos.x, y = pos.y, z = pos.z }
					local newnode_copy = { name = def.name, param1 = 0, param2 = 0 }
					local oldnode_copy = { name = "air", param1 = 0, param2 = 0 }
					if callback(pos_copy, newnode_copy, placer, oldnode_copy, itemstack) then
						take_item = false
					end
				end

				if take_item then
					itemstack:take_item()
				end

				local obj = minetest.add_entity(pos, "technic:frame_entity")
				obj:get_luaentity():set_node({ name = node.name })

				return itemstack
			else
				--local pointed_thing = { type = "node", under = pos }
				if pointed_thing then
					return minetest.item_place_node(itemstack, placer, pointed_thing)
				end
			end
		end,
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
		collisionbox = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 },
		visual = "wielditem",
		textures = {},
		visual_size = { x = 0.667, y = 0.667 },
	},

	node = {},

	set_node = function(self, node)
		self.node = node
		local pos = vector.round(self.object:getpos())
		frames_pos[pos_to_string(pos)] = node.name

		local prop = {
			is_visible = true,
			textures = { node.name },
		}
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
		return self.node.name
	end,

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({ immortal = 1 })
		self:set_node({ name = staticdata })
	end,

	dig = function(self)
		minetest.handle_node_drops(self.object:get_pos(), { ItemStack("technic:frame_111111") }, self.last_puncher)
		local pos = vector.round(self.object:get_pos())
		frames_pos[pos_to_string(pos)] = nil
		self.object:remove()
	end,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		local pos = self.object:get_pos()
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
		local ppos = puncher:get_pos()
		local pvect = puncher:get_look_dir()
		local pface = get_face(pos, ppos, pvect)
		if pface == nil then return end
		local nodename = self.node.name
		local newstate = tostring(1 - tonumber(string.sub(nodename, pface - 7, pface - 7)))

		if pface <= 5 then
			nodename = string.sub(nodename, 1, pface - 7 - 1)..newstate..string.sub(nodename, pface - 7 + 1)
		else
			nodename = string.sub(nodename, 1, -2)..newstate
		end

		self.node.name = nodename
		self:set_node(self.node)
	end,

	on_rightclick = function(self, clicker)
		local pos = self.object:get_pos()
		local ppos = clicker:get_pos()
		local pvect = clicker:get_look_dir()
		local pface = get_face(pos, ppos, pvect)

		if pface == nil then
			return
		end

		local pos_under = vector.round(pos)
		local pos_above = { x = pos_under.x, y = pos_under.y, z = pos_under.z }
		local index = ({ "x", "y", "z" })[math.floor((pface + 1) / 2)]
		pos_above[index] = pos_above[index] + 2 * ((pface + 1)%2) - 1
		local pointed_thing = { type = "node", under = pos_under, above = pos_above }
		local itemstack = clicker:get_wielded_item()
		local itemdef = minetest.registered_items[itemstack:get_name()]

		if itemdef ~= nil then
			itemdef.on_place(itemstack, clicker, pointed_thing)
		end
	end,
})

local crack = "crack_anylength.png^[verticalframe:5:0"
minetest.register_entity("technic:damage_entity", {
	initial_properties = {
		visual = "cube",
		visual_size = { x = 1.01, y = 1.01 },
		textures = { crack, crack, crack, crack, crack, crack },
		collisionbox = { 0, 0, 0, 0, 0, 0 },
		physical = false,
	},
	on_step = function(self, dtime)
		if self.remaining_time == nil then
			self.object:remove()
			self.frame_object.damage_object = nil
		end
		self.remaining_time = self.remaining_time - dtime
		if self.remaining_time < 0 then
			self.object:remove()
			self.frame_object.damage_object = nil
		end
		self.texture_change_time = self.texture_change_time - dtime
		if self.texture_change_time < 0 then
			self.texture_change_time = self.texture_change_time + 0.15
			self.texture_index = self.texture_index + 1
			if self.texture_index == 5 then
				self.object:remove()
				self.frame_object.damage_object = nil
				self.frame_object:dig()
			end
			local ct = "crack_anylength.png^[verticalframe:5:"..self.texture_index
			self.object:set_properties({ textures = { ct, ct, ct, ct, ct, ct } })
		end
	end,
})

mesecon.register_mvps_unmov("technic:frame_entity")
mesecon.register_mvps_unmov("technic:damage_entity")
mesecon.register_on_mvps_move(function(moved_nodes)
	local to_move = {}
	for _, n in ipairs(moved_nodes) do
		if frames_pos[pos_to_string(n.oldpos)] ~= nil then
			to_move[#to_move + 1] = {
				pos = n.pos,
				oldpos = n.oldpos,
				name = frames_pos[pos_to_string(n.oldpos)]
			}
			frames_pos[pos_to_string(n.oldpos)] = nil
		end
	end
	if #to_move > 0 then
		for _, t in ipairs(to_move) do
			frames_pos[pos_to_string(t.pos)] = t.name
			local objects = minetest.get_objects_inside_radius(t.oldpos, 0.1)
			for _, obj in ipairs(objects) do
				local entity = obj:get_luaentity()
				if entity and (entity.name == "technic:frame_entity" or
						entity.name == "technic:damage_entity") then
					obj:set_pos(t.pos)
				end
			end
		end
	end
end)

minetest.register_on_dignode(function(pos, node)
	if frames_pos[pos_to_string(pos)] ~= nil then
		minetest.set_node(pos, { name = frames_pos[pos_to_string(pos)] })
		frames_pos[pos_to_string(pos)] = nil
		local objects = minetest.get_objects_inside_radius(pos, 0.1)
		for _, obj in ipairs(objects) do
			local entity = obj:get_luaentity()
			if entity and (entity.name == "technic:frame_entity" or entity.name == "technic:damage_entity") then
				obj:remove()
			end
		end
	end
end)

-- Frame motor
local function connected(pos, c, adj)
	for _, vect in ipairs(adj) do
		local pos1 = vector.add(pos, vect)
		local nodename = minetest.get_node(pos1).name
		if frames_pos[pos_to_string(pos1)] then
			nodename = frames_pos[pos_to_string(pos1)]
		end
		if not pos_in_list(c, pos1) and nodename ~= "air" and
				(minetest.registered_nodes[nodename].frames_can_connect == nil or
				minetest.registered_nodes[nodename].frames_can_connect(pos1, vect)) then
			c[#c + 1] = pos1
			if minetest.registered_nodes[nodename].frame == 1 then
				local adj = minetest.registered_nodes[nodename].frame_connect_all(nodename)
				connected(pos1, c, adj)
			end
		end
	end
end

local function get_connected_nodes(pos)
	local c = { pos }
	local nodename = minetest.get_node(pos).name
	if frames_pos[pos_to_string(pos)] then
		nodename = frames_pos[pos_to_string(pos)]
	end
	connected(pos, c, minetest.registered_nodes[nodename].frame_connect_all(nodename))
	return c
end

local function frame_motor_on(pos, node)
	local dirs = {
		{ x = 0, y = 1, z = 0 }, { x = 0, y = 0, z = 1 },
		{ x = 0, y = 0, z = -1 }, { x = 1, y = 0, z = 0 },
		{ x = -1, y = 0, z = 0 }, { x = 0, y = -1, z = 0 }
	}
	local nnodepos = vector.add(pos, dirs[math.floor(node.param2 / 4) + 1])
	local dir = minetest.facedir_to_dir(node.param2)
	local nnode = minetest.get_node(nnodepos)

	if frames_pos[pos_to_string(nnodepos)] then
		nnode.name = frames_pos[pos_to_string(nnodepos)]
	end

	local meta = minetest.get_meta(pos)
	if meta:get_int("last_moved") == minetest.get_gametime() then
		return
	end

	local owner = meta:get_string("owner")
	if minetest.registered_nodes[nnode.name].frame == 1 then
		local connected_nodes = get_connected_nodes(nnodepos)
		move_nodes_vect(connected_nodes, dir, pos, owner)
	end

	minetest.get_meta(vector.add(pos, dir)):set_int("last_moved", minetest.get_gametime())
end

minetest.register_node("technic:frame_motor", {
	description = S("Frame Motor"),
	tiles = {
		"pipeworks_filter_top.png^[transformR90", "technic_lv_cable.png", "technic_lv_cable.png",
		"technic_lv_cable.png", "technic_lv_cable.png", "technic_lv_cable.png"
	},
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, mesecon = 2 },
	paramtype2 = "facedir",
	mesecons = { effector = { action_on = frame_motor_on } },

	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
	end,

	frames_can_connect = function(pos, dir)
		local node = minetest.get_node(pos)
		local dir2 = ({
			{ x= 0 , y = 1, z = 0 }, { x = 0, y = 0, z = 1 },
			{ x = 0, y = 0, z = -1 }, { x = 1, y = 0, z = 0 },
			{ x = -1, y = 0, z = 0 }, { x = 0, y = -1, z = 0 }
		})[math.floor(node.param2 / 4) + 1]
		return dir2.x ~= -dir.x or dir2.y ~= -dir.y or dir2.z ~= -dir.z
	end
})



-- Templates
local function template_connected(pos, c, connectors)
	local vects = {
		{ x = 0, y = 1, z = 0 }, { x = 0, y = 0, z = 1 },
		{ x = 0, y = 0, z = -1 }, { x = 1, y = 0, z = 0 },
		{ x = -1, y = 0, z = 0 }, { x = 0, y = -1, z = 0 }
	}
	for _, vect in ipairs(vects) do
		local pos1 = vector.add(pos, vect)
		local nodename = minetest.get_node(pos1).name
		if not pos_in_list(c, pos1) and (nodename == "technic:template" or
				nodename == "technic:template_connector") then
			local meta = minetest.get_meta(pos1)
			if meta:get_string("connected") == "" then
				c[#c + 1] = pos1
				template_connected(pos1, c, connectors)
				if nodename == "technic:template_connector" then
					connectors[#connectors + 1] = pos1
				end
			end
		end
	end
end

local function get_templates(pos)
	local c = { pos }
	local connectors
	if minetest.get_node(pos).name == "technic:template_connector" then
		connectors = { pos }
	else
		connectors = {}
	end
	template_connected(pos, c, connectors)
	return c, connectors
end

local function swap_template(pos, new)
	local meta = minetest.get_meta(pos)
	local saved_node = meta:get_string("saved_node")
	meta:set_string("saved_node", "")
	technic.swap_node(pos, new)
	meta = minetest.get_meta(pos)
	meta:set_string("saved_node", saved_node)
end

local function save_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "air" then
		minetest.set_node(pos, { name = "technic:template" })
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
	minetest.set_node(pos, { name = "technic:template" })
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
		end
	end
end

local function compress_templates(pos)
	local templates, connectors = get_templates(pos)

	if #connectors == 0 then
		connectors = { pos }
	end

	for _, cn in ipairs(connectors) do
		local meta = minetest.get_meta(cn)
		local c = {}
		for _, p in ipairs(templates) do
			local np = vector.subtract(p, cn)
			if not pos_in_list(c, np) then
				c[#c + 1] = np
			end
		end
		local cc = {}
		for _, p in ipairs(connectors) do
			local np = vector.subtract(p, cn)
			if np.x ~= 0 or np.y ~= 0 or np.z ~= 0 then
				cc[pos_to_string(np)] = true
			end
		end
		swap_template(cn, "technic:template")
		meta:set_string("connected", minetest.serialize(c))
		meta:set_string("connectors_connected", minetest.serialize(cc))
	end

	for _, p in ipairs(templates) do
		if not pos_in_list(connectors, p) then
			minetest.set_node(p, { name = "air" })
		end
	end
end

local function template_drops(pos, node, oldmeta, digger)
	local c = oldmeta.fields.connected
	local cc = oldmeta.fields.connectors_connected
	local drops

	if c == "" or c == nil then
		drops = { "technic:template 1" }
	else
		if cc == "" or cc == nil then
			drops = { "technic:template 1" }
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
						d[pos_to_string({ x = -ssp.x, y = -ssp.y, z = -ssp.z })] = nil
						meta:set_string("connectors_connected", minetest.serialize(d))
					end
				end
			else
				local stack_max = 99
				local num = #minetest.deserialize(c)
				drops = {}
				while num > stack_max do
					drops[#drops + 1] = "technic:template "..stack_max
					num = num - stack_max
				end
				drops[#drops + 1] = "technic:template "..num
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

minetest.register_node("technic:template", {
	description = S("Template"),
	tiles = { "technic_mv_cable.png" },
	drop = "",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	on_destruct = template_on_destruct,
	after_dig_node = template_drops,
	on_punch = function(pos, node, puncher)
		swap_template(pos, "technic:template_disabled")
	end
})

minetest.register_node("technic:template_disabled", {
	description = S("Template"),
	tiles = { "technic_hv_cable.png" },
	drop = "",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1 },
	on_destruct = template_on_destruct,
	after_dig_node = template_drops,
	on_punch = function(pos, node, puncher)
	local _ = minetest.get_meta(pos)
		swap_template(pos, "technic:template_connector")
	end
})

minetest.register_node("technic:template_connector", {
	description = S("Template"),
	tiles = { "technic_lv_cable.png" },
	drop = "",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1 },
	on_destruct = template_on_destruct,
	after_dig_node = template_drops,
	on_punch = function(pos, node, puncher)
		swap_template(pos, "technic:template")
	end
})

minetest.register_craftitem("technic:template_replacer", {
	description = S("Template (replacing)"),
	inventory_image = "technic_template_replacer.png",
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

minetest.register_tool("technic:template_tool", {
	description = S("Template Tool"),
	inventory_image = "technic_template_tool.png",
	on_use = function(itemstack, puncher, pointed_thing)
		local pos = pointed_thing.under
		if pos == nil or minetest.is_protected and minetest.is_protected(pos, puncher:get_player_name()) then
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
	for _, vect in ipairs(adj) do
		local pos1 = vector.add(pos, vect)
		local nodename = minetest.get_node(pos1).name
		if not(pos_in_list(c, pos1)) and nodename ~= "air" then
			c[#c + 1] = pos1
		end
	end
	return c
end

local function template_motor_on(pos, node)
	local dirs = {
		{ x = 0, y = 1, z = 0 }, { x = 0, y = 0, z = 1 },
		{ x = 0, y = 0, z = -1 }, { x = 1, y = 0, z = 0 },
		{ x = -1, y = 0, z = 0 }, { x = 0, y = -1, z = 0 }
	}
	local nnodepos = vector.add(pos, dirs[math.floor(node.param2 / 4) + 1])
	local dir = minetest.facedir_to_dir(node.param2)
	local nnode = minetest.get_node(nnodepos)
	local meta = minetest.get_meta(pos)
	if meta:get_int("last_moved") == minetest.get_gametime() then
		return
	end
	local owner = meta:get_string("owner")
	if nnode.name == "technic:template" then
		local connected_nodes = get_template_nodes(nnodepos)
		move_nodes_vect(connected_nodes, dir, pos, owner)
	end
	minetest.get_meta(vector.add(pos, dir)):set_int("last_moved", minetest.get_gametime())
end

minetest.register_node("technic:template_motor", {
	description = S("Template Motor"),
	tiles = {
		"pipeworks_filter_top.png^[transformR90",
		"technic_lv_cable.png",
		"technic_lv_cable.png",
		"technic_lv_cable.png",
		"technic_lv_cable.png",
		"technic_lv_cable.png"
	},
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, mesecon = 2 },
	paramtype2 = "facedir",
	mesecons = { effector = { action_on = template_motor_on } },
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
	end,
})

-- Crafts
minetest.register_craft({
	output = 'technic:frame_111111',
	recipe = {
		{ '',              'default:stick',       '' },
		{ 'default:stick', 'basic_materials:brass_ingot', 'default:stick' },
		{ '',              'default:stick',       '' },
	}
})

minetest.register_craft({
	output = 'technic:frame_motor',
	recipe = {
		{ '',                                  'technic:frame_111111', '' },
		{ 'group:mesecon_conductor_craftable', 'basic_materials:motor',        'group:mesecon_conductor_craftable' },
		{ '',                                  'technic:frame_111111', '' },
	}
})

minetest.register_craft({
	output = 'technic:template 10',
	recipe = {
		{ '',                    'basic_materials:brass_ingot',  '' },
		{ 'basic_materials:brass_ingot', 'default:mese_crystal', 'basic_materials:brass_ingot' },
		{ '',                    'basic_materials:brass_ingot',  '' },
	}
})

minetest.register_craft({
	output = 'technic:template_replacer',
	recipe = { { 'technic:template' } }
})

minetest.register_craft({
	output = 'technic:template',
	recipe = { { 'technic:template_replacer' } }
})

minetest.register_craft({
	output = 'technic:template_motor',
	recipe = {
		{ '',                                  'technic:template', '' },
		{ 'group:mesecon_conductor_craftable', 'basic_materials:motor',    'group:mesecon_conductor_craftable' },
		{ '',                                  'technic:template', '' },
	}
})

minetest.register_craft({
	output = 'technic:template_tool',
	recipe = {
		{ '',                     'technic:template', '' },
		{ 'default:mese_crystal', 'default:stick',    'default:mese_crystal' },
		{ '',                     'default:stick',    '' },
	}
})
