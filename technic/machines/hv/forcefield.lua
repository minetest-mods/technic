-- Forcefield mod by ShadowNinja
-- Modified by kpoppel
--
-- Forcefields are powerful barriers but they consume huge amounts of power.
-- Forcefield Generator is a HV machine.

-- How expensive is the generator? Leaves room for upgrades lowering the power drain?
local forcefield_power_drain     = 10
local forcefield_step_interval = 1

minetest.register_craft({
	output = 'technic:forcefield_emitter_off',
	recipe = {
			{'default:mese',         'technic:deployer_off', 'default:mese'        },
			{'technic:deployer_off', 'technic:motor',        'technic:deployer_off'},
			{'default:mese',         'technic:deployer_off', 'default:mese'        },
	}
})


-- Idea: Let forcefields have different colors by upgrade slot.
-- Idea: Let forcefields add up by detecting if one hits another.
--    ___   __
--   /   \/   \
--  |          |
--   \___/\___/

local function update_forcefield(pos, range, active)
	local vm = VoxelManip()
	local p1 = {x = pos.x-range, y = pos.y-range, z = pos.z-range}
	local p2 = {x = pos.x+range, y = pos.y+range, z = pos.z+range}
	local MinEdge, MaxEdge = vm:read_from_map(p1, p2)
	local area = VoxelArea:new({MinEdge = MinEdge, MaxEdge = MaxEdge})
	local data = vm:get_data()

	local c_air   = minetest.get_content_id("air")
	local c_field = minetest.get_content_id("technic:forcefield")

	for z=-range, range do
	for y=-range, range do
	local vi = area:index(pos.x+(-range), pos.y+y, pos.z+z)
	for x=-range, range do
		if x*x+y*y+z*z <= range     *  range    +  range    and
		   x*x+y*y+z*z >= (range-1) * (range-1) + (range-1) and
		   ((active and data[vi] == c_air) or ((not active) and data[vi] == c_field)) then
		   	if active then
				data[vi] = c_field
			else
				data[vi] = c_air
			end
		end
		vi = vi + 1
	end
	end
	end

	vm:set_data(data)
	vm:update_liquids()
	vm:write_to_map()
	vm:update_map()
end

local get_forcefield_formspec = function(range)
	return "invsize[3,4;]"..
		"label[0,0;Forcefield emitter]"..
		"label[1,1;Range]"..
		"label[1,2;"..range.."]"..
		"button[0,2;1,1;subtract;-]"..
		"button[2,2;1,1;add;+]"..
		"button[0,3;3,1;toggle;Enable/Disable]"
end

local forcefield_receive_fields = function(pos, formname, fields, sender)
	local meta = minetest.env:get_meta(pos)
	local range = meta:get_int("range")

	if fields.add then range = range + 1 end
	if fields.subtract then range = range - 1 end
	if fields.toggle then
		if meta:get_int("enabled") == 1 then
		   meta:set_int("enabled", 0)
		else
		   meta:set_int("enabled", 1)
		end
	end

	-- Smallest field is 5. Anything less is asking for trouble.
	-- Largest is 20. It is a matter of pratical node handling.
	if range < 5  then range = 5 end
	if range > 20 then range = 20 end

	if range <= 20 and range >= 5 and meta:get_int("range") ~= range then
		update_forcefield(pos, meta:get_int("range"), false)
		meta:set_int("range", range)
		meta:set_string("formspec", get_forcefield_formspec(range))
	end
end

local function forcefield_step(pos)
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local eu_input   = meta:get_int("HV_EU_input")
	local eu_demand  = meta:get_int("HV_EU_demand")
	local enabled    = meta:get_int("enabled")

	-- Power off automatically if no longer connected to a switching station
	technic.switching_station_timeout_count(pos, "HV")

	local power_requirement = 0
	if enabled == 1 then
		power_requirement = math.floor(
				4 * math.pi * math.pow(meta:get_int("range"), 2)
			) * forcefield_power_drain
	else
		power_requirement = eu_demand
	end

	if meta:get_int("enabled") == 0 then
		if node.name == "technic:forcefield_emitter_on" then
			update_forcefield(pos, meta:get_int("range"), false)
			hacky_swap_node(pos, "technic:forcefield_emitter_off")
			meta:set_int("HV_EU_demand", 100)
			meta:set_string("infotext", "Forcefield Generator Disabled")
		end
	elseif eu_input < power_requirement then
		meta:set_string("infotext", "Forcefield Generator Unpowered")
		if node.name == "technic:forcefield_emitter_on" then
			update_forcefield(pos, meta:get_int("range"), false)
			hacky_swap_node(pos, "technic:forcefield_emitter_off")
		end
	elseif eu_input >= power_requirement then
		if node.name == "technic:forcefield_emitter_off" then
			hacky_swap_node(pos, "technic:forcefield_emitter_on")
			meta:set_string("infotext", "Forcefield Generator Active")
		end
		update_forcefield(pos, meta:get_int("range"), true)
	end
	meta:set_int("HV_EU_demand", power_requirement)
	return true
end

local mesecons = {
	effector = {
		action_on = function(pos, node)
			minetest.env:get_meta(pos):set_int("enabled", 0)
		end,
		action_off = function(pos, node)
			minetest.env:get_meta(pos):set_int("enabled", 1)
		end
	}
}

minetest.register_node("technic:forcefield_emitter_off", {
	description = "Forcefield emitter",
	inventory_image = minetest.inventorycube("technic_forcefield_emitter_off.png"),
	tiles = {"technic_forcefield_emitter_off.png"},
	is_ground_content = true,
	groups = {cracky = 1},
	on_timer = forcefield_step,
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos)
		minetest.env:get_node_timer(pos):start(forcefield_step_interval)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_hv_power_machine", 1)
		meta:set_int("HV_EU_input", 0)
		meta:set_int("HV_EU_demand", 0)
		meta:set_int("range", 10)
		meta:set_int("enabled", 0)
		meta:set_string("formspec", get_forcefield_formspec(meta:get_int("range")))
		meta:set_string("infotext", "Forcefield emitter");
	end,
	mesecons = mesecons
})

minetest.register_node("technic:forcefield_emitter_on", {
	description = "Forcefield emitter on (you hacker you)",
	tiles = {"technic_forcefield_emitter_on.png"},
	is_ground_content = true,
	groups = {cracky = 1, not_in_creative_inventory=1},
	drop='"technic:forcefield_emitter_off" 1',
	on_timer = forcefield_step,
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos) 
		minetest.env:get_node_timer(pos):start(forcefield_step_interval)
		local meta = minetest.env:get_meta(pos)
--		meta:set_float("technic_hv_power_machine", 1)
--		meta:set_float("HV_EU_input", 0)
--		meta:set_float("HV_EU_demand", 0)
--		meta:set_int("range", 10)
--		meta:set_int("enabled", 1)
		meta:set_string("formspec", get_forcefield_formspec(meta:get_int("range")))
--		meta:set_string("infotext", "Forcefield emitter");
	end,
	on_dig = function(pos, node, digger)
		update_forcefield(pos, minetest.env:get_meta(pos):get_int("range"), false)
		return minetest.node_dig(pos, node, digger)
	end,
	mesecons = mesecons
})

minetest.register_node("technic:forcefield", {
	description = "Forcefield (you hacker you)",
	sunlight_propagates = true,
	drop = '',
        light_source = 8,
	tiles = {{
		name = "technic_forcefield_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w=16,
			aspect_h=16,
			length=2.0,
		},
	}},
	is_ground_content = true,
	groups = { not_in_creative_inventory=1, unbreakable=1 },
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {  --hacky way to get the field blue and not see through the ground
		type = "fixed",
		fixed={
			{-.5,-.5,-.5,.5,.5,.5},
		},
	},
})

technic.register_HV_machine("technic:forcefield_emitter_on", "RE")
technic.register_HV_machine("technic:forcefield_emitter_off", "RE")
