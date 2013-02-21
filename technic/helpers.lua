function get_item_meta (string)
	if string.find(string, "return {") then
		return minetest.deserialize(string)
	else return nil
	end
end

function set_item_meta (table)
	return minetest.serialize(table)
end
