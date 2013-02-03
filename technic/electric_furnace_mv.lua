minetest.register_craft({
	output = 'technic:mv_electric_furnace',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:electric_furnace', 'technic:stainless_steel_ingot'},
		{'pipeworks:tube_000000', 'technic:mv_transformer', 'pipeworks:tube_000000'},
		{'technic:stainless_steel_ingot', 'technic:mv_cable', 'technic:stainless_steel_ingot'},
	}
})


mv_electric_furnace_formspec =
	"invsize[8,10;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,6;8,4;]"..
	"label[0,0;MV Electric Furnace]"..
	"label[1,2.8;Power level]"..
	"list[current_name;upgrade1;1,4;1,1;]"..
	"list[current_name;upgrade2;2,4;1,1;]"..
	"label[1,5;Upgrade Slots]"

minetest.register_node("technic:mv_electric_furnace", {
	description = "MV Electric furnace",
	tiles = {"technic_mv_electric_furnace_top.png", "technic_mv_electric_furnace_bottom.png", "technic_mv_electric_furnace_side_tube.png",
		"technic_mv_electric_furnace_side_tube.png", "technic_mv_electric_furnace_side.png", "technic_mv_electric_furnace_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1,tubedevice_receiver=1,},
		tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
				return inv:add_item("src",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("src",stack)
		end,
		},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	technic_power_machine=1,
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_mv_power_machine", 1)
		meta:set_string("formspec", mv_electric_furnace_formspec)
		meta:set_string("infotext", "Electric furnace")
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		inv:set_size("upgrade1", 1)
		inv:set_size("upgrade2", 1)
		local EU_used  = 0
		local furnace_is_cookin = 0
		local cooked = nil
		meta:set_float("internal_EU_buffer",0)
		meta:set_float("internal_EU_buffer_size",2000)
		meta:set_float("tube_time", 0)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		elseif not inv:is_empty("upgrade1") then
			return false
		elseif not inv:is_empty("upgrade2") then
			return false
		end
		return true
	end,
})

minetest.register_node("technic:mv_electric_furnace_active", {
	description = "MV Electric Furnace",
	tiles = {"technic_mv_electric_furnace_top.png", "technic_mv_electric_furnace_bottom.png", "technic_mv_electric_furnace_side_tube.png",
		"technic_mv_electric_furnace_side_tube.png", "technic_mv_electric_furnace_side.png", "technic_mv_electric_furnace_front_active.png"},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "technic:mv_electric_furnace",
	groups = {cracky=2, tubedevice=1,tubedevice_receiver=1,not_in_creative_inventory=1},
	tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
				return inv:add_item("src",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("src",stack)
		end,
		},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	internal_EU_buffer=0;
	interal_EU_buffer_size=2000;
	technic_power_machine=1,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_mv_power_machine", 1)
		meta:set_string("formspec", mv_electric_furnace_formspec)
		meta:set_string("infotext", "Electric furnace");
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		inv:set_size("upgrade1", 1)
		inv:set_size("upgrade2", 1)
		local EU_used  = 0
		local furnace_is_cookin = 0
		local cooked = nil
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		elseif not inv:is_empty("upgrade1") then
			return false
		elseif not inv:is_empty("upgrade2") then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"technic:mv_electric_furnace","technic:mv_electric_furnace_active"},
	interval = 1,
	chance = 1,

	action = function(pos, node, active_object_count, active_object_count_wider)

		local pos1={}
		pos1.x=pos.x
		pos1.y=pos.y
		pos1.z=pos.z
		local x_velocity=0
		local z_velocity=0
		
		-- output is on the left side of the furnace
		if node.param2==3 then pos1.z=pos1.z-1 z_velocity =-1 end
		if node.param2==2 then pos1.x=pos1.x-1 x_velocity =-1 end
		if node.param2==1 then pos1.z=pos1.z+1 z_velocity = 1 end
		if node.param2==0 then pos1.x=pos1.x+1 x_velocity = 1 end
		
		local output_tube_connected = false
		local meta=minetest.env:get_meta(pos1) 
		if meta:get_int("tubelike")==1 then output_tube_connected=true end
		meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		local upg_item1
		local upg_item1_name=""
		local upg_item2
		local upg_item2_name=""
		local srcstack = inv:get_stack("upgrade1", 1)
		if srcstack then upg_item1=srcstack:to_table() end
		srcstack = inv:get_stack("upgrade2", 1)
		if srcstack then upg_item2=srcstack:to_table() end
		if upg_item1 then upg_item1_name=upg_item1.name end
		if upg_item2 then upg_item2_name=upg_item2.name end
		
		local speed=0
		if upg_item1_name=="technic:control_logic_unit" then speed=speed+1 end
		if upg_item2_name=="technic:control_logic_unit" then speed=speed+1 end
		tube_time=meta:get_float("tube_time")
		tube_time=tube_time+speed
		if tube_time>3 then 
			tube_time=0
			if output_tube_connected then send_cooked_items(pos,x_velocity,z_velocity) end
		end
		meta:set_float("tube_time", tube_time)
			
		local extra_buffer_size = 0
		if upg_item1_name=="technic:battery" then extra_buffer_size =extra_buffer_size + 10000 end
		if upg_item2_name=="technic:battery" then extra_buffer_size =extra_buffer_size + 10000 end
		local internal_EU_buffer_size=2000+extra_buffer_size
		meta:set_float("internal_EU_buffer_size",internal_EU_buffer_size)
		
		internal_EU_buffer=meta:get_float("internal_EU_buffer")
		if internal_EU_buffer > internal_EU_buffer_size then internal_EU_buffer = internal_EU_buffer_size end
		local load = math.floor(internal_EU_buffer/(internal_EU_buffer_size) * 100)
		meta:set_string("formspec",
				"invsize[8,10;]"..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
					(load)..":technic_power_meter_fg.png]"..
				"list[current_name;src;3,1;1,1;]"..
				"list[current_name;dst;5,1;2,2;]"..
				"list[current_player;main;0,6;8,4;]"..
				"label[0,0;MV Electric Furnace]"..
				"label[1,2.8;Power level]"..
				"list[current_name;upgrade1;1,4;1,1;]"..
				"list[current_name;upgrade2;2,4;1,1;]"..
				"label[1,5;Upgrade Slots]")

		local furnace_is_cookin = meta:get_float("furnace_is_cookin")
		
		
		local srclist = inv:get_list("src")
		local cooked=nil 

		if srclist then
		 cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		end
		
		
		if (furnace_is_cookin == 1) then
			if internal_EU_buffer>=150 then
			internal_EU_buffer=internal_EU_buffer-150;
			meta:set_float("internal_EU_buffer",internal_EU_buffer)
			meta:set_float("src_time", meta:get_float("src_time") + 3)
			if cooked and cooked.item and meta:get_float("src_time") >= cooked.time then
				-- check if there's room for output in "dst" list
				if inv:room_for_item("dst",cooked.item) then
					-- Put result in "dst" list
					inv:add_item("dst", cooked.item)
					-- take stuff from "src" list
					srcstack = inv:get_stack("src", 1)
					srcstack:take_item()
					inv:set_stack("src", 1, srcstack)
				else
					print("Furnace inventory full!")
				end
				meta:set_string("src_time", 0)
			end
			end		
		end



		if srclist then
			cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
			if cooked.time>0 then 
			hacky_swap_node(pos,"technic:mv_electric_furnace_active")
			meta:set_string("infotext","Furnace active")
			meta:set_string("furnace_is_cookin",1)
			meta:set_string("src_time", 0)
			return
			end

		end

				hacky_swap_node(pos,"technic:mv_electric_furnace")
				meta:set_string("infotext","Furnace inactive")
				meta:set_string("furnace_is_cookin",0)
				meta:set_string("src_time", 0)

end,
})

function send_cooked_items (pos,x_velocity,z_velocity)
		local meta=minetest.env:get_meta(pos) 
		local inv = meta:get_inventory()
		local i=0
		for _,stack in ipairs(inv:get_list("dst")) do
		i=i+1
			if stack then
			local item0=stack:to_table()
			if item0 then 
				item0["count"]="1"
				local item1=tube_item({x=pos.x,y=pos.y,z=pos.z},item0)
				item1:get_luaentity().start_pos = {x=pos.x,y=pos.y,z=pos.z}
				item1:setvelocity({x=x_velocity, y=0, z=z_velocity})
				item1:setacceleration({x=0, y=0, z=0})
				stack:take_item(1);
				inv:set_stack("dst", i, stack)
				return
				end
			end
		end
end

register_MV_machine ("technic:mv_electric_furnace","RE")
register_MV_machine ("technic:mv_electric_furnace_active","RE")
