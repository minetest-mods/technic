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


-- Based on code by Uberi: https://gist.github.com/Uberi/3125280
function technic.trace_node_ray(pos, dir, range)
	local p = vector.round(pos)
	local x_step,      y_step,      z_step      = 0, 0, 0
	local x_component, y_component, z_component = 0, 0, 0
	local x_intersect, y_intersect, z_intersect = 0, 0, 0

	if dir.x == 0 then
		x_intersect = math.huge
	elseif dir.x > 0 then
		x_step = 1
		x_component = 1 / dir.x
		x_intersect = x_component
	else
		x_step = -1
		x_component = 1 / -dir.x
	end
	if dir.y == 0 then
		y_intersect = math.huge
	elseif dir.y > 0 then
		y_step = 1
		y_component = 1 / dir.y
		y_intersect = y_component
	else
		y_step = -1
		y_component = 1 / -dir.y
	end
	if dir.z == 0 then
		z_intersect = math.huge
	elseif dir.z > 0 then
		z_step = 1
		z_component = 1 / dir.z
		z_intersect = z_component
	else
		z_step = -1
		z_component = 1 / -dir.z
	end

	return function()
		if x_intersect < y_intersect then
			if x_intersect < z_intersect then
				p.x = p.x + x_step
				x_intersect = x_intersect + x_component
			else
				p.z = p.z + z_step
				z_intersect = z_intersect + z_component
			end
		elseif y_intersect < z_intersect then
			p.y = p.y + y_step
			y_intersect = y_intersect + y_component
		else
			p.z = p.z + z_step
			z_intersect = z_intersect + z_component
		end
		if vector.distance(pos, p) > range then
			return nil
		end
		return p
	end
end

