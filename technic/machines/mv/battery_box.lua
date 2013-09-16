-- MV Battery box
minetest.register_craft(
   {output = 'technic:mv_battery_box 1',
    recipe = {
       {'technic:battery_box', 'technic:battery_box', 'technic:battery_box'},
       {'technic:battery_box', 'technic:mv_transformer', 'technic:battery_box'},
       {'technic:stainless_steel_ingot', 'technic:mv_cable', 'technic:stainless_steel_ingot'},
    }
 })

local battery_box_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;dst;5,1;1,1;]"..
	"label[0,0;MV Battery Box]"..
	"label[3,0;Charge]"..
	"label[5,0;Discharge]"..
	"label[1,3;Power level]"..
	"list[current_player;main;0,5;8,4;]"..
	"background[-0.19,-0.25;8.4,9.75;ui_form_bg.png]"..
	"background[0,0;8,4;ui_mv_battery_box.png]"..
	"background[0,5;8,4;ui_main_inventory.png]"

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
			meta:set_int("MV_EU_demand", 0) -- How much can this node charge
			meta:set_int("MV_EU_supply", 0) -- How much can this node discharge
			meta:set_int("MV_EU_input",  0) -- How much power is this machine getting.
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
      "technic:mv_battery_box"..i,
      {
	 description = "MV Battery Box",
	 tiles  = {"technic_mv_battery_box_top.png", "technic_mv_battery_box_bottom.png", "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png",
		   "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png", "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png", "technic_mv_battery_box_side0.png^technic_power_meter"..i..".png"},
	 groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	 sounds = default.node_sound_wood_defaults(),
	 drop   = "technic:mv_battery_box",
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

minetest.register_abm(
   {
      nodenames = {"technic:mv_battery_box","technic:mv_battery_box1","technic:mv_battery_box2","technic:mv_battery_box3","technic:mv_battery_box4",
		   "technic:mv_battery_box5","technic:mv_battery_box6","technic:mv_battery_box7","technic:mv_battery_box8"
		},
      interval = 1,
      chance   = 1,
      action = function(pos, node, active_object_count, active_object_count_wider)
		local meta               = minetest.env:get_meta(pos)
		local max_charge         = 300000 -- Set maximum charge for the device here
		local max_charge_rate    = 2000   -- Set maximum rate of charging (4000)
		local max_discharge_rate = 3000   -- Set maximum rate of discharging
		local eu_input           = meta:get_int("MV_EU_input")
		local current_charge     = meta:get_int("internal_EU_charge") -- Battery charge right now

		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "MV")

		-- Charge/discharge the battery with the input EUs
		if eu_input >=0 then
		   current_charge = math.min(current_charge+eu_input, max_charge)
		else
		   current_charge = math.max(current_charge+eu_input, 0)
		end

		-- Charging/discharging tools here
		current_charge = charge_tools(meta, current_charge, 4000)
		current_charge = discharge_tools(meta, current_charge, max_charge, 4000)

		-- Set a demand (we allow batteries to charge on less than the demand though)
		meta:set_int("MV_EU_demand", math.min(max_charge_rate, max_charge-current_charge))

		-- Set how much we can supply
		meta:set_int("MV_EU_supply", math.min(max_discharge_rate, current_charge))

		meta:set_int("internal_EU_charge", current_charge)
		--dprint("BA: input:"..eu_input.." supply="..meta:get_int("MV_EU_supply").." demand="..meta:get_int("MV_EU_demand").." current:"..current_charge)

		-- Select node textures
		local i=math.ceil((current_charge/max_charge)*8)
		if i > 8 then i = 8 end
		local j = meta:get_float("last_side_shown")
		if i~=j then
		   if i>0 then hacky_swap_node(pos,"technic:mv_battery_box"..i)
		   elseif i==0 then hacky_swap_node(pos,"technic:mv_battery_box") end
		   meta:set_float("last_side_shown",i)
		end

		local load = math.floor(current_charge/max_charge * 100)
		meta:set_string("formspec",
				battery_box_formspec..
				   "image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
				   (load)..":technic_power_meter_fg.png]"
			     )

		if eu_input == 0 then
		   meta:set_string("infotext", "MV Battery box: "..current_charge.."/"..max_charge.." (idle)")
		else
		   meta:set_string("infotext", "MV Battery box: "..current_charge.."/"..max_charge)
		end
	     end
   })

-- Register as a battery type
-- Battery type machines function as power reservoirs and can both receive and give back power
technic.register_MV_machine("technic:mv_battery_box","BA")
for i=1,8,1 do
   technic.register_MV_machine("technic:mv_battery_box"..i,"BA")
end

