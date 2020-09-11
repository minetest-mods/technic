
local S = technic.getter

local fs_helpers = pipeworks.fs_helpers

local tube_entry = "^pipeworks_tube_connection_metallic.png"

local function inject_items (pos)
		local meta=minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local mode=meta:get_string("mode")
		if mode=="single items" then
			local i=0
			for _,stack in ipairs(inv:get_list("main")) do
			i=i+1
				if stack then
				local item0=stack:to_table()
				if item0 then
					item0["count"] = 1
					technic.tube_inject_item(pos, pos, vector.new(0, -1, 0), item0)
					stack:take_item(1)
					inv:set_stack("main", i, stack)
					return
					end
				end
			end
		end
		if mode=="whole stacks" then
			local i=0
			for _,stack in ipairs(inv:get_list("main")) do
			i=i+1
				if stack then
				local item0=stack:to_table()
				if item0 then
					technic.tube_inject_item(pos, pos, vector.new(0, -1, 0), item0)
					stack:clear()
					inv:set_stack("main", i, stack)
					return
					end
				end
			end
		end

end

minetest.register_craft({
	output = 'technic:injector 1',
	recipe = {
		{'', 'technic:control_logic_unit',''},
		{'', 'default:chest',''},
		{'', 'pipeworks:tube_1',''},
	}
})

local function set_injector_formspec(meta)
	local is_stack = meta:get_string("mode") == "whole stacks"
	meta:set_string("formspec",
		"size[8,9;]"..
		"item_image[0,0;1,1;technic:injector]"..
		"label[1,0;"..S("Self-Contained Injector").."]"..
		(is_stack and
			"button[0,1;2,1;mode_item;"..S("Stackwise").."]" or
			"button[0,1;2,1;mode_stack;"..S("Itemwise").."]")..
		"list[current_name;main;0,2;8,2;]"..
		"list[current_player;main;0,5;8,4;]"..
		"listring[]"..
		fs_helpers.cycling_button(
			meta,
			pipeworks.button_base,
			"splitstacks",
			{
				pipeworks.button_off,
				pipeworks.button_on
			}
		)..pipeworks.button_label
	)
end

minetest.register_node("technic:injector", {
	description = S("Self-Contained Injector"),
	tiles = {
		"technic_injector_top.png"..tube_entry,
		"technic_injector_bottom.png",
		"technic_injector_side.png"..tube_entry,
		"technic_injector_side.png"..tube_entry,
		"technic_injector_side.png"..tube_entry,
		"technic_injector_side.png"
	},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, tubedevice=1, tubedevice_receiver=1},
	tube = {
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if meta:get_int("splitstacks") == 1 then
				stack = stack:peek_item(1)
			end
			return inv:room_for_item("main", stack)
		end,
		insert_object = function(pos, node, stack, direction)
			return minetest.get_meta(pos):get_inventory():add_item("main", stack)
		end,
		connect_sides = {left=1, right=1, back=1, top=1, bottom=1},
	},
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Self-Contained Injector"))
		local inv = meta:get_inventory()
		inv:set_size("main", 8*2)
		meta:set_string("mode","single items")
		set_injector_formspec(meta)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_receive_fields = function(pos, formanme, fields, sender)
		if minetest.is_protected(pos, sender:get_player_name()) then return end

		local meta = minetest.get_meta(pos)
		if fields.mode_item then meta:set_string("mode", "single items") end
		if fields.mode_stack then meta:set_string("mode", "whole stacks") end

		if fields["fs_helpers_cycling:0:splitstacks"]
		  or fields["fs_helpers_cycling:1:splitstacks"] then
			if not pipeworks.may_configure(pos, sender) then return end
			fs_helpers.on_receive_fields(pos, fields)
		end
		set_injector_formspec(meta)
	end,
	allow_metadata_inventory_put = technic.machine_inventory_put,
	allow_metadata_inventory_take = technic.machine_inventory_take,
	allow_metadata_inventory_move = technic.machine_inventory_move,
	after_place_node = pipeworks.after_place,
	after_dig_node = pipeworks.after_dig
})

minetest.register_abm({
	label = "Machines: run injector",
	nodenames = {"technic:injector"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local pos1 = vector.add(pos, vector.new(0, -1, 0))
		local node1 = minetest.get_node(pos1)
		if minetest.get_item_group(node1.name, "tubedevice") > 0 then
			inject_items(pos)
		end
	end,
})

