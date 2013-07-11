-- HV battery box
minetest.register_craft(
   {output = 'technic:hv_battery_box 1',
    recipe = {
       {'technic:mv_battery_box', 'technic:mv_battery_box', 'technic:mv_battery_box'},
       {'technic:mv_battery_box', 'technic:hv_transformer', 'technic:mv_battery_box'},
       {'', 'technic:hv_cable', ''},
    }
 })

local battery_box_formspec =
   "invsize[8,9;]"..
   "image[1,1;1,2;technic_power_meter_bg.png]"..
   "list[current_name;src;3,1;1,1;]"..
   "image[4,1;1,1;technic_battery_reload.png]"..
   "list[current_name;dst;5,1;1,1;]"..
   "label[0,0;HV Battery Box]"..
   "label[3,0;Charge]"..
   "label[5,0;Discharge]"..
   "label[1,3;Power level]"..
   "list[current_player;main;0,5;8,4;]"

minetest.register_node(
   "technic:hv_battery_box", {
      description = "HV Battery Box",
      tiles = {"technic_hv_battery_box_top.png", "technic_hv_battery_box_bottom.png", "technic_hv_battery_box_side0.png",
	       "technic_hv_battery_box_side0.png", "technic_hv_battery_box_side0.png", "technic_hv_battery_box_side0.png"},
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      sounds = default.node_sound_wood_defaults(),
      drop="technic:hv_battery_box",
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			meta:set_string("infotext", "HV Battery Box")
			meta:set_float("technic_hv_power_machine", 1)
			meta:set_string("formspec", battery_box_formspec)
			meta:set_int("HV_EU_demand", 0) -- How much can this node charge
			meta:set_int("HV_EU_supply", 0) -- How much can this node discharge
			meta:set_int("HV_EU_input",  0) -- How much power is this machine getting.
			meta:set_float("internal_EU_charge", 0)
			inv:set_size("src", 1)
			inv:set_size("dst", 1)
		     end,
      can_dig = function(pos,player)
		   local meta = minetest.env:get_meta(pos);
		   local inv = meta:get_inventory()
		   if not inv:is_empty("src") or not inv:is_empty("dst") then
		      minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		      return false
		   else
		      return true
		   end
		end,
   })

for i=1,8,1 do
   minetest.register_node(
      "technic:hv_battery_box"..i,
      {description = "HV Battery Box",
       tiles = {"technic_hv_battery_box_top.png", "technic_hv_battery_box_bottom.png", "technic_hv_battery_box_side0.png^technic_power_meter"..i..".png",
		"technic_hv_battery_box_side0.png^technic_power_meter"..i..".png", "technic_hv_battery_box_side0.png^technic_power_meter"..i..".png", "technic_hv_battery_box_side0.png^technic_power_meter"..i..".png"},
       groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
       sounds = default.node_sound_wood_defaults(),
       paramtype="light",
       light_source=9,
       drop="technic:hv_battery_box",
       can_dig = function(pos,player)
		    local meta = minetest.env:get_meta(pos);
		    local inv = meta:get_inventory()
		    if not inv:is_empty("src") or not inv:is_empty("dst") then
		       minetest.chat_send_player(player:get_player_name(), "Machine cannot be removed because it is not empty");
		       return false
		    else
		       return true
		    end
		 end,
    })
end

local power_tools = technic.HV_power_tools

local charge_HV_tools = function(meta, charge)
		     --charge registered power tools
		     local inv = meta:get_inventory()
		     if inv:is_empty("src")==false  then
			local srcstack = inv:get_stack("src", 1)
			local src_item=srcstack:to_table()
			local src_meta=get_item_meta(src_item["metadata"])
			
			local toolname = src_item["name"]
			if power_tools[toolname] ~= nil then
			   -- Set meta data for the tool if it didn't do it itself :-(
			   src_meta=get_item_meta(src_item["metadata"])
			   if src_meta==nil then
			      src_meta={}
			      src_meta["technic_hv_power_tool"]=true
			      src_meta["charge"]=0
			   else
			      if src_meta["technic_hv_power_tool"]==nil then
				 src_meta["technic_hv_power_tool"]=true
				 src_meta["charge"]=0
			      end
			   end
			   -- Do the charging
			   local item_max_charge = power_tools[toolname]
			   local load            = src_meta["charge"]
			   local load_step       = 1000 -- how much to charge per tick
			   if load<item_max_charge and charge>0 then
			      if charge-load_step<0 then load_step=charge end
			      if load+load_step>item_max_charge then load_step=item_max_charge-load end
			      load=load+load_step
			      charge=charge-load_step
			      technic.set_RE_wear(src_item,load,item_max_charge)
			      src_meta["charge"]   = load
			      src_item["metadata"] = set_item_meta(src_meta)
			      inv:set_stack("src", 1, src_item)
			   end
			end
		     end
		     return charge -- return the remaining charge in the battery
		  end

local discharge_HV_tools = function(meta, charge, max_charge)
			-- discharging registered power tools
			local inv = meta:get_inventory()
			if inv:is_empty("dst") == false then
			   srcstack = inv:get_stack("dst", 1)
			   src_item=srcstack:to_table()
			   local src_meta=get_item_meta(src_item["metadata"])
			   local toolname = src_item["name"]
			   if power_tools[toolname] ~= nil then
			      -- Set meta data for the tool if it didn't do it itself :-(
			      src_meta=get_item_meta(src_item["metadata"])
			      if src_meta==nil then
				 src_meta={}
				 src_meta["technic_hv_power_tool"]=true
				 src_meta["charge"]=0
			      else
				 if src_meta["technic_hv_power_tool"]==nil then
				    src_meta["technic_hv_power_tool"]=true
				    src_meta["charge"]=0
				 end
			      end
			      -- Do the discharging
			      local item_max_charge = power_tools[toolname]
			      local load            = src_meta["charge"]
			      local load_step       = 4000 -- how much to discharge per tick
			      if load>0 and charge<max_charge then
				 if charge+load_step>max_charge then load_step=max_charge-charge end
				 if load-load_step<0 then load_step=load end
				 load=load-load_step
				 charge=charge+load_step
				 technic.set_RE_wear(src_item,load,item_max_charge)
				 src_meta["charge"]=load
				 src_item["metadata"]=set_item_meta(src_meta)
				 inv:set_stack("dst", 1, src_item)
			      end
			   end
			end
			return charge -- return the remaining charge in the battery
		     end

minetest.register_abm(
   {nodenames = {"technic:hv_battery_box","technic:hv_battery_box1","technic:hv_battery_box2","technic:hv_battery_box3","technic:hv_battery_box4",
		 "technic:hv_battery_box5","technic:hv_battery_box6","technic:hv_battery_box7","technic:hv_battery_box8"
	      },
    interval = 1,
    chance   = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
		local meta               = minetest.env:get_meta(pos)
		local max_charge         = 1500000 -- Set maximum charge for the device here
		local max_charge_rate    = 3000    -- Set maximum rate of charging
		local max_discharge_rate = 5000    -- Set maximum rate of discharging (16000)
		local eu_input           = meta:get_int("HV_EU_input")
		local current_charge     = meta:get_int("internal_EU_charge") -- Battery charge right now

		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "HV")

		-- Charge/discharge the battery with the input EUs
		if eu_input >=0 then
		   current_charge = math.min(current_charge+eu_input, max_charge)
		else
		   current_charge = math.max(current_charge+eu_input, 0)
		end

		-- Charging/discharging tools here
		current_charge = charge_HV_tools(meta, current_charge)
		current_charge = discharge_HV_tools(meta, current_charge, max_charge)

		-- Set a demand (we allow batteries to charge on less than the demand though)
		meta:set_int("HV_EU_demand", math.min(max_charge_rate, max_charge-current_charge))

		-- Set how much we can supply
		meta:set_int("HV_EU_supply", math.min(max_discharge_rate, current_charge))

		meta:set_int("internal_EU_charge", current_charge)
		--dprint("BA: input:"..eu_input.." supply="..meta:get_int("HV_EU_supply").." demand="..meta:get_int("HV_EU_demand").." current:"..current_charge)

		-- Select node textures
		local i=math.ceil((current_charge/max_charge)*8)
		if i > 8 then i = 8 end
		local j = meta:get_float("last_side_shown")
		if i~=j then
		   if i>0 then hacky_swap_node(pos,"technic:hv_battery_box"..i)
		   elseif i==0 then hacky_swap_node(pos,"technic:hv_battery_box") end
		   meta:set_float("last_side_shown",i)
		end

		local load = math.floor(current_charge/max_charge * 100)
		meta:set_string("formspec",
				battery_box_formspec..
				   "image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
				   (load)..":technic_power_meter_fg.png]"
			     )

		if eu_input == 0 then
		   meta:set_string("infotext", "HV Battery box: "..current_charge.."/"..max_charge.." (idle)")
		else
		   meta:set_string("infotext", "HV Battery box: "..current_charge.."/"..max_charge)
		end
	     end
 })

-- Register as a battery type
-- Battery type machines function as power reservoirs and can both receive and give back power
technic.register_HV_machine("technic:hv_battery_box","BA")
for i=1,8,1 do
   technic.register_HV_machine("technic:hv_battery_box"..i,"BA")
end

