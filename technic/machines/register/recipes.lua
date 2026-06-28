local ui_version = core.get_modpath("unified_inventory") and unified_inventory.version
local cg_version = core.get_modpath("craftguide")
local i3_version = core.get_modpath("i3")

-- Mod compatibility pre-check.
if cg_version and (not craftguide.register_craft or not craftguide.register_craft_type) then
	core.log("warning", "[technic] Unsupported 'craftguide' version.")
	cg_version = nil
end


technic.recipes = { cooking = { input_size = 1, output_size = 1 } }
function technic.register_recipe_type(typename, origdata)
	local data = {}
	for k, v in pairs(origdata) do data[k] = v end
	data.input_size = data.input_size or 1
	data.output_size = data.output_size or 1

	if ui_version and (unified_inventory.version >= 6 or data.output_size == 1) then
		unified_inventory.register_craft_type(typename, {
			description = data.description,
			width = data.input_size,
			height = 1,
		})
	end
	if data.output_size == 1 then
		if cg_version then
			craftguide.register_craft_type(typename, {
				description = data.description,
			})
		end
		if i3_version then
			i3.register_craft_type(typename, {
				description = data.description,
			})
		end
	end
	data.recipes = {}
	technic.recipes[typename] = data
end

--- @brief  Generates a (hopefully) unique hash from the given input items
--- @return Sorted item names. '/' delimited. e.g. "boo:baz/firstmod:foo/othermod:bar"
local function get_recipe_index(items)
	if type(items) ~= "table" then
		return false
	end

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
		for i, stack in ipairs(data.output) do
			data.output[i] = ItemStack(stack):to_string()
		end
	else
		data.output = ItemStack(data.output):to_string()
	end

	local type_def = technic.recipes[typename]

	-- (Try to) add the recipe to the technic-internal recipe list
	do
		local recipe = {time = data.time, input = {}, output = data.output}
		local index = get_recipe_index(data.input)
		if not index then
			print("[Technic] ignored registration of garbage recipe!")
			return
		end

		-- Convert inputs to the format "default:apple 3"
		for _, itemstring in ipairs(data.input) do
			local stack = ItemStack(itemstring)
			recipe.input[stack:get_name()] = stack:get_count()
		end
		type_def.recipes[index] = recipe
	end

	-- For craft guides only supporting 1 output
	local result_1 = data.output
	if type(result_1) == "table" then
		result_1 = result_1[1]
	end

	-- Add the recipe to the supported craft guides
	if ui_version then
		unified_inventory.register_craft({
			type = typename,
			output = (ui_version >= 6) and data.output or result_1,
			items = data.input,
			width = 0,
		})
	end
	if type_def.output_size == 1 then
		if cg_version then
			craftguide.register_craft({
				type = typename,
				result = result_1,
				items = data.input,
			})
		end
		if i3_version then
			i3.register_craft({
				type = typename,
				result = result_1,
				items = data.input,
			})
		end
	end
end

local recipes_to_register = {}
function technic.register_recipe(typename, data)
	assert(typename)
	assert(data.input)
	assert(data.output)

	-- Postpone to handle aliases
	table.insert(recipes_to_register, {
		typename,
		data
	})
end

core.register_on_mods_loaded(function()
	for _, def in ipairs(recipes_to_register) do
		register_recipe(def[1], def[2])
	end
	recipes_to_register = nil
end)

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


