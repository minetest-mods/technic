-- register MV machines here
technic.MV_machines = {}
--local MV_machines = {}
local MV_machines = technic.MV_machines
function register_MV_machine(string1,string2)
   technic.MV_machines[string1] = string2
end

minetest.register_craft(
   {
      output = 'technic:mv_battery_box 1',
      recipe = {
	 {'technic:battery_box', 'technic:battery_box', 'technic:battery_box'},
	 {'technic:battery_box', 'technic:mv_transformer', 'technic:battery_box'},
	 {'', 'technic:mv_cable', ''},
      }
   })

mv_battery_box_formspec =
   "invsize[8,9;]"..
   "image[1,1;1,2;technic_power_meter_bg.png]"..
   "list[current_name;src;3,1;1,1;]"..
   "image[4,1;1,1;technic_battery_reload.png]"..
   "list[current_name;dst;5,1;1,1;]"..
   "label[0,0;MV_Battery box]"..
   "label[3,0;Charge]"..
   "label[5,0;Discharge]"..
   "label[1,3;Power level]"..
   "list[current_player;main;0,5;8,4;]"

minetest.register_node(
   "technic:mv_battery_box", {
      description = "MV Battery Box",
      tiles  = {"technic_mv_battery_box_top.png", "technic_mv_battery_box_bottom.png", "technic_mv_battery_box_side0.png",
	        "technic_mv_battery_box_side0.png", "technic_mv_battery_box_side0.png", "technic_mv_battery_box_side0.png"},
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      sounds = default.node_sound_wood_defaults(),
      drop   = "technic:mv_battery_box",
      on_construct = function(pos)
			if pos==nil then return end
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			meta:set_string("infotext", "MV Battery box")
			meta:set_float("technic_mv_power_machine", 1)
			meta:set_string("formspec", battery_box_formspec)
			meta:set_float("internal_EU_buffer", 0)
			meta:set_float("internal_EU_buffer_size", 300000)
			inv:set_size("src", 1)
			inv:set_size("dst", 1)
		     end,
      can_dig = function(pos,player)
		   if pos==nil then return end
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("dst") then
		      return false
		   elseif not inv:is_empty("src") then
		      return false
		   end
		   return true
		end
   })


for i=1,8,1 do
   minetest.register_node(
      "technic:mv_battery_box"..i, {
	 description = "MV Battery Box",
	 tiles  = {"technic_mv_battery_box_top.png", "technic_mv_battery_box_bottom.png", "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png",
		   "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png", "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png", "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png"},
	 groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	 sounds = default.node_sound_wood_defaults(),
	 drop   = "technic:mv_battery_box",
	 on_construct = function(pos)
			   if pos==nil then return end
			   local meta = minetest.env:get_meta(pos);
			   local inv = meta:get_inventory()
			   meta:set_string("infotext", "MV Battery box")
			   meta:set_float("technic_mv_power_machine", 1)
			   meta:set_string("formspec", battery_box_formspec)
			   meta:set_float("internal_EU_buffer", 0)
			   meta:set_float("internal_EU_buffer_size", 300000)
			   inv:set_size("src", 1)
			   inv:set_size("dst", 1)
			end,
	 can_dig = function(pos,player)
		      if pos==nil then return end
		      local meta = minetest.env:get_meta(pos);
		      local inv = meta:get_inventory()
		      if not inv:is_empty("dst") then
			 return false
		      elseif not inv:is_empty("src") then
			 return false
		      end
		      return true
		   end
      })
end

minetest.register_abm(
   {nodenames = {"technic:mv_battery_box","technic:mv_battery_box1","technic:mv_battery_box2","technic:mv_battery_box3","technic:mv_battery_box4",
		 "technic:mv_battery_box5","technic:mv_battery_box6","technic:mv_battery_box7","technic:mv_battery_box8"
	      },
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
		local meta       = minetest.env:get_meta(pos)
		local max_charge = 300000 -- Set maximum charge for the device here
		local charge     = meta:get_int("internal_EU_buffer")

		-- Select node textures
		local i = math.ceil((charge/max_charge)*8)
		if i > 8 then i = 8 end
		local j = meta:get_float("last_side_shown")
		if i~=j then
		   if i>0 then hacky_swap_node(pos,"technic:mv_battery_box"..i)
		   elseif i==0 then hacky_swap_node(pos,"technic:mv_battery_box") end
		   meta:set_float("last_side_shown",i)
		end

		--charge registered power tools
		local inv = meta:get_inventory()
		if inv:is_empty("src")==false  then
		   local srcstack = inv:get_stack("src", 1)
		   local src_item=srcstack:to_table()
		   local src_meta=get_item_meta(src_item["metadata"])

		   -- Power tools should really be made into a hash table to avoid linear search. But the list is short so okay...
		   for i=1,registered_power_tools_count,1 do
		      if power_tools[i].tool_name==src_item["name"] then
			 -- What is this code doing? Setting tool properties if not set already????
			 src_meta=get_item_meta(src_item["metadata"])
			 if src_meta==nil then
			    src_meta={}
			    src_meta["technic_power_tool"]=true
			    src_meta["charge"]=0
			 else
			    if src_meta["technic_power_tool"]==nil then
			       src_meta["technic_power_tool"]=true
			       src_meta["charge"]=0
			    end
			 end
			 -- Do the charging
			 local item_max_charge = power_tools[i].max_charge
			 local load1           = src_meta["charge"]
			 local load_step       = 4000 -- how much to charge per tick
			 if load1<item_max_charge and charge>0 then
			    if charge-load_step<0 then load_step=charge end
			    if load1+load_step>item_max_charge then load_step=item_max_charge-load1 end
			    load1=load1+load_step
			    charge=charge-load_step
			    set_RE_wear(src_item,load1,item_max_charge)
			    src_meta["charge"]   = load1
			    src_item["metadata"] = set_item_meta(src_meta)
			    inv:set_stack("src", 1, src_item)
			 end
			 meta:set_int("internal_EU_buffer",charge)
			 break
		      end
		   end
		end

		-- discharging registered power tools
		if inv:is_empty("dst") == false then
		   srcstack = inv:get_stack("dst", 1)
		   src_item=srcstack:to_table()
		   local src_meta=get_item_meta(src_item["metadata"])
		   local item_max_charge=nil
		   for i=1,registered_power_tools_count,1 do
		      if power_tools[i].tool_name==src_item["name"] then
			 src_meta=get_item_meta(src_item["metadata"])
			 if src_meta==nil then
			    src_meta={}
			    src_meta["technic_power_tool"]=true
			    src_meta["charge"]=0
			 else
			    if src_meta["technic_power_tool"]==nil then
			       src_meta["technic_power_tool"]=true
			       src_meta["charge"]=0
			    end
			 end
			 local item_max_charge = power_tools[i].max_charge
			 local load1           = src_meta["charge"]
			 local load_step       = 4000 -- how much to discharge per tick
			 if load1>0 and charge<max_charge then
			    if charge+load_step>max_charge then load_step=max_charge-charge end
			    if load1-load_step<0 then load_step=load1 end
			    load1=load1-load_step
			    charge=charge+load_step
			    set_RE_wear(src_item,load1,item_max_charge)
			    src_meta["charge"]=load1
			    src_item["metadata"]=set_item_meta(src_meta)
			    inv:set_stack("dst", 1, src_item)
			 end
			 meta:set_int("internal_EU_buffer",charge)
			 break
		      end
		   end
		end

		local load = math.floor((charge/300000) * 100)
		meta:set_string("formspec",
				mv_battery_box_formspec..
				   "image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
				   (load)..":technic_power_meter_fg.png]"
			     )

		-- Next index the surrounding network the get the producers and receivers on the power grid
		local pos1 = {}
		pos1.y = pos.y-1
		pos1.x = pos.x
		pos1.z = pos.z

		meta1 = minetest.env:get_meta(pos1)
		if meta1:get_float("mv_cablelike")~=1 then return end

		local MV_nodes = {}
		local PR_nodes = {}
		local RE_nodes = {}
		local BA_nodes = {}

		MV_nodes[1]   = {}
		MV_nodes[1].x = pos1.x
		MV_nodes[1].y = pos1.y
		MV_nodes[1].z = pos1.z

		local table_index=1
		repeat
		   check_MV_node(PR_nodes,RE_nodes,BA_nodes,MV_nodes,table_index)
		   table_index=table_index+1
		   if MV_nodes[table_index]==nil then break end
		until false

		-- Get power from all connected producers
		local pr_pos
                for _,pr_pos in ipairs(PR_nodes) do
		   local meta1              = minetest.env:get_meta(pr_pos)
		   local internal_EU_buffer = meta1:get_float("internal_EU_buffer")
		   local charge_to_take     = 1000
		   if charge<max_charge then
		      if internal_EU_buffer-charge_to_take<=0 then
			 charge_to_take=internal_EU_buffer
		      end
		      if charge_to_take>0 then
			 charge=charge+charge_to_take
			 internal_EU_buffer=internal_EU_buffer-charge_to_take
			 meta1:set_float("internal_EU_buffer",internal_EU_buffer)
		      end
		   end
		end

		if charge>max_charge then charge=max_charge end

		-- Provide power to all connected receivers
		local re_pos
                for _,re_pos in ipairs(RE_nodes) do
		   local meta1                   = minetest.env:get_meta(re_pos)
		   local internal_EU_buffer      = meta1:get_float("internal_EU_buffer")
		   local internal_EU_buffer_size = meta1:get_float("internal_EU_buffer_size")
		   local charge_to_give          = math.min(1000, charge/table.getn(RE_nodes))
		   if internal_EU_buffer+charge_to_give>internal_EU_buffer_size then
		      charge_to_give=internal_EU_buffer_size-internal_EU_buffer
		   end
		   if charge-charge_to_give<0 then charge_to_give=charge end

		   internal_EU_buffer=internal_EU_buffer+charge_to_give
		   meta1:set_float("internal_EU_buffer",internal_EU_buffer)
		   charge=charge-charge_to_give;
		end
		charge=math.floor(charge)
		meta:set_string("infotext", "MV Battery box: "..charge.."/"..max_charge);
		meta:set_int("internal_EU_buffer",charge)
	     end
 })

-- Register as a battery type
-- Battery type machines function as power reservoirs and can both receive and give back power
register_MV_machine("technic:mv_battery_box","BA")
for i=1,8,1 do
   register_MV_machine("technic:mv_battery_box"..i,"BA")
end

function add_new_MVcable_node (MV_nodes,pos1)
   if MV_nodes == nil then return true end
   local i=1
   repeat
      if MV_nodes[i]==nil then break end
      if pos1.x==MV_nodes[i].x and pos1.y==MV_nodes[i].y and pos1.z==MV_nodes[i].z then return false end
      i=i+1
   until false
   MV_nodes[i]={}
   MV_nodes[i].x=pos1.x
   MV_nodes[i].y=pos1.y
   MV_nodes[i].z=pos1.z
   return true
end

function check_MV_node(PR_nodes,RE_nodes,BA_nodes,MV_nodes,i)
   local pos1={}
   pos1.x=MV_nodes[i].x
   pos1.y=MV_nodes[i].y
   pos1.z=MV_nodes[i].z

   pos1.x=pos1.x+1
   check_MV_node_subp(PR_nodes,RE_nodes,BA_nodes,MV_nodes,pos1)
   pos1.x=pos1.x-2
   check_MV_node_subp(PR_nodes,RE_nodes,BA_nodes,MV_nodes,pos1)
   pos1.x=pos1.x+1

   pos1.y=pos1.y+1
   check_MV_node_subp(PR_nodes,RE_nodes,BA_nodes,MV_nodes,pos1)
   pos1.y=pos1.y-2
   check_MV_node_subp(PR_nodes,RE_nodes,BA_nodes,MV_nodes,pos1)
   pos1.y=pos1.y+1

   pos1.z=pos1.z+1
   check_MV_node_subp(PR_nodes,RE_nodes,BA_nodes,MV_nodes,pos1)
   pos1.z=pos1.z-2
   check_MV_node_subp(PR_nodes,RE_nodes,BA_nodes,MV_nodes,pos1)
   pos1.z=pos1.z+1
end

function check_MV_node_subp (PR_nodes,RE_nodes,BA_nodes,MV_nodes,pos1)
   local meta = minetest.env:get_meta(pos1)
   local name = minetest.env:get_node(pos1).name
   if meta:get_float("mv_cablelike")==1 then
      add_new_MVcable_node(MV_nodes,pos1)
   elseif MV_machines[name] then
      --print(name.." is a "..MV_machines[name])
      if     MV_machines[name] == "PR" then
	 add_new_MVcable_node(PR_nodes,pos1)
      elseif MV_machines[name] == "RE" then
	 add_new_MVcable_node(RE_nodes,pos1)
      elseif MV_machines[name] == "BA" then
	 add_new_MVcable_node(BA_nodes,pos1)
      end
   end
end
