-- The power radiator fuctions like an inductive charger
-- only better in the game setting.
-- The purpose is to allow small appliances to receive power
-- without the overhead of the wiring needed for larger machines.
--
-- The power radiator will consume power corresponding to the
-- sum(power rating of the attached appliances)/0.06
-- Using inductive power transfer is very inefficient so this is
-- set to the factor 0.06.
--
-- Punching the radiator will toggle the power state of all attached appliances.

local power_radius = 12


minetest.register_craft({
	output = 'technic:power_radiator 1',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:mv_transformer', 'technic:stainless_steel_ingot'},
		{'technic:copper_coil',           'technic:machine_casing', 'technic:copper_coil'},
		{'technic:rubber',                'technic:mv_cable',       'technic:rubber'},
	}
})

------------------------------------------------------------------
-- API for inductive powered nodes:
-- Use the functions below to set the corresponding callbacks
-- Also two nodes are needed: The inactive and the active one. The active must be called <name>_active .
------------------------------------------------------------------
-- Register a new appliance using this function

technic.inductive_nodes = {}
technic.register_inductive_machine = function(name)
	table.insert(technic.inductive_nodes, name)
	table.insert(technic.inductive_nodes, name.."_active")
end

-- Appliances:
--  has_supply: pos of supply node if the appliance has a power radiator near with sufficient power for the demand else ""
--  EU_demand: The power demand of the device.
--  EU_charge: Actual use. set to EU_demand if active==1
--  active: set to 1 if the device is on
technic.inductive_on_construct = function(pos, eu_demand, infotext)
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext", infotext)
	meta:set_int("technic_inductive_power_machine", 1)
	meta:set_int("EU_demand", eu_demand)     -- The power demand of this appliance
	meta:set_int("EU_charge", 0)       -- The actual power draw of this appliance
	meta:set_string("has_supply", "") -- Register whether we are powered or not. For use with several radiators.
	meta:set_int("active", 0)    -- If the appliance can be turned on and off by using it use this.
end

technic.inductive_on_punch_off = function(pos, eu_charge, swapnode)
	local meta = minetest.get_meta(pos)
	if meta:get_string("has_supply") ~= "" then
		technic.swap_node(pos, swapnode)
		meta:set_int("active", 1)
		meta:set_int("EU_charge",eu_charge)
		--print("-----------")
		--print("Turn on:")
		--print("EU_charge: "..meta:get_int("EU_charge"))
		--print("has_supply: "..meta:get_string("has_supply"))
		--print("<----------->")
	end
end

technic.inductive_on_punch_on = function(pos, eu_charge, swapnode)
	local meta = minetest.get_meta(pos)
	technic.swap_node(pos, swapnode)
	meta:set_int("active", 0)
	meta:set_int("EU_charge",eu_charge)
	--print("-----------")
	--print("Turn off:")
	--print("EU_charge: "..meta:get_int("EU_charge"))
	--print("has_supply: "..meta:get_string("has_supply"))
	--print("<---------->")
end

local shutdown_inductive_appliances = function(pos)
	-- The supply radius
	local rad = power_radius
	-- If the radiator is removed. turn off all appliances in region
	-- If another radiator is near it will turn on the appliances again
	local positions = minetest.find_nodes_in_area(
		{x=pos.x-rad, y=pos.y-rad, z=pos.z-rad},
		{x=pos.x+rad, y=pos.y+rad, z=pos.z+rad},
		technic.inductive_nodes)
	for _, pos1 in pairs(positions) do
		local meta1 = minetest.get_meta(pos1)
		-- If the appliance is belonging to this node
		if meta1:get_string("has_supply") == pos.x..pos.y..pos.z then
			local nodename = minetest.get_node(pos1).name
			-- Swap the node and make sure it is off and unpowered
			if string.sub(nodename, -7) == "_active" then
				technic.swap_node(pos1, string.sub(nodename, 1, -8))
				meta1:set_int("active", 0)
				meta1:set_int("EU_charge", 0)
			end
			meta1:set_string("has_supply", "")
		end
	end
end

local toggle_on_off_inductive_appliances = function(pos, node, puncher)
	if pos == nil then return end
	-- The supply radius
	local rad = power_radius
	local positions = minetest.find_nodes_in_area(
		{x=pos.x-rad, y=pos.y-rad, z=pos.z-rad},
		{x=pos.x+rad, y=pos.y+rad, z=pos.z+rad},
		technic.inductive_nodes)
	for _, pos1 in pairs(positions) do
		local meta1 = minetest.get_meta(pos1)
		if meta1:get_string("has_supply") == pos.x..pos.y..pos.z then
			minetest.punch_node(pos1)
		end
	end
end

minetest.register_node("technic:power_radiator", {
	description = "MV Power Radiator",
	tiles  = {"technic_lv_cable.png", "technic_lv_cable.png", "technic_lv_cable.png",
	          "technic_lv_cable.png", "technic_lv_cable.png", "technic_lv_cable.png"},
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = true,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("MV_EU_demand",1)               -- Demand on the primary side when idle
		meta:set_int("connected_EU_demand",0)        -- Potential demand of connected appliances
		meta:set_string("infotext", "MV Power Radiator")
	end,
	on_dig = function(pos, node, digger)
		shutdown_inductive_appliances(pos)
		return minetest.node_dig(pos, node, digger)
	end,
	on_punch = function(pos, node, puncher)
		toggle_on_off_inductive_appliances(pos, node, puncher)
	end
})

minetest.register_abm({
	label = "Machines: run power radiator",
	nodenames = {"technic:power_radiator"},
	interval   = 1,
	chance     = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta             = minetest.get_meta(pos)
		local eu_input  = meta:get_int("MV_EU_input")
		local eu_demand = meta:get_int("MV_EU_demand")

		-- Power off automatically if no longer connected to a switching station
		technic.switching_station_timeout_count(pos, "MV")

		if eu_input == 0 then
			-- No power
			meta:set_string("infotext", "MV Power Radiator is unpowered");
			-- meta:set_int("active", 1) -- used for setting textures someday maybe
			shutdown_inductive_appliances(pos)
			meta:set_int("connected_EU_demand", 0)
			meta:set_int("MV_EU_demand",1)
		elseif eu_input == eu_demand then
			-- Powered and ready

			-- The maximum EU sourcing a single radiator can provide.
			local max_charge          = 30000 -- == the max EU demand of the radiator
			local connected_EU_demand = meta:get_int("connected_EU_demand")

			-- Efficiency factor
			local eff_factor = 0.06
			-- The supply radius
			local rad = power_radius

			local used_charge      = 0

			-- Index all nodes within supply range
			local positions = minetest.find_nodes_in_area(
				{x=pos.x-rad, y=pos.y-rad, z=pos.z-rad},
				{x=pos.x+rad, y=pos.y+rad, z=pos.z+rad},
				technic.inductive_nodes)
			for _, pos1 in pairs(positions) do
				local meta1 = minetest.get_meta(pos1)
				-- If not supplied see if this node can handle it.
				if meta1:get_string("has_supply") == "" then
					-- if demand surpasses the capacity of this node, don't bother adding it.
					local app_eu_demand = math.floor(meta1:get_int("EU_demand") / eff_factor)
					if connected_EU_demand + app_eu_demand <= max_charge then
						-- We can power the appliance. Register, and spend power if it is on.
						connected_EU_demand = connected_EU_demand + app_eu_demand

						meta1:set_string("has_supply", pos.x..pos.y..pos.z)
						--Always 0: used_charge = math.floor(used_charge + meta1:get_int("EU_charge") / eff_factor)
					end
				elseif meta1:get_string("has_supply") == pos.x..pos.y..pos.z then
					-- The appliance has power from this node. Spend power if it is on.
					used_charge = used_charge + math.floor(meta1:get_int("EU_charge") / eff_factor)
				end
				meta:set_string("infotext", "MV Power Radiator is powered ("
					..math.floor(used_charge / max_charge * 100)
					.."% of maximum power)");
				if used_charge == 0 then
					meta:set_int("MV_EU_demand", 1) -- Still idle
				else
					meta:set_int("MV_EU_demand", used_charge)
				end
			end
			-- Save state
			meta:set_int("connected_EU_demand", connected_EU_demand)
		end
	end,
})

technic.register_machine("MV", "technic:power_radiator", technic.receiver)

