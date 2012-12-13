technic.creative_inventory_size = 0
technic.creative_list = {}

-- Create detached creative inventory after loading all mods
minetest.after(0, function()
	local inv = minetest.create_detached_inventory("technic_creative", {})
	technic.creative_list = {}
	for name,def in pairs(minetest.registered_items) do
		if (not def.groups.not_in_creative_inventory or def.groups.not_in_creative_inventory == 0)
				and def.description and def.description ~= "" then
			table.insert(technic.creative_list, name)
		end
	end
	table.sort(technic.creative_list)
	--inv:set_size("main", #technic.creative_list)
	--for _,itemstring in ipairs(technic.creative_list) do
	--	local stack = ItemStack(itemstring)
	--	inv:add_item("main", stack)
	--end
	--technic.creative_inventory_size = #technic.creative_list
end)
