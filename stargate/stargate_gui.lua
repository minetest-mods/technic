-- default GUI page
stargate.default_page = "main"
stargate_network["players"]={}
stargate.current_page={}

stargate.save_data = function(table_pointer)
	local data = minetest.serialize( stargate_network[table_pointer] )
	local path = minetest.get_worldpath().."/stargate_"..table_pointer..".data"
	local file = io.open( path, "w" )
	if( file ) then
		file:write( data )
		file:close()
		return true
	else return nil
	end
end

stargate.restore_data = function(table_pointer)
	local path = minetest.get_worldpath().."/stargate_"..table_pointer..".data"
	local file = io.open( path, "r" )
	if( file ) then
		local data = file:read("*all")
		stargate_network[table_pointer] = minetest.deserialize( data )
		file:close()
	return true
	else return nil
	end
end

-- load Stargates network data
if stargate.restore_data("registered_players") ~= nil then
	for __,tab in ipairs(stargate_network["registered_players"]) do
		if stargate.restore_data(tab["player_name"]) == nil  then
			print ("[stargate] Error loading data!")
		end
	end
else
	print ("[stargate] Error loading data! Creating new file.")
	stargate_network["registered_players"]={}
	stargate.save_data("registered_players")
end

-- register_on_joinplayer
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local registered=nil
	for __,tab in ipairs(stargate_network["registered_players"]) do
		if tab["player_name"] ==  player_name then registered = true break end
	end
	if registered == nil then
		local new={}
		new["player_name"]=player_name
		table.insert(stargate_network["registered_players"],new)
		stargate_network[player_name]={}
		stargate.save_data("registered_players")
		stargate.save_data(player_name)
	end
	stargate_network["players"][player_name]={}
	stargate_network["players"][player_name]["formspec"]=""
	stargate_network["players"][player_name]["current_page"]=stargate.default_page
	stargate_network["players"][player_name]["own_gates"]={}
	stargate_network["players"][player_name]["own_gates_count"]=0
	stargate_network["players"][player_name]["public_gates"]={}
	stargate_network["players"][player_name]["public_gates_count"]=0
	stargate_network["players"][player_name]["current_index"]=0
	stargate_network["players"][player_name]["temp_gate"]={}
end)

stargate.registerGate = function(player_name,pos,dir)
	if stargate_network[player_name]==nil then
		stargate_network[player_name]={}
	end
	local new_gate ={}
	new_gate["pos"]=pos
	new_gate["type"]="private"
	new_gate["description"]=""
	new_gate["dir"]=dir
	new_gate["owner"]=player_name
	table.insert(stargate_network[player_name],new_gate)
	if stargate.save_data(player_name)==nil then
		print ("[stargate] Couldnt update network file!")
	end
end

stargate.unregisterGate = function(player_name,pos)
	for __,gates in ipairs(stargate_network[player_name]) do
		if gates["pos"].x==pos.x and gates["pos"].y==pos.y and gates["pos"].z==pos.z then
			table.remove(stargate_network[player_name], __)
			break
		end
	end
	if stargate.save_data(player_name)==nil then
		print ("[stargate] Couldnt update network file!")
	end
end

stargate.findGate = function(pos)
	for __,tab in ipairs(stargate_network["registered_players"]) do
		local player_name=tab["player_name"]
		if type(stargate_network[player_name])=="table" then
			for __,gates in ipairs(stargate_network[player_name]) do
				if gates then 
					if gates["pos"].x==pos.x and gates["pos"].y==pos.y and gates["pos"].z==pos.z then
						return gates
					end
				end
			end
		end
	end
	return nil
end

--show formspec to player
stargate.gateFormspecHandler = function(pos, node, clicker, itemstack)
	local player_name = clicker:get_player_name()
	local meta = minetest.env:get_meta(pos)
	local owner=meta:get_string("owner")
	if player_name~=owner then return end
	local current_gate=nil
	stargate_network["players"][player_name]["own_gates"]={}
	stargate_network["players"][player_name]["public_gates"]={}
	local own_gates_count=0
	local public_gates_count=0

	for __,gates in ipairs(stargate_network[player_name]) do
		if gates["pos"].x==pos.x and gates["pos"].y==pos.y and gates["pos"].z==pos.z then
			current_gate=gates
		else
		own_gates_count=own_gates_count+1
		table.insert(stargate_network["players"][player_name]["own_gates"],gates)
		end
	end
	stargate_network["players"][player_name]["own_gates_count"]=own_gates_count

	-- get all public gates
	for __,tab in ipairs(stargate_network["registered_players"]) do
		local temp=tab["player_name"]
		if type(stargate_network[temp])=="table" and temp~=player_name then
			for __,gates in ipairs(stargate_network[temp]) do
				if gates["type"]=="public" then 
					public_gates_count=public_gates_count+1
					table.insert(stargate_network["players"][player_name]["public_gates"],gates)
					end
				end
			end
		end

	print(dump(stargate_network["players"][player_name]["public_gates"]))
	if current_gate==nil then 
		print ("Gate not registered in network! Please remove it and place once again.")
		return nil
	end
	stargate_network["players"][player_name]["current_index"]=0
	stargate_network["players"][player_name]["temp_gate"]["type"]=current_gate["type"]
	stargate_network["players"][player_name]["temp_gate"]["description"]=current_gate["description"]
	stargate_network["players"][player_name]["temp_gate"]["pos"]={}
	stargate_network["players"][player_name]["temp_gate"]["pos"].x=current_gate["pos"].x
	stargate_network["players"][player_name]["temp_gate"]["pos"].y=current_gate["pos"].y
	stargate_network["players"][player_name]["temp_gate"]["pos"].z=current_gate["pos"].z
	if current_gate["destination"] then 
		stargate_network["players"][player_name]["temp_gate"]["destination_description"]=current_gate["destination_description"]
		stargate_network["players"][player_name]["temp_gate"]["destination_dir"]=current_gate["destination_dir"]
		stargate_network["players"][player_name]["temp_gate"]["destination"]={}
		stargate_network["players"][player_name]["temp_gate"]["destination"].x=current_gate["destination"].x
		stargate_network["players"][player_name]["temp_gate"]["destination"].y=current_gate["destination"].y
		stargate_network["players"][player_name]["temp_gate"]["destination"].z=current_gate["destination"].z
	else
		stargate_network["players"][player_name]["temp_gate"]["destination"]=nil
	end
	stargate_network["players"][player_name]["current_gate"]=current_gate
	stargate_network["players"][player_name]["dest_type"]="own"
	local formspec=stargate.get_formspec(player_name,"main")
	stargate_network["players"][player_name]["formspec"]=formspec
	if formspec ~=nil then minetest.show_formspec(player_name, "stargate_main", formspec) end
end

-- get_formspec
stargate.get_formspec = function(player_name,page)
	if player_name==nil then return nil end
	stargate_network["players"][player_name]["current_page"]=page
	local temp_gate=stargate_network["players"][player_name]["temp_gate"]
	local formspec = "size[14,10]"
	--background
	formspec = formspec .."background[-0.19,-0.2,;14.38,10.55;ui_form_bg.png]"
	formspec = formspec.."label[0,0.0;Stargate DHD]"
	formspec = formspec.."label[0,.5;Position: ("..temp_gate["pos"].x..","..temp_gate["pos"].y..","..temp_gate["pos"].z..")]"
	formspec = formspec.."image_button[3.5,.6;.6,.6;toggle_icon.png;toggle_type;]"
	formspec = formspec.."label[4,.5;Type: "..temp_gate["type"].."]"
	formspec = formspec.."image_button[6.5,.6;.6,.6;pencil_icon.png;edit_desc;]"
	formspec = formspec.."label[0,1.1;Destination: ]"
	if temp_gate["destination"] then 
		formspec = formspec.."label[2.5,1.1;("..temp_gate["destination"].x..","
											  ..temp_gate["destination"].y..","
											  ..temp_gate["destination"].z..") "
											  ..temp_gate["destination_description"].."]"
		formspec = formspec.."image_button[2,1.2;.6,.6;cancel_icon.png;remove_dest;]"
	else
	formspec = formspec.."label[2,1.1;Not connected]"
	end
	formspec = formspec.."label[0,1.7;Aviable destinations:]"
	formspec = formspec.."image_button[3.5,1.8;.6,.6;toggle_icon.png;toggle_dest_type;]"
	formspec = formspec.."label[4,1.7;Filter: "..stargate_network["players"][player_name]["dest_type"].."]"

	if page=="main" then
	formspec = formspec.."image_button[6.5,.6;.6,.6;pencil_icon.png;edit_desc;]"
	formspec = formspec.."label[7,.5;Description: "..temp_gate["description"].."]"
	end
	if page=="edit_desc" then
	formspec = formspec.."image_button[6.5,.6;.6,.6;ok_icon.png;save_desc;]"
	formspec = formspec.."field[7.3,.7;5,1;desc_box;Edit gate description:;"..temp_gate["description"].."]"
	end
	
	local list_index=stargate_network["players"][player_name]["current_index"]
	local page=math.floor(list_index / 24 + 1)
	local pagemax
	if stargate_network["players"][player_name]["dest_type"] == "own" then 
		pagemax = math.floor((stargate_network["players"][player_name]["own_gates_count"] / 24) + 1)
		local x,y
		for y=0,7,1 do
		for x=0,2,1 do
			local gate_temp=stargate_network["players"][player_name]["own_gates"][list_index+1]
			if gate_temp then
				formspec = formspec.."image_button["..(x*4.5)..","..(2.5+y*.87)..";.6,.6;stargate_icon.png;list_button"..list_index..";]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.3+y*.87)..";("..gate_temp["pos"].x..","..gate_temp["pos"].y..","..gate_temp["pos"].z..") "..gate_temp["type"].."]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.7+y*.87)..";"..gate_temp["description"].."]"
			end
			list_index=list_index+1
		end
		end
	else
		pagemax = math.floor((stargate_network["players"][player_name]["public_gates_count"] / 24) + 1)
		local x,y
		for y=0,7,1 do
		for x=0,2,1 do
			local gate_temp=stargate_network["players"][player_name]["public_gates"][list_index+1]
			if gate_temp then
				formspec = formspec.."image_button["..(x*4.5)..","..(2.5+y*.87)..";.6,.6;stargate_icon.png;list_button"..list_index..";]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.3+y*.87)..";("..gate_temp["pos"].x..","..gate_temp["pos"].y..","..gate_temp["pos"].z..") "..gate_temp["owner"].."]"
				formspec = formspec.."label["..(x*4.5+.5)..","..(2.7+y*.87)..";"..gate_temp["description"].."]"
			end
			list_index=list_index+1
		end
		end
	end
	formspec=formspec.."label[7.5,1.7;Page: "..page.." of "..pagemax.."]"
	formspec = formspec.."image_button[6.5,1.8;.6,.6;left_icon.png;page_left;]"
	formspec = formspec.."image_button[6.9,1.8;.6,.6;right_icon.png;page_right;]"
	formspec = formspec.."image_button_exit[6.1,9.3;.8,.8;ok_icon.png;save_changes;]"
	formspec = formspec.."image_button_exit[7.1,9.3;.8,.8;cancel_icon.png;discard_changes;]"
	return formspec
end

-- register_on_player_receive_fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if not formname == "stargate_main" then return "" end
	local player_name = player:get_player_name()
	local temp_gate=stargate_network["players"][player_name]["temp_gate"]
	local current_gate=stargate_network["players"][player_name]["current_gate"]
	local formspec

	if fields.toggle_type then
		if temp_gate["type"] == "private" then 
			temp_gate["type"] = "public"
		else temp_gate["type"] = "private" end
		stargate_network["players"][player_name]["current_index"]=0
		formspec= stargate.get_formspec(player_name,"main")
		stargate_network["players"][player_name]["formspec"] = formspec
		minetest.show_formspec(player_name, "stargate_main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end
	if fields.toggle_dest_type then
		if stargate_network["players"][player_name]["dest_type"] == "own" then 
			stargate_network["players"][player_name]["dest_type"] = "all public"
		else stargate_network["players"][player_name]["dest_type"] = "own" end
		stargate_network["players"][player_name]["current_index"] = 0
		formspec = stargate.get_formspec(player_name,"main")
		stargate_network["players"][player_name]["formspec"] = formspec
		minetest.show_formspec(player_name, "stargate_main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end
	if fields.edit_desc then
		formspec= stargate.get_formspec(player_name,"edit_desc")
		stargate_network["players"][player_name]["formspec"]=formspec
		minetest.show_formspec(player_name, "stargate_main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end

	if fields.save_desc then
		temp_gate["description"]=fields.desc_box
		formspec= stargate.get_formspec(player_name,"main")
		stargate_network["players"][player_name]["formspec"]=formspec
		minetest.show_formspec(player_name, "stargate_main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end
	
	-- page controls
	local start=math.floor(stargate_network["players"][player_name]["current_index"]/24 +1 )
	local start_i=start
	local pagemax = math.floor(((stargate_network["players"][player_name]["own_gates_count"]-1) / 24) + 1)
	
	if fields.page_left then
		minetest.sound_play("paperflip2", {to_player=player_name, gain = 1.0})
		start_i = start_i - 1
		if start_i < 1 then	start_i = 1	end
		if not (start_i	== start) then
			stargate_network["players"][player_name]["current_index"] = (start_i-1)*24
			formspec = stargate.get_formspec(player_name,"main")
			stargate_network["players"][player_name]["formspec"] = formspec
			minetest.show_formspec(player_name, "stargate_main", formspec)
		end
	end
	if fields.page_right then
		minetest.sound_play("paperflip2", {to_player=player_name, gain = 1.0})
		start_i = start_i + 1 
		if start_i > pagemax then start_i =  pagemax end
		if not (start_i	== start) then
			stargate_network["players"][player_name]["current_index"] = (start_i-1)*24
			formspec = stargate.get_formspec(player_name,"main")
			stargate_network["players"][player_name]["formspec"] = formspec
			minetest.show_formspec(player_name, "stargate_main", formspec)
		end
	end

	if fields.remove_dest then
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		temp_gate["destination"]=nil
		temp_gate["destination_description"]=nil
		formspec = stargate.get_formspec(player_name,"main")
		stargate_network["players"][player_name]["formspec"] = formspec
		minetest.show_formspec(player_name, "stargate_main", formspec)
	end

	if fields.save_changes then
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		local meta = minetest.env:get_meta(temp_gate["pos"])
		local infotext=""
		current_gate["type"]=temp_gate["type"]
		current_gate["description"]=temp_gate["description"]
		current_gate["pos"]={}
		current_gate["pos"].x=temp_gate["pos"].x
		current_gate["pos"].y=temp_gate["pos"].y
		current_gate["pos"].z=temp_gate["pos"].z
		current_gate["dest"]=temp_gate["dest"]
		if temp_gate["destination"] then 
			current_gate["destination"]={}
			current_gate["destination"].x=temp_gate["destination"].x
			current_gate["destination"].y=temp_gate["destination"].y
			current_gate["destination"].z=temp_gate["destination"].z
			current_gate["destination_description"]=temp_gate["destination_description"]
			current_gate["destination_dir"]=temp_gate["destination_dir"]
		else
			current_gate["destination"]=nil
		end
		if current_gate["destination"] then 
			activateGate (current_gate["pos"])
		else
			deactivateGate (current_gate["pos"])
		end
		if current_gate["type"]=="private" then infotext="Private"	else infotext="Public" end
		infotext=infotext.." Gate: "..current_gate["description"].."\n"
		infotext=infotext.."Owned by "..player_name.."\n"
		if current_gate["destination"] then 
			infotext=infotext.."Destination: ("..current_gate["destination"].x..","..current_gate["destination"].y..","..current_gate["destination"].z..") "
			infotext=infotext..current_gate["destination_description"]
		end
		meta:set_string("infotext",infotext)
		if stargate.save_data(player_name)==nil then
			print ("[stargate] Couldnt update network file!")
		end
	end

	if fields.discard_changes then
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
	end

	local list_index=stargate_network["players"][player_name]["current_index"]
	local i
	for i=0,23,1 do
	local button="list_button"..i+list_index
	if fields[button] then 
		minetest.sound_play("click", {to_player=player_name, gain = 1.0})
		local gate=stargate_network["players"][player_name]["temp_gate"]
		local dest_gate
		if stargate_network["players"][player_name]["dest_type"] == "own" then
			dest_gate=stargate_network["players"][player_name]["own_gates"][list_index+i+1]
		else
			dest_gate=stargate_network["players"][player_name]["public_gates"][list_index+i+1]
		end
		gate["destination"]={}
		gate["destination"].x=dest_gate["pos"].x
		gate["destination"].y=dest_gate["pos"].y
		gate["destination"].z=dest_gate["pos"].z
		gate["destination_description"]=dest_gate["description"]
		gate["destination_dir"]=dest_gate["dir"]
		formspec = stargate.get_formspec(player_name,"main")
		stargate_network["players"][player_name]["formspec"] = formspec
		minetest.show_formspec(player_name, "stargate_main", formspec)
	end
	end
end)
