local sonic_screwdriver_max_charge = 15000
technic.register_power_tool("technic:sonic_screwdriver", sonic_screwdriver_max_charge)

minetest.register_tool("technic:sonic_screwdriver", {
	description = "Sonic Screwdriver",
	inventory_image = "technic_sonic_screwdriver.png",
	on_use = function(itemstack, user, pointed_thing)
		-- Must be pointing to facedir applicable node
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = minetest.get_pointed_thing_position(pointed_thing, above)
		local node = minetest.get_node(pos)
		local node_name = node.name
		if minetest.registered_nodes[node_name].paramtype2 ~= "facedir" and
		   minetest.registered_nodes[node_name].paramtype2 ~= "wallmounted" then
			return itemstack
		end
		if node.param2 == nil then
			return
		end
		local meta1 = get_item_meta(itemstack:get_metadata())
		if not meta1 or not meta1.charge then
			return
		end
		if meta1.charge - 100 > 0 then
			minetest.sound_play("technic_sonic_screwdriver",
					{pos = pos, gain = 0.3, max_hear_distance = 10})
			local p = node.param2
			if minetest.registered_nodes[node_name].paramtype2 == "facedir" then
				p = p + 1
				if p == 4 then
					p = 0
				end
			else
				p = p + 1
				if p == 6 then
					p = 0
				end
			end
			-- hacky_swap_node, unforunatly.
			local meta = minetest.get_meta(pos)
			local meta0 = meta:to_table()
			node.param2 = p
			minetest.set_node(pos, node)
			meta = minetest.get_meta(pos)
			meta:from_table(meta0)

			meta1.charge = meta1.charge - 100  
			itemstack:set_metadata(set_item_meta(meta1))
			technic.set_RE_wear(itemstack, meta1.charge, sonic_screwdriver_max_charge)
		end
		return itemstack
	end, 
})
 
minetest.register_craft({
	output = "technic:sonic_screwdriver",
	recipe = {
		{"default:diamond"},
		{"technic:battery"},
		{"technic:stainless_steel_ingot"}
		}
})
