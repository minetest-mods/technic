

local S
if intllib then
	S = intllib.Getter()
else
	S = function(s) return s end
end

local chest_mark_colors = {
	{"black", S("Black")},
	{"blue", S("Blue")},
	{"brown", S("Brown")},
	{"cyan", S("Byan")},
	{"dark_green", S("Dark Green")},
	{"dark_grey", S("Dark Grey")},
	{"green", S("Green")},
	{"grey", S("Grey")},
	{"magenta", S("Magenta")},
	{"orange", S("Orange")},
	{"pink", S("Pink")},
	{"red", S("Red")},
	{"violet", S("Violet")},
	{"white", S("White")},
	{"yellow", S("Yellow")},
}


local function colorid_to_postfix(id)
	return chest_mark_colors[id] and "_"..chest_mark_colors[id][1] or ""
end


local function get_color_buttons()
	local buttons_string = ""
	for y = 0, 3 do
		for x = 0, 3 do
			local file_name = "technic_colorbutton"..(y * 4 + x)..".png"
			buttons_string = buttons_string.."image_button["
				..(8.1 + x * 0.7)..","..(6.1 + y * 0.7)
				..";0.8,0.8;"..file_name..";color_button"
				..(y * 4 + x + 1)..";]"
		end
	end
	return buttons_string
end


local function check_color_buttons(pos, meta, chest_name, fields)
	for i = 1, 16 do
		if fields["color_button"..i] then
			technic.swap_node(pos, chest_name..colorid_to_postfix(i))
			meta:set_string("color", i)
			return
		end
	end
end


local function get_receive_fields(name, data)
	if not data.infotext and not data.color then
		return nil
	end
	local lname = name:lower()
	return function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local node = minetest.get_node(pos)
		local page = "main"
		if fields.edit_infotext then
			page = "edit_infotext"
		end
		if fields.save_infotext then
			meta:set_string("infotext", fields.infotext_box)
		end
		local formspec = data.formspec
		local formspec_infotext = minetest.formspec_escape(meta:get_string("infotext"))
		if page == "main" and data.infotext then
			formspec = formspec.."image_button[2.1,0.1;0.8,0.8;"
					.."technic_pencil_icon.png;edit_infotext;]"
					.."label[3,0;"..formspec_infotext.."]"
		end
		if page == "edit_infotext" then
			formspec = formspec.."image_button[2.1,0.1;0.8,0.8;"
					.."technic_checkmark_icon.png;save_infotext;]"
					.."field[3.3,0.2;4.8,1;"
					.."infotext_box;"..S("Edit chest description:")..";"
					..formspec_infotext.."]"
		end
		if data.color then
			-- This sets the node
			local nn = "technic:"..lname..(data.locked and "_locked" or "").."_chest"
			check_color_buttons(pos, meta, nn, fields)
			local colorID = meta:get_int("color")
			local colorName
			if chest_mark_colors[colorID] then
				colorName = chest_mark_colors[colorID][2]
			else
				colorName = S("None")
			end
			formspec = formspec.."label[8.2,9;"..S("Color Filter: %s"):format(colorName).."]"
		end
		meta:set_string("formspec", formspec)
	end
end


function technic.chests:register(name, data)
	local lname = name:lower()
	name = S(name)

	local width = math.max(data.color and 11 or 8, data.width)

	local locked_after_place = nil
	local front = {"technic_"..lname.."_chest_front.png"}
	data.formspec = "invsize["..width..",10;]"..
			"label[0,0;"..name.." Chest]"..
			"list[current_name;main;0,1;"..width..",4;]"..
			"list[current_player;main;0,6;8,4;]"..
			"background[-0.19,-0.25;"..width..".4,10.75;ui_form_bg.png]"..
			"background[0,1;"..width..",4;technic_"..lname.."_chest_inventory.png]"..
			"background[0,6;8,4;ui_main_inventory.png]"
	if data.color then
		data.formspec = data.formspec..get_color_buttons()
	end

	if data.locked then
		locked_after_place = function(pos, placer)
			local meta = minetest.get_meta(pos)
			meta:set_string("owner", placer:get_player_name() or "")
			meta:set_string("infotext",
					S("%s Locked Chest (owned by %s)")
					:format(name, meta:get_string("owner")))
		end
		table.insert(front, "technic_"..lname.."_chest_lock_overlay.png")
	end

	local desc
	if data.locked then
		desc = S("%s Locked Chest"):format(name)
	else
		desc = S("%s Chest"):format(name)
	end

	local def = {
		description = desc,
		tiles = {"technic_"..lname.."_chest_top.png", "technic_"..lname.."_chest_top.png",
			"technic_"..lname.."_chest_side.png", "technic_"..lname.."_chest_side.png",
			"technic_"..lname.."_chest_side.png", table.concat(front, "^")},
		paramtype2 = "facedir",
		groups = self.groups,
		tube = self.tube,
		legacy_facedir_simple = true,
		sounds = default.node_sound_wood_defaults(),
		after_place_node = locked_after_place,
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", data.formspec
				..(data.color and "label[8.2,9;Color Filter: None" or "")
				..(data.infotext and "image_button[2.1,0.1;0.8,0.8;"
					.."technic_pencil_icon.png;edit_infotext;]" or ""))
			meta:set_string("infotext", S("%s Chest"):format(name))
			local inv = meta:get_inventory()
			inv:set_size("main", data.width * 4)
		end,
		can_dig = self.can_dig,
		on_receive_fields = get_receive_fields(name, data),
		on_metadata_inventory_move = self.on_inv_move,
		on_metadata_inventory_put = self.on_inv_put,
		on_metadata_inventory_take = self.on_inv_take,
	}
	if data.locked then
		def.allow_metadata_inventory_move = self.inv_move
		def.allow_metadata_inventory_put = self.inv_put
		def.allow_metadata_inventory_take = self.inv_take
	end

	local nn = "technic:"..lname..(data.locked and "_locked" or "").."_chest"

	minetest.register_node(":"..nn, def)

	if data.color then
		front[3] = front[2]
		for i = 1, 15 do
			local postfix = colorid_to_postfix(i)
			local colordef = {}
			for k, v in pairs(def) do
				colordef[k] = v
			end
			colordef.drop = nn
			colordef.groups = self.groups_noinv
			front[2] = "technic_chest_overlay"..postfix..".png"
			colordef.tiles[6] = table.concat(front, "^")
			minetest.register_node(":"..nn..postfix, colordef)
		end
	end

end

