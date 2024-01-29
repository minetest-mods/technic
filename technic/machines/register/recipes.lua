local have_ui = minetest.get_modpath("unified_inventory")
local have_cg = minetest.get_modpath("craftguide")
local have_i3 = minetest.get_modpath("i3")

technic.recipes = { cooking = { input_size = 1, output_size = 1 } }
function technic.register_recipe_type(typename, origdata)
	local data = {}
	for k, v in pairs(origdata) do data[k] = v end
	data.input_size = data.input_size or 1
	data.output_size = data.output_size or 1
	if data.output_size == 1 then
		if have_ui and unified_inventory.register_craft_type then
			unified_inventory.register_craft_type(typename, {
				description = data.description,
				width = data.input_size,
				height = 1,
			})
		end
		if have_cg and craftguide.register_craft_type then
			craftguide.register_craft_type(typename, {
				description = data.description,
			})
		end
		if have_i3 then
			i3.register_craft_type(typename, {
				description = data.description,
			})
		end
	end
	data.recipes = {}
	technic.recipes[typename] = data
end

local function get_recipe_index(items)
	if not items or type(items) ~= "table" then return false end
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
	if type(data.output) == "table" then
		for i, v in ipairs(data.output) do
			data.output[i] = ItemStack(data.output[i]):to_string()
		end
	else
		data.output = ItemStack(data.output):to_string()
	end

	local recipe = {time = data.time, input = {}, output = data.output}
	local index = get_recipe_index(data.input)
	if not index then
		print("[Technic] ignored registration of garbage recipe!")
		return
	end
	for _, stack in ipairs(data.input) do
		recipe.input[ItemStack(stack):get_name()] = ItemStack(stack):get_count()
	end

	technic.recipes[typename].recipes[index] = recipe
	if have_ui and technic.recipes[typename].output_size == 1 then
		unified_inventory.register_craft({
			type = typename,
			output = data.output,
			items = data.input,
			width = 0,
		})
	end
	if (have_cg or have_i3) and technic.recipes[typename].output_size == 1 then
		local result = data.output
		if (type(result)=="table") then
			result = result[1]
		end
		local items = table.concat(data.input, ", ")
		if have_cg and craftguide.register_craft then
			craftguide.register_craft({
				type = typename,
				result = result,
				items = {items},
			})
		end
		if have_i3 then
			i3.register_craft({
				type = typename,
				result = result,
				items = {items},
			})
		end
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
	if not index then
		print("[Technic] ignored registration of garbage recipe!")
		return
	end
	local recipe = technic.recipes[typename].recipes[index]
    if recipe then
        local new_input = {}
        for i, stack in ipairs(items) do
            local input_count = recipe.input[stack:get_name()]
            if input_count == nil then
                -- Handle nil value, maybe return nil or log a warning
                return nil
            end
            if stack:get_count() < input_count then
                return nil
            else
                new_input[i] = ItemStack(stack)
                new_input[i]:take_item(input_count)
            end
        end
        return {time = recipe.time, new_input = new_input, output = recipe.output}
    else
        return nil
    end
end


