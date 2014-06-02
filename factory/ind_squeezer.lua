function factory.ind_squeezer_active(pos, percent, item_percent)
    local formspec = 
	"size[8,8.5]"..
	factory_gui_bg..
	factory_gui_bg_img..
	factory_gui_slots..
	"list[current_name;src;2.75,0.5;1,1;]"..
	"list[current_name;fuel;2.75,2.5;1,1;]"..
	"image[2.75,1.5;1,1;factory_compressor_drop_bg.png^[lowpart:"..
	(100-percent)..":factory_compressor_drop_fg.png]"..
        "image[3.75,1.5;1,1;gui_ind_furnace_arrow_bg.png^[lowpart:"..
        (item_percent*100)..":gui_ind_furnace_arrow_fg.png^[transformR270]"..
	"list[current_name;dst;4.75,0.5;2,2;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	factory.get_hotbar_bg(0,4.25)
    return formspec
  end

function factory.ind_squeezer_active_formspec(pos, percent)
	local meta = minetest.get_meta(pos)local inv = meta:get_inventory()
	local srclist = inv:get_list("src")
	local cooked = nil
	if srclist then
		cooked = factory.get_craft_result({method = "ind_squeezer", width = 1, items = srclist})
	end
	local item_percent = 0
	if cooked then
		item_percent = meta:get_float("src_time")/cooked.time
	end
       
        return factory.ind_squeezer_active(pos, percent, item_percent)
end

factory.ind_squeezer_inactive_formspec =
	"size[8,8.5]"..
	factory_gui_bg..
	factory_gui_bg_img..
	factory_gui_slots..
	"list[current_name;src;2.75,0.5;1,1;]"..
	"list[current_name;fuel;2.75,2.5;1,1;]"..
	"image[2.75,1.5;1,1;factory_compressor_drop_bg.png]"..
	"image[3.75,1.5;1,1;gui_ind_furnace_arrow_bg.png^[transformR270]"..
	"list[current_name;dst;4.75,0.5;2,2;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	factory.get_hotbar_bg(0,4.25)

minetest.register_node("factory:ind_squeezer", {
	description = "Industrial Squeezer",
	tiles = {"factory_machine_brick_1.png", "factory_machine_brick_2.png", "factory_machine_side_1.png",
		"factory_machine_side_1.png", "factory_machine_side_1.png", "factory_compressor_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=3},
	legacy_facedir_simple = true,
	is_ground_content = false,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", factory.ind_squeezer_inactive_formspec)
		meta:set_string("infotext", "Industrial Squeezer")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Industrial Squeezer is empty")
				end
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Industrial Squeezer is empty")
				end
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,
})

minetest.register_node("factory:ind_squeezer_active", {
	description = "Industrial Squeezer",
	tiles = {
		"factory_machine_brick_1.png",
		"factory_machine_brick_2.png",
		"factory_machine_side_1.png",
		"factory_machine_side_1.png",
		"factory_machine_side_1.png",
		{
			image = "factory_compressor_front_active.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 4
			},
		}
	},
	paramtype2 = "facedir",
	light_source = 2,
	drop = "factory:ind_squeezer",
	groups = {cracky=3, not_in_creative_inventory=1,hot=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", factory.ind_squeezer_inactive_formspec)
		meta:set_string("infotext", "Industrial Squeezer (working)");
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Industrial Squeezer is empty")
				end
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Industrial Squeezer is empty")
				end
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,
})

minetest.register_abm({
	nodenames = {"factory:ind_squeezer","factory:ind_squeezer_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		for i, name in ipairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
		end

		local height = 0

		for i=1,7 do -- SMOKE TUBE CHECK
			local dn = minetest.get_node({x = pos.x, y = pos.y + i, z = pos.z})
			if dn.name == "factory:smoke_tube" then
				height = height + 1
			else break end
		end

		if minetest.get_node({x = pos.x, y = pos.y + height + 1, z = pos.z}).name ~= "air" then return end

		if height < 1 then return else
			if minetest.get_node(pos).name == "factory:ind_squeezer_active" then
				minetest.add_particlespawner({
					amount = 4,
					time = 3,
					minpos = {x = pos.x - 0.2, y = pos.y + height + 0.3, z = pos.z - 0.2},
					maxpos = {x = pos.x + 0.2, y = pos.y + height + 0.6, z = pos.z + 0.2},
					minvel = {x=-0.4, y=1, z=-0.4},
	    			maxvel = {x=0.4, y=2, z=0.4},
	    			minacc = {x=0, y=0, z=0},
	    			maxacc = {x=0, y=0, z=0},
	    			minexptime = 0.8,
	   				maxexptime = 2,
	   				minsize = 2,
	    			maxsize = 4,
	    			collisiondetection = false,
	    			vertical = false,
	    			texture = "factory_smoke.png",
	    			playername = nil,
				})
			end
		end

		local inv = meta:get_inventory()

		local srclist = inv:get_list("src")
		local cooked = nil
		
		if srclist then
			cooked = factory.get_craft_result({method = "ind_squeezer", width = 1, items = srclist})
		end
		
		local was_active = false
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_float("fuel_time", meta:get_float("fuel_time") + 0.9)
			meta:set_float("src_time", meta:get_float("src_time") + 0.2)
			if cooked and cooked.item and meta:get_float("src_time") >= cooked.time then
				-- check if there's room for output in "dst" list
				if inv:room_for_item("dst",cooked.item) then
					-- Put result in "dst" list
					inv:add_item("dst", cooked.item)
					-- take stuff from "src" list
					local afteritem = inv:get_stack("src", 1)
					afteritem:take_item(1)
					inv:set_stack("src", 1, afteritem)
				else
					--print("Could not insert '"..cooked.item:to_string().."'")
				end
				meta:set_string("src_time", 0)
			end
		end
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			local percent = math.floor(meta:get_float("fuel_time") /
					meta:get_float("fuel_totaltime") * 100)
			meta:set_string("infotext","Industrial Squeezer is working, fuel current used: "..percent.."%")
			factory.swap_node(pos,"factory:ind_squeezer_active")
			meta:set_string("formspec",factory.ind_squeezer_active_formspec(pos, percent))
			return
		end

		local fuel = nil
		local afterfuel
		local cooked = nil
		local fuellist = inv:get_list("fuel")
		local srclist = inv:get_list("src")
		
		if srclist then
			cooked = factory.get_craft_result({method = "ind_squeezer", width = 1, items = srclist})
		end
		if fuellist then
			fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if not fuel or fuel.time <= 0 then
			meta:set_string("infotext","Industrial Squeezer has nothing to burn with")
			factory.swap_node(pos,"factory:ind_squeezer")
			meta:set_string("formspec", factory.ind_squeezer_inactive_formspec)
			return
		end

		if cooked.item:is_empty() then
			if was_active then
				meta:set_string("infotext","Industrial Squeezer is empty")
				factory.swap_node(pos,"factory:ind_squeezer")
				meta:set_string("formspec", factory.ind_squeezer_inactive_formspec)
			end
			return
		end

		meta:set_string("fuel_totaltime", fuel.time)
		meta:set_string("fuel_time", 0)
		
		inv:set_stack("fuel", 1, afterfuel.items[1])
	end,
})