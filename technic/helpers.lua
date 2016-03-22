local digit_sep_esc
do
	local sep = technic.config:get("digit_separator")
	sep = tonumber(sep) and string.char(sep) or sep or " "
	-- Escape for gsub
	for magic in ("().%+-*?[^$"):gmatch(".") do
		if sep == magic then
			sep = "%"..sep
		end
	end
	digit_sep_esc = sep
end


function technic.pretty_num(num)
	local str, k = tostring(num), nil
	repeat
		str, k = str:gsub("^(-?%d+)(%d%d%d)", "%1"..digit_sep_esc.."%2")
	until k == 0
	return str
end


--- Same as minetest.swap_node, but only changes name
-- and doesn't re-set if already set.
function technic.swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name ~= name then
		node.name = name
		minetest.swap_node(pos, node)
	end
end


--- Fully charge RE chargeable item.
-- Must be defined early to reference in item definitions.
function technic.refill_RE_charge(stack)
	local max_charge = technic.power_tools[stack:get_name()]
	if not max_charge then return stack end
	technic.set_RE_wear(stack, max_charge, max_charge)
	local meta = minetest.deserialize(stack:get_metadata()) or {}
	meta.charge = max_charge
	stack:set_metadata(minetest.serialize(meta))
	return stack
end


-- If the node is loaded, returns it.  If it isn't loaded, load it and return nil.
function technic.get_or_load_node(pos)
	local node = minetest.get_node_or_nil(pos)
	if node then return node end
	local vm = VoxelManip()
	local MinEdge, MaxEdge = vm:read_from_map(pos, pos)
	return nil
end


technic.tube_inject_item = pipeworks.tube_inject_item or function(pos, start_pos, velocity, item)
	local tubed = pipeworks.tube_item(vector.new(pos), item)
	tubed:get_luaentity().start_pos = vector.new(start_pos)
	tubed:setvelocity(velocity)
	tubed:setacceleration(vector.new(0, 0, 0))
end


--- Iterates over the node positions along the specified ray.
-- The returned positions will not include the starting position.
function technic.trace_node_ray(pos, dir, range)
	local x_step = dir.x > 0 and 1 or -1
	local y_step = dir.y > 0 and 1 or -1
	local z_step = dir.z > 0 and 1 or -1

	local i = 1
	return function(p)
		-- Approximation of where we should be if we weren't rounding
		-- to nodes.  This moves forward a bit faster then we do.
		-- A correction is done below.
		local real_x = pos.x + (dir.x * i)
		local real_y = pos.y + (dir.y * i)
		local real_z = pos.z + (dir.z * i)

		-- How far off we've gotten from where we should be.
		local dx = math.abs(real_x - p.x)
		local dy = math.abs(real_y - p.y)
		local dz = math.abs(real_z - p.z)

		-- If the real position moves ahead too fast, stop it so we
		-- can catch up.  If it gets too far ahead it will smooth
		-- out our movement too much and we won't turn fast enough.
		if dx + dy + dz < 2 then
			i = i + 1
		end

		-- Step in whichever direction we're most off course in.
		if dx > dy then
			if dx > dz then
				p.x = p.x + x_step
			else
				p.z = p.z + z_step
			end
		elseif dy > dz then
			p.y = p.y + y_step
		else
			p.z = p.z + z_step
		end
		if vector.distance(pos, p) > range then
			return nil
		end
		return p
	end, vector.round(pos)
end


--- Like trace_node_ray, but includes extra positions close to the ray.
function technic.trace_node_ray_fat(pos, dir, range)
	local x_step = dir.x > 0 and 1 or -1
	local y_step = dir.y > 0 and 1 or -1
	local z_step = dir.z > 0 and 1 or -1

	local next_poses = {}

	local i = 1
	return function(p)
		local ni, np = next(next_poses)
		if np then
			next_poses[ni] = nil
			return np
		end

		-- Approximation of where we should be if we weren't rounding
		-- to nodes.  This moves forward a bit faster then we do.
		-- A correction is done below.
		local real_x = pos.x + (dir.x * i)
		local real_y = pos.y + (dir.y * i)
		local real_z = pos.z + (dir.z * i)

		-- How far off we've gotten from where we should be.
		local dx = math.abs(real_x - p.x)
		local dy = math.abs(real_y - p.y)
		local dz = math.abs(real_z - p.z)

		-- If the real position moves ahead too fast, stop it so we
		-- can catch up.  If it gets too far ahead it will smooth
		-- out our movement too much and we won't turn fast enough.
		if dx + dy + dz < 2 then
			i = i + 1
		end

		-- Step in whichever direction we're most off course in.
		local sx, sy, sz  -- Whether we've already stepped along each axis
		if dx > dy then
			if dx > dz then
				sx = true
				p.x = p.x + x_step
			else
				sz = true
				p.z = p.z + z_step
			end
		elseif dy > dz then
			sy = true
			p.y = p.y + y_step
		else
			sz = true
			p.z = p.z + z_step
		end

		if vector.distance(pos, p) > range then
			return nil
		end

		-- Add other positions that we're significantly off on.
		-- We can just use fixed integer keys here because the
		-- table will be completely cleared before we reach this
		-- code block again.
		local dlen = math.sqrt(dx*dx + dy*dy + dz*dz)
		-- Normalized axis deltas
		local dxn, dyn, dzn = dx / dlen, dy / dlen, dz / dlen
		if not sx and dxn > 0.5 then
			next_poses[1] = vector.new(p.x + x_step, p.y, p.z)
		end
		if not sy and dyn > 0.5 then
			next_poses[2] = vector.new(p.x, p.y + y_step, p.z)
		end
		if not sz and dzn > 0.5 then
			next_poses[3] = vector.new(p.x, p.y, p.z + z_step)
		end

		return p
	end, vector.round(pos)
end

