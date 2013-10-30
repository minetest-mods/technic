-- original code comes from walkin_light mod by Echo http://minetest.net/forum/viewtopic.php?id=2621

local flashlight_max_charge = 30000

local S = technic.getter

technic.register_power_tool("technic:flashlight", flashlight_max_charge)
      
minetest.register_tool("technic:flashlight", {
	description = S("Flashlight"),
	inventory_image = "technic_flashlight.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	end,
})

minetest.register_craft({
output = "technic:flashlight",
recipe = {
		{"technic:rubber",                "glass",           "technic:rubber"},
		{"technic:stainless_steel_ingot", "technic:battery", "technic:stainless_steel_ingot"},
		{"",                              "technic:battery", ""}
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
	local pos = player:getpos()
	local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
	player_positions[player_name] = rounded_pos
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	for i, v in ipairs(players) do
		if v == player_name then 
			table.remove(players, i)
			last_wielded[player_name] = nil
			-- Neuberechnung des Lichts erzwingen
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x),y=round(pos.y)+1,z=round(pos.z)}
			local nodename = minetest.get_node(rounded_pos).name
			if nodename == "technic:light_off" or nodename == "technic:light" then
				minetest.remove_node(rounded_pos)
			end
			if player_positions[player_name] then
				player_positions[player_name] = nil
			end
		end
	end
end)

minetest.register_globalstep(function(dtime)
	for i, player_name in ipairs(players) do
		local player = minetest.get_player_by_name(player_name)
		if player then
			flashlight_weared = check_for_flashlight(player)
			local pos = player:getpos()
			local rounded_pos = {x=round(pos.x), y=round(pos.y)+1, z=round(pos.z)}
			local old_pos = vector.new(player_positions[player_name])
			
			if last_wielded[player_name] and not flashlight_weared then --remove light, flashlight weared out or was removed from hotbar
				local node = minetest.get_node_or_nil(old_pos)
				if node and node.name == "technic:light" then 
					minetest.add_node(old_pos,{name="air"})		
					last_wielded[player_name] = false
				end

				player_moved = not(old_pos.x == rounded_pos.x and old_pos.y == rounded_pos.y and old_pos.z == rounded_pos.z)
				if player_moved and last_wielded[player_name] and flashlight_weared  then
					
					local node=minetest.env:get_node_or_nil(rounded_pos)
					if node then
						if node.name=="air" then 
							minetest.env:add_node(rounded_pos,{type="node",name="technic:light"})
						end
					end
					local node=minetest.env:get_node_or_nil(old_pos)
					if node then
						if node.name=="technic:light" then 
							minetest.env:add_node(old_pos,{type="node",name="technic:light_off"})
							minetest.env:add_node(old_pos,{type="node",name="air"})		
						end
					end
					player_positions[player_name]["x"] = rounded_pos.x
					player_positions[player_name]["y"] = rounded_pos.y
					player_positions[player_name]["z"] = rounded_pos.z
					
				elseif not last_wielded[player_name] and flashlight_weared then
					local node=minetest.env:get_node_or_nil(rounded_pos)
					if node then
						if node.name=="air" then 
							minetest.env:add_node(rounded_pos,{type="node",name="technic:light"})
						end
					end
					player_positions[player_name]["x"] = rounded_pos.x
					player_positions[player_name]["y"] = rounded_pos.y
					player_positions[player_name]["z"] = rounded_pos.z
					last_wielded[player_name]=true
				end			
					
			end
		end
	end
end)

minetest.register_node("technic:light", {
	drawtype = "glasslike",
	tile_images = {"technic_light.png"},
	paramtype = "light",
	walkable = false,
	buildable_to = true,
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
	buildable_to = true,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	selection_box = {
        type = "fixed",
        fixed = {0, 0, 0, 0, 0, 0},
    },
})

function check_for_flashlight(player)
	if player == nil then
		return false
	end
	local inv = player:get_inventory()
	local hotbar = inv:get_list("main")
	for i = 1, 8 do
		if hotbar[i]:get_name() == "technic:flashlight" then
			local meta = get_item_meta(hotbar[i]:get_metadata())
			if not meta or not meta.charge then
				return false
			end
			if meta.charge - 2 > 0 then
				meta.charge = meta.charge - 2;
				technic.set_RE_wear(hotbar[i], meta.charge, flashlight_max_charge)
				hotbar[i]:set_metadata(set_item_meta(meta))
				inv:set_stack("main", i, hotbar[i])
				return true
			end
		end
	end
	return false
end

