local chest_mark_colors = {
    {'_black','Black'},
    {'_blue','Blue'}, 
    {'_brown','Brown'},
    {'_cyan','Cyan'},
    {'_dark_green','Dark Green'},
    {'_dark_grey','Dark Grey'},
    {'_green','Green'},
    {'_grey','Grey'},
    {'_magenta','Magenta'},
    {'_orange','Orange'},
    {'_pink','Pink'},
    {'_red','Red'},
    {'_violet','Violet'},
    {'_white','White'},
    {'_yellow','Yellow'},
    {'','None'}
}

minetest.register_craft({
	output = 'technic:gold_chest',
	recipe = {
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
		{'default:gold_ingot','technic:silver_chest','default:gold_ingot'},
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:gold_locked_chest',
	recipe = {
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
		{'default:gold_ingot','technic:silver_locked_chest','default:gold_ingot'},
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:gold_locked_chest',
	recipe = {
		{'default:steel_ingot'},
		{'technic:gold_chest'},
	}
})

minetest.register_craftitem(":technic:gold_chest", {
	description = "Gold Chest",
	stack_max = 99,
})
minetest.register_craftitem(":technic:gold_locked_chest", {
	description = "Gold Locked Chest",
	stack_max = 99,
})

function get_pallette_buttons ()
local buttons_string=""
	for y=0,3,1 do
		for x=0,3,1 do
			local file_name="ui_colorbutton"..(y*4+x)..".png"
			buttons_string=buttons_string.."image_button["..(9.2+x*.7)..","..(6+y*.7)..";.81,.81;"..file_name..";color_button"..(y*4+x)..";]"
		end
	end	
return buttons_string
end

gold_chest_formspec	=	"invsize[12,10;]"..
						"list[current_name;main;0,1;12,4;]"..
						"list[current_player;main;0,6;8,4;]"..
						"background[-0.19,-0.25;12.4,10.75;ui_form_bg.png]"..
						"background[0,1;12,4;ui_gold_chest_inventory.png]"..
						"background[0,6;8,4;ui_main_inventory.png]"..
						get_pallette_buttons ()

gold_chest_inv_size = 12*4

minetest.register_node(":technic:gold_chest", {
	description = "Gold Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_front.png"},
	paramtype2 = "facedir",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",gold_chest_formspec..
			"label[0,0;Gold Chest]"..
			"image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"..		
			"label[9.2,9;Color Filter: None")
		meta:set_string("infotext", "Gold Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", gold_chest_inv_size)
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
		local formspec = gold_chest_formspec.."label[0,0;Gold Chest]"
		if page=="main" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"
			formspec = formspec.."label[4,0;"..meta:get_string("infotext").."]"
		end
		if page=="edit_infotext" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;ok_icon.png;save_infotext;]"
			formspec = formspec.."field[4.3,.2;6,1;infotext_box;Edit chest description:;"..meta:get_string("infotext").."]"
		end			
		formspec = formspec .. "label[9.2,9;Color Filter: "..chest_mark_colors[check_color_buttons (pos,"technic:gold_chest",fields)][2].."]"		
		meta:set_string("formspec",formspec)
	end,

	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})

for i=1,15,1 do
minetest.register_node(":technic:gold_chest".. chest_mark_colors[i][1], {
	description = "Gold Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_front"..chest_mark_colors[i][1]..".png"},
	paramtype2 = "facedir",
	groups = chest_groups2,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:gold_chest",
	can_dig =chest_can_dig,
	
	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos)
        local page="main"
      	if fields.edit_infotext then 
			page="edit_infotext"
      	end
      	if fields.save_infotext then 
			meta:set_string("infotext",fields.infotext_box)
      	end
		local formspec = gold_chest_formspec.."label[0,0;Gold Chest]"
		if page=="main" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"
			formspec = formspec.."label[4,0;"..meta:get_string("infotext").."]"
		end
		if page=="edit_infotext" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;ok_icon.png;save_infotext;]"
			formspec = formspec.."field[4.3,.2;6,1;infotext_box;Edit chest description:;"..meta:get_string("infotext").."]"
		end			
		formspec = formspec .. "label[9.2,9;Color Filter: "..chest_mark_colors[check_color_buttons (pos,"technic:gold_chest",fields)][2].."]"		
		meta:set_string("formspec",formspec)
	end,

	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
end

minetest.register_node(":technic:gold_locked_chest", {
	description = "Gold Locked Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_locked.png"},
	paramtype2 = "facedir",
	drop = "technic:gold_locked_chest",
	groups = chest_groups1,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Gold Locked Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				gold_chest_formspec..
				"label[0,0;Gold Locked Chest]"..
				"image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"..
				"label[9.2,9;Color Filter: None")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", gold_chest_inv_size)
	end,

	can_dig =chest_can_dig,

	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos)
      	local formspec = gold_chest_formspec..
			"label[0,0;Gold Locked Chest]"
		local page="main"
      	if fields.edit_infotext then 
			page="edit_infotext"
      	end
      	if fields.save_infotext then 
			meta:set_string("infotext",fields.infotext_box)
      	end
		if page=="main" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"
			formspec = formspec.."label[4,0;"..meta:get_string("infotext").."]"
		end
		if page=="edit_infotext" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;ok_icon.png;save_infotext;]"
			formspec = formspec.."field[4.3,.2;6,1;infotext_box;Edit chest description:;"..meta:get_string("infotext").."]"
		end	
		formspec = formspec .. "label[9.2,9;Color Filter: "..chest_mark_colors[check_color_buttons (pos,"technic:gold_locked_chest",fields)][2].."]"		
		meta:set_string("formspec",formspec)
	end,

	allow_metadata_inventory_move = def_allow_metadata_inventory_move,
	allow_metadata_inventory_put = def_allow_metadata_inventory_put,
	allow_metadata_inventory_take = def_allow_metadata_inventory_take,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})

for i=1,15,1 do
minetest.register_node(":technic:gold_locked_chest".. chest_mark_colors[i][1], {
	description = "Gold Locked Chest",
	tiles = {"technic_gold_chest_top.png", "technic_gold_chest_top.png", "technic_gold_chest_side.png",
		"technic_gold_chest_side.png", "technic_gold_chest_side.png", "technic_gold_chest_locked"..chest_mark_colors[i][1]..".png"},
	paramtype2 = "facedir",
	drop = "technic:gold_locked_chest",
	groups = chest_groups2,
	tube = tubes_properties,
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	can_dig = chest_can_dig,

	on_receive_fields = function(pos, formname, fields, sender)
        local meta = minetest.env:get_meta(pos)
      	local formspec = gold_chest_formspec..
				"label[0,0;Gold Locked Chest]"
      	local page="main"
      	if fields.edit_infotext then 
			page="edit_infotext"
      	end
      	if fields.save_infotext then 
			meta:set_string("infotext",fields.infotext_box)
      	end
		if page=="main" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;pencil_icon.png;edit_infotext;]"
			formspec = formspec.."label[4,0;"..meta:get_string("infotext").."]"
		end
		if page=="edit_infotext" then
			formspec = formspec.."image_button[3.5,.1;.6,.6;ok_icon.png;save_infotext;]"
			formspec = formspec.."field[4.3,.2;6,1;infotext_box;Edit chest description:;"..meta:get_string("infotext").."]"
		end			
		formspec = formspec .. "label[9.2,9;Color Filter: "..chest_mark_colors[check_color_buttons (pos,"technic:gold_locked_chest",fields)][2].."]"		
		meta:set_string("formspec",formspec)
	end,

	allow_metadata_inventory_move = def_allow_metadata_inventory_move,
	allow_metadata_inventory_put = def_allow_metadata_inventory_put,
	allow_metadata_inventory_take = def_allow_metadata_inventory_take,
	on_metadata_inventory_move = def_on_metadata_inventory_move,
	on_metadata_inventory_put = def_on_metadata_inventory_put,
	on_metadata_inventory_take = def_on_metadata_inventory_take 
})
end

function check_color_buttons (pos,chest_name,fields)
	if fields.color_button15 then
		hacky_swap_node(pos,chest_name)
		return 16
	end
	for i=0,14,1 do
		local button="color_button"..i
		if fields[button] then
			hacky_swap_node(pos,chest_name..chest_mark_colors[i+1][1])
			return i+1
		end
	end
	return 16
end	
	
