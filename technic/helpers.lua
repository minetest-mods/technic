minetest.swap_node = minetest.swap_node or function(pos, node)
	local oldmeta = minetest.get_meta(pos):to_table()
	minetest.set_node(pos, node)
	minetest.get_meta(pos):from_table(oldmeta)
end

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
