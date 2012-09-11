power_tools ={}

registered_power_tools_count=1

function register_power_tool (string1,max_charge)
power_tools[registered_power_tools_count]={}
power_tools[registered_power_tools_count].tool_name=string1
power_tools[registered_power_tools_count].max_charge=max_charge
registered_power_tools_count=registered_power_tools_count+1
end

register_power_tool ("technic:mining_drill",60000)
register_power_tool ("technic:laser_mk1",40000)
register_power_tool ("technic:battery",10000)

minetest.register_alias("battery", "technic:battery")
minetest.register_alias("battery_box", "technic:battery_box")

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
	local item_max_charge = nil
	local counter=registered_power_tools_count-1
	for i=1, counter,1 do
		if power_tools[i].tool_name==src_item["name"] then
		item_max_charge=power_tools[i].max_charge	
		end
		end
	if item_max_charge then
		local load1=tonumber((src_item["wear"])) 
		load1=get_RE_item_load(load1,item_max_charge)
		load_step=1000
		if load1<item_max_charge and charge>0 then 
		 if charge-load_step<0 then load_step=charge end
		 if load1+load_step>item_max_charge then load_step=item_max_charge-load1 end
		load1=load1+load_step
		charge=charge-load_step
	
		load1=set_RE_item_load(load1,item_max_charge)
		src_item["wear"]=tostring(load1)
		inv:set_stack("src", 1, src_item)
		end
		meta:set_float("battery_charge",charge)
	end	
	end
	
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
	if PR_nodes[i]==nil then break end -- gettin power from all connected producers
		pos1.x=PR_nodes[i].x
		pos1.y=PR_nodes[i].y
		pos1.z=PR_nodes[i].z
	local meta1 = minetest.env:get_meta(pos1)
	local internal_EU_buffer=meta1:get_float("internal_EU_buffer")
	if charge<max_charge then 
	charge_to_take=200	
	if internal_EU_buffer-charge_to_take<=0 then
		charge_to_take=internal_EU_buffer
	end
	if charge_to_take>0 then 
	charge=charge+charge_to_take 
	internal_EU_buffer=internal_EU_buffer-charge_to_take
	meta1:set_float("internal_EU_buffer",internal_EU_buffer)
	end
	end
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
if minetest.env:get_node(pos1).name == "technic:generator" then 	new_node_added=add_new_cable_node(PR_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:generator_active" then 	new_node_added=add_new_cable_node(PR_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:geothermal" then 	new_node_added=add_new_cable_node(PR_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:geothermal_active" then 	new_node_added=add_new_cable_node(PR_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:water_mill" then 	new_node_added=add_new_cable_node(PR_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:water_mill_active" then 	new_node_added=add_new_cable_node(PR_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:electric_furnace" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:electric_furnace_active" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:alloy_furnace" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:alloy_furnace_active" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:tool_workshop" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:music_player" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
if minetest.env:get_node(pos1).name == "technic:grinder" then 	new_node_added=add_new_cable_node(RE_nodes,pos1) end		
end
		