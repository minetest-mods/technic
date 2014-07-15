-- Forcefield mod by ShadowNinja
-- Modified by kpoppel
--
-- Forcefields are powerful barriers but they consume huge amounts of power.
-- Forcefield Generator is a HV machine.

-- How expensive is the generator?
-- Leaves room for upgrades lowering the power drain?
local forcefield_power_drain   = 10
local forcefield_step_interval = 1

local S = technic.getter

minetest.register_craft({
	output = 'technic:forcefield_emitter_off',
	recipe = {
			{'default:mese',         'technic:motor',          'default:mese'        },
			{'technic:deployer_off', 'technic:machine_casing', 'technic:deployer_off'},
			{'default:mese',         'technic:hv_cable0',      'default:mese'        },
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
		   x*x+y*y+z*z >= (range-1) * (range-1) + (range-1) then
			if active and data[vi] == c_air then
				data[vi] = c_field
			elseif not active and data[vi] == c_field then
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

local function set_forcefield_formspec(meta)
	local formspec = "size[5,2.25]"..
		"field[2,0.5;2,1;range;"..S("Range")..";"..meta:get_int("range").."]"
	-- The names for these toggle buttons are explicit about which
	-- state they'll switch to, so that multiple presses (arising
	-- from the ambiguity between lag and a missed press) only make
	-- the single change that the user expects.
	if meta:get_int("mesecon_mode") == 0 then
		formspec = formspec.."button[0,1;5,1;mesecon_mode_1;"..S("Ignoring Mesecon Signal").."]"
	else
		formspec = formspec.."button[0,1;5,1;mesecon_mode_0;"..S("Controlled by Mesecon Signal").."]"
	end
	if meta:get_int("enabled") == 0 then
		formspec = formspec.."button[0,1.75;5,1;enable;"..S("%s Disabled"):format(S("%s Forcefield Emitter"):format("HV")).."]"
	else
		formspec = formspec.."button[0,1.75;5,1;disable;"..S("%s Enabled"):format(S("%s Forcefield Emitter"):format("HV")).."]"
	end
	meta:set_string("formspec", formspec)
end

local forcefield_receive_fields = function(pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)
	if fields.range then
		local range = tonumber(fields.range) or 0
		-- Smallest field is 5. Anything less is asking for trouble.
		-- Largest is 20. It is a matter of pratical node handling.
		-- At the maximim range updating the forcefield takes about 0.2s
		range = math.max(range, 5)
		range = math.min(range, 20)
		if meta:get_int("range") ~= range then
			update_forcefield(pos, meta:get_int("range"), false)
			meta:set_int("range", range)
		end
	end
	if fields.enable then meta:set_int("enabled", 1) end
	if fields.disable then meta:set_int("enabled", 0) end
	if fields.mesecon_mode_0 then meta:set_int("mesecon_mode", 0) end
	if fields.mesecon_mode_1 then meta:set_int("mesecon_mode", 1) end
	set_forcefield_formspec(meta)
end

local mesecons = {
	effector = {
		action_on = function(pos, node)
			minetest.get_meta(pos):set_int("mesecon_effect", 1)
		end,
		action_off = function(pos, node)
			minetest.get_meta(pos):set_int("mesecon_effect", 0)
		end
	}
}

local run = function(pos, node, active_object_count, active_object_count_wider)
	local meta = minetest.get_meta(pos)
	local eu_input   = meta:get_int("HV_EU_input")
	local eu_demand  = meta:get_int("HV_EU_demand")
	local enabled = meta:get_int("enabled") ~= 0 and (meta:get_int("mesecon_mode") == 0 or meta:get_int("mesecon_effect") ~= 0)
	local machine_name = S("%s Forcefield Emitter"):format("HV")

	local power_requirement = math.floor(
			4 * math.pi * math.pow(meta:get_int("range"), 2)
		) * forcefield_power_drain

	if not enabled then
		if node.name == "technic:forcefield_emitter_on" then
			meta:set_int("HV_EU_demand", 0)
			update_forcefield(pos, meta:get_int("range"), false)
			technic.swap_node(pos, "technic:forcefield_emitter_off")
			meta:set_string("infotext", S("%s Disabled"):format(machine_name))
			return
		end
	elseif eu_input < power_requirement then
		meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
		if node.name == "technic:forcefield_emitter_on" then
			update_forcefield(pos, meta:get_int("range"), false)
			technic.swap_node(pos, "technic:forcefield_emitter_off")
		end
	elseif eu_input >= power_requirement then
		if node.name == "technic:forcefield_emitter_off" then
			technic.swap_node(pos, "technic:forcefield_emitter_on")
			meta:set_string("infotext", S("%s Active"):format(machine_name))
		end
		update_forcefield(pos, meta:get_int("range"), true)
	end
	meta:set_int("HV_EU_demand", power_requirement)
end

minetest.register_node("technic:forcefield_emitter_off", {
	description = S("%s Forcefield Emitter"):format("HV"),
	tiles = {"technic_forcefield_emitter_off.png"},
	groups = {cracky = 1, technic_machine = 1},
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("HV_EU_input", 0)
		meta:set_int("HV_EU_demand", 0)
		meta:set_int("range", 10)
		meta:set_int("enabled", 0)
		meta:set_int("mesecon_mode", 0)
		meta:set_int("mesecon_effect", 0)
		meta:set_string("infotext", S("%s Forcefield Emitter"):format("HV"))
		set_forcefield_formspec(meta)
	end,
	mesecons = mesecons,
	technic_run = run,
})

minetest.register_node("technic:forcefield_emitter_on", {
	description = S("%s Forcefield Emitter"):format("HV"),
	tiles = {"technic_forcefield_emitter_on.png"},
	groups = {cracky = 1, technic_machine = 1, not_in_creative_inventory=1},
	drop = "technic:forcefield_emitter_off",
	on_receive_fields = forcefield_receive_fields,
	on_destruct = function(pos)
		local meta = minetest.get_meta(pos)
		update_forcefield(pos, meta:get_int("range"), false)
	end,
	mesecons = mesecons,
	technic_run = run,
	technic_disabled_machine_name = "technic:forcefield_emitter",
})

minetest.register_node("technic:forcefield", {
	description = S("%s Forcefield"):format("HV"),
	sunlight_propagates = true,
	drawtype = "glasslike",
	groups = {not_in_creative_inventory=1, unbreakable=1},
	paramtype = "light",
        light_source = 15,
	drop = '',
	tiles = {{
		name = "technic_forcefield_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.0,
		},
	}},
})


if minetest.get_modpath("mesecons_mvps") then
	mesecon:register_mvps_stopper("technic:forcefield")
end

technic.register_machine("HV", "technic:forcefield_emitter_on",  technic.receiver)
technic.register_machine("HV", "technic:forcefield_emitter_off", technic.receiver)

