local S = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end

local pipeworks = rawget(_G, "pipeworks")
local fs_helpers
local tubelib_exists = minetest.global_exists("tubelib")

local registered_chest_data = {} -- data passed to :register()

local allow_label = ""
local tube_entry = ""

if not minetest.get_modpath("pipeworks") then
	-- Pipeworks is not installed. Simulate using a dummy table...
	pipeworks = {}
	fs_helpers = {}
	local pipeworks_meta = {}
	setmetatable(pipeworks, pipeworks_meta)
	local dummy = function()
		end
	pipeworks_meta.__index = function(table, key)
			print("[technic_chests] WARNING: variable or method '"..key.."' not present in dummy pipeworks table - assuming it is a method...")
			pipeworks[key] = dummy
			return dummy
		end
	pipeworks.after_place = dummy
	pipeworks.after_dig = dummy
	fs_helpers.cycling_button = function() return "" end
else
	fs_helpers = pipeworks.fs_helpers
	allow_label = "Allow splitting incoming stacks from tubes"
	tube_entry = "^pipeworks_tube_connection_metallic.png"
end

-- Change the appearance of the chest
local chest_mark_colors = {
	{"black", S("Black")},
	{"blue", S("Blue")},
	{"brown", S("Brown")},
	{"cyan", S("Cyan")},
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


local function get_color_buttons(coleft, lotop)
	local buttons_string = ""
	for y = 0, 3 do
		for x = 0, 3 do
			local file_name = "technic_colorbutton"..(y * 4 + x)..".png"
			buttons_string = buttons_string.."image_button["
				..(coleft + 0.1 + x * 0.7)..","..(lotop + 0.1 + y * 0.7)
				..";0.8,0.8;"..file_name..";color_button"
				..(y * 4 + x + 1)..";]"
		end
	end
	return buttons_string
end


local function check_color_buttons(pos, meta, chest_name, fields)
	for i = 1, 16 do
		if fields["color_button"..i] then
			local node = minetest.get_node(pos)
			node.name = chest_name..colorid_to_postfix(i)
			minetest.swap_node(pos, node)
			meta:set_string("color", i)
			return
		end
	end
end

local function set_formspec(pos, data, page)
	local meta = minetest.get_meta(pos)

	-- Static formspec elements are in base_formspec
	local fs = { data.base_formspec }

	-- Pipeworks splitting setting
	fs[#fs + 1] = fs_helpers.cycling_button(
		meta,
		"image_button[0,0.5;1,0.6",
		"splitstacks",
		{
			pipeworks.button_off,
			pipeworks.button_on
		}
	)

	if data.autosort then
		local status = meta:get_int("autosort")
		fs[#fs + 1] = ("checkbox[%g,%g;autosort_to_%s;%s;%s]"):format(
			data.hileft + 2.2, data.lotop - 1.15,
			tostring(1 - status), S("Auto-sort upon exit"), tostring(status == 1))
	end

	if data.infotext then
		local formspec_infotext = minetest.formspec_escape(meta:get_string("infotext"))

		local button_fmt = "image_button[%g,0;0.8,0.8;%s;%s;]"
		if page == "main" then
			fs[#fs + 1] = button_fmt:format(data.hileft + 6.1,
				"technic_pencil_icon.png", "edit_infotext")

			fs[#fs + 1] = "label["..(data.hileft+7.1)..",0.1;"..formspec_infotext.."]"
		elseif page == "edit_infotext" then
			fs[#fs + 1] = button_fmt:format(data.hileft + 6.1,
				"technic_checkmark_icon.png", "save_infotext")

			fs[#fs + 1] = "field["..(data.hileft+7.3)..",0.2;4,1;"
					.."infotext_box;;"
					..formspec_infotext.."]"
		end
	end
	if data.color then
		local colorID = meta:get_int("color")
		local colorName
		if chest_mark_colors[colorID] then
			colorName = chest_mark_colors[colorID][2]
		else
			colorName = S("None")
		end
		fs[#fs + 1] = "label["..(data.coleft+0.2)..","..(data.lotop+3)..";"..S("Color Filter: %s"):format(colorName).."]"
	end
	meta:set_string("formspec", table.concat(fs))
end

local function sort_inventory(inv)
	local inlist = inv:get_list("main")
	local typecnt = {}
	local typekeys = {}
	for _, st in ipairs(inlist) do
		if not st:is_empty() then
			local n = st:get_name()
			local w = st:get_wear()
			local m = st:get_metadata()
			local k = string.format("%s %05d %s", n, w, m)
			if not typecnt[k] then
				typecnt[k] = {st}
				table.insert(typekeys, k)
			else
				table.insert(typecnt[k], st)
			end
		end
	end
	table.sort(typekeys)
	inv:set_list("main", {})
	for _, k in ipairs(typekeys) do
		for _, item in ipairs(typecnt[k]) do
			inv:add_item("main", item)
		end
	end
end

local function get_receive_fields(name, data)
	local lname = name:lower()
	return function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local page = "main"

		local owner = meta:get_string("owner")
		if owner ~= "" then
			-- prevent modification of locked chests
			if owner ~= sender:get_player_name() then return end
		elseif not fields.quit then
			-- prevent modification of protected chests
			if minetest.is_protected(pos, sender:get_player_name()) then return end
		end

		if fields.sort or (data.autosort and fields.quit and meta:get_int("autosort") == 1) then
			sort_inventory(meta:get_inventory())
			return -- No formspec update
		end
		if fields.edit_infotext then
			page = "edit_infotext"
		end
		if fields.autosort_to_1 then meta:set_int("autosort", 1) end
		if fields.autosort_to_0 then meta:set_int("autosort", 0) end
		if fields.infotext_box then
			meta:set_string("infotext", fields.infotext_box)
		end
		if data.color then
			-- This sets the node
			local nn = "technic:"..lname..(data.locked and "_locked" or "").."_chest"
			check_color_buttons(pos, meta, nn, fields)
		end
		if fields["fs_helpers_cycling:0:splitstacks"]
		  or fields["fs_helpers_cycling:1:splitstacks"] then
			if not pipeworks.may_configure(pos, sender) then return end
			fs_helpers.on_receive_fields(pos, fields)
		end

		set_formspec(pos, data, page)
	end
end

function technic.chests:definition(name, data)
	local lname = name:lower()
	name = S(name)

	-- Calculate formspec positions
	data.lowidth = 8
	data.ovwidth = math.max(data.lowidth, data.width)
	data.hileft = (data.ovwidth - data.width) / 2
	data.loleft = (data.ovwidth - data.lowidth) / 2
	if data.color then
		if data.lowidth + 3 <= data.ovwidth then
			data.coleft = data.ovwidth - 3
			if data.loleft + data.lowidth > data.coleft then
				data.loleft = data.coleft - data.lowidth
			end
		else
			data.loleft = 0
			data.coleft = data.lowidth
			data.ovwidth = data.lowidth + 3
		end
	end
	data.lotop = data.height + 2
	data.ovheight = data.lotop + 4

	-- Set up constant formspec fields
	local fs = {
		"size["..data.ovwidth..","..data.ovheight.."]",
		"label[0,0;"..S("%s Chest"):format(name).."]",
		"list[context;main;"..data.hileft..",1;"..data.width..","..data.height..";]",
		"list[current_player;main;"..data.loleft..","..data.lotop..";8,4;]",
		"listring[]"
	}
	if #allow_label > 0 then
		fs[#fs + 1] = ("label[0.9,0.5;%s]"):format(allow_label)
	end

	if data.color then
		fs[#fs + 1] = get_color_buttons(data.coleft, data.lotop)
	end

	if data.sort then
		fs[#fs + 1] = ("button[%g,%g;2,0.7;sort;%s]"):format(
			data.hileft, data.lotop - 1, S("Sort now"))
	end
	data.base_formspec = table.concat(fs)

	local front = {"technic_"..lname.."_chest_front.png"}
	local locked_after_place
	if data.locked then
		locked_after_place = function(pos, placer)
			local meta = minetest.get_meta(pos)
			meta:set_string("owner", placer:get_player_name() or "")
			meta:set_string("infotext",
					S("%s Locked Chest (owned by %s)")
					:format(name, meta:get_string("owner")))
			pipeworks.after_place(pos)
		end
		table.insert(front, "technic_"..lname.."_chest_lock_overlay.png")
	else
		locked_after_place = pipeworks.after_place
	end

	local desc
	if data.locked then
		desc = S("%s Locked Chest"):format(name)
	else
		desc = S("%s Chest"):format(name)
	end

	local tentry = tube_entry
	if tube_entry ~= "" then
		if lname == "wooden" then
			tentry = "^pipeworks_tube_connection_wooden.png"
		elseif lname == "mithril" then
			tentry = "^pipeworks_tube_connection_stony.png"
		end
	end
	local def = {
		description = desc,
		tiles = {
			"technic_"..lname.."_chest_top.png"..tentry,
			"technic_"..lname.."_chest_top.png"..tentry,
			"technic_"..lname.."_chest_side.png"..tentry,
			"technic_"..lname.."_chest_side.png"..tentry,
			"technic_"..lname.."_chest_side.png"..tentry,
			table.concat(front, "^")
		},
		paramtype2 = "facedir",
		groups = self.groups,
		tube = self.tube,
		legacy_facedir_simple = true,
		sounds = default.node_sound_wood_defaults(),
		after_place_node = locked_after_place,
		after_dig_node = pipeworks.after_dig,

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", S("%s Chest"):format(name))
			set_formspec(pos, data, "main")
			local inv = meta:get_inventory()
			inv:set_size("main", data.width * data.height)
		end,
		can_dig = self.can_dig,
		on_receive_fields = get_receive_fields(name, data),
		on_metadata_inventory_move = self.on_inv_move,
		on_metadata_inventory_put = self.on_inv_put,
		on_metadata_inventory_take = self.on_inv_take,
		on_blast = function(pos)
			local drops = {}
			default.get_inventory_drops(pos, "main", drops)
			drops[#drops+1] = "technic:"..name:lower()..(data.locked and "_locked" or "").."_chest"
			minetest.remove_node(pos)
			return drops
		end,
	}
	if data.locked then
		def.allow_metadata_inventory_move = self.inv_move
		def.allow_metadata_inventory_put = self.inv_put
		def.allow_metadata_inventory_take = self.inv_take
		def.on_blast = function() end
		def.can_dig = function(pos,player)
			local meta = minetest.get_meta(pos);
			local inv = meta:get_inventory()
			return inv:is_empty("main") and default.can_interact_with_node(player, pos)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("owner")
			local name = player:get_player_name()

			-- verify placer is owner of lockable chest
			if owner ~= name then
				minetest.record_protection_violation(pos, name)
				minetest.chat_send_player(name, "You do not own this chest.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked chest", owner
		end
	end
	return def
end

local _TUBELIB_CALLBACKS = {
	on_pull_item = function(pos, side, player_name)
		if not minetest.is_protected(pos, player_name) then
			local inv = minetest.get_meta(pos):get_inventory()
			for _, stack in pairs(inv:get_list("main")) do
				if not stack:is_empty() then
					return inv:remove_item("main", stack:get_name())
				end
			end
		end
		return nil
	end,
	on_push_item = function(pos, side, item, player_name)
		local inv = minetest.get_meta(pos):get_inventory()
		if inv:room_for_item("main", item) then
			inv:add_item("main", item)
			return true
		end
		return false
	end,
	on_unpull_item = function(pos, side, item, player_name)
		local inv = minetest.get_meta(pos):get_inventory()
		if inv:room_for_item("main", item) then
			inv:add_item("main", item)
			return true
		end
		return false
	end,
}

function technic.chests:register(name, data)
	data = table.copy(data) -- drop reference
	local def = technic.chests:definition(name, data)

	local nn = "technic:"..name:lower()..(data.locked and "_locked" or "").."_chest"
	minetest.register_node(":"..nn, def)
	registered_chest_data[nn] = data

	if tubelib_exists then
		tubelib.register_node(nn, {}, _TUBELIB_CALLBACKS)
	end

	if data.color then
		local mk_front
		if string.find(def.tiles[6], "%^") then
			mk_front = function (overlay) return def.tiles[6]:gsub("%^", "^"..overlay.."^") end
		else
			mk_front = function (overlay) return def.tiles[6].."^"..overlay end
		end
		for i = 1, 15 do
			local postfix = colorid_to_postfix(i)
			local colordef = {}
			for k, v in pairs(def) do
				colordef[k] = v
			end
			colordef.drop = nn
			colordef.groups = self.groups_noinv
			colordef.tiles = { def.tiles[1], def.tiles[2], def.tiles[3], def.tiles[4], def.tiles[5], mk_front("technic_chest_overlay"..postfix..".png") }

			local new_name = nn .. postfix
			minetest.register_node(":" .. new_name, colordef)
			registered_chest_data[new_name] = data -- for all colors

			if tubelib_exists then
				tubelib.register_node(nn..postfix, {}, _TUBELIB_CALLBACKS)
			end
		end
	end
end


-- Migration of chest formspecs
-- Group is specified in common.lua
minetest.register_lbm({
	label = "technic_chests formspec upgrade",
	name = "technic_chests:upgrade_formspec",
	nodenames = {"group:technic_chest"},
	run_at_every_load = false,
	action = function(pos, node)
		set_formspec(pos, registered_chest_data[node.name], "main")
	end
})
