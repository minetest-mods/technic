--HV cable node boxes


minetest.register_craft({
	output = 'technic:hv_cable 3',
	recipe ={
		{'technic:rubber','technic:rubber','technic:rubber'},
		{'technic:mv_cable','technic:mv_cable','technic:mv_cable'},
		{'technic:rubber','technic:rubber','technic:rubber'},
		}
}) 


minetest.register_craftitem("technic:hv_cable", {
	description = "Gigh Voltage Copper Cable",
	stack_max = 99,
}) 

minetest.register_node("technic:hv_cable", {
	description = "High Voltage Copper Cable",
	tiles = {"technic_hv_cable.png"},
	inventory_image = "technic_hv_cable_wield.png",
	wield_image = "technic_hv_cable_wield.png",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:hv_cable",
	hv_cablelike=1,
	rules_x1=0,
	rules_x2=0,
	rules_y1=0,
	rules_y2=0,
	rules_z1=0,
	rules_z2=0,
	paramtype = "light",
        drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
                fixed = {
		{ -0.1 , -0.1 , -0.1 , 0.1 ,  0.1 , 0.1  },
		}},
	node_box = {
		type = "fixed",
                fixed = {
		{ -0.125 , -0.125 , -0.125 , 0.125 ,  0.125 , 0.125  },
		}},
	on_construct = function(pos)
	meta=minetest.env:get_meta(pos)
	meta:set_float("hv_cablelike",1)
	meta:set_float("x1",0)
	meta:set_float("x2",0)
	meta:set_float("y1",0)
	meta:set_float("y2",0)
	meta:set_float("z1",0)
	meta:set_float("z2",0)
	HV_check_connections (pos)
	end,

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
	HV_check_connections_on_destroy (pos)
	end,

})


str_y1=		{ -0.125 , -0.125 , -0.125 , 0.125 , 0.5, 0.125  }    --0 y+
str_x1=		{ -0.125 , -0.125 , -0.125 , 0.5, 0.125 , 0.125  }    --0 x+
str_z1=		{ -0.125 , -0.125 ,  0.125 ,  0.125 , 0.125 , 0.5 }   --0 z+
str_z2=		{ -0.125 , -0.125, -0.5 ,  0.125 ,  0.125 , 0.125  }  --0 z-
str_y2=		{ -0.125 , -0.5, -0.125 ,  0.125 ,  0.125 , 0.125  }  --0 y-
str_x2=		{ -0.5 , -0.125, -0.125 ,  0.125 ,  0.125 , 0.125  }  --0 x-



local x1,x2,y1,y2,z1,z2
local count=0

for x1 = 0, 1, 1 do	--x-
for x2 = 0, 1, 1 do	--x+
for y1 = 0, 1, 1 do	--y-
for y2 = 0, 1, 1 do	--y-	
for z1 = 0, 1, 1 do	--z-
for z2 = 0, 1, 1 do	--z+
     
temp_x1={} temp_x2={} temp_y1={} temp_y2={} temp_z1={} temp_z2={}

if x1==1 then 	temp_x1=str_x1  end 
if x2==1 then 	temp_x2=str_x2  end 
if y1==1 then 	temp_y1=str_y1  end 
if y2==1 then 	temp_y2=str_y2  end 
if z1==1 then 	temp_z1=str_z1  end 
if z2==1 then 	temp_z2=str_z2  end 


minetest.register_node("technic:hv_cable"..count, {
	description = "Gigh Voltage Copper Cable",
	tiles = {"technic_hv_cable.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:hv_cable",
	rules_x1=0,
	rules_x2=0,
	rules_y1=0,
	rules_y2=0,
	rules_z1=0,
	rules_z2=0,
	cablelike=1,
	paramtype = "light",
        drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
           fixed = {
		temp_x1,temp_x2,temp_y1,temp_y2,temp_z1,temp_z2,
		}},

	node_box = {
		type = "fixed",
           fixed = {
		temp_x1,temp_x2,temp_y1,temp_y2,temp_z1,temp_z2,
		}},

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
	HV_check_connections_on_destroy (pos)
	end,
	
})

count=count+1 end end end end end end

HV_check_connections = function(pos)
		local pos1={}
		pos1.x=pos.x
		pos1.y=pos.y
		pos1.z=pos.z
		
		pos1.x=pos1.x+1
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		x2=1
		x1=minetest.env:get_meta(pos1):get_float("x1")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos1,"technic:hv_cable"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_float("x2",x2)
		meta=minetest.env:get_meta(pos)
		x1=1
		x2=minetest.env:get_meta(pos):get_float("x2")
		y1=minetest.env:get_meta(pos):get_float("y1")
		y2=minetest.env:get_meta(pos):get_float("y2")
		z1=minetest.env:get_meta(pos):get_float("z1")
		z2=minetest.env:get_meta(pos):get_float("z2")
		meta:set_float("x1",x1)
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos,"technic:hv_cable"..rule)
		end

		pos1.x=pos1.x-2
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		x1=1
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos1,"technic:hv_cable"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_float("x1",x1)
		meta=minetest.env:get_meta(pos)
		x2=1
		x1=minetest.env:get_meta(pos):get_float("x1")
		y1=minetest.env:get_meta(pos):get_float("y1")
		y2=minetest.env:get_meta(pos):get_float("y2")
		z1=minetest.env:get_meta(pos):get_float("z1")
		z2=minetest.env:get_meta(pos):get_float("z2")
		meta:set_float("x2",x2)
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos,"technic:hv_cable"..rule)
		end

		pos1.x=pos1.x+1
		
		pos1.y=pos1.y+1
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		y2=1
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos1,"technic:hv_cable"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_float("y2",y2)
		meta=minetest.env:get_meta(pos)
		y1=1
		x1=minetest.env:get_meta(pos):get_float("x1")
		x2=minetest.env:get_meta(pos):get_float("x2")
		y2=minetest.env:get_meta(pos):get_float("y2")
		z1=minetest.env:get_meta(pos):get_float("z1")
		z2=minetest.env:get_meta(pos):get_float("z2")
		meta:set_float("y1",y1)
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos,"technic:hv_cable"..rule)
		end
		
		if minetest.env:get_meta(pos1):get_float("technic_hv_power_machine")==1 then
		y1=1
		x1=minetest.env:get_meta(pos):get_float("x1")
		x2=minetest.env:get_meta(pos):get_float("x2")
		y2=minetest.env:get_meta(pos):get_float("y2")
		z1=minetest.env:get_meta(pos):get_float("z1")
		z2=minetest.env:get_meta(pos):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos,"technic:hv_cable"..rule)
		meta=minetest.env:get_meta(pos)
		meta:set_float("y1",y1)
		end


		pos1.y=pos1.y-2
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		y1=1
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos1,"technic:hv_cable"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_float("y1",y1)
		meta=minetest.env:get_meta(pos)
		y2=1
		x1=minetest.env:get_meta(pos):get_float("x1")
		x2=minetest.env:get_meta(pos):get_float("x2")
		y1=minetest.env:get_meta(pos):get_float("y1")
		z1=minetest.env:get_meta(pos):get_float("z1")
		z2=minetest.env:get_meta(pos):get_float("z2")
		meta:set_float("y2",y2)
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos,"technic:hv_cable"..rule)
		end
		pos1.y=pos1.y+1

		pos1.z=pos1.z+1
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		z2=1
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos1,"technic:hv_cable"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_float("z2",z2)
		meta=minetest.env:get_meta(pos)
		z1=1
		x1=minetest.env:get_meta(pos):get_float("x1")
		x2=minetest.env:get_meta(pos):get_float("x2")
		y1=minetest.env:get_meta(pos):get_float("y1")
		y2=minetest.env:get_meta(pos):get_float("y2")
		z2=minetest.env:get_meta(pos):get_float("z2")
		meta:set_float("z1",z1)
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos,"technic:hv_cable"..rule)
		end
		pos1.z=pos1.z-2
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		z1=1
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos1,"technic:hv_cable"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_float("z1",z1)
		meta=minetest.env:get_meta(pos)
		z2=1
		x1=minetest.env:get_meta(pos):get_float("x1")
		x2=minetest.env:get_meta(pos):get_float("x2")
		y1=minetest.env:get_meta(pos):get_float("y1")
		y2=minetest.env:get_meta(pos):get_float("y2")
		z1=minetest.env:get_meta(pos):get_float("z1")
		meta:set_float("z2",z2)
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		hacky_swap_node(pos,"technic:hv_cable"..rule)
		end
		pos1.z=pos1.z+1
end	


HV_check_connections_on_destroy = function(pos)
		local pos1={}
		pos1.x=pos.x
		pos1.y=pos.y
		pos1.z=pos.z
		
		pos1.x=pos1.x+1
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		x2=0
		x1=minetest.env:get_meta(pos1):get_float("x1")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		if rule==0 then hacky_swap_node(pos1,"technic:hv_cable") end
		if rule>0  then	hacky_swap_node(pos1,"technic:hv_cable"..rule) end
		meta=minetest.env:get_meta(pos1)
		meta:set_float("x2",x2)
		end
		
		pos1.x=pos1.x-2
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		x1=0
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		if rule==0 then hacky_swap_node(pos1,"technic:hv_cable") end
		if rule>0  then	hacky_swap_node(pos1,"technic:hv_cable"..rule) end
		meta=minetest.env:get_meta(pos1)
		meta:set_float("x1",x1)
		end
		pos1.x=pos1.x+1

		pos1.y=pos1.y+1
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		y2=0
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		if rule==0 then hacky_swap_node(pos1,"technic:hv_cable") end
		if rule>0  then	hacky_swap_node(pos1,"technic:hv_cable"..rule) end
		meta=minetest.env:get_meta(pos1)
		meta:set_float("y2",y2)
		end
		
		pos1.y=pos1.y-2
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		y1=0
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		if rule==0 then hacky_swap_node(pos1,"technic:hv_cable") end
		if rule>0  then	hacky_swap_node(pos1,"technic:hv_cable"..rule) end
		meta=minetest.env:get_meta(pos1)
		meta:set_float("y1",y1)
		end
		pos1.y=pos1.y+1

		pos1.z=pos1.z+1
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		z2=0
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z1=minetest.env:get_meta(pos1):get_float("z1")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		if rule==0 then hacky_swap_node(pos1,"technic:hv_cable") end
		if rule>0  then	hacky_swap_node(pos1,"technic:hv_cable"..rule) end
		meta=minetest.env:get_meta(pos1)
		meta:set_float("z2",z2)
		end
		
		pos1.z=pos1.z-2
		if minetest.env:get_meta(pos1):get_float("hv_cablelike")==1 then
		z1=0
		x1=minetest.env:get_meta(pos1):get_float("x1")
		x2=minetest.env:get_meta(pos1):get_float("x2")
		y1=minetest.env:get_meta(pos1):get_float("y1")
		y2=minetest.env:get_meta(pos1):get_float("y2")
		z2=minetest.env:get_meta(pos1):get_float("z2")
		rule=make_rule_number(x1,x2,y1,y2,z1,z2)
		if rule==0 then hacky_swap_node(pos1,"technic:hv_cable") end
		if rule>0  then	hacky_swap_node(pos1,"technic:hv_cable"..rule) end
		meta=minetest.env:get_meta(pos1)
		meta:set_float("z1",z1)
		end
		pos1.y=pos1.y+1
		
end	

