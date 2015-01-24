-- Only changes name, keeps other params
function technic.swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name ~= name then
		node.name = name
		minetest.swap_node(pos, node)
	end
	return node.name
end

-- Fully charge RE chargeable item.
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

local function resolve_name(function_name)
	local a = _G
	for key in string.gmatch(function_name, "([^%.]+)(%.?)") do
		if a[key] then
			a = a[key]
		else
			return nil
		end
	end
	return a
end

function technic.function_exists(function_name)
	return type(resolve_name(function_name)) == 'function'
end

-- if the node is loaded, returns it. If it isn't loaded, load it and return nil.
function technic.get_or_load_node(pos)
	local node_or_nil = minetest.get_node_or_nil(pos)
	if node_or_nil then return node_or_nil end
	local vm = VoxelManip()
	local MinEdge, MaxEdge = vm:read_from_map(pos, pos)
	return nil
end
