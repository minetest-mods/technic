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
		{"default:diamond", "technic:brass_ingot",        "default:obsidian_glass"},
		{"",                "technic:brass_ingot",        "technic:red_energy_crystal"},
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

local scalar = vector.scalar or vector.dot or function(v1, v2)
	return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
end

local function biggest_of_vec(vec)
	if vec.x < vec.y then
		if vec.y < vec.z then
			return "z"
		end
		return "y"
	end
	if vec.x < vec.z then
		return "z"
	end
	return "x"
end

local function rayIter(pos, dir, range)
	-- make a table of possible movements
	local step = {}
	for i in pairs(pos) do
		local v = math.sign(dir[i])
		if v ~= 0 then
			step[i] = v
		end
	end

	local p
	return function()
		if not p then
			-- avoid skipping the first position
			p = vector.round(pos)
			return vector.new(p)
		end

		-- find the position which has the smallest distance to the line
		local choose = {}
		local choosefit = vector.new()
		for i in pairs(step) do
			choose[i] = vector.new(p)
			choose[i][i] = choose[i][i] + step[i]
			choosefit[i] = scalar(vector.normalize(vector.subtract(choose[i], pos)), dir)
		end
		p = choose[biggest_of_vec(choosefit)]

		if vector.distance(pos, p) <= range then
			return vector.new(p)
		end
	end
end

local function laser_node(pos, node, player)
	local def = minetest.registered_nodes[node.name]
	if def.liquidtype ~= "none"
	and def.buildable_to then
		minetest.remove_node(pos)
		minetest.add_particle({
			pos = pos,
			vel = {x=0, y=1.5+math.random(), z=0},
			acc = {x=0, y=-1, z=0},
			expirationtime = 1.5,
			size = 6 + math.random() * 2,
			texture = "smoke_puff.png^[transform" .. math.random(0, 7),
		})
		return
	end
	minetest.node_dig(pos, node, player)
end

local no_destroy = {air = true}
local function keep_node(name)
	if no_destroy[name] ~= nil then
		return no_destroy[name]
	end
	no_destroy[name] = minetest.get_item_group(name, "hot") ~= 0
	return no_destroy[name]
end

local function laser_shoot(player, range, particle_texture, sound)
	local player_pos = player:getpos()
	local player_name = player:get_player_name()
	local dir = player:get_look_dir()

	local start_pos = vector.new(player_pos)
	-- Adjust to head height
	start_pos.y = start_pos.y + 1.625
	minetest.add_particle({
		pos = start_pos,
		velocity = dir,
		acceleration = vector.multiply(dir, 50),
		expirationtime = (math.sqrt(1+100*(range+0.4))-1)/50,
		size = 1,
		texture = particle_texture .. "^[transform" .. math.random(0, 7),
	})
	minetest.sound_play(sound, {pos = player_pos, max_hear_distance = range})
	for pos in rayIter(start_pos, dir, range) do
		if minetest.is_protected(pos, player_name) then
			minetest.record_protection_violation(pos, player_name)
			break
		end
		local node = minetest.get_node_or_nil(pos)
		if not node
		or not minetest.registered_nodes[node.name] then
			break
		end
		if not keep_node(node.name) then
			laser_node(pos, node, player)
		end
	end
end

for _, m in pairs(mining_lasers_list) do
	technic.register_power_tool("technic:laser_mk"..m[1], m[3])
	minetest.register_tool("technic:laser_mk"..m[1], {
		description = S("Mining Laser Mk%d"):format(m[1]),
		inventory_image = "technic_mining_laser_mk"..m[1]..".png",
		stack_max = 1,
		wear_represents = "technic_RE_charge",
		on_refill = technic.refill_RE_charge,
		on_use = function(itemstack, user)
			local meta = minetest.deserialize(itemstack:get_metadata())
			if not meta
			or not meta.charge
			or meta.charge == 0 then
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
			laser_shoot(user, range, "technic_laser_beam_mk"..m[1]..".png", "technic_laser_mk"..m[1])
			if not technic.creative_mode then
				meta.charge = math.max(meta.charge - m[4], 0)
				technic.set_RE_wear(itemstack, meta.charge, m[3])
				itemstack:set_metadata(minetest.serialize(meta))
			end
			return itemstack
		end,
	})
end
