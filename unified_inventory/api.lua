--data tables definitions
unified_inventory = {}
unified_inventory.players = {}
unified_inventory.current_page = {}
unified_inventory.current_index = {}
unified_inventory.items_list_size = 0
unified_inventory.items_list = {}
unified_inventory.filtered_items_list_size = {}
unified_inventory.filtered_items_list = {}
unified_inventory.activefilter = {}
unified_inventory.alternate = {}
unified_inventory.current_item = {}
unified_inventory.crafts_table ={}
unified_inventory.crafts_table_count=0

-- default inventory page
unified_inventory.default = "craft"

-- homepos stuff
local home_gui = {}
local homepos = {}
unified_inventory.home_filename = minetest.get_worldpath()..'/unified_inventory_home'

-- Create detached creative inventory after loading all mods
minetest.after(0.01, function()
	unified_inventory.items_list = {}
	for name,def in pairs(minetest.registered_items) do
		if (not def.groups.not_in_creative_inventory or def.groups.not_in_creative_inventory == 0)
				and def.description and def.description ~= "" then
			table.insert(unified_inventory.items_list, name)
			local recipes=minetest.get_all_craft_recipes(name)
			if unified_inventory.crafts_table[name]==nil then
				unified_inventory.crafts_table[name] = {}
			end
			if recipes then 
				for i=1,#recipes,1 do
					table.insert(unified_inventory.crafts_table[name],recipes[i])
				end
			end
		end
	end
	--print(dump(unified_inventory.crafts_table))
	table.sort(unified_inventory.items_list)
	unified_inventory.items_list_size = #unified_inventory.items_list
	print ("Unified Inventory. inventory size: "..unified_inventory.items_list_size)
end)

-- register_on_joinplayer
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	unified_inventory.players[player_name]={}
	unified_inventory.current_index[player_name] = 1
	unified_inventory.filtered_items_list[player_name] = {}
	unified_inventory.filtered_items_list[player_name] = unified_inventory.items_list
	unified_inventory.filtered_items_list_size[player_name]=unified_inventory.items_list_size
	unified_inventory.activefilter[player_name]=""
	unified_inventory.apply_filter(player, "")
	unified_inventory.alternate[player_name] = 1
	unified_inventory.current_item[player_name] =nil
	unified_inventory.set_inventory_formspec(player,unified_inventory.get_formspec(player, unified_inventory.default))
	
--crafting guide inventories
local inv = minetest.create_detached_inventory(player:get_player_name().."craftrecipe",{
	allow_put = function(inv, listname, index, stack, player)
		return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			if minetest.setting_getbool("creative_mode") then
				return stack:get_count()
			else
				return 0
			end
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
	})
inv:set_size("output", 1)
inv:set_size("build", 3*3)

-- refill slot
unified_inventory.refill = minetest.create_detached_inventory(player_name.."refill", {
	allow_put = function(inv, listname, index, stack, player)
		if minetest.setting_getbool("creative_mode") then
			return stack:get_count()
		else
			return 0
		end
	end,
	on_put = function(inv, listname, index, stack, player)
		inv:set_stack(listname, index, ItemStack(stack:get_name().." "..stack:get_stack_max()))
		minetest.sound_play("electricity", {to_player=player_name, gain = 1.0})
	end,
})
unified_inventory.refill:set_size("main", 1)

-- trash slot
unified_inventory.trash = minetest.create_detached_inventory("trash", {
	allow_put = function(inv, listname, index, stack, player)
		if minetest.setting_getbool("creative_mode") then
			return stack:get_count()
		else
			return 0
		end
	end,
	on_put = function(inv, listname, index, stack, player)
		inv:set_stack(listname, index, nil)
		local player_name=player:get_player_name()
		minetest.sound_play("trash", {to_player=player_name, gain = 1.0})
	end,
})
unified_inventory.trash:set_size("main", 1)
end)

-- set_inventory_formspec
unified_inventory.set_inventory_formspec = function(player,formspec)
	if player then
		player:set_inventory_formspec(formspec)
	end
end

-- get_formspec
unified_inventory.get_formspec = function(player,page)
	if player==nil then return "" end
	local player_name = player:get_player_name()
	unified_inventory.current_page[player_name]=page
	
	local formspec = "size[14,10]"

	-- player inventory
	formspec = formspec .. "list[current_player;main;0,4.5;8,4;]"

	-- backgrounds
		formspec = formspec .. "background[-0.19,-0.2,;14.38,10.55;ui_form_bg.png]"
	if page=="craft" then
		formspec = formspec .. "background[0.06,0.99,;7.92,7.52;ui_crafting_form.png]"
		end
	if page=="craftguide" then
		formspec = formspec .. "background[0.06,0.99,;7.92,7.52;ui_craftguide_form.png]"
		end
	if page=="misc" then
		formspec = formspec .. "background[0.06,0.99,;7.92,7.52;ui_misc_form.png]"
		end
	if page=="bags" then
		formspec = formspec .. "background[0.06,0.99,;7.92,7.52;ui_bags_main_form.png]"
		end

	for i=1,4 do
		if page=="bag"..i then
			local slots = player:get_inventory():get_stack(page, 1):get_definition().groups.bagslots
			if slots == 8 then
				formspec = formspec .. "background[0.06,0.99,;7.92,7.52;ui_bags_sm_form.png]"
			elseif slots == 16 then
				formspec = formspec .. "background[0.06,0.99,;7.92,7.52;ui_bags_med_form.png]"
			elseif slots == 24 then
				formspec = formspec .. "background[0.06,0.99,;7.92,7.52;ui_bags_lg_form.png]"
			end
		end
	end

	-- main buttons
		local start_x=0
		formspec = formspec .. "image_button["..(start_x+.65*0)..",9;.8,.8;ui_craft_icon.png;craft;]"
		formspec = formspec .. "image_button["..(start_x+.65*1)..",9;.8,.8;ui_craftguide_icon.png;craftguide;]"
		formspec = formspec .. "image_button["..(start_x+.65*2)..",9;.8,.8;ui_bags_icon.png;bags;]"
		formspec = formspec .. "image_button["..(start_x+.65*3)..",9;.8,.8;ui_sethome_icon.png;home_gui_set;]"
		formspec = formspec .. "image_button["..(start_x+.65*4)..",9;.8,.8;ui_gohome_icon.png;home_gui_go;]"
		if minetest.setting_getbool("creative_mode") then
		formspec = formspec .. "image_button["..(start_x+.65*5)..",9;.8,.8;ui_sun_icon.png;misc_set_day;]"
		formspec = formspec .. "image_button["..(start_x+.65*6)..",9;.8,.8;ui_moon_icon.png;misc_set_night;]"
		formspec = formspec .. "image_button["..(start_x+.65*7)..",9;.8,.8;ui_trash_icon.png;clear_inv;]"
		end
		
	--controls to flip items pages
		start_x=9.2
		formspec = formspec .. "image_button["..(start_x+.6*0)..",9;.8,.8;ui_skip_backward_icon.png;start_list;]"
		formspec = formspec .. "image_button["..(start_x+.6*1)..",9;.8,.8;ui_doubleleft_icon.png;rewind3;]"
		formspec = formspec .. "image_button["..(start_x+.6*2)..",9;.8,.8;ui_left_icon.png;rewind1;]"
		formspec = formspec .. "image_button["..(start_x+.6*3)..",9;.8,.8;ui_right_icon.png;forward1;]"
		formspec = formspec .. "image_button["..(start_x+.6*4)..",9;.8,.8;ui_doubleright_icon.png;forward3;]"
		formspec = formspec .. "image_button["..(start_x+.6*5)..",9;.8,.8;ui_skip_forward_icon.png;end_list;]"
		
	-- search box
		formspec = formspec .. "field[9.5,8.325;3,1;searchbox;;]"
		formspec = formspec .. "image_button[12.2,8.1;.8,.8;ui_search_icon.png;searchbutton;]"

	-- craft page
	if page=="craft" then
		formspec = formspec.."label[0,0;Crafting]"
		formspec = formspec.."list[current_player;craftpreview;6,1;1,1;]"
		formspec = formspec.."list[current_player;craft;2,1;3,3;]"
			if minetest.setting_getbool("creative_mode") then
				formspec = formspec.."label[0,2.5;Refill:]"
				formspec = formspec.."list[detached:"..player_name.."refill;main;0,3;1,1;]"
				formspec = formspec.."label[7,2.5;Trash:]"
				formspec = formspec.."list[detached:trash;main;7,3;1,1;]"
			end
		end

	-- craft guide page
	if page=="craftguide" then
		formspec = formspec.."label[0,0;Crafting Guide]"
		formspec = formspec.."list[detached:"..player_name.."craftrecipe;build;2,1;3,3;]"
		formspec = formspec.."list[detached:"..player_name.."craftrecipe;output;6,1;1,1;]"
		formspec = formspec.."label[2,0.5;Input:]"
		formspec = formspec.."label[6,0.5;Output:]"
		formspec = formspec.."label[6,2.6;Method:]"
		local item_name=unified_inventory.current_item[player_name]
		if item_name then
			formspec = formspec.."label[2,0;"..item_name.."]"	
			local alternates = 0
			local alternate = unified_inventory.alternate[player_name]
			local crafts = unified_inventory.crafts_table[item_name]

			if crafts ~= nil and #crafts>0 then
				alternates = #crafts
				local craft = crafts[alternate]
				local method = "Crafting"
				if craft.type == "shapeless" then
				method="Crafting"
				end	
				if craft.type == "cooking" then
				method="Cooking"
				end	
				if craft.type == "fuel" then
				method="Fuel"
				end	
				if craft.type == "grinding" then
				method="Grinding"
				end	
				if craft.type == "alloy" then
				method="Alloy cooking"
				end	
				formspec = formspec.."label[6,3;"..method.."]"
			end
			
			if alternates > 1 then
			formspec = formspec.."label[0,2.6;Recipe "..tostring(alternate).." of "..tostring(alternates).."]"
			formspec = formspec.."button[0,3.15;2,1;alternate;Alternate]"
			end
		end
	end

	-- bags
	if page=="bags" then
	formspec = formspec.."label[0,0;Bags]"
	formspec=formspec.."button[0,2;2,0.5;bag1;Bag 1]"
	formspec=formspec.."button[2,2;2,0.5;bag2;Bag 2]"
	formspec=formspec.."button[4,2;2,0.5;bag3;Bag 3]"
	formspec=formspec.."button[6,2;2,0.5;bag4;Bag 4]"
	formspec=formspec.."list[detached:"..player_name.."_bags;bag1;0.5,1;1,1;]"
	formspec=formspec.."list[detached:"..player_name.."_bags;bag2;2.5,1;1,1;]"
	formspec=formspec.."list[detached:"..player_name.."_bags;bag3;4.5,1;1,1;]"
	formspec=formspec.."list[detached:"..player_name.."_bags;bag4;6.5,1;1,1;]"
		end

	for i=1,4 do
		if page=="bag"..i then
			local image = player:get_inventory():get_stack("bag"..i, 1):get_definition().inventory_image
			formspec=formspec.."image[7,0;1,1;"..image.."]"
			formspec=formspec.."list[current_player;bag"..i.."contents;0,1;8,3;]"
		end
	end

	--Items list
	local list_index=unified_inventory.current_index[player_name]
	local page=math.floor(list_index / (80) + 1)
	local pagemax = math.floor((unified_inventory.filtered_items_list_size[player_name]-1) / (80) + 1)
	local image
	local item={}
	for y=0,9,1 do
	for x=0,7,1 do
		name=unified_inventory.filtered_items_list[player_name][list_index]	
		if minetest.registered_items[name] then
		formspec=formspec.."item_image_button["..(8.2+x*.7)..","..(1+y*.7)..";.81,.81;"..name..";item_button"..list_index..";]"
		list_index=list_index+1
		end
	end
	end	
	formspec=formspec.."label[8.2,0;Page:]"
	formspec=formspec.."label[9,0;"..page.." of "..pagemax.."]"
	formspec=formspec.."label[8.2,0.4;Filter:]"
	formspec=formspec.."label[9,0.4;"..unified_inventory.activefilter[player_name].."]"
	return formspec
end

-- register_on_player_receive_fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local player_name = player:get_player_name()

	-- main buttons
	if fields.craft then
		unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,"craft"))
		minetest.sound_play("click", {to_player=player_name, gain = 0.1})
		return
	end

	if fields.craftguide then
		unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,"craftguide"))
		minetest.sound_play("click", {to_player=player_name, gain = 0.1})
		return
	end

	if fields.bags then
		unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,"bags"))
		minetest.sound_play("click", {to_player=player_name, gain = 0.1})
		return
	end

	-- bags
	for i=1,4 do
		local page = "bag"..i
		if fields[page] then
			if player:get_inventory():get_stack(page, 1):get_definition().groups.bagslots==nil then
				page = "bags"
			end
			unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,page))
			minetest.sound_play("click", {to_player=player_name, gain = 0.1})
			return
		end
	end

	-- Miscellaneous
	if fields.home_gui_set then
		unified_inventory.set_home(player, player:getpos())
		local home = homepos[player_name]
		if home ~= nil then
			minetest.sound_play("dingdong", {to_player=player_name, gain = 1.0})
			minetest.chat_send_player(player_name, "Home position set to: "..math.floor(home.x)..","..math.floor(home.y)..","..math.floor(home.z))
		end
	end
	if fields.home_gui_go then
		unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,"craft"))
		minetest.sound_play("teleport", {to_player=player_name, gain = 1.0})
		unified_inventory.go_home(player)
	end
	if fields.misc_set_day then
		if minetest.get_player_privs(player_name).settime==true then 
		minetest.sound_play("birds", {to_player=player_name, gain = 1.0})
		minetest.env:set_timeofday((6000 % 24000) / 24000)
		minetest.chat_send_player(player_name, "Time of day set to 6am")
		else
		minetest.chat_send_player(player_name, "You don't have settime priviledge!")
		end
	end
	if fields.misc_set_night then
		if minetest.get_player_privs(player_name).settime==true then 	
		minetest.sound_play("owl", {to_player=player_name, gain = 1.0})
		minetest.env:set_timeofday((21000 % 24000) / 24000)
		minetest.chat_send_player(player_name, "Time of day set to 9pm")
		else
		minetest.chat_send_player(player_name, "You don't have settime priviledge!")	
		end	
	end

	if fields.clear_inv then
		local inventory = {}
		player:get_inventory():set_list("main", inventory)
		minetest.chat_send_player(player_name, 'Inventory Cleared!')
		minetest.sound_play("trash_all", {to_player=player_name, gain = 1.0})
	end
	
	-- Inventory page controls
	local start=math.floor(unified_inventory.current_index[player_name]/80 +1 )
	local start_i=start
	local pagemax = math.floor((unified_inventory.filtered_items_list_size[player_name]-1) / (80) + 1)
	
	if fields.start_list then
		minetest.sound_play("paperflip1", {to_player=player_name, gain = 1.0})
		start_i = 1
	end
	if fields.rewind1 then
		minetest.sound_play("paperflip1", {to_player=player_name, gain = 1.0})
		start_i = start_i - 1
	end
	if fields.forward1 then
		minetest.sound_play("paperflip1", {to_player=player_name, gain = 1.0})
		start_i = start_i + 1
	end
	if fields.rewind3 then
		minetest.sound_play("paperflip1", {to_player=player_name, gain = 1.0})
		start_i = start_i - 3
	end
	if fields.forward3 then
		minetest.sound_play("paperflip1", {to_player=player_name, gain = 1.0})
		start_i = start_i + 3
	end
	if fields.end_list then
		minetest.sound_play("paperflip1", {to_player=player_name, gain = 1.0})
		start_i = pagemax
	end
	if start_i < 1 then
		start_i = 1
	end
	if start_i > pagemax then
		start_i =  pagemax
	end
	if not (start_i	==start) then
		unified_inventory.current_index[player_name] = (start_i-1)*80+1
		unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,unified_inventory.current_page[player_name]))
		end
	
	-- Item list buttons
	local list_index=unified_inventory.current_index[player_name]
	local page=unified_inventory.current_page[player_name]
	for i=0,80,1 do
		local button="item_button"..list_index
		if fields[button] then 
			minetest.sound_play("click", {to_player=player_name, gain = 0.1})
			if minetest.setting_getbool("creative_mode")==false then
				unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,"craftguide"))
				page="craftguide"
				end
			if page=="craftguide" then 
				unified_inventory.current_item[player_name] = unified_inventory.filtered_items_list[player_name][list_index] 
				unified_inventory.alternate[player_name] = 1
				unified_inventory.update_recipe (player, unified_inventory.filtered_items_list[player_name][list_index], 1)
				unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,unified_inventory.current_page[player_name]))
			else
				if minetest.setting_getbool("creative_mode") then
					local inv = player:get_inventory()
					dst_stack={}
					dst_stack["name"] = unified_inventory.filtered_items_list[player_name][list_index] 
					dst_stack["count"]=99
					if inv:room_for_item("main",dst_stack) then
					inv:add_item("main",dst_stack)
					end
				end	
			end	
		end	
	list_index=list_index+1
	end
	
	if fields.searchbutton then
		unified_inventory.apply_filter(player, fields.searchbox)
		unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,unified_inventory.current_page[player_name]))
		minetest.sound_play("paperflip2", {to_player=player_name, gain = 1.0})
	end	
	
	-- alternate button
	if fields.alternate then
		minetest.sound_play("click", {to_player=player_name, gain = 0.1})
		local item_name=unified_inventory.current_item[player_name]
		if item_name then
			local alternates = 0
			local alternate=unified_inventory.alternate[player_name]
			local crafts = unified_inventory.crafts_table[item_name]
			if crafts ~= nil then
				alternates = #crafts
			end
			if alternates > 1 then
			alternate=alternate+1
			if alternate>alternates then
				alternate=1
			end
			unified_inventory.alternate[player_name]=alternate		
			unified_inventory.update_recipe (player, unified_inventory.current_item[player_name], alternate)
			unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,unified_inventory.current_page[player_name]))
			end
		end	
	end		
end)

-- load_home
local load_home = function()
    local input = io.open(unified_inventory.home_filename..".home", "r")
    if input then
        while true do
            local x = input:read("*n")
            if x == nil then
                break
            end
            local y = input:read("*n")
            local z = input:read("*n")
            local name = input:read("*l")
            homepos[name:sub(2)] = {x = x, y = y, z = z}
        end
        io.close(input)
    else
        homepos = {}
    end
end
load_home() -- run it now

-- set_home
unified_inventory.set_home = function(player, pos)
	local player_name=player:get_player_name()
	homepos[player_name] = pos
	-- save the home data from the table to the file
	local output = io.open(unified_inventory.home_filename..".home", "w")
	for k, v in pairs(homepos) do
		if v ~= nil then
			output:write(math.floor(v.x).." "..math.floor(v.y).." "..math.floor(v.z).." "..k.."\n")
		end
	end
	io.close(output)
end

-- go_home 
unified_inventory.go_home = function(player)
	local pos = homepos[player:get_player_name()]
	if pos~=nil then
		player:setpos(pos)
	end
end

--apply filter to the inventory list (create filtered copy of full one)
unified_inventory.apply_filter = function(player,filter)
	local player_name = player:get_player_name() 
	local size=0
	local str_temp1=string.lower(filter)
	if str_temp1 ~= "" then 
		for i=1,str_temp1:len(),1 do
			if string.byte(str_temp1,i) == 91 then 
				str_temp1=""
				end
			end
	end
	local str_temp2
	local str_temp3
	unified_inventory.filtered_items_list[player_name]={}
	for name,def in pairs(minetest.registered_items) do
		if (not def.groups.not_in_creative_inventory or def.groups.not_in_creative_inventory == 0)
				and def.description and def.description ~= "" then
			str_temp2=string.lower(def.name)
			str_temp3=string.lower(def.description)
			if string.find(str_temp2, str_temp1) or string.find(str_temp3, str_temp1) then
				table.insert(unified_inventory.filtered_items_list[player_name], name)
				size=size+1
			end
		end
	
	end
	table.sort(unified_inventory.filtered_items_list[player_name])
	unified_inventory.filtered_items_list_size[player_name]=size
	unified_inventory.current_index[player_name]=1	
	unified_inventory.activefilter[player_name]=filter
	unified_inventory.set_inventory_formspec(player, unified_inventory.get_formspec(player,unified_inventory.current_page[player_name]))
end


-- update_recipe
unified_inventory.update_recipe = function(player, stack_name, alternate)
	local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."craftrecipe"})	
	for i=0,inv:get_size("build"),1 do
		inv:set_stack("build", i, nil)
	end
	inv:set_stack("output", 1, nil)
	alternate = tonumber(alternate) or 1
	local crafts = unified_inventory.crafts_table[stack_name]
	print(dump(crafts))
	local next=next
	if next(crafts) == nil then return end -- no craft recipes
	if alternate < 1 or alternate > #crafts then
		alternate = 1
	end
	local craft = crafts[alternate]
	inv:set_stack("output", 1, craft.output)
	local items=craft.items
	-- cook, fuel, grinding recipes
	if craft.type == "cooking" or craft.type == "fuel" or craft.type == "grinding" then
		def=unified_inventory.find_item_def(craft["items"][1])
		if def then
			inv:set_stack("build", 1, def)
		end
		return 
	end
	if craft.width==0 then
	local build_table={1,2,3}
	for i=1,3,1 do
		if craft.items[i] then
			def=unified_inventory.find_item_def(craft.items[i])
			if def then inv:set_stack("build", build_table[i], def) end
		end
	end
	end
	if craft.width==1 then
	local build_table={1,4,7}
	for i=1,3,1 do
		if craft.items[i] then
			def=unified_inventory.find_item_def(craft.items[i])
			if def then inv:set_stack("build", build_table[i], def) end
		end
	end
	end
	if craft.width==2 then
	local build_table={1,2,4,5,7,8}
	for i=1,6,1 do
		if craft.items[i] then
			def=unified_inventory.find_item_def(craft.items[i])
			if def then inv:set_stack("build", build_table[i], def) end
		end
	end
	end
	if craft.width==3 then
		for i=1,9,1 do
			if craft.items[i] then
				def=unified_inventory.find_item_def(craft.items[i])
				if def then inv:set_stack("build", i, def) end
			end
		end
	end
end

unified_inventory.find_item_def = function(def1)
if type(def1)=="string" then
	if string.find(def1, "group:") then
		def1=string.gsub(def1, "group:", "")
		def1=string.gsub(def1, '\"', "")
		local items=unified_inventory.items_in_group(def1)
		return items[1]
	else
		return def1
	end
end
return nil
end

unified_inventory.items_in_group = function(group)
	local items = {}
	for name, item in pairs(minetest.registered_items) do
		for _, g in ipairs(group:split(',')) do
			if item.groups[g] then
				table.insert(items,name)
			end
		end
	end
	return items
end

-- register_craft
unified_inventory.register_craft = function(options)
	if  options.output == nil then
		return
	end
	local itemstack = ItemStack(options.output)
	if itemstack:is_empty() then
		return
	end
	if unified_inventory.crafts_table[itemstack:get_name()]==nil then
		unified_inventory.crafts_table[itemstack:get_name()] = {}
	end
	table.insert(unified_inventory.crafts_table[itemstack:get_name()],options)
	--crafts_table_count=crafts_table_count+1
end
