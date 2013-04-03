--Minetest 0.4.6 mod: concrete 
--(c) 2013 by RealBadAngel <mk@realbadangel.pl>

minetest.register_craft({
	output = ':technic:rebar 6',
	recipe = {
		{'','', 'default:steel_ingot'},
		{'','default:steel_ingot',''},
		{'default:steel_ingot', '', ''},
	}
})

minetest.register_craft({
	output = ':technic:concrete 5',
	recipe = {
		{'default:stone','technic:rebar','default:stone'},
		{'technic:rebar','default:stone','technic:rebar'},
		{'default:stone','technic:rebar','default:stone'},
	}
})

minetest.register_craft({
	output = ':technic:concrete_post_platform 6',
	recipe = {
		{'technic:concrete','technic:concrete_post','technic:concrete'},
	}
})

minetest.register_craft({
	output = ':technic:concrete_post 12',
	recipe = {
		{'default:stone','technic:rebar','default:stone'},
		{'default:stone','technic:rebar','default:stone'},
		{'default:stone','technic:rebar','default:stone'},
}
})

platform_box = {-0.5 , 0.3 , -0.5 , 0.5 ,  0.5 , 0.5  }
post_str_y={ -0.15 , -0.5 , -0.15 , 0.15 ,  0.5 , 0.15  }
post_str_x1={ 0 , -0.3 , -0.1, 0.5 ,  0.3 , 0.1 }  -- x+
post_str_z1={ -0.1 , -0.3 , 0, 0.1 ,  0.3 , 0.5 } -- z+
post_str_x2={ 0 , -0.3 , -0.1, -0.5 ,  0.3 , 0.1 } -- x-
post_str_z2={ -0.1 , -0.3 , 0, 0.1 ,  0.3 , -0.5 } -- z-

minetest.register_craftitem(":technic:rebar", {
	description = "Rebar",
	inventory_image = "technic_rebar.png",
	stack_max = 99,
})

minetest.register_craftitem(":technic:concrete", {
	description = "Concrete Block",
	inventory_image = "technic_concrete_block.png",
	stack_max = 99,
})

minetest.register_craftitem(":technic:concrete_post", {
	description = "Concrete Post",
	stack_max = 99,
})

minetest.register_craftitem(":technic:concrete_post_platform", {
	description = "Concrete Post Platform",
	stack_max = 99,
})

minetest.register_node(":technic:concrete", {
	description = "Concrete Block",
	tile_images = {"technic_concrete_block.png",},
	is_ground_content = true,
	groups={cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	on_construct = function(pos)
		meta=minetest.env:get_meta(pos)
		meta:set_float("postlike",1)
		check_post_connections (pos,1)
	end,
	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		check_post_connections  (pos,0)
	end,
})

minetest.register_node(":technic:concrete_post_platform", {
	description = "Concrete Post Platform",
	tile_images = {"technic_concrete_block.png",},
	is_ground_content = true,
	groups={cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = {platform_box}
		},
	node_box = {
		type = "fixed",
		fixed = {platform_box}
		},
	on_place=function (itemstack, placer, pointed_thing)
	local node=minetest.env:get_node(pointed_thing.under)
	if minetest.get_item_group(node.name, "concrete_post")==0 then 
		return minetest.item_place_node(itemstack, placer, pointed_thing) 
	end
	local meta=minetest.env:get_meta(pointed_thing.under)
	y1=meta:get_float("y1")
	platform=meta:get_float("platform")
	if y1==1 or platform==1 then 
		return minetest.item_place_node(itemstack, placer, pointed_thing) 
	end
	y2=meta:get_float("y2")
	x1=meta:get_float("x1")
	x2=meta:get_float("x2")
	z1=meta:get_float("z1")
	z2=meta:get_float("z2")
	rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,1)
	meta:set_float("platform",1)
	hacky_swap_posts(pointed_thing.under,"technic:concrete_post"..rule)
	itemstack:take_item()
	placer:set_wielded_item(itemstack)
	return itemstack
	end,
})


minetest.register_node(":technic:concrete_post", {
	description = "Concrete Post",
	tiles = {"technic_concrete_block.png"},
	groups={cracky=1,level=2,concrete_post=1},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = { -0.15 , -0.5 , -0.15 , 0.15 ,  0.5 , 0.15 }},
	node_box = {
		type = "fixed",
		fixed = {-0.15 , -0.5 , -0.15 , 0.15 ,  0.5 , 0.15  }},
	on_construct = function(pos)
	meta=minetest.env:get_meta(pos)
	meta:set_int("postlike",1)
	meta:set_int("platform",0)
	meta:set_int("x1",0)
	meta:set_int("x2",0)
	meta:set_int("y1",0)
	meta:set_int("y2",0)
	meta:set_int("z1",0)
	meta:set_int("z2",0)
	check_post_connections (pos,1)
	end,

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
	check_post_connections  (pos,0)
	end,

})

local x1,x2,y1,z1,z2
local count=0

for x1 = 0, 1, 1 do	--x-
for x2 = 0, 1, 1 do	--x+
for z1 = 0, 1, 1 do	--z-
for z2 = 0, 1, 1 do	--z+
     
temp_x1={} temp_x2={} temp_z1={} temp_z2={}

if x1==1 then 	temp_x1=post_str_x1  end 
if x2==1 then 	temp_x2=post_str_x2  end 
if z1==1 then 	temp_z1=post_str_z1  end 
if z2==1 then 	temp_z2=post_str_z2  end 


minetest.register_node(":technic:concrete_post"..count, {
	description = "Concrete Post",
	tiles = {"technic_concrete_block.png"},
	groups={cracky=1,level=2,not_in_creative_inventory=1,concrete_post=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:concrete_post",
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = {
		temp_x1,temp_x2,post_str_y,temp_z1,temp_z2,
		}},

	node_box = {
		type = "fixed",
		fixed = {
		temp_x1,temp_x2,post_str_y,temp_z1,temp_z2,
		}},

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
	check_post_connections  (pos,0)
	end,

})

minetest.register_node(":technic:concrete_post"..count+16, {
	description = "Concrete Post",
	tiles = {"technic_concrete_block.png"},
	groups={cracky=1,level=2,not_in_creative_inventory=1,concrete_post=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:concrete_post_platform",
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = {
		platform_box,temp_x1,temp_x2,post_str_y,temp_z1,temp_z2,
		}},

	node_box = {
		type = "fixed",
		fixed = {
		platform_box,temp_x1,temp_x2,post_str_y,temp_z1,temp_z2,
		}},

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		dig_post_with_platform (pos,oldnode,oldmetadata)
	end,
})

count=count+1 end end end end

minetest.register_node(":technic:concrete_post32", {
	description = "Concrete Post",
	tiles = {"technic_concrete_block.png"},
	groups={cracky=1,level=2,not_in_creative_inventory=1,concrete_post=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:concrete_post",
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = {-0.5,-0.3,-0.1,0.5,0.3,0.1},
		},
	node_box = {
		type = "fixed",
		fixed = {
		post_str_x1,post_str_x2,
		}},

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		check_post_connections  (pos,0)
	end,
})
minetest.register_node(":technic:concrete_post33", {
	description = "Concrete Post",
	tiles = {"technic_concrete_block.png"},
	groups={cracky=1,level=2,not_in_creative_inventory=1,concrete_post=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:concrete_post",
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = {
		post_str_z1,post_str_z2,
		}},
	node_box = {
		type = "fixed",
		fixed = {
		post_str_z1,post_str_z2,
		}},

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
	check_post_connections  (pos,0)
	end,
})

minetest.register_node(":technic:concrete_post34", {
	description = "Concrete Post",
	tiles = {"technic_concrete_block.png"},
	groups={cracky=1,level=2,not_in_creative_inventory=1,concrete_post=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:concrete_post_platform",
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = {
		platform_box,post_str_x1,post_str_x2,
		}},
	node_box = {
		type = "fixed",
		fixed = {
		platform_box,post_str_x1,post_str_x2,
		}},

	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		dig_post_with_platform (pos,oldnode,oldmetadata)
	end,
})
minetest.register_node(":technic:concrete_post35", {
	description = "Concrete Post",
	tiles = {"technic_concrete_block.png"},
	groups={cracky=1,level=2,not_in_creative_inventory=1,concrete_post=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "technic:concrete_post_platform",
	paramtype = "light",
	light_source = 0,
	sunlight_propagates = true,
	drawtype = "nodebox", 
	selection_box = {
		type = "fixed",
		fixed = {
		platform_box,post_str_z1,post_str_z2,
		}},
	node_box = {
		type = "fixed",
		fixed = {
		platform_box,post_str_z1,post_str_z2,
		}},
	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		dig_post_with_platform (pos,oldnode,oldmetadata)
	end,
})

dig_post_with_platform = function (pos,oldnode,oldmetadata)
	x1=tonumber(oldmetadata.fields["x1"])
	x2=tonumber(oldmetadata.fields["x2"])
	y1=tonumber(oldmetadata.fields["y1"])
	y2=tonumber(oldmetadata.fields["y2"])
	z1=tonumber(oldmetadata.fields["z1"])
	z2=tonumber(oldmetadata.fields["z2"])
	print(dump(x1))
	oldmetadata.fields["platform"]="0"
	local rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,0)
	print(dump(rule))
	oldnode.name="technic:concrete_post"..rule
	minetest.env:set_node(pos,oldnode)
	meta = minetest.env:get_meta(pos)
	meta:from_table(oldmetadata)
end	

check_post_connections = function(pos,mode)
		local pos1={}
		pos1.x=pos.x
		pos1.y=pos.y
		pos1.z=pos.z
		tempx1=0
		tempx2=0
		tempy1=0
		tempy2=0
		tempz1=0
		tempz2=0
		
		pos1.x=pos1.x+1
		if minetest.env:get_meta(pos1):get_int("postlike")==1 then
		x2=mode
		x1=minetest.env:get_meta(pos1):get_int("x1")
		y1=minetest.env:get_meta(pos1):get_int("y1")
		y2=minetest.env:get_meta(pos1):get_int("y2")
		z1=minetest.env:get_meta(pos1):get_int("z1")
		z2=minetest.env:get_meta(pos1):get_int("z2")
		platform=minetest.env:get_meta(pos1):get_int("platform")
		rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,platform)
		hacky_swap_posts(pos1,"technic:concrete_post"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_int("x2",x2)
		tempx1=mode
		end

		pos1.x=pos1.x-2
		if minetest.env:get_meta(pos1):get_int("postlike")==1 then
		x1=mode
		x2=minetest.env:get_meta(pos1):get_int("x2")
		y1=minetest.env:get_meta(pos1):get_int("y1")
		y2=minetest.env:get_meta(pos1):get_int("y2")
		z1=minetest.env:get_meta(pos1):get_int("z1")
		z2=minetest.env:get_meta(pos1):get_int("z2")
		platform=minetest.env:get_meta(pos1):get_int("platform")
		rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,platform)
		hacky_swap_posts(pos1,"technic:concrete_post"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_int("x1",x1)
		tempx2=mode
		end

		pos1.x=pos1.x+1
		
		pos1.y=pos1.y+1
		if minetest.env:get_meta(pos1):get_int("postlike")==1 then
		y2=mode
		x1=minetest.env:get_meta(pos1):get_int("x1")
		x2=minetest.env:get_meta(pos1):get_int("x2")
		y1=minetest.env:get_meta(pos1):get_int("y1")
		z1=minetest.env:get_meta(pos1):get_int("z1")
		z2=minetest.env:get_meta(pos1):get_int("z2")
		platform=minetest.env:get_meta(pos1):get_int("platform")
		rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,platform)
		hacky_swap_posts(pos1,"technic:concrete_post"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_int("y2",y2)
		tempy1=mode
		end

		pos1.y=pos1.y-2
		if minetest.env:get_meta(pos1):get_int("postlike")==1 then
		y1=mode
		x1=minetest.env:get_meta(pos1):get_int("x1")
		x2=minetest.env:get_meta(pos1):get_int("x2")
		y2=minetest.env:get_meta(pos1):get_int("y2")
		z1=minetest.env:get_meta(pos1):get_int("z1")
		z2=minetest.env:get_meta(pos1):get_int("z2")
		platform=minetest.env:get_meta(pos1):get_int("platform")
		rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,platform)
		hacky_swap_posts(pos1,"technic:concrete_post"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_int("y1",y1)
		tempy2=mode
		end
		pos1.y=pos1.y+1

		pos1.z=pos1.z+1
		if minetest.env:get_meta(pos1):get_int("postlike")==1 then
		z2=mode
		x1=minetest.env:get_meta(pos1):get_int("x1")
		x2=minetest.env:get_meta(pos1):get_int("x2")
		y1=minetest.env:get_meta(pos1):get_int("y1")
		y2=minetest.env:get_meta(pos1):get_int("y2")
		z1=minetest.env:get_meta(pos1):get_int("z1")
		platform=minetest.env:get_meta(pos1):get_int("platform")
		rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,platform)
		hacky_swap_posts(pos1,"technic:concrete_post"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_int("z2",z2)
		tempz1=mode
		end
		pos1.z=pos1.z-2
		
		if minetest.env:get_meta(pos1):get_int("postlike")==1 then
		z1=mode
		x1=minetest.env:get_meta(pos1):get_int("x1")
		x2=minetest.env:get_meta(pos1):get_int("x2")
		y1=minetest.env:get_meta(pos1):get_int("y1")
		y2=minetest.env:get_meta(pos1):get_int("y2")
		z2=minetest.env:get_meta(pos1):get_int("z2")
		platform=minetest.env:get_meta(pos1):get_int("platform")
		rule=make_post_rule_number(x1,x2,y1,y2,z1,z2,platform)
		hacky_swap_posts(pos1,"technic:concrete_post"..rule)
		meta=minetest.env:get_meta(pos1)
		meta:set_int("z1",z1)
		tempz2=mode
		end
		pos1.z=pos1.z+1
		if mode==1 then 
			meta=minetest.env:get_meta(pos)
			meta:set_int("x1",tempx1)
			meta:set_int("x2",tempx2)
			meta:set_int("y1",tempy1)
			meta:set_int("y2",tempy2)
			meta:set_int("z1",tempz1)
			meta:set_int("z2",tempz2)
			rule=make_post_rule_number(tempx1,tempx2,tempy1,tempy2,tempz1,tempz2,0)
			hacky_swap_posts(pos,"technic:concrete_post"..rule)
		end
end	

function make_post_rule_number (x1,x2,y1,y2,z1,z2,platform)
local tempy=y1+y2
local tempx=x1+x2
local tempz=z1+z2
if platform==0 then 
	if tempy==0 and tempx==0 and tempz==0 then return 0 end
	if x1==1 and x2==1 and tempz==0 and tempy==0 then return 32 end
	if z1==1 and z2==1 and tempx==0 and tempy==0 then return 33 end
	return z2+z1*2+x2*4+x1*8
else
	if tempy==0 and tempx==0 and tempz==0 then return 16 end
	if x1==1 and x2==1 and tempz==0 and tempy==0 then return 34 end
	if z1==1 and z2==1 and tempx==0 and tempy==0 then return 35 end
	return z2+z1*2+x2*4+x1*8+16
end
end

function hacky_swap_posts(pos,name)
	local node = minetest.env:get_node(pos)
		if node.name == "technic:concrete" then
		return nil
	end
	local meta = minetest.env:get_meta(pos)
	local meta0 = meta:to_table()
	node.name = name
	local meta0 = meta:to_table()
	minetest.env:set_node(pos,node)
	meta = minetest.env:get_meta(pos)
	meta:from_table(meta0)
	return 1
end
