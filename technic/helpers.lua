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

