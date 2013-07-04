-- The supply converter is a generic device which can convert from
-- LV to MV and back, and HV to MV and back.
-- The machine will not convert from HV directly to LV.
-- The machine is configured by the wiring below and above it.
-- It is prepared for an upgrade slot if this is to be implemented later.
--
-- The conversion factor is a constant and the conversion is a lossy operation.
--
-- It works like this:
--   The top side is setup as the "RE" side, the bottom as the "PR" side.
--   Once the RE side is powered it will deliver power to the other side.
--   Unused power is wasted just like any other producer!
--   
minetest.register_node(
   "technic:supply_converter", {
      description = "Supply Converter",
      tiles  = {"technic_supply_converter_top.png", "technic_supply_converter_bottom.png", "technic_supply_converter_side.png",
		"technic_supply_converter_side.png", "technic_supply_converter_side.png", "technic_supply_converter_side.png"},
      groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
      sounds = default.node_sound_wood_defaults(),
      drawtype = "nodebox",
      paramtype = "light",
      is_ground_content = true,
      node_box = {
	 type = "fixed",
	 fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
      },
      selection_box = {
	 type = "fixed",
	 fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
      },
      on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_float("technic_hv_power_machine", 1)
			meta:set_float("technic_mv_power_machine", 1)
			meta:set_float("technic_power_machine", 1)
			meta:set_string("infotext", "Supply Converter")
			  meta:set_float("active", false)
		       end,
   })

minetest.register_craft({
	output = 'technic:supply_converter 1',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot','technic:stainless_steel_ingot'},
		{'technic:mv_transformer',        'technic:mv_cable',             'technic:lv_transformer'},
		{'technic:mv_cable',              'technic:rubber',               'technic:lv_cable'},
	}
})

minetest.register_abm(
   { nodenames = {"technic:supply_converter"},
     interval   = 1,
     chance     = 1,
     action = function(pos, node, active_object_count, active_object_count_wider)
		 -- Conversion factors (a picture of V*A - loss) Asymmetric.
		 local lv_mv_factor  = 5 -- division (higher is less efficient)
		 local mv_lv_factor  = 4 -- multiplication (higher is more efficient)
		 local mv_hv_factor  = 5 -- division
		 local hv_mv_factor  = 4 -- multiplication
		 local max_lv_demand = 2000 -- The increment size power supply tier. Determines how many are needed
		 local max_mv_demand = 2000 -- -""-
		 local max_hv_demand = 2000 -- -""-

		 -- Machine information
		 local machine_name  = "Supply Converter"
		 local meta          = minetest.env:get_meta(pos)
		 local upgrade       = "" -- Replace with expansion slot later??
		 
		 -- High voltage on top, low at bottom regardless of converter direction
		 local pos_up        = {x=pos.x, y=pos.y+1, z=pos.z}
		 local pos_down      = {x=pos.x, y=pos.y-1, z=pos.z}
		 local meta_up       = minetest.env:get_meta(pos_up)
		 local meta_down     = minetest.env:get_meta(pos_down)
		 local convert_MV_LV = 0
		 local convert_LV_MV = 0
		 local convert_MV_HV = 0
		 local convert_HV_MV = 0
		 -- check cabling
		 if meta_up:get_float("mv_cablelike") == 1 and meta_down:get_float("cablelike") == 1 then
		    convert_MV_LV = 1
		    upgrade = "MV-LV step down"
		 end
		 if meta_up:get_float("cablelike") == 1 and meta_down:get_float("mv_cablelike") == 1 then
		    convert_LV_MV = 1
		    upgrade = "LV-MV step up"
		 end
		 if meta_up:get_float("mv_cablelike") == 1 and meta_down:get_float("hv_cablelike") == 1 then
		    convert_MV_HV = 1
		    upgrade = "MV-HV step up"
		 end
		 if meta_up:get_float("hv_cablelike") == 1 and meta_down:get_float("mv_cablelike") == 1 then
		    convert_HV_MV = 1
		    upgrade = "HV-MV step down"
		 end
		 --print("Cabling:"..convert_MV_LV.."|"..convert_LV_MV.."|"..convert_HV_MV.."|"..convert_MV_HV)

		 if convert_MV_LV == 0 and convert_LV_MV == 0 and convert_HV_MV == 0 and convert_MV_HV == 0 then
		    meta:set_string("infotext", machine_name.." has bad cabling")
		    return
		 end

		 -- The node is programmed with an upgrade slot
		 -- containing a MV-LV step down, LV-MV step up, HV-MV step down or MV-HV step up unit

		 if upgrade == "" then
		    meta:set_string("infotext", machine_name.." has an empty converter slot");
		    technic.unregister_LV_machine("technic:supply_converter")
		    technic.unregister_MV_machine("technic:supply_converter")
		    technic.unregister_HV_machine("technic:supply_converter")
		    meta:set_int("LV_EU_demand", 0)
		    meta:set_int("LV_EU_supply", 0)
		    meta:set_int("LV_EU_input",  0)
		    meta:set_int("MV_EU_demand", 0)
		    meta:set_int("MV_EU_supply", 0)
		    meta:set_int("MV_EU_input",  0)
		    meta:set_int("HV_EU_demand", 0)
		    meta:set_int("HV_EU_supply", 0)
		    meta:set_int("HV_EU_input",  0)
		    return
		 end

		 -- State machine
		 if upgrade == "MV-LV step down" and convert_MV_LV then
		    -- Register machine type
		    technic.register_LV_machine("technic:supply_converter","PR")
		    technic.register_MV_machine("technic:supply_converter","RE")

		    -- Power off automatically if no longer connected to a switching station
		    technic.switching_station_timeout_count(pos, "MV")

		    local eu_input  = meta:get_int("MV_EU_input")
		    if eu_input == 0 then
		       -- Unpowered - go idle
		       --hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Unpowered")
		       meta:set_int("LV_EU_supply", 0)
		       meta:set_int("MV_EU_supply", 0)

		       meta:set_int("LV_EU_demand", 0)
		       meta:set_int("MV_EU_demand", max_mv_demand)
		    else
		       -- MV side has got power to spare
		       meta:set_string("infotext", machine_name.." is active (MV:"..max_mv_demand.."->LV:"..eu_input*mv_lv_factor..")");
		       meta:set_int("LV_EU_supply", eu_input*mv_lv_factor)
		    end
		    ---------------------------------------------------
		 elseif upgrade == "LV-MV step up"   and convert_LV_MV then
		    -- Register machine type
		    technic.register_LV_machine("technic:supply_converter","RE")
		    technic.register_MV_machine("technic:supply_converter","PR")

		    -- Power off automatically if no longer connected to a switching station
		    technic.switching_station_timeout_count(pos, "LV")

		    local eu_input  = meta:get_int("LV_EU_input")
		    if eu_input == 0 then
		       -- Unpowered - go idle
		       --hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Unpowered")
		       meta:set_int("LV_EU_supply", 0)
		       meta:set_int("MV_EU_supply", 0)

		       meta:set_int("LV_EU_demand", max_lv_demand)
		       meta:set_int("MV_EU_demand", 0)
		    else
		       -- LV side has got power to spare
		       meta:set_string("infotext", machine_name.." is active (LV:"..max_lv_demand.."->MV:"..eu_input/lv_mv_factor..")");
		       meta:set_int("MV_EU_supply", eu_input/lv_mv_factor)
		    end
		    ---------------------------------------------------

		 elseif upgrade == "HV-MV step down" and convert_HV_MV then
		    -- Register machine type
		    technic.register_MV_machine("technic:supply_converter","PR")
		    technic.register_HV_machine("technic:supply_converter","RE")

		    -- Power off automatically if no longer connected to a switching station
		    technic.switching_station_timeout_count(pos, "HV")

		    local eu_input  = meta:get_int("HV_EU_input")
		    if eu_input == 0 then
		       -- Unpowered - go idle
		       --hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Unpowered")
		       meta:set_int("MV_EU_supply", 0)
		       meta:set_int("HV_EU_supply", 0)

		       meta:set_int("MV_EU_demand", 0)
		       meta:set_int("HV_EU_demand", max_hv_demand)
		    else
		       -- HV side has got power to spare
		       meta:set_string("infotext", machine_name.." is active (HV:"..max_hv_demand.."->MV:"..eu_input*hv_mv_factor..")");
		       meta:set_int("MV_EU_supply", eu_input*hv_mv_factor)
		    end
		    ---------------------------------------------------
		 elseif upgrade == "MV-HV step up"   and convert_MV_HV then
		    -- Register machine type
		    technic.register_MV_machine("technic:supply_converter","RE")
		    technic.register_HV_machine("technic:supply_converter","PR")

		    -- Power off automatically if no longer connected to a switching station
		    technic.switching_station_timeout_count(pos, "MV")

		    local eu_input  = meta:get_int("MV_EU_input")
		    if eu_input == 0 then
		       -- Unpowered - go idle
		       --hacky_swap_node(pos, machine_node)
		       meta:set_string("infotext", machine_name.." Unpowered")
		       meta:set_int("MV_EU_supply", 0)
		       meta:set_int("HV_EU_supply", 0)

		       meta:set_int("MV_EU_demand", max_mv_demand)
		       meta:set_int("HV_EU_demand", 0)
		    else
		       -- MV side has got power to spare
		       meta:set_string("infotext", machine_name.." is active (MV:"..max_mv_demand.."->HV:"..eu_input/mv_hv_factor..")");
		       meta:set_int("HV_EU_supply", eu_input/mv_hv_factor)
		    end
		    ---------------------------------------------------
		 end
	end,
})
