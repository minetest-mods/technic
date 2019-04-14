--- Forcefield generator.
-- @author ShadowNinja
--
-- Forcefields are powerful barriers but they consume huge amounts of power.
-- The forcefield Generator is an HV machine.

-- How expensive is the generator?
-- Leaves room for upgrades lowering the power drain?
local digilines_path = minetest.get_modpath("digilines")

local forcefield_power_drain   = 10

local S = technic.getter

local cable_entry = "^technic_cable_connection_overlay.png"

minetest.register_craft({
	output = "technic:forcefield_emitter_off",
	recipe = {
		{"default:mese",         "basic_materials:motor",          "default:mese"        },
		{"technic:deployer_off", "technic:machine_casing", "technic:deployer_off"},
		{"default:mese",         "technic:hv_cable",       "default:mese"        },
	}
})


local replaceable_cids = {}

minetest.after(0, function()
	for name, ndef in pairs(minetest.registered_nodes) do
		if ndef.buildable_to == true and name ~= "ignore" then
			replaceable_cids[minetest.get_content_id(name)] = true
		end
	end
end)


-- Idea: Let forcefields have different colors by upgrade slot.
-- Idea: Let forcefields add up by detecting if one hits another.
--    ___   __
--   /   \/   \
--  |          |
--   \___/\___/

local function update_forcefield(pos, meta, active)
	local shape = meta:get_int("shape")
	local range = meta:get_int("range")
	local vm = VoxelManip()
	local MinEdge, MaxEdge = vm:read_from_map(vector.subtract(pos, range),
			vector.add(pos, range))
	local area = VoxelArea:new({MinEdge = MinEdge, MaxEdge = MaxEdge})
	local data = vm:get_data()

	local c_air = minetest.get_content_id("air")
	local c_field = minetest.get_content_id("technic:forcefield")

	for z = -range, range do
	for y = -range, range do
	local vi = area:index(pos.x + (-range), pos.y + y, pos.z + z)
	for x = -range, range do
		local relevant
		if shape == 0 then
			local squared = x * x + y * y + z * z
			relevant =
				squared <= range       *  range      +  range and
				squared >= (range - 1) * (range - 1) + (range - 1)
		else
			relevant =
				x == -range or x == range or
				y == -range or y == range or
				z == -range or z == range
		end
		if relevant then
			local cid = data[vi]
			if active and replaceable_cids[cid] then
				data[vi] = c_field
			elseif not active and cid == c_field then
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
end

local function set_forcefield_formspec(meta)
	local formspec
	if digilines_path then
		formspec = "size[5,3.25]"..
			"field[0.3,3;5,1;channel;Digiline Channel;"..meta:get_string("channel").."]"
	else
		formspec = "size[5,2.25]"
	end
	formspec = formspec..
		"field[0.3,0.5;2,1;range;"..S("Range")..";"..meta:get_int("range").."]"
	-- The names for these toggle buttons are explicit about which
	-- state they'll switch to, so that multiple presses (arising
	-- from the ambiguity between lag and a missed press) only make
	-- the single change that the user expects.
	if meta:get_int("shape") == 0 then
		formspec = formspec.."button[3,0.2;2,1;shape1;"..S("Sphere").."]"
	else
		formspec = formspec.."button[3,0.2;2,1;shape0;"..S("Cube").."]"
	end
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
	local player_name = sender:get_player_name()
	if minetest.is_protected(pos, player_name) then
		minetest.chat_send_player(player_name, "You are not allowed to edit this!")
		minetest.record_protection_violation(pos, player_name)
		return
	end
	local meta = minetest.get_meta(pos)
	local range = nil
	if fields.range then
		range = tonumber(fields.range) or 0
		-- Smallest field is 5. Anything less is asking for trouble.
		-- Largest is 20. It is a matter of pratical node handling.
		-- At the maximim range updating the forcefield takes about 0.2s
		range = math.max(range, 5)
		range = math.min(range, 20)
		if range == meta:get_int("range") then range = nil end
	end
	if fields.shape0 or fields.shape1 or range then
		update_forcefield(pos, meta, false)
	end
	if range then meta:set_int("range", range) end
	if fields.channel then meta:set_string("channel", fields.channel) end
	if fields.shape0  then meta:set_int("shape", 0) end
	if fields.shape1  then meta:set_int("shape", 1) end
	if fields.enable  then meta:set_int("enabled", 1) end
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

local digiline_def = {
	receptor = {action = function() end},
	effector = {
		action = function(pos, node, channel, msg)
			local meta = minetest.get_meta(pos)
			if channel ~= meta:get_string("channel") then
				return
			end
			local msgt = type(msg)
			if msgt == "string" then
				local smsg = msg:lower()
				msg = {}
				if smsg == "get" then
					msg.command = "get"
				elseif smsg == "off" then
					msg.command = "off"
				elseif smsg == "on" then
					msg.command = "on"
				elseif smsg == "toggle" then
					msg.command = "toggle"
				elseif smsg:sub(1, 5) == "range" then
					msg.command = "range"
					msg.value = tonumber(smsg:sub(7))
				elseif smsg:sub(1, 5) == "shape" then
					msg.command = "shape"
					msg.value = smsg:sub(7):lower()
					msg.value = tonumber(msg.value) or msg.value
				end
			elseif msgt ~= "table" then
				return
			end
			if msg.command == "get" then
				digilines.receptor_send(pos, digilines.rules.default, channel, {
					enabled = meta:get_int("enabled"),
					range   = meta:get_int("range"),
					shape   = meta:get_int("shape")
				})
				return
			elseif msg.command == "off" then
				meta:set_int("enabled", 0)
			elseif msg.command == "on" then
				meta:set_int("enabled", 1)
			elseif msg.command == "toggle" then
				local onn = meta:get_int("enabled")
				onn = 1-onn -- Mirror onn with pivot 0.5, so switch between 1 and 0.
				meta:set_int("enabled", onn)
			elseif msg.command == "range" then
				if type(msg.value) ~= "number" then
					return
				end
				msg.value = math.max(msg.value, 5)
				msg.value = math.min(msg.value, 20)
				update_forcefield(pos, meta, false)
				meta:set_int("range", msg.value)
			elseif msg.command == "shape" then
				local valuet = type(msg.value)
				if valuet == "string" then
					if msg.value == "sphere" then
						msg.value = 0
					elseif msg.value == "cube" then
						msg.value = 1
					end
				elseif valuet ~= "number" then
					return
				end
				if not msg.value then
					return
				end
				update_forcefield(pos, meta, false)
				meta:set_int("shape", msg.value)
			else
				return
			end
			set_forcefield_formspec(meta)
		end
	},
}

local function run(pos, node)
	local meta = minetest.get_meta(pos)
	local eu_input   = meta:get_int("HV_EU_input")
	local enabled = meta:get_int("enabled") ~= 0 and
		(meta:get_int("mesecon_mode") == 0 or meta:get_int("mesecon_effect") ~= 0)
	local machine_name = S("%s Forcefield Emitter"):format("HV")

	local range = meta:get_int("range")
	local power_requirement
	if meta:get_int("shape") == 0 then
		power_requirement = math.floor(4 * math.pi * range * range)
	else
		power_requirement = 24 * range * range
	end
	power_requirement = power_requirement * forcefield_power_drain

	if not enabled then
		if node.name == "technic:forcefield_emitter_on" then
			update_forcefield(pos, meta, false)
			technic.swap_node(pos, "technic:forcefield_emitter_off")
			meta:set_string("infotext", S("%s Disabled"):format(machine_name))
		end
		meta:set_int("HV_EU_demand", 0)
		return
	end
	meta:set_int("HV_EU_demand", power_requirement)
	if eu_input < power_requirement then
		meta:set_string("infotext", S("%s Unpowered"):format(machine_name))
		if node.name == "technic:forcefield_emitter_on" then
			update_forcefield(pos, meta, false)
			technic.swap_node(pos, "technic:forcefield_emitter_off")
		end
	elseif eu_input >= power_requirement then
		if node.name == "technic:forcefield_emitter_off" then
			technic.swap_node(pos, "technic:forcefield_emitter_on")
			meta:set_string("infotext", S("%s Active"):format(machine_name))
		end
		update_forcefield(pos, meta, true)
	end
end

minetest.register_node("technic:forcefield_emitter_off", {
	description = S("%s Forcefield Emitter"):format("HV"),
	tiles = {
		"technic_forcefield_emitter_off.png",
		"technic_machine_bottom.png"..cable_entry,
		"technic_forcefield_emitter_off.png",
		"technic_forcefield_emitter_off.png",
		"technic_forcefield_emitter_off.png",
		"technic_forcefield_emitter_off.png"
	},
	groups = {cracky = 1, technic_machine = 1, technic_hv = 1},
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("HV_EU_input", 0)
		meta:set_int("HV_EU_demand", 0)
		meta:set_int("range", 10)
		meta:set_int("enabled", 0)
		meta:set_int("mesecon_mode", 0)
		meta:set_int("mesecon_effect", 0)
		if digilines_path then
			meta:set_string("channel", "forcefield"..minetest.pos_to_string(pos))
		end
		meta:set_string("infotext", S("%s Forcefield Emitter"):format("HV"))
		set_forcefield_formspec(meta)
	end,
	mesecons = mesecons,
	digiline = digiline_def,
	technic_run = run,
})

minetest.register_node("technic:forcefield_emitter_on", {
	description = S("%s Forcefield Emitter"):format("HV"),
	tiles = {
		"technic_forcefield_emitter_on.png",
		"technic_machine_bottom.png"..cable_entry,
		"technic_forcefield_emitter_on.png",
		"technic_forcefield_emitter_on.png",
		"technic_forcefield_emitter_on.png",
		"technic_forcefield_emitter_on.png"
	},
	groups = {cracky = 1, technic_machine = 1, technic_hv = 1,
			not_in_creative_inventory=1},
	drop = "technic:forcefield_emitter_off",
	on_receive_fields = forcefield_receive_fields,
	on_destruct = function(pos)
		local meta = minetest.get_meta(pos)
		update_forcefield(pos, meta, false)
	end,
	mesecons = mesecons,
	digiline = digiline_def,
	technic_run = run,
	technic_on_disable = function (pos, node)
		local meta = minetest.get_meta(pos)
		update_forcefield(pos, meta, false)
		technic.swap_node(pos, "technic:forcefield_emitter_off")
	end,
	on_blast = function(pos, intensity)
		minetest.dig_node(pos)
		return {"technic:forcefield_emitter_off"}
	end,
})

minetest.register_node("technic:forcefield", {
	description = S("%s Forcefield"):format("HV"),
	sunlight_propagates = true,
	drawtype = "glasslike",
	groups = {not_in_creative_inventory=1},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	diggable = false,
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
	on_blast = function(pos, intensity)
	end,
})


if minetest.get_modpath("mesecons_mvps") then
	mesecon.register_mvps_stopper("technic:forcefield")
end

technic.register_machine("HV", "technic:forcefield_emitter_on",  technic.receiver)
technic.register_machine("HV", "technic:forcefield_emitter_off", technic.receiver)

