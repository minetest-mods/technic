laser_mk1_max_charge=40000

local laser_shoot = function(itemstack, player, pointed_thing)
				local playerpos=player:getpos()
				local dir=player:get_look_dir()
				direction_y=math.abs(math.floor(dir.y*100))
				print (direction_y)
				if direction_y>50 then entity_name="technic:laser_beam_entityV"
					else entity_name="technic:laser_beam_entity" end
				local obj=minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.6,z=playerpos.z},entity_name)
				if obj:get_luaentity().player == nil then
					obj:get_luaentity().player = player
				end
				obj:setvelocity({x=dir.x*10, y=dir.y*10, z=dir.z*10})
				obj:setacceleration({x=0, y=0, z=0})
				obj:setyaw(player:get_look_yaw()+math.pi)
				if obj:get_luaentity().player == nil then
					obj:get_luaentity().player = player
				end
				--obj:get_luaentity().node = player:get_inventory():get_stack("main", 1):get_name()
				minetest.sound_play("technic_laser", {pos = playerpos, gain = 1.0, max_hear_distance = 10,})
				return true
end


minetest.register_tool("technic:laser_mk1", {
	description = "Mining Laser MK1",
	inventory_image = "technic_mining_laser_mk1.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		item=itemstack:to_table()
		local charge=tonumber((item["wear"])) 
		if charge ==0 then charge =65535 end
		charge=get_RE_item_load(charge,laser_mk1_max_charge)
		if charge-400>0 then
		 laser_shoot(item, user, pointed_thing)
		 charge =charge-400;	
		charge=set_RE_item_load(charge,laser_mk1_max_charge)
		item["wear"]=tostring(charge)
		itemstack:replace(item)
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = 'technic:laser_mk1',
	recipe = {
		{'technic:diamond', 'default:steel_ingot', 'technic:battery'},
		{'', 'default:steel_ingot', 'technic:battery'},
		{'', '', 'moreores:copper_ingot'},
	}
})



minetest.register_node("technic:laser_beam_box", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5 , -0.1, -0.1 ,  0.1 ,  0.1 , 0.1  },
			{ -0.1 , -0.1 , -0.1 , 0.5, 0.1 , 0.1  },
		}
	},
	tiles = {"technic_laser_beam.png"},
	groups = {not_in_creative_inventory=1},
})

minetest.register_node("technic:laser_beam_boxV", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.1 , -0.1 , -0.1 , 0.1 , 0.5, 0.1  },
			{ -0.1 , -0.5, -0.1 ,  0.1 ,  0.1 , 0.1  },

		}
	},
	tiles = {"technic_laser_beam.png"},
	groups = {not_in_creative_inventory=1},
})

LASER_BEAM_ENTITY={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.2, y=0.2},
	textures = {"technic:laser_beam_box"},
	lastpos={},
	max_range=10,
	count=0,
--	digger=nil,
	collisionbox = {0,0,0,0,0,0},
}

LASER_BEAM_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	if self.player~=nil then if self.lastpos.x~=nil then lazer_it (pos, self.player) end end		
	if self.lastpos.x ~=nil and self.lastpos.y ~=nil and self.lastpos.y ~=nil then 
			temp1={x=math.floor(self.lastpos.x),y=math.floor(self.lastpos.y),z=math.floor(self.lastpos.z)}
			temp2={x=math.floor(pos.x),y=math.floor(pos.y),z=math.floor(pos.z)}
			if temp1.x==temp2.x and temp1.y==temp2.y and temp1.z==temp2.z then return end
			end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z}	
	self.count=self.count+1
	if self.count==self.max_range then self.object:remove() end
end

LASER_BEAM_ENTITYV={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.2, y=0.2},
	textures = {"technic:laser_beam_boxV"},
	lastpos={},
	max_range=15,
	count=0,
	collisionbox = {0,0,0,0,0,0},
}

LASER_BEAM_ENTITYV.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	if self.player~=nil then if self.lastpos.x~=nil then lazer_it (pos, self.player) end end		
	if self.lastpos.x ~=nil and self.lastpos.y ~=nil and self.lastpos.y ~=nil then 
			temp1={x=math.floor(self.lastpos.x),y=math.floor(self.lastpos.y),z=math.floor(self.lastpos.z)}
			temp2={x=math.floor(pos.x),y=math.floor(pos.y),z=math.floor(pos.z)}
			if temp1.x==temp2.x and temp1.y==temp2.y and temp1.z==temp2.z then return end
			end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z}	
	self.count=self.count+1
	if self.count==self.max_range then self.object:remove() end
end


minetest.register_entity("technic:laser_beam_entity", LASER_BEAM_ENTITY)
minetest.register_entity("technic:laser_beam_entityV", LASER_BEAM_ENTITYV)

function lazer_it (pos, player)	
	local pos1={}
--	pos1.x=math.floor(pos.x)
--	pos1.y=math.floor(pos.y)
--	pos1.z=math.floor(pos.z)
	local node = minetest.env:get_node(pos)
	if node.name == "air" or node.name == "ignore" or node.name == "default:lava_source" or node.name == "default:lava_flowing" then return end
	if node.name == "default:water_source" or node.name == "default:water_flowing" then minetest.env:remove_node(pos) return end
	if player then minetest.node_dig(pos,node,player) end
end