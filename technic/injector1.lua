minetest.register_craftitem("technic:injector", {
	description = "Injector",
	stack_max = 99,
})

minetest.register_node("technic:injector", {
	description = "Injector",
	tiles = {"technic_injector_top.png", "technic_injector_bottom.png", "technic_injector_side.png",
		"technic_injector_side.png", "technic_injector_side.png", "technic_injector_side.png"},
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
			pos1=pos
			pos1.y=pos1.y
			local x=pos1.x+1.5
			local z=pos1.z
			item1=tube_item({x=pos1.x,y=pos1.y,z=pos1.z},stack)
			item1:get_luaentity().start_pos = {x=pos1.x,y=pos1.y,z=pos1.z}
			item1:setvelocity({x=1, y=0, z=0})
			item1:setacceleration({x=0, y=0, z=0})
			return
			end
	end
end,
})


function tube_item(pos, item)
		local TUBE_nodes = {}
		local CHEST_nodes = {}

	 	TUBE_nodes[1]={}
	 	TUBE_nodes[1].x=pos.x
		TUBE_nodes[1].y=pos.y
		TUBE_nodes[1].z=pos.z


table_index=1
	repeat
	check_TUBE_node (TUBE_nodes,CHEST_nodes,table_index)
	table_index=table_index+1
	if TUBE_nodes[table_index]==nil then break end
	until false
found=table_index-1


print("Found "..found.." tubes connected")
print(dump(CHEST_nodes))
	-- Take item in any format
	local stack = ItemStack(item)
	local obj = minetest.env:add_entity(pos, "technic:tubed_item")
	obj:get_luaentity():set_item(stack:to_string())
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
		start_pos={},
		route={}
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
--		print (dump(staticdata))
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
	local stack = ItemStack(self.itemstring)
	local drop_pos=nil
		
	local velocity=self.object:getvelocity()
	
	if velocity==nil then print ("wypadl") return end

	if math.abs(velocity.x)==1 then
		local next_node=math.abs(pos.x-self.start_pos.x)
		if next_node >= 1 then 
			self.start_pos.x=self.start_pos.x+velocity.x
			if check_pos_vector (self.start_pos, velocity)==0 then 
			if check_next_step (self.start_pos, velocity)==0 then
				drop_pos=minetest.env:find_node_near({x=self.start_pos.x,y=self.start_pos.y,z=self.start_pos.z+velocity.x}, 1, "air")
				if drop_pos then minetest.item_drop(stack, "", drop_pos) end
				self.object:remove()
				end
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
			if check_next_step (self.start_pos, velocity)==0 then
				drop_pos=minetest.env:find_node_near({x=self.start_pos.x+velocity.x,y=self.start_pos.y+velocity.y,z=self.start_pos.z+velocity.z}, 1, "air")
				if drop_pos then minetest.item_drop(stack, "", drop_pos) end
				self.object:remove()
				end
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
			if check_next_step (self.start_pos, velocity)==0 then
				drop_pos=minetest.env:find_node_near({x=self.start_pos.x+velocity.x,y=self.start_pos.y+velocity.y,z=self.start_pos.z+velocity.z}, 1, "air")
				if drop_pos then minetest.item_drop(stack, "", drop_pos) end
				self.object:remove()
				end
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
if tubelike==1 then velocity.x=-1 velocity.y=0 velocity.z=0 return 1 end
meta = minetest.env:get_meta({x=pos.x+1,y=pos.y,z=pos.z})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=1 velocity.y=0 velocity.z=0 return 1 end
end

if velocity.z==0 then
meta = minetest.env:get_meta({x=pos.x,y=pos.y,z=pos.z+1})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=0 velocity.z=1 return 1 end
meta = minetest.env:get_meta({x=pos.x,y=pos.y,z=pos.z-1})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=0 velocity.z=-1 return 1 end
end

if velocity.y==0 then
meta = minetest.env:get_meta({x=pos.x,y=pos.y+1,z=pos.z})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=1 velocity.z=0 return 1 end
meta = minetest.env:get_meta({x=pos.x,y=pos.y-1,z=pos.z})
tubelike=meta:get_int("tubelike")
if tubelike==1 then velocity.x=0 velocity.y=-1 velocity.z=0 return 1 end
end

print ("spadl")
return 0
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

function add_new_TUBE_node (TUBE_nodes,pos1,parent)
local i=1
	repeat
		if TUBE_nodes[i]==nil then break end
		if pos1.x==TUBE_nodes[i].x and pos1.y==TUBE_nodes[i].y and pos1.z==TUBE_nodes[i].z then return false end
		i=i+1
	until false
TUBE_nodes[i]={}
TUBE_nodes[i].x=pos1.x
TUBE_nodes[i].y=pos1.y
TUBE_nodes[i].z=pos1.z
TUBE_nodes[i].parent_x=parent.x
TUBE_nodes[i].parent_y=parent.y
TUBE_nodes[i].parent_z=parent.z

return true
end

function check_TUBE_node (TUBE_nodes,CHEST_nodes,i)
		local pos1={}
		local parent={}
		pos1.x=TUBE_nodes[i].x
		pos1.y=TUBE_nodes[i].y
		pos1.z=TUBE_nodes[i].z
		parent.x=pos1.x
		parent.y=pos1.y
		parent.z=pos1.z
		new_node_added=false
	
		pos1.x=pos1.x+1
		check_TUBE_node_subp (TUBE_nodes,CHEST_nodes,pos1,parent)
		pos1.x=pos1.x-2
		check_TUBE_node_subp (TUBE_nodes,CHEST_nodes,pos1,parent)
		pos1.x=pos1.x+1
		
		pos1.y=pos1.y+1
		check_TUBE_node_subp (TUBE_nodes,CHEST_nodes,pos1,parent)
		pos1.y=pos1.y-2
		check_TUBE_node_subp (TUBE_nodes,CHEST_nodes,pos1,parent)
		pos1.y=pos1.y+1

		pos1.z=pos1.z+1
		check_TUBE_node_subp (TUBE_nodes,CHEST_nodes,pos1,parent)
		pos1.z=pos1.z-2
		check_TUBE_node_subp (TUBE_nodes,CHEST_nodes,pos1,parent)
		pos1.z=pos1.z+1
return new_node_added
end

function check_TUBE_node_subp (TUBE_nodes,CHEST_nodes,pos1,parent)
meta = minetest.env:get_meta(pos1)
if meta:get_float("tubelike")==1 then add_new_TUBE_node(TUBE_nodes,pos1,parent) return end
nctr = minetest.env:get_node(pos1)
if minetest.get_item_group(nctr.name, "tubedevice_receiver") == 1 then add_new_TUBE_node(CHEST_nodes,pos1,parent) return end
end

