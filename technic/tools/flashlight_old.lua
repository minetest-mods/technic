-- original code comes from walkin_light mod by Echo http://minetest.net/forum/viewtopic.php?id=2621

flashlight_max_charge=30000
      
       minetest.register_tool("technic:flashlight", {
            description = "Flashlight",
            inventory_image = "technic_flashlight.png",
	stack_max = 1,
            on_use = function(itemstack, user, pointed_thing)
	end,	        
    })
     
    minetest.register_craft({
            output = "technic:flashlight",
            recipe = {
		    {"glass","glass","glass"},
                    {"technic:stainless_steel_ingot","technic:battery","technic:stainless_steel_ingot"},
                    {"","technic:battery",""}
            }
    })
local players = {}
local player_positions = {}
local last_wielded = {}

function round(num) 
	return math.floor(num + 0.5) 
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	table.insert(players, player_name)
	last_wielded[player_name] = flashlight_weared(player)
	local pos = player:getpos()
	local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
	local wielded_item = player:get_wielded_item():get_name()
	if flashlight_weared(player)==true then
		-- Neuberechnung des Lichts erzwingen
		minetest.env:add_node(rounded_pos,{type="node",name="technic:light_off"})
		minetest.env:add_node(rounded_pos,{type="node",name="air"})
	end
	player_positions[player_name] = {}
	player_positions[player_name]["x"] = rounded_pos.x;
	player_positions[player_name]["y"] = rounded_pos.y;
	player_positions[player_name]["z"] = rounded_pos.z;
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	for i,v in ipairs(players) do
		if v == player_name then 
			table.remove(players, i)
			last_wielded[player_name] = nil
			-- Neuberechnung des Lichts erzwingen
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
			minetest.env:add_node(rounded_pos,{type="node",name="technic:light_off"})
			minetest.env:add_node(rounded_pos,{type="node",name="air"})
			player_positions[player_name]["x"] = nil
			player_positions[player_name]["y"] = nil
			player_positions[player_name]["z"] = nil
			player_positions[player_name]["m"] = nil
			player_positions[player_name] = nil
		end
	end
end)

minetest.register_globalstep(function(dtime)
	for i,player_name in ipairs(players) do
		local player = minetest.env:get_player_by_name(player_name)
		if flashlight_weared(player)==true then
			-- Fackel ist in der Hand
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
			if (last_wielded[player_name] ~= true) or (player_positions[player_name]["x"] ~= rounded_pos.x or player_positions[player_name]["y"] ~= rounded_pos.y or player_positions[player_name]["z"] ~= rounded_pos.z) then
				-- Fackel gerade in die Hand genommen oder zu neuem Node bewegt
				local is_air  = minetest.env:get_node_or_nil(rounded_pos)
				if is_air == nil or (is_air ~= nil and (is_air.name == "air" or is_air.name == "technic:light")) then
					-- wenn an aktueller Position "air" ist, Fackellicht setzen
					minetest.env:add_node(rounded_pos,{type="node",name="technic:light"})
				end
				if (player_positions[player_name]["x"] ~= rounded_pos.x or player_positions[player_name]["y"] ~= rounded_pos.y or player_positions[player_name]["z"] ~= rounded_pos.z) then
					-- wenn Position geänder, dann altes Licht löschen
					local old_pos = {x=player_positions[player_name]["x"], y=player_positions[player_name]["y"], z=player_positions[player_name]["z"]}
					-- Neuberechnung des Lichts erzwingen
					local is_light = minetest.env:get_node_or_nil(old_pos)
					if is_light ~= nil and is_light.name == "technic:light" then
						minetest.env:add_node(old_pos,{type="node",name="technic:light_off"})
						minetest.env:add_node(old_pos,{type="node",name="air"})
					end
				end
				-- gemerkte Position ist nun die gerundete neue Position
				player_positions[player_name]["x"] = rounded_pos.x
				player_positions[player_name]["y"] = rounded_pos.y
				player_positions[player_name]["z"] = rounded_pos.z
			end

			last_wielded[player_name] = true;
		elseif last_wielded[player_name] == true  then
			-- Fackel nicht in der Hand, aber beim letzten Durchgang war die Fackel noch in der Hand
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
			repeat
				local is_light  = minetest.env:get_node_or_nil(rounded_pos)
				if is_light ~= nil and is_light.name == "technic:light" then
					-- minetest.env:remove_node(rounded_pos)
					-- Erzwinge Neuberechnung des Lichts
					minetest.env:add_node(rounded_pos,{type="node",name="technic:light_off"})
					minetest.env:add_node(rounded_pos,{type="node",name="air"})
				end
			until minetest.env:get_node_or_nil(rounded_pos) ~= "technic:light"
			local old_pos = {x=player_positions[player_name]["x"], y=player_positions[player_name]["y"], z=player_positions[player_name]["z"]}
			repeat
				is_light  = minetest.env:get_node_or_nil(old_pos)
				if is_light ~= nil and is_light.name == "technic:light" then
					-- minetest.env:remove_node(old_pos)
					-- Erzwinge Neuberechnung des Lichts
					minetest.env:add_node(old_pos,{type="node",name="technic:light_off"})
					minetest.env:add_node(old_pos,{type="node",name="air"})
				end
			until minetest.env:get_node_or_nil(old_pos) ~= "technic:light"
			last_wielded[player_name] = true
		end
	end
end)

minetest.register_node("technic:light", {
	drawtype = "glasslike",
	tile_images = {"technic_light.png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	light_source = 15,
	selection_box = {
        type = "fixed",
        fixed = {0, 0, 0, 0, 0, 0},
    },
})
minetest.register_node("technic:light_off", {
	drawtype = "glasslike",
	tile_images = {"technic_light.png"},
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	selection_box = {
        type = "fixed",
        fixed = {0, 0, 0, 0, 0, 0},
    },
})

function flashlight_weared (player)
flashlight_on=false
local inv = player:get_inventory()
local hotbar=inv:get_list("main")
		for i=1,8,1 do
			
			if hotbar[i]:get_name() == "technic:flashlight" then
			item=hotbar[i]:to_table()
			if item["metadata"]=="" or item["metadata"]=="0" then return flashlight_on end --flashlight not charghed
			charge=tonumber(item["metadata"]) 
			if charge-2>0 then
			 flashlight_on=true	
			 charge =charge-2;	
			set_RE_wear(item,charge,flashlight_max_charge)
			item["metadata"]=tostring(charge)
			hotbar[i]:replace(item)
			inv:set_stack("main",i,hotbar[i])
			return true
			end
			end
		end
return flashlight_on
end	