-- The MV down converter will step down MV EUs to LV EUs
-- If we take the solar panel as calibration then the
-- 1 MVEU = 5 LVEU as we stack 5 LV arrays to get an MV array.
-- The downconverter does of course have a conversion loss.
-- This loses 30% of the power.
-- The converter does not store any energy by itself.
minetest.register_node(
   "technic:down_converter_mv", {
      description = "MV Down Converter",
      tiles  = {"technic_mv_down_converter_top.png", "technic_mv_down_converter_bottom.png", "technic_mv_down_converter_side.png",
		"technic_mv_down_converter_side.png", "technic_mv_down_converter_side.png", "technic_mv_down_converter_side.png"},
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
			meta:set_float("technic_mv_power_machine", 1)
			meta:set_float("technic_power_machine", 1)
			meta:set_float("internal_EU_buffer",0)
			meta:set_float("internal_EU_buffer_size",0)
			meta:set_string("infotext", "MV Down Converter")
			  meta:set_float("active", false)
		       end,
   })

minetest.register_craft({
	output = 'technic:down_converter_mv 1',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot','technic:stainless_steel_ingot'},
		{'technic:mv_transformer',        'technic:mv_cable',             'technic:lv_transformer'},
		{'technic:mv_cable',              'technic:rubber',               'technic:lv_cable'},
	}
})

minetest.register_abm(
	{nodenames = {"technic:down_converter_mv"},
	interval   = 1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		    -- MV->LV conversion factor
		    local mv_lv_factor = 5
		    -- The maximun charge a single converter can handle. Let's set this to
		    -- what 5 MV solar arrays can produce - 30% loss (720*5*0.7)
		    local max_charge = 2520*mv_lv_factor

		    local meta             = minetest.env:get_meta(pos)
		    local meta1            = nil
		    local pos1             = {}
		    local available_charge = 0 -- counted in LV units
		    local used_charge      = 0 -- counted in LV units

		    -- Index all MV nodes connected to the network
		    -- MV cable comes in through the bottom
		    pos1.y = pos.y-1
		    pos1.x = pos.x
		    pos1.z = pos.z
		    meta1  = minetest.env:get_meta(pos1)
		    if meta1:get_float("mv_cablelike")~=1 then return end

		    local MV_nodes    = {} -- MV type
		    local MV_PR_nodes = {} -- MV type
		    local MV_BA_nodes = {} -- MV type

		    MV_nodes[1]         = {}
		    MV_nodes[1].x       = pos1.x
		    MV_nodes[1].y       = pos1.y
		    MV_nodes[1].z       = pos1.z

		    local table_index = 1
		    repeat
		       check_MV_node(MV_PR_nodes,nil,MV_BA_nodes,MV_nodes,table_index)
		       table_index = table_index + 1
		       if MV_nodes[table_index] == nil then break end
		    until false

		    --print("MV_nodes: PR="..table.getn(MV_PR_nodes).." BA="..table.getn(MV_BA_nodes))

		    -- Index all LV nodes connected to the network
		    -- LV cable comes out of the top
		    pos1.y = pos.y+1
		    pos1.x = pos.x
		    pos1.z = pos.z
		    meta1  = minetest.env:get_meta(pos1)
		    if meta1:get_float("cablelike")~=1 then return end

		    local LV_nodes    = {} -- LV type
		    local LV_RE_nodes = {} -- LV type
		    local LV_BA_nodes = {} -- LV type

		    LV_nodes[1]         = {}
		    LV_nodes[1].x       = pos1.x
		    LV_nodes[1].y       = pos1.y
		    LV_nodes[1].z       = pos1.z

		    table_index = 1
		    repeat
		       check_LV_node(nil,LV_RE_nodes,LV_BA_nodes,LV_nodes,table_index)
		       table_index = table_index + 1
		       if LV_nodes[table_index] == nil then break end
		    until false

		    --print("LV_nodes: RE="..table.getn(LV_RE_nodes).." BA="..table.getn(LV_BA_nodes))

		    -- First get available power from all the attached MV suppliers
		    -- Get the supplier internal EU buffer and read the EUs from it
		    -- No update yet!
		    local pos1
-- FIXME: Until further leave the producers out of it and just let the batteries be the hub
--		    for _,pos1 in ipairs(MV_PR_nodes) do
--		       meta1  = minetest.env:get_meta(pos1)
--		       local internal_EU_buffer = meta1:get_float("internal_EU_buffer")
--		       available_charge = available_charge + meta1:get_float("internal_EU_buffer") * mv_lv_factor
--		       -- Limit conversion capacity
--		       if available_charge > max_charge then
--			  available_charge = max_charge
--			  break
--		       end
--		    end
--		    print("Available_charge PR:"..available_charge)

		    for _,pos1 in ipairs(MV_BA_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       local internal_EU_buffer = meta1:get_float("internal_EU_buffer")
		       available_charge = available_charge + meta1:get_float("internal_EU_buffer") * mv_lv_factor
		       -- Limit conversion capacity
		       if available_charge > max_charge then
			  available_charge = max_charge
			  break
		       end
		    end
		    --print("Available_charge PR+BA:"..available_charge)

		    -- Calculate total number of receivers:
		    local LV_receivers = table.getn(LV_RE_nodes)+table.getn(LV_BA_nodes)

		    -- Next supply power to all connected LV machines
		    -- Get the power receiver internal EU buffer and give EUs to it
		    -- Note: for now leave out RE type machines until producers distribute power themselves even without a battery
--		    for _,pos1 in ipairs(LV_RE_nodes) do
--		       local meta1                   = minetest.env:get_meta(pos1)
--		       local internal_EU_buffer      = meta1:get_float("internal_EU_buffer")
--		       local internal_EU_buffer_size = meta1:get_float("internal_EU_buffer_size")
--		       local charge_to_give = math.min(1000, available_charge/LV_receivers) -- power rating limit on the LV wire
--		       -- How much can this unit take?
--		       if internal_EU_buffer+charge_to_give > internal_EU_buffer_size then
--			  charge_to_give=internal_EU_buffer_size-internal_EU_buffer
--		       end
--		       -- If we are emptying the supply take the remainder
--		       if available_charge<used_charge+charge_to_give then charge_to_give=available_charge-used_charge end
--		       -- Update the unit supplied to
--		       internal_EU_buffer = internal_EU_buffer + charge_to_give
--		       meta1:set_float("internal_EU_buffer",internal_EU_buffer)
--		       -- Do the accounting
--		       used_charge = used_charge + charge_to_give
--		       if available_charge == used_charge then break end -- bail out if supply depleted
--		    end
		    --print("used_charge RE:"..used_charge)

		    for _,pos1 in ipairs(LV_BA_nodes) do
		       local meta1 = minetest.env:get_meta(pos1)
		       local internal_EU_buffer      = meta1:get_float("internal_EU_buffer")
		       local internal_EU_buffer_size = meta1:get_float("internal_EU_buffer_size")
		       --print("internal_EU_buffer:"..internal_EU_buffer)
		       --print("internal_EU_buffer_size:"..internal_EU_buffer_size)
		       local charge_to_give = math.min(math.floor(available_charge/LV_receivers), 1000) -- power rating limit on the LV wire
		       --print("charge_to_give:"..charge_to_give)
		       -- How much can this unit take?
		       if internal_EU_buffer+charge_to_give > internal_EU_buffer_size then
			  charge_to_give=internal_EU_buffer_size-internal_EU_buffer
		       end
		       --print("charge_to_give2:"..charge_to_give)
		       -- If we are emptying the supply take the remainder
		       if available_charge<used_charge+charge_to_give then charge_to_give=available_charge-used_charge end
		       -- Update the unit supplied to
		       --print("charge_to_give3:"..charge_to_give)
		       internal_EU_buffer = internal_EU_buffer + charge_to_give
		       --print("internal_EU_buffer:"..internal_EU_buffer)
		       meta1:set_float("internal_EU_buffer",internal_EU_buffer)
		       -- Do the accounting
		       used_charge = used_charge + charge_to_give
		       --print("used_charge:"..used_charge)
		       if available_charge == used_charge then break end -- bail out if supply depleted
		    end
		    --print("used_charge RE+BA:"..used_charge)

		    -- Last update the MV suppliers with the actual demand.
		    -- Get the supplier internal EU buffer and update the EUs from it
		    -- Note: So far PR nodes left out and only BA nodes are updated
		    local MV_BA_size = table.getn(MV_BA_nodes)
		    for _,pos1 in ipairs(MV_BA_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       local internal_EU_buffer = meta1:get_float("internal_EU_buffer")
		       local charge_to_take = math.floor(used_charge/MV_BA_size/mv_lv_factor) -- MV units
		       if internal_EU_buffer-charge_to_take <= 0 then
			  charge_to_take = internal_EU_buffer
		       end
		       if charge_to_take > 0 then
			  internal_EU_buffer = internal_EU_buffer-charge_to_take
			  meta1:set_float("internal_EU_buffer",internal_EU_buffer)
		       end
		    end

		    if used_charge>0 then
		       meta:set_string("infotext", "MV Down Converter is active (MV:"..available_charge.."/LV:"..used_charge..")");
		       meta:set_float("active",1) -- used for setting textures someday maybe
		    else
		       meta:set_string("infotext", "MV Down Converter is inactive (MV:"..available_charge.."/LV:"..used_charge..")");
		       meta:set_float("active",0) -- used for setting textures someday maybe
		       return
		    end
	end,
})

-- This machine does not store energy it receives energy from the MV side and outputs it on the LV side
register_MV_machine ("technic:down_converter_mv","RE")
register_LV_machine ("technic:down_converter_mv","PR")
