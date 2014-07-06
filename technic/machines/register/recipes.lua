
technic.recipes = {cooking = {numitems = 1}}
function technic.register_recipe_type(typename, desc, numitems)
	numitems = numitems or 1
	if unified_inventory and unified_inventory.register_craft_type then
		unified_inventory.register_craft_type(typename, {
			description = desc,
			height = numitems,
			width = 1,
		})
	end
	technic.recipes[typename] = {numitems = numitems, recipes = {}}
end

local function get_recipe_index(items)
	local l = {}
	for i, stack in ipairs(items) do
		l[i] = ItemStack(stack):get_name()
	end
	table.sort(l)
	return table.concat(l, "/")
end

local function register_recipe(typename, data)
	-- Handle aliases
	for i, stack in ipairs(data.input) do
		data.input[i] = ItemStack(stack):to_string()
	end
	data.output = ItemStack(data.output):to_string()
	
	local recipe = {time = data.time, input = {}, output = data.output}
	local index = get_recipe_index(data.input)
	for _, stack in ipairs(data.input) do
		recipe.input[ItemStack(stack):get_name()] = ItemStack(stack):get_count()
	end
	
	technic.recipes[typename].recipes[index] = recipe
	if unified_inventory then
		unified_inventory.register_craft({
			type = typename,
			output = data.output,
			items = data.input,
			width = 0,
		})
	end
end

function technic.register_recipe(typename, data)
	minetest.after(0.01, register_recipe, typename, data) -- Handle aliases
end

function technic.get_recipe(typename, items)
	if typename == "cooking" then -- Already builtin in Minetest, so use that
		local result, new_input = minetest.get_craft_result({
			method = "cooking",
			width = 1,
			items = items})
		-- Compatibility layer
		if not result or result.time == 0 then
			return nil
		else
			return {time = result.time,
			        new_input = new_input.items,
			        output = result.item}
		end
	end
	local index = get_recipe_index(items)
	local recipe = technic.recipes[typename].recipes[index]
	if recipe then
		local new_input = {}
		for i, stack in ipairs(items) do
			if stack:get_count() < recipe.input[stack:get_name()] then
				print(stack:get_name())
				return nil
			else
				new_input[i] = ItemStack(stack)
				new_input[i]:take_item(recipe.input[stack:get_name()])
			end
		end
		return {time = recipe.time,
		        new_input = new_input,
		        output = recipe.output}
	else
		return nil
	end
end


