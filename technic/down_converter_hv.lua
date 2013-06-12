-- The HV down converter will step down HV EUs to MV EUs
-- If we take the solar panel as calibration then the
-- 1 HVEU = 5 MVEU as we stack 5 MV arrays to get a HV array.
-- The downconverter does of course have a conversion loss.
-- This loses 30% of the power.
-- The converter does not store any energy by itself.
minetest.register_node("technic:down_converter_hv", {
        description = "HV Down Converter",
	tiles  = {"technic_hv_down_converter_top.png", "technic_hv_down_converter_bottom.png", "technic_hv_down_converter_side.png",
		  "technic_hv_down_converter_side.png", "technic_hv_down_converter_side.png", "technic_hv_down_converter_side.png"},
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
			  meta:set_float("internal_EU_buffer",0)
			  meta:set_float("internal_EU_buffer_size",0)
			  meta:set_string("infotext", "HV Down Converter")
			  meta:set_float("active", false)
		       end,
     })

minetest.register_craft({
	output = 'technic:down_converter_hv 1',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot','technic:stainless_steel_ingot'},
		{'technic:hv_transformer',        'technic:hv_cable',             'technic:mv_transformer'},
		{'technic:hv_cable',              'technic:rubber',               'technic:mv_cable'},
	}
})

minetest.register_abm(
	{nodenames = {"technic:down_converter_hv"},
	interval   = 1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		    -- HV->MV conversion factor
		    local hv_mv_factor = 5
		    -- The maximun charge a single converter can handle. Let's set this to
		    -- what 5 HV solar arrays can produce - 30% loss (2880*5*0.7)
		    local max_charge = 10080*hv_mv_factor

		    local meta             = minetest.env:get_meta(pos)
		    local meta1            = nil
		    local pos1             = {}
		    local available_charge = 0 -- counted in MV units
		    local used_charge      = 0 -- counted in MV units

		    -- Index all HV nodes connected to the network
		    -- HV cable comes in through the bottom
		    pos1.y = pos.y-1
		    pos1.x = pos.x
		    pos1.z = pos.z
		    meta1  = minetest.env:get_meta(pos1)
		    if meta1:get_float("hv_cablelike")~=1 then return end

		    local HV_nodes    = {} -- HV type
		    local HV_PR_nodes = {} -- HV type
		    local HV_BA_nodes = {} -- HV type

		    HV_nodes[1]         = {}
		    HV_nodes[1].x       = pos1.x
		    HV_nodes[1].y       = pos1.y
		    HV_nodes[1].z       = pos1.z

		    local table_index = 1
		    repeat
		       check_HV_node(HV_PR_nodes,nil,HV_BA_nodes,HV_nodes,table_index)
		       table_index = table_index + 1
		       if HV_nodes[table_index] == nil then break end
		    until false

		    --print("HV_nodes: PR="..table.getn(HV_PR_nodes).." BA="..table.getn(HV_BA_nodes))

		    -- Index all MV nodes connected to the network
		    -- MV cable comes out of the top
		    pos1.y = pos.y+1
		    pos1.x = pos.x
		    pos1.z = pos.z
		    meta1  = minetest.env:get_meta(pos1)
		    if meta1:get_float("mv_cablelike")~=1 then return end

		    local MV_nodes    = {} -- MV type
		    local MV_RE_nodes = {} -- MV type
		    local MV_BA_nodes = {} -- MV type

		    MV_nodes[1]         = {}
		    MV_nodes[1].x       = pos1.x
		    MV_nodes[1].y       = pos1.y
		    MV_nodes[1].z       = pos1.z

		    table_index = 1
		    repeat
		       check_MV_node(nil,MV_RE_nodes,MV_BA_nodes,MV_nodes,table_index)
		       table_index = table_index + 1
		       if MV_nodes[table_index] == nil then break end
		    until false

		    --print("MV_nodes: RE="..table.getn(MV_RE_nodes).." BA="..table.getn(MV_BA_nodes))

		    -- First get available power from all the attached HV suppliers
		    -- Get the supplier internal EU buffer and read the EUs from it
		    -- No update yet!
		    local pos1
-- FIXME: Until further leave the producers out of it and just let the batteries be the hub
--		    for _,pos1 in ipairs(HV_PR_nodes) do
--		       meta1  = minetest.env:get_meta(pos1)
--		       local internal_EU_buffer = meta1:get_float("internal_EU_buffer")
--		       available_charge = available_charge + meta1:get_float("internal_EU_buffer") * hv_mv_factor
--		       -- Limit conversion capacity
--		       if available_charge > max_charge then
--			  available_charge = max_charge
--			  break
--		       end
--		    end
--		    --print("Available_charge PR:"..available_charge)

		    for _,pos1 in ipairs(HV_BA_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       local internal_EU_buffer = meta1:get_float("internal_EU_buffer")
		       available_charge = available_charge + meta1:get_float("internal_EU_buffer") * hv_mv_factor
		       -- Limit conversion capacity
		       if available_charge > max_charge then
			  available_charge = max_charge
			  break
		       end
		    end
		    --print("Available_charge PR+BA:"..available_charge)

		    -- Calculate total number of receivers:
		    local MV_receivers = table.getn(MV_RE_nodes)+table.getn(MV_BA_nodes)

		    -- Next supply power to all connected MV machines
		    -- Get the power receiver internal EU buffer and give EUs to it
		    -- Note: for now leave out RE type machines until producers distribute power themselves even without a battery
--		    for _,pos1 in ipairs(MV_RE_nodes) do
--		       local meta1                   = minetest.env:get_meta(pos1)
--		       local internal_EU_buffer      = meta1:get_float("internal_EU_buffer")
--		       local internal_EU_buffer_size = meta1:get_float("internal_EU_buffer_size")
--		       local charge_to_give = math.min(4000, available_charge/MV_receivers) -- power rating limit on the MV wire
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

		    for _,pos1 in ipairs(MV_BA_nodes) do
		       local meta1 = minetest.env:get_meta(pos1)
		       local internal_EU_buffer      = meta1:get_float("internal_EU_buffer")
		       local internal_EU_buffer_size = meta1:get_float("internal_EU_buffer_size")
		       --print("internal_EU_buffer:"..internal_EU_buffer)
		       --print("internal_EU_buffer_size:"..internal_EU_buffer_size)
		       local charge_to_give = math.min(math.floor(available_charge/MV_receivers), 4000) -- power rating limit on the MV wire
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

		    -- Last update the HV suppliers with the actual demand.
		    -- Get the supplier internal EU buffer and update the EUs from it
		    -- Note: So far PR nodes left out and only BA nodes are updated
		    local HV_BA_size = table.getn(HV_BA_nodes)
		    for _,pos1 in ipairs(HV_BA_nodes) do
		       meta1  = minetest.env:get_meta(pos1)
		       local internal_EU_buffer = meta1:get_float("internal_EU_buffer")
		       local charge_to_take = math.floor(used_charge/HV_BA_size/hv_mv_factor) -- HV units
		       if internal_EU_buffer-charge_to_take <= 0 then
			  charge_to_take = internal_EU_buffer
		       end
		       if charge_to_take > 0 then
			  internal_EU_buffer = internal_EU_buffer-charge_to_take
			  meta1:set_float("internal_EU_buffer",internal_EU_buffer)
		       end
		    end

		    if used_charge>0 then
		       meta:set_string("infotext", "HV Down Converter is active (HV:"..available_charge.."/MV:"..used_charge..")");
		       meta:set_float("active",1) -- used for setting textures someday maybe
		    else
		       meta:set_string("infotext", "HV Down Converter is inactive (HV:"..available_charge.."/MV:"..used_charge..")");
		       meta:set_float("active",0) -- used for setting textures someday maybe
		       return
		    end
	end,
})

-- This machine does not store energy it receives energy from the HV side and outputs it on the MV side
register_HV_machine ("technic:down_converter_hv","RE")
register_MV_machine ("technic:down_converter_hv","PR")
