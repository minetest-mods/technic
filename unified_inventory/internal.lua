
function unified_inventory.get_formspec(player, page)
	if not player then
		return ""
	end
	local player_name = player:get_player_name()
	unified_inventory.current_page[player_name] = page

	local formspec = "size[14,10]"

	-- Player inventory
	formspec = formspec .. "list[current_player;main;0,4.5;8,4;]"

	-- Background
	formspec = formspec .. "background[-0.19,-0.2;14.38,10.55;ui_form_bg.png]"
	
	-- Current page
	if unified_inventory.pages[page] then
		formspec = unified_inventory.pages[page].get_formspec(player, formspec)
	else
		return "" -- Invalid page name
	end

	-- Main buttons
	local i = 0
	for i, def in pairs(unified_inventory.buttons) do
		if def.type == "image" then
			formspec = formspec.."image_button["
					..(0.65 * i)..",9;0.8,0.8;"
					..minetest.formspec_escape(def.image)..";"
					..minetest.formspec_escape(def.name)..";]"
		end
		i = i + 1
	end

	-- Controls to flip items pages
	local start_x = 9.2
	formspec = formspec .. "image_button["..(start_x + 0.6 * 0)..",9;.8,.8;ui_skip_backward_icon.png;start_list;]"
	formspec = formspec .. "image_button["..(start_x + 0.6 * 1)..",9;.8,.8;ui_doubleleft_icon.png;rewind3;]"
	formspec = formspec .. "image_button["..(start_x + 0.6 * 2)..",9;.8,.8;ui_left_icon.png;rewind1;]"
	formspec = formspec .. "image_button["..(start_x + 0.6 * 3)..",9;.8,.8;ui_right_icon.png;forward1;]"
	formspec = formspec .. "image_button["..(start_x + 0.6 * 4)..",9;.8,.8;ui_doubleright_icon.png;forward3;]"
	formspec = formspec .. "image_button["..(start_x + 0.6 * 5)..",9;.8,.8;ui_skip_forward_icon.png;end_list;]"

	-- Search box
	formspec = formspec .. "field[9.5,8.325;3,1;searchbox;;]"
	formspec = formspec .. "image_button[12.2,8.1;.8,.8;ui_search_icon.png;searchbutton;]"

	-- Items list
	local list_index = unified_inventory.current_index[player_name]
	local page = math.floor(list_index / (80) + 1)
	local pagemax = math.floor((unified_inventory.filtered_items_list_size[player_name] - 1) / (80) + 1)
	local image = nil
	local item = {}
	for y = 0, 9 do
	for x = 0, 7 do
		name = unified_inventory.filtered_items_list[player_name][list_index]	
		if minetest.registered_items[name] then
			formspec = formspec.."item_image_button["
					..(8.2 + x * 0.7)..","
					..(1   + y * 0.7)..";.81,.81;"
					..name..";item_button"
					..list_index..";]"
			list_index = list_index + 1
		end
	end
	end
	formspec = formspec.."label[8.2,0;Page:]"
	formspec = formspec.."label[9,0;"..page.." of "..pagemax.."]"
	formspec = formspec.."label[8.2,0.4;Filter:]"
	formspec = formspec.."label[9,0.4;"..unified_inventory.activefilter[player_name].."]"
	return formspec
end

function unified_inventory.set_inventory_formspec(player, page)
	if player then
		local formspec = unified_inventory.get_formspec(player, page)
		player:set_inventory_formspec(formspec)
	end
end

--apply filter to the inventory list (create filtered copy of full one)
function unified_inventory.apply_filter(player, filter)
	local player_name = player:get_player_name() 
	local size = 0
	local lfilter = string.lower(filter)
	if lfilter ~= "" then 
		for i=1, lfilter:len() do
			if lfilter:sub(i, i) == '[' then 
				str_temp1 = ""
				break
			end
		end
	end
	unified_inventory.filtered_items_list[player_name]={}
	for name, def in pairs(minetest.registered_items) do
		if (not def.groups.not_in_creative_inventory or
		   def.groups.not_in_creative_inventory == 0)
		   and def.description and def.description ~= "" then
			local lname = string.lower(name)
			local ldesc = string.lower(def.description)
			if string.find(lname, lfilter) or string.find(ldesc, lfilter) then
				table.insert(unified_inventory.filtered_items_list[player_name], name)
				size = size + 1
			end
		end
	
	end
	table.sort(unified_inventory.filtered_items_list[player_name])
	unified_inventory.filtered_items_list_size[player_name] = size
	unified_inventory.current_index[player_name] = 1
	unified_inventory.activefilter[player_name] = filter
	unified_inventory.set_inventory_formspec(player,
			unified_inventory.current_page[player_name])
end


-- update_recipe
function unified_inventory.update_recipe(player, stack_name, alternate)
	local inv = minetest.get_inventory({
		type = "detached",
		name = player:get_player_name().."craftrecipe"
	})	
	for i = 0, inv:get_size("build") do
		inv:set_stack("build", i, nil)
	end
	inv:set_stack("output", 1, nil)
	alternate = tonumber(alternate) or 1
	local crafts = unified_inventory.crafts_table[stack_name]
	--print(dump(crafts))
	if next(crafts) == nil then -- No craft recipes
		return
	end
	if alternate < 1 or alternate > #crafts then
		alternate = 1
	end
	local craft = crafts[alternate]
	inv:set_stack("output", 1, craft.output)
	local items = craft.items

	if craft.type == "cooking" or
	   craft.type == "fuel" or
	   craft.type == "grinding" or
	   craft.type == "extracting" or
	   craft.type == "compressing" then
		def = unified_inventory.find_item_def(craft["items"][1])
		if def then
			inv:set_stack("build", 1, def)
		end
		return
	end
	if craft.width == 0 then
		for i = 1, 3 do
			if craft.items[i] then
				def = unified_inventory.find_item_def(craft.items[i])
				if def then
					inv:set_stack("build", i, def)
				end
			end
		end
	end
	if craft.width == 1 then
		local build_table={1, 4, 7}
		for i = 1, 3 do
			if craft.items[i] then
				def = unified_inventory.find_item_def(craft.items[i])
				if def then
					inv:set_stack("build", build_table[i], def)
				end
			end
		end
	end
	if craft.width == 2 then
		local build_table = {1, 2, 4, 5, 7, 8}
		for i=1, 6 do
			if craft.items[i] then
				def = unified_inventory.find_item_def(craft.items[i])
				if def then
					inv:set_stack("build", build_table[i], def)
				end
			end
		end
	end
	if craft.width == 3 then
		for i=1, 9 do
			if craft.items[i] then
				def = unified_inventory.find_item_def(craft.items[i])
				if def then
					inv:set_stack("build", i, def)
				end
			end
		end
	end
end

function unified_inventory.find_item_def(def)
	if type(def) ~= "string" then
		return nil
	end
	if string.find(def, "group:") then
		def = string.gsub(def, "group:", "")
		def = string.gsub(def, "\"", "")
		if minetest.registered_nodes["default:"..def] then
			return "default:"..def
		end
		local items = unified_inventory.items_in_group(def)
		return items[1]
	else
		return def
	end
end

function unified_inventory.items_in_group(groups)
	local items = {}
	for name, item in pairs(minetest.registered_items) do
		for _, group in pairs(groups:split(',')) do
			if item.groups[group] then
				table.insert(items, name)
			end
		end
	end
	return items
end
