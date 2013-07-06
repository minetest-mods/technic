minetest.register_craft({
	output = 'technic:silver_chest',
	recipe = {
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		{'moreores:silver_ingot','technic:copper_chest','moreores:silver_ingot'},
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:silver_locked_chest',
	recipe = {
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
		{'moreores:silver_ingot','technic:copper_locked_chest','moreores:silver_ingot'},
		{'moreores:silver_ingot','moreores:silver_ingot','moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:silver_locked_chest',
	recipe = {
		{'default:steel_ingot'},
		{'technic:silver_chest'},
	}
})

minetest.register_craftitem(":technic:silver_chest", {
	description = "Silver Chest",
	stack_max = 99,
})
minetest.register_craftitem(":technic:silver_locked_chest", {
	description = "Silver Locked Chest",
	stack_max = 99,
})

silver_chest_formspec = 
				"invsize[11,10;]"..
				"list[current_name;main;0,1;11,4;]"..
				"list[current_player;main;0,6;8,4;]"..
				"background[-0.19,-0.25;11.4,10.75;ui_form_bg.png]"..
				"background[0,1;11,4;ui_silver_chest_inventory.png]"..
				"background[0,6;8,4;ui_main_inventory.png]"
				
minetest.register_node(":technic:silver_chest", {
	description = "Silver Chest",
	tiles = {"technic_silver_chest_top.png", "technic_silver_chest_top.png", "technic_silver_chest_side.png",
		"technic_silver_chest_side.png", "technic_silver_chest_side.png", "technic_silver_chest_front.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				silver_chest_formspec..
				"label[0,0;Silver Chest]"..
				"image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]")
		meta:set_string("infotext", "Silver Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 11*4)
	end,
	can_dig = chest_can_dig,

	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos)
      	local page="main"
      	if fields.edit_infotext then 
			page="edit_infotext"
      	end
      	if fields.save_infotext then 
			meta:set_string("infotext",fields.infotext_box)
      	end
		local formspec = silver_chest_formspec.."label[0,0;Silver Chest]"
		if page=="main" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"
			formspec = formspec.."label[4,0;"..meta:get_string("infotext").."]"
		end
		if page=="edit_infotext" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;ok_icon.png;save_infotext;]"
			formspec = formspec.."field[4.3,.2;6,1;infotext_box;Edit chest description:;"..meta:get_string("infotext").."]"
		end			
		meta:set_string("formspec",formspec)
	end,

	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})

minetest.register_node(":technic:silver_locked_chest", {
	description = "Silver Locked Chest",
	tiles = {"technic_silver_chest_top.png", "technic_silver_chest_top.png", "technic_silver_chest_side.png",
		"technic_silver_chest_side.png", "technic_silver_chest_side.png", "technic_silver_chest_locked.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Silver Locked Chest (owned by "..
			meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				silver_chest_formspec..
				"label[0,0;Silver Locked Chest]"..
				"image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 11*4)
	end,
	can_dig = chest_can_dig,

	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos)
      	local page="main"
      	if fields.edit_infotext then 
			page="edit_infotext"
      	end
      	if fields.save_infotext then 
			meta:set_string("infotext",fields.infotext_box)
      	end
		local formspec = silver_chest_formspec.."label[0,0;Silver Locked Chest]"
		if page=="main" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"
			formspec = formspec.."label[4,0;"..meta:get_string("infotext").."]"
		end
		if page=="edit_infotext" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;ok_icon.png;save_infotext;]"
			formspec = formspec.."field[4.3,.2;6,1;infotext_box;Edit chest description:;"..meta:get_string("infotext").."]"
		end			
		meta:set_string("formspec",formspec)
	end,

	allow_metadata_inventory_move = def_allow_metadata_inventory_move,
	allow_metadata_inventory_put = def_allow_metadata_inventory_put,
	allow_metadata_inventory_take = def_allow_metadata_inventory_take,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
