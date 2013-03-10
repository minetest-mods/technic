-- default GUI page
stargate.default_page = "main"
stargate.players={}
stargate.current_page={}

stargate.save_data = function()
	local data = minetest.serialize( stargate_network )
	local path = minetest.get_worldpath().."/mod_stargate.data"
	local file = io.open( path, "w" )
	if( file ) then
		file:write( data )
		file:close()
		return true
	else return nil
	end
end

stargate.restore_data = function()
	local path = minetest.get_worldpath().."/mod_stargate.data"
	local file = io.open( path, "r" )
	if( file ) then
		local data = file:read("*all")
		stargate_network = minetest.deserialize( data )
		file:close()
	return true
	else return nil
	end
end

-- load Stargates network data
if stargate.restore_data()==nil then
	print ("[stargate] network data not found. Creating new file.")
	if stargate.save_data()==nil then
		print ("[stargate] Cannot load nor create new file!")
		--crash or something here?
	else
		print ("[stargate] New data file created.")
	end
end

-- register_on_joinplayer
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	stargate.players[player_name]={}
	stargate.players[player_name]["formspec"]=""
	stargate.players[player_name]["current_page"]=stargate.default_page
	stargate.players[player_name]["own_gates"]={}
	stargate.players[player_name]["own_gates_count"]=0
	stargate.players[player_name]["public_gates"]={}
	stargate.players[player_name]["public_gates_count"]=0
end)

stargate.registerGate = function(player_name,pos)
	if stargate_network[player_name]==nil then
		stargate_network[player_name]={}
	end
	local new_gate ={}
	new_gate["pos"]=pos
	new_gate["type"]="private"
	new_gate["description"]=""
	table.insert(stargate_network[player_name],new_gate)
	if stargate.save_data()==nil then
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
	if stargate.save_data()==nil then
		print ("[stargate] Couldnt update network file!")
	end
end

--show formspec to player
stargate.gateFormspecHandler = function(pos, node, clicker, itemstack)
	local player_name = clicker:get_player_name()
	local meta = minetest.env:get_meta(pos)
	local owner=meta:get_string("owner")
	if player_name~=owner then return end
	local current_gate=nil
	stargate.players[player_name]["own_gates"]={}
	stargate.players[player_name]["public_gates"]={}
	local own_gates_count=0
	for __,gates in ipairs(stargate_network[player_name]) do
		if gates["pos"].x==pos.x and gates["pos"].y==pos.y and gates["pos"].z==pos.z then
			current_gate=gates
		else
		own_gates_count=own_gates_count+1
		table.insert(stargate.players[player_name]["own_gates"],gates)
		end
	end
	stargate.players[player_name]["own_gates_count"]=own_gates_count
	if current_gate==nil then 
		print ("Gate not registered in network! Please remove it and place once again.")
		return nil
	end
	stargate.players[player_name]["current_index"]=0
	stargate.players[player_name]["current_gate"]=current_gate
	stargate.players[player_name]["dest_type"]="own"
	local formspec=stargate.get_formspec(player_name,"main")
	stargate.players[player_name]["formspec"]=formspec
	minetest.show_formspec(player_name, "stargate:main", formspec)
end

-- get_formspec
stargate.get_formspec = function(player_name,page)
	if player_name==nil then return "" end
	stargate.players[player_name]["current_page"]=page
	local current_gate=stargate.players[player_name]["current_gate"]
	local formspec = "size[14,10]"
	--background
	formspec = formspec .."background[-0.19,-0.2,;14.38,10.55;ui_form_bg.png]"
	formspec = formspec.."label[0,0.0;Stargate]"
	formspec = formspec.."label[0,.5;Position: ("..current_gate["pos"].x..","..current_gate["pos"].y..","..current_gate["pos"].z..")]"
	formspec = formspec.."image_button[3.5,.6;.6,.6;toggle_icon.png;toggle_type;]"
	formspec = formspec.."label[4,.5;Type: "..current_gate["type"].."]"
	formspec = formspec.."image_button[6.5,.6;.6,.6;pencil_icon.png;edit_desc;]"
	formspec = formspec.."label[0,1.1;Destination: ]"
	formspec = formspec.."label[0,1.7;Aviable destinations:]"
	formspec = formspec.."image_button[3.5,1.8;.6,.6;toggle_icon.png;toggle_dest_type;]"
	formspec = formspec.."label[4,1.7;Type: "..stargate.players[player_name]["dest_type"].."]"

	if page=="main" then
	formspec = formspec.."image_button[6.5,.6;.6,.6;pencil_icon.png;edit_desc;]"
	formspec = formspec.."label[7,.5;Description: "..current_gate["description"].."]"
	end
	if page=="edit_desc" then
	formspec = formspec.."image_button[6.5,.6;.6,.6;ok_icon.png;save_desc;]"
	formspec = formspec.."field[7.3,.7;5,1;desc_box;Edit gate description:;"..current_gate["description"].."]"
	end
	
	local list_index=stargate.players[player_name]["current_index"]
	print(dump(stargate.players[player_name]["own_gates_count"]))
	local page=math.floor(list_index / (30) + 1)
	local pagemax = math.floor((stargate.players[player_name]["own_gates_count"]+1) / (30) + 1)
	for y=0,9,1 do
	for x=0,2,1 do
		print(dump(list_index))
		print(dump(stargate.players[player_name]["own_gates"][list_index+1]))
		local gate_temp=stargate.players[player_name]["own_gates"][list_index+1]
		if gate_temp then
			formspec = formspec.."image_button["..(x*5)..","..(4+y*.8)..";.6,.6;dot_icon.png;list_button"..list_index..";]"
			formspec = formspec.."label["..(x*5+.8)..","..(4+y*.8)..";("..gate_temp["pos"].x..","..gate_temp["pos"].y..","..gate_temp["pos"].z..")]"
		end
		list_index=list_index+1
	end
	end	
	return formspec
end

-- register_on_player_receive_fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local player_name = player:get_player_name()
	local current_gate=stargate.players[player_name]["current_gate"]
	local formspec

	if fields.toggle_type then
		if current_gate["type"] == "private" then 
			current_gate["type"]="public"
		else current_gate["type"]="private" end
		formspec= stargate.get_formspec(player_name,"main")
		stargate.players[player_name]["formspec"]=formspec
		minetest.show_formspec(player_name, "stargate:main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end
	if fields.toggle_dest_type then
		if stargate.players[player_name]["dest_type"] == "all own" then 
			stargate.players[player_name]["dest_type"]="all public"
		else stargate.players[player_name]["dest_type"]="all own" end
		formspec= stargate.get_formspec(player_name,"main")
		stargate.players[player_name]["formspec"]=formspec
		minetest.show_formspec(player_name, "stargate:main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end
	if fields.edit_desc then
		formspec= stargate.get_formspec(player_name,"edit_desc")
		stargate.players[player_name]["formspec"]=formspec
		minetest.show_formspec(player_name, "stargate:main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end

	if fields.save_desc then
		current_gate["description"]=fields.desc_box
		formspec= stargate.get_formspec(player_name,"main")
		stargate.players[player_name]["formspec"]=formspec
		minetest.show_formspec(player_name, "stargate:main", formspec)
		minetest.sound_play("click", {to_player=player_name, gain = 0.5})
		return
	end
end)
