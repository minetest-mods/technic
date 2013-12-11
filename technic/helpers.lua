function get_item_meta (string)
	if string.find(string, "return {") then
		return minetest.deserialize(string)
	else return nil
	end
end

function set_item_meta (table)
	return minetest.serialize(table)
end

function has_locked_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end

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

