minetest.register_craftitem("technic:injector", {
	description = "Injector",
	stack_max = 99,
})

minetest.register_node("technic:injector", {
	description = "Injector",
	tiles = {"technic_iron_chest_top.png", "technic_iron_chest_top.png", "technic_iron_chest_side.png",
		"technic_iron_chest_side.png", "technic_iron_chest_side.png", "technic_iron_chest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[9,9;]"..
				"list[current_name;main;0,2;8,2;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Injector")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_punch = function (pos, node, puncher)
	local meta = minetest.env:get_meta(pos);
	local inv = meta:get_inventory()
	for _,stack in ipairs(inv:get_list("main")) do
		if stack:get_name() ~="" then 
			inv:remove_item("main",stack)
			item1=tube_item({x=pos.x+.5,y=pos.y,z=pos.z},stack)
			return
			end
	end
end,
})


function tube_item(pos, item)
	-- Take item in any format
	local stack = ItemStack(item)
	local obj = minetest.env:add_entity(pos, "technic:tubed_item")
	obj:get_luaentity():set_item(stack:to_string())
	obj:get_luaentity().start_pos = {x=pos.x,y=pos.y,z=pos.z}
	obj:setacceleration({x=0, y=0, z=0})
	pos.x=pos.x+1
	local meta = minetest.env:get_meta(pos)
	if meta:get_int("tubelike")==1 then obj:setvelocity({x=1, y=0, z=0}) return obj end
	pos.x=pos.x-2
	meta = minetest.env:get_meta(pos)
	if meta:get_int("tubelike")==1 then obj:setvelocity({x=-1, y=0, z=0}) return obj end
	pos.x=pos.x+1
	pos.z=pos.z+1
	meta = minetest.env:get_meta(pos)
	if meta:get_int("tubelike")==1 then obj:setvelocity({x=0, y=0, z=1}) return obj end
	pos.z=pos.z-2
	meta = minetest.env:get_meta(pos)
	if meta:get_int("tubelike")==1 then obj:setvelocity({x=0, y=0, z=-1}) return obj end
	pos.z=pos.z+1
	pos.y=pos.y+1
	meta = minetest.env:get_meta(pos)
	if meta:get_int("tubelike")==1 then obj:setvelocity({x=0, y=1, z=0}) return obj end
	pos.y=pos.y-2
	meta = minetest.env:get_meta(pos)
	if meta:get_int("tubelike")==1 then obj:setvelocity({x=0, y=-2, z=0}) return obj end
	pos.y=pos.y+1
	return obj
end

minetest.register_entity("technic:tubed_item", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collisionbox = {0,0,0,0,0,0},
		visual = "sprite",
		visual_size = {x=0.5, y=0.5},
		textures = {""},
		spritediv = {x=1, y=1},
		initial_sprite_basepos = {x=0, y=0},
		is_visible = false,
		start_pos={}
	},
	
	itemstring = '',
	physical_state = false,

	set_item = function(self, itemstring)
		self.itemstring = itemstring
		local stack = ItemStack(itemstring)
		local itemtable = stack:to_table()
		local itemname = nil
		if itemtable then
			itemname = stack:to_table().name
		end
		local item_texture = nil
		local item_type = ""
		if minetest.registered_items[itemname] then
			item_texture = minetest.registered_items[itemname].inventory_image
			item_type = minetest.registered_items[itemname].type
		end
		prop = {
			is_visible = true,
			visual = "sprite",
			textures = {"unknown_item.png"}
		}
		if item_texture and item_texture ~= "" then
			prop.visual = "sprite"
			prop.textures = {item_texture}
			prop.visual_size = {x=0.3, y=0.3}
		else
			prop.visual = "wielditem"
			prop.textures = {itemname}
			prop.visual_size = {x=0.15, y=0.15}
		end
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
			
			return	minetest.serialize({
				itemstring=self.itemstring,
				velocity=self.object:getvelocity(),
				start_pos=self.start_pos
				})
	end,

	on_activate = function(self, staticdata)
		if  staticdata=="" or staticdata==nil then return end
		local item = minetest.deserialize(staticdata)
		local stack = ItemStack(item.itemstring)
		local itemtable = stack:to_table()
		local itemname = nil
		if itemtable then
			itemname = stack:to_table().name
		end
		
		if itemname then 
		self.start_pos=item.start_pos
		self.object:setvelocity(item.velocity)
		self.object:setacceleration({x=0, y=0, z=0})
		self.object:setpos(item.start_pos)
		end
		self:set_item(item.itemstring)
	end,

	on_step = function(self, dtime)
	if self.start_pos then
	local pos = self.object:getpos()
	local node = minetest.env:get_node(pos)
	local meta = minetest.env:get_meta(pos)
	tubelike=meta:get_int("tubelike")
	local velocity=self.object:getvelocity()
	
	if not velocity then return end

	if math.abs(velocity.x)==1 then
		local next_node=math.abs(pos.x-self.start_pos.x)
		if next_node >= 1 then 
			self.start_pos.x=self.start_pos.x+velocity.x
			if check_pos_vector (self.start_pos, velocity)==0 then 
			check_next_step (self.start_pos, velocity) 
			self.object:setpos(self.start_pos)
			self.object:setvelocity(velocity)
			return
			end
			end
		end

	if math.abs(velocity.y)==1 then
		local next_node=math.abs(pos.y-self.start_pos.y)
		if next_node >= 1 then 
			self.start_pos.y=self.start_pos.y+velocity.y
			if check_pos_vector (self.start_pos, velocity)==0 then
			check_next_step (self.start_pos, velocity) 
			self.object:setpos(self.start_pos)
			self.object:setvelocity(velocity)
			return
			end
			end
		end
	
	if math.abs(velocity.z)==1 then
		local next_node=math.abs(pos.z-self.start_pos.z)
		if next_node >= 1 then 
			self.start_pos.z=self.start_pos.z+velocity.z
			if check_pos_vector (self.start_pos, velocity)==0 then
			check_next_step (self.start_pos, velocity) 
			self.object:setpos(self.start_pos)
			self.object:setvelocity(velocity)
			return
			end
			end
		end
	end
end
})


function check_next_step (pos,velocity)
local meta
local tubelike

if velocity.x==0 then
meta = minetest.env:get_meta({x=pos.x-1,y=pos.y,z=pos.z})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=-1 velocity.y=0 velocity.z=0 return end
meta = minetest.env:get_meta({x=pos.x+1,y=pos.y,z=pos.z})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=1 velocity.y=0 velocity.z=0 return end
end

if velocity.z==0 then
meta = minetest.env:get_meta({x=pos.x,y=pos.y,z=pos.z+1})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=0 velocity.z=1 return end
meta = minetest.env:get_meta({x=pos.x,y=pos.y,z=pos.z-1})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=0 velocity.z=-1 return end
end

if velocity.y==0 then
meta = minetest.env:get_meta({x=pos.x,y=pos.y+1,z=pos.z})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=1 velocity.z=0 return end
meta = minetest.env:get_meta({x=pos.x,y=pos.y-1,z=pos.z})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=-1 velocity.z=0 return end
end

--velocity.x=0
--velocity.y=0
--velocity.z=0
end

function check_pos_vector (pos,velocity)
added={}
added.x=pos.x+velocity.x
added.y=pos.y+velocity.y
added.z=pos.z+velocity.z
local meta=minetest.env:get_meta(added) 
--print(dump(added).." : "..tubelike)
if meta:get_int("tubelike")==1 then return 1 end
return 0
end
