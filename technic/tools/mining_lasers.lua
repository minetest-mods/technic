local mining_lasers_list = {
--	{<num>, <range of the laser shots>, <max_charge>, <charge_per_shot>},
	{"1", 7, 50000, 1000},
	{"2", 14, 200000, 2000},
	{"3", 21, 650000, 3000},
}

local S = technic.getter

minetest.register_craft({
	output = 'technic:laser_mk1',
	recipe = {
		{'default:diamond', 'technic:brass_ingot',        'default:obsidian_glass'},
		{'',                'technic:brass_ingot',        'technic:red_energy_crystal'},
		{'',                '',                           'default:copper_ingot'},
	}
})
minetest.register_craft({
	output = 'technic:laser_mk2',
	recipe = {
		{'default:diamond', 'technic:carbon_steel_ingot', 'technic:laser_mk1'},
		{'',                'technic:carbon_steel_ingot', 'technic:green_energy_crystal'},
		{'',                '',                           'default:copper_ingot'},
	}
})
minetest.register_craft({
	output = 'technic:laser_mk3',
	recipe = {
		{'default:diamond', 'technic:carbon_steel_ingot', 'technic:laser_mk2'},
		{'',                'technic:carbon_steel_ingot', 'technic:blue_energy_crystal'},
		{'',                '',                           'default:copper_ingot'},
	}
})

local function table_icontains(t, v)
	for i = 1,#t do
		if v == t[i] then
			return true
		end
	end
	return false
end

local function laser_node(pos, player)
	local node = minetest.get_node(pos)
	if table_icontains({"air", "ignore", "default:lava_source", "default:lava_flowing"}, node.name) then
		return
	end
	local pname = player:get_player_name()
	if minetest.is_protected(pos, pname) then
		minetest.record_protection_violation(pos, pname)
		return
	end
	if table_icontains({"default:water_flowing", "default:water_source"}, node.name) then
		minetest.remove_node(pos)
		minetest.add_particle({
			pos = pos,
			vel = {x=0, y=2, z=0},
			acc = {x=0, y=-1, z=0},
			expirationtime = 1.5,
			size = 6+math.random()*2,
			texture = "smoke_puff.png^[transform"..math.random(0,7),
		})
		return
	end
	if player then
		minetest.node_dig(pos, node, player)
	end
end

if not vector.line then
	dofile(technic.modpath.."/tools/vector_line.lua")
end

local function laser_shoot(player, range, particle_texture, sound)
	local playerpos = player:getpos()
	local dir = player:get_look_dir()

	local startpos = {x = playerpos.x, y = playerpos.y + 1.625, z = playerpos.z}
	local mult_dir = vector.multiply(dir, 50)
	minetest.add_particle({
		pos = startpos,
		vel = dir,
		acc = mult_dir,
		expirationtime = range / 11,
		size = 1,
		texture = particle_texture.."^[transform"..math.random(0,7),
	})
	for _,pos in ipairs(vector.line(vector.round(startpos), dir, range)) do
		laser_node(pos, player)
	end
	minetest.sound_play(sound, {pos = playerpos, max_hear_distance = range})
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
			if not meta or not meta.charge then
				return
			end

			-- If there's enough charge left, fire the laser
			if meta.charge >= m[4] then
				meta.charge = meta.charge - m[4]
				laser_shoot(user, m[2], "technic_laser_beam_mk"..m[1]..".png", "technic_laser_mk"..m[1])
				technic.set_RE_wear(itemstack, meta.charge, m[3])
				itemstack:set_metadata(minetest.serialize(meta))
			end
			return itemstack
		end,
	})
end

