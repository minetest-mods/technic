local mining_lasers_list = {
--	{<num>, <range of the laser shots>, <max_charge>, <charge_per_shot>},
	{"1", 7, 50000, 1000},
	{"2", 14, 200000, 2000},
	{"3", 21, 650000, 3000},
}
local allow_entire_discharging = true

local S = technic.getter

minetest.register_craft({
	output = "technic:laser_mk1",
	recipe = {
		{"default:diamond", "basic_materials:brass_ingot",        "default:obsidian_glass"},
		{"",                "basic_materials:brass_ingot",        "technic:red_energy_crystal"},
		{"",                "",                           "default:copper_ingot"},
	}
})
minetest.register_craft({
	output = "technic:laser_mk2",
	recipe = {
		{"default:diamond", "technic:carbon_steel_ingot", "technic:laser_mk1"},
		{"",                "technic:carbon_steel_ingot", "technic:green_energy_crystal"},
		{"",                "",                           "default:copper_ingot"},
	}
})
minetest.register_craft({
	output = "technic:laser_mk3",
	recipe = {
		{"default:diamond", "technic:carbon_steel_ingot", "technic:laser_mk2"},
		{"",                "technic:carbon_steel_ingot", "technic:blue_energy_crystal"},
		{"",                "",                           "default:copper_ingot"},
	}
})

local function laser_node(pos, node, player)
	local def = minetest.registered_nodes[node.name]
	if def.liquidtype ~= "none" and def.buildable_to then
		minetest.remove_node(pos)
		minetest.add_particle({
			pos = pos,
			velocity = {x = 0, y = 1.5 + math.random(), z = 0},
			acceleration = {x = 0, y = -1, z = 0},
			size = 6 + math.random() * 2,
			texture = "smoke_puff.png^[transform" .. math.random(0, 7),
		})
		return
	end
	def.on_dig(pos, node, player)
end

local keep_node = {air = true}
local function can_keep_node(name)
	if keep_node[name] ~= nil then
		return keep_node[name]
	end
	keep_node[name] = minetest.get_item_group(name, "hot") ~= 0
	return keep_node[name]
end

local function laser_shoot(player, range, particle_texture, sound)
	local player_pos = player:get_pos()
	local player_name = player:get_player_name()
	local dir = player:get_look_dir()

	local start_pos = vector.new(player_pos)
	-- Adjust to head height
	start_pos.y = start_pos.y + (player:get_properties().eye_height or 1.625)
	minetest.add_particle({
		pos = start_pos,
		velocity = dir,
		acceleration = vector.multiply(dir, 50),
		expirationtime = (math.sqrt(1 + 100 * (range + 0.4)) - 1) / 50,
		size = 1,
		texture = particle_texture .. "^[transform" .. math.random(0, 7),
	})
	minetest.sound_play(sound, {pos = player_pos, max_hear_distance = range})
	for pos in technic.trace_node_ray_fat(start_pos, dir, range) do
		if minetest.is_protected(pos, player_name) then
			minetest.record_protection_violation(pos, player_name)
			break
		end
		local node = minetest.get_node(pos)
		if node.name == "ignore"
				or not minetest.registered_nodes[node.name] then
			break
		end
		if not can_keep_node(node.name) then
			laser_node(pos, node, player)
		end
	end
end

for _, m in pairs(mining_lasers_list) do
	technic.register_power_tool("technic:laser_mk"..m[1], m[3])
	minetest.register_tool("technic:laser_mk"..m[1], {
		description = S("Mining Laser Mk%d"):format(m[1]),
		inventory_image = "technic_mining_laser_mk"..m[1]..".png",
		range = 0,
		stack_max = 1,
		wear_represents = "technic_RE_charge",
		on_refill = technic.refill_RE_charge,
		on_use = function(itemstack, user)
			local meta = minetest.deserialize(itemstack:get_metadata())
			if not meta or not meta.charge or meta.charge == 0 then
				return
			end

			local range = m[2]
			if meta.charge < m[4] then
				if not allow_entire_discharging then
					return
				end
				-- If charge is too low, give the laser a shorter range
				range = range * meta.charge / m[4]
			end
			laser_shoot(user, range, "technic_laser_beam_mk" .. m[1] .. ".png",
				"technic_laser_mk" .. m[1])
			if not technic.creative_mode then
				meta.charge = math.max(meta.charge - m[4], 0)
				technic.set_RE_wear(itemstack, meta.charge, m[3])
				itemstack:set_metadata(minetest.serialize(meta))
			end
			return itemstack
		end,
	})
end
