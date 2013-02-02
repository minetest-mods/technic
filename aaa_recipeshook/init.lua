crafts_table ={}
crafts_table_count=0
UI_recipes_hook=true

-- override minetest.register_craft
local minetest_register_craft = minetest.register_craft
minetest.register_craft = function (options) 
	register_craft(options)
	if options.type=="alloy" or options.type=="grinding" then return end
	minetest_register_craft(options) 
end

-- register_craft
register_craft = function(options)
	if  options.output == nil then
		return
	end
	local itemstack = ItemStack(options.output)
	if itemstack:is_empty() then
		return
	end
	if crafts_table[itemstack:get_name()]==nil then
		crafts_table[itemstack:get_name()] = {}
	end
	table.insert(crafts_table[itemstack:get_name()],options)
	crafts_table_count=crafts_table_count+1
end


