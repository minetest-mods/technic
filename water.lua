minetest.register_alias("battery", "technic:battery")
minetest.register_alias("battery_box", "technic:battery_box")
minetest.register_alias("electric_furnace", "technic:electric_furnace")


minetest.register_craft({
	output = 'technic:battery 1',
	recipe = {
		{'default:wood', 'moreores:copper_ingot', 'default:wood'},
		{'default:wood', 'moreores:tin_ingot', 'default:wood'},
		{'default:wood', 'moreores:copper_ingot', 'default:wood'},
	}
}) 

minetest.register_craft({
	output = 'technic:battery_box 1',
	recipe = {
		{'technic:battery', 'default:wood', 'technic:battery'},
		{'technic:battery', 'moreores:copper_ingot', 'technic:battery'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
}) 

minetest.register_craft({
	output = 'technic:electric_furnace',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', '', 'default:brick'},
		{'default:steel_ingot', 'moreores:copper_ingot', 'default:steel_ingot'},
	}
})


--minetest.register_craftitem("technic:battery", {
--	description = "Recharcheable battery",
--	inventory_image = "technic_battery.png",
--	stack_max = 1,
--}) 

minetest.register_tool("technic:battery",
{description = "RE Battery",
inventory_image = "technic_battery.png",
energy_charge = 0,
tool_capabilities = {max_drop_level=0, groupcaps={fleshy={times={}, uses=10000, maxlevel=0}}}}) 

minetest.register_craftitem("technic:battery_box", {
	description = "Battery box",
	stack_max = 99,
}) 



battery_box_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"image[4,1;1,1;technic_battery_reload.png]"..
	"list[current_name;dst;5,1;1,1;]"..
	"label[0,0;Battery box]"..
	"label[3,0;Charge]"..
	"label[5,0;Discharge]"..
	"label[1,3;Power level]"..
	"list[current_player;main;0,5;8,4;]"

minetest.register_node("technic:battery_box", {
	description = "Battery box",
	tiles = {"technic_battery_box_top.png", "technic_battery_box_bottom.png", "technic_battery_box_side.png",
		"technic_battery_box_side.png", "technic_battery_box_side.png", "technic_battery_box_side.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	technic_power_machine=1,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Battery box")
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", battery_box_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 1)
		battery_charge = 0
		max_charge = 60000
		end,	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
})

electric_furnace_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"label[0,0;Electric Furnace]"..
	"label[1,3;Power level]"
	
minetest.register_node("technic:electric_furnace", {
	description = "Electric furnace",
	tiles = {"technic_electric_furnace_top.png", "technic_electric_furnace_bottom.png", "technic_electric_furnace_side.png",
		"technic_electric_furnace_side.png", "technic_electric_furnace_side.png", "technic_electric_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	technic_power_machine=1,
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", electric_furnace_formspec)
		meta:set_string("infotext", "Electric furnace")
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		local EU_used  = 0
		local furnace_is_cookin = 0
		local cooked = nil
		meta:set_float("internal_EU_buffer",0)
		meta:set_float("internal_EU_buffer_size",2000)

	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
})

minetest.register_node("technic:electric_furnace_active", {
	description = "Electric Furnace",
	tiles = {"technic_electric_furnace_top.png", "technic_electric_furnace_bottom.png", "technic_electric_furnace_side.png",
		"technic_electric_furnace_side.png", "technic_electric_furnace_side.png", "technic_electric_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "technic:electric_furnace",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	technic_power_machine=1,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_string("formspec", electric_furnace_formspec)
		meta:set_string("infotext", "Electric furnace");
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		local EU_used  = 0
		local furnace_is_cookin = 0
		local cooked = nil
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"technic:electric_furnace","technic:electric_furnace_active"},
	interval = 1,
	chance = 1,
	
	action = function(pos, node, active_object_count, active_object_count_wider)

		local meta = minetest.env:get_meta(pos)
		internal_EU_buffer=meta:get_float("internal_EU_buffer")
		internal_EU_buffer_size=meta:get_float("internal_EU_buffer")
		local load = math.floor(internal_EU_buffer/2000 * 100)
		meta:set_string("formspec",
				"invsize[8,9;]"..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]"..
				"list[current_name;src;3,1;1,1;]"..
				"list[current_name;dst;5,1;2,2;]"..
				"list[current_player;main;0,5;8,4;]"..
				"label[0,0;Electric Furnace]"..
				"label[1,3;Power level]")

		local inv = meta:get_inventory()
		
		local furnace_is_cookin = meta:get_float("furnace_is_cookin")
		
		
		local srclist = inv:get_list("src")
		local cooked=nil 

		if srclist then
		 cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		end
		
		
		if (furnace_is_cookin == 1) then
			if internal_EU_buffer>=150 then
			internal_EU_buffer=internal_EU_buffer-150;
			meta:set_float("internal_EU_buffer",internal_EU_buffer)
			meta:set_float("src_time", meta:get_float("src_time") + 3)
			if cooked and cooked.item and meta:get_float("src_time") >= cooked.time then
				-- check if there's room for output in "dst" list
				if inv:room_for_item("dst",cooked.item) then
					-- Put result in "dst" list
					inv:add_item("dst", cooked.item)
					-- take stuff from "src" list
					srcstack = inv:get_stack("src", 1)
					srcstack:take_item()
					inv:set_stack("src", 1, srcstack)
				else
					print("Furnace inventory full!")
				end
				meta:set_string("src_time", 0)
			end
			end		
		end
		
		

		
		if srclist then
			cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
			if cooked.time>0 then 
			hacky_swap_node(pos,"technic:electric_furnace_active")
			meta:set_string("infotext","Furnace active")
			meta:set_string("furnace_is_cookin",1)
		--	meta:set_string("formspec", electric_furnace_formspec)
			meta:set_string("src_time", 0)
			return
			end

		end
	
				hacky_swap_node(pos,"technic:electric_furnace")
				meta:set_string("infotext","Furnace inactive")
				meta:set_string("furnace_is_cookin",0)
		--		meta:set_string("formspec", electric_furnace_formspec)
				meta:set_string("src_time", 0)
		
	
end,		
})




function take_EU_from_net(pos, EU_to_take)
	local meta = minetest.env:get_meta(pos)
	local pos1=pos
	pos1.z=pos1.z +1
	local meta1 = minetest.env:get_meta(pos1)
	charge=meta1:get_float("battery_charge")
	charge=charge - EU_to_take
	meta1:set_float("battery_charge",charge)
end

	LV_nodes_visited = {}

function get_RE_item_load (load1,max_load)
if load1==0 then load1=65535 end
local temp = 65536-load1
temp= temp/65535*max_load
return math.floor(temp + 0.5)
end

function set_RE_item_load (load1,max_load)
if load1 == 0 then return 65535 end
local temp=load1/max_load*65535
temp=65536-temp
return math.floor(temp)
end

minetest.register_abm({
	nodenames = {"technic:battery_box"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
	local meta = minetest.env:get_meta(pos)
	charge= meta:get_float("battery_charge")
	max_charge= 60000
		
		local inv = meta:get_inventory()
		if inv:is_empty("src")==false  then 
		srcstack = inv:get_stack("src", 1)
		src_item=srcstack:to_table()
		if src_item["name"]== "technic:battery" then
		local load1=tonumber((src_item["wear"])) 
		load1=get_RE_item_load(load1,10000)
		load_step=1000
		if load1<10000 and charge>0 then 
		 if charge-load_step<0 then load_step=charge end
		 if load1+load_step>10000 then load_step=10000-load1 end
		load1=load1+load_step
		charge=charge-load_step
	
		load1=set_RE_item_load(load1,10000)
		src_item["wear"]=tostring(load1)
		inv:set_stack("src", 1, src_item)
		end		
		end
		end
		meta:set_float("battery_charge",charge)
		
	
		if inv:is_empty("src")==false  then 
		srcstack = inv:get_stack("src", 1)
		src_item=srcstack:to_table()
		if src_item["name"]== "technic:laser_mk1" then
		local load1=tonumber((src_item["wear"])) 
		load1=get_RE_item_load(load1,40000)
		load_step=1000
		if load1<40000 and charge>0 then 
		 if charge-load_step<0 then load_step=charge end
		 if load1+load_step>40000 then load_step=40000-load1 end
		load1=load1+load_step
		charge=charge-load_step
		load1=set_RE_item_load(load1,40000)
		src_item["wear"]=tostring(load1)
		inv:set_stack("src", 1, src_item)
		end		
		end
		end
		meta:set_float("battery_charge",charge)


		if inv:is_empty("dst") == false then 
		srcstack = inv:get_stack("dst", 1)
		src_item=srcstack:to_table()
		if src_item["name"]== "technic:battery" then
		local load1=tonumber((src_item["wear"])) 
		load1=get_RE_item_load(load1,10000)
		load_step=1000
		if load1>0 and charge<max_charge then 
			 if charge+load_step>max_charge then load_step=max_charge-charge end
		  	 if load1-load_step<0 then load_step=load1 end
		load1=load1-load_step
		charge=charge+load_step
	
		load1=set_RE_item_load(load1,10000)
		src_item["wear"]=tostring(load1)
		inv:set_stack("dst", 1, src_item)
		end		
		end
		end
		

	meta:set_float("battery_charge",charge)
	meta:set_string("infotext", "Battery box: "..charge.."/"..max_charge);

	local load = math.floor(charge/60000 * 100)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]"..
				"list[current_name;src;3,1;1,1;]"..
				"image[4,1;1,1;technic_battery_reload.png]"..
				"list[current_name;dst;5,1;1,1;]"..
				"label[0,0;Battery box]"..
				"label[3,0;Charge]"..
				"label[5,0;Discharge]"..
				"label[1,3;Power level]"..
				"list[current_player;main;0,5;8,4;]")
		
	local pos1={}

	pos1.y=pos.y-1
	pos1.x=pos.x
	pos1.z=pos.z


	meta1 = minetest.env:get_meta(pos1)
	if meta1:get_float("cablelike")~=1 then return end

		local LV_nodes = {}
		local PR_nodes = {}
		local RE_nodes = {}

	 	LV_nodes[1]={}
	 	LV_nodes[1].x=pos1.x
		LV_nodes[1].y=pos1.y
		LV_nodes[1].z=pos1.z
		LV_nodes[1].visited=false


table_index=1
	repeat
	check_LV_node (PR_nodes,RE_nodes,LV_nodes,table_index)
	table_index=table_index+1
	if LV_nodes[table_index]==nil then break end
	until false


local pos1={}
i=1
	repeat
	if PR_nodes[i]==nil then break end
		pos1.x=PR_nodes[i].x
		pos1.y=PR_nodes[i].y
		pos1.z=PR_nodes[i].z
	local meta1 = minetest.env:get_meta(pos1)
	local active=meta1:get_float("active")
	if active==1 then charge=charge+80 end
	i=i+1
	until false

if charge>max_charge then charge=max_charge end

i=1
	repeat
	if RE_nodes[i]==nil then break end
		pos1.x=RE_nodes[i].x         -- loading all conected machines buffers
		pos1.y=RE_nodes[i].y
		pos1.z=RE_nodes[i].z
	local meta1 = minetest.env:get_meta(pos1)
	local internal_EU_buffer=meta1:get_float("internal_EU_buffer")
	local internal_EU_buffer_size=meta1:get_float("internal_EU_buffer_size")

	local charge_to_give=200
	if internal_EU_buffer+charge_to_give>internal_EU_buffer_size then
		charge_to_give=internal_EU_buffer_size-internal_EU_buffer
	end
	if charge-charge_to_give<0 then charge_to_give=charge end

	internal_EU_buffer=internal_EU_buffer+charge_to_give
	meta1:set_float("internal_EU_buffer",internal_EU_buffer)
	charge=charge-charge_to_give;
	
	i=i+1
	until false
	
	meta:set_float("battery_charge",charge)
	meta:set_string("infotext", "Battery box: "..charge.."/"..max_charge);


end
})

function add_new_cable_node (LV_nodes,pos1)
local i=1
	repeat
		if LV_nodes[i]==nil then break end
		if pos1.x==LV_nodes[i].x and pos1.y==LV_nodes[i].y and pos1.z==LV_nodes[i].z then return false end
		i=i+1
	until false
LV_nodes[i]={}
LV_nodes[i].x=pos1.x
LV_nodes[i].y=pos1.y
LV_nodes[i].z=pos1.z
LV_nodes[i].visited=false
return true
end

function check_LV_node (PR_nodes,RE_nodes,LV_nodes,i)
		local pos1={}
		pos1.x=LV_nodes[i].x
		pos1.y=LV_nodes[i].y
		pos1.z=LV_nodes[i].z
		LV_nodes[i].visited=true
		new_node_added=false
	
		pos1.x=pos1.x+1
		check_LV_node_subp (PR_nodes,RE_nodes,LV_nodes,pos1)
		pos1.x=pos1.x-2
		check_LV_node_subp (PR_nodes,RE_nodes,LV_nodes,pos1)
		pos1.x=pos1.x+1
		
		pos1.y=pos1.y+1
		check_LV_node_subp (PR_nodes,RE_nodes,LV_nodes,pos1)
		pos1.y=pos1.y-2
		check_LV_node_subp (PR_nodes,RE_nodes,LV_nodes,pos1)
		pos1.y=pos1.y+1

		pos1.z=pos1.z+1
		check_LV_node_subp (PR_nodes,RE_nodes,LV_nodes,pos1)
		pos1.z=pos1.z-2
		check_LV_node_subp (PR_nodes,RE_nodes,LV_nodes,pos1)
		pos1.z=pos1.z+1
return new_node_added
end

function check_LV_node_subp (PR_nodes,RE_nodes,LV_nodes,pos1)
meta = minetest.env:get_meta(pos1)
if meta:get_float("cablelike")==1 then new_node_added=add_new_cable_node(LV_nodes,pos1) end
if minetest.env:get_node(pos1).name == "technic:solar_panel" then 	new_node_added=add_new_cable_node(PR_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:electric_furnace" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:electric_furnace_active" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:tool_workshop" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:music_player" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:grinder" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
end
		

function get_connected_charge (charge,pos1)
	local charge1=0
	local meta={}
	if minetest.env:get_node(pos1).name == "technic:battery_box" then
	print ("found batbox")
	meta = minetest.env:get_meta(pos1)
	return meta:get_float("cable_OUT") 
	end

	if minetest.env:get_node(pos1).name == "technic:lv_cable" then
	meta = minetest.env:get_meta(pos1)
	charge1=meta:get_float("cable_OUT")
		if charge1>charge then
		charge=charge1
		end
	end
return charge
end

minetest.register_node("technic:solar_panel", {
	tiles = {"technic_solar_panel_top.png", "technic_solar_panel_side.png", "technic_solar_panel_side.png",
		"technic_solar_panel_side.png", "technic_solar_panel_side.png", "technic_solar_panel_side.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
    	description="Solar Panel",
	active = false,
	technic_power_machine=1,
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = true,	
	node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_string("infotext", "Solar Panel")
		meta:set_float("active", false)
	end,
})

minetest.register_craft({
	output = 'technic:solar_panel 1',
	recipe = {
		{'default:sand', 'default:sand','default:sand'},
		{'default:sand', 'moreores:copper_ingot','default:sand'},
		{'default:sand', 'default:sand','default:sand'},

	}
})

minetest.register_abm(
	{nodenames = {"technic:solar_panel"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		
		local pos1={}
		pos1.y=pos.y+1
		pos1.x=pos.x
		pos1.z=pos.z

		local light = minetest.env:get_node_light(pos1, nil)
		local meta = minetest.env:get_meta(pos)
		if light == nil then light = 0 end
		if light >= 12 then
			meta:set_string("infotext", "Solar Panel is active ")
			meta:set_float("active",1)
		else
			meta:set_string("infotext", "Solar Panel is inactive");
			meta:set_float("active",0)
		end
	end,
}) 