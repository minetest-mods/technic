local supported_nodes = {
["default:chest"] = {name="wrench:default_chest", lists={"main"}},
["default:furnace"] = {name="wrench:default_furnace", lists={"fuel", "src", "dst"}},
["default:furnace_active"] = {name="wrench:default_furnace", lists={"fuel", "src", "dst"}},
["technic:iron_chest"] = {name="wrench:technic_iron_chest", lists={"main"}},
["technic:iron_locked_chest"] = {name="wrench:technic_iron_locked_chest", lists={"main"}},
["technic:copper_chest"] = {name="wrench:technic_copper_chest", lists={"main"}},
["technic:copper_locked_chest"] = {name="wrench:technic_copper_locked_chest", lists={"main"}},
["technic:silver_chest"] = {name="wrench:technic_silver_chest", lists={"main"}},
["technic:silver_locked_chest"] = {name="wrench:technic_silver_locked_chest", lists={"main"}},
["technic:gold_chest"] = {name="wrench:technic_gold_chest", lists={"main"}},
["technic:gold_locked_chest"] = {name="wrench:technic_gold_locked_chest", lists={"main"}},
["technic:mithril_chest"] = {name="wrench:technic_mithril_chest", lists={"main"}},
["technic:mithril_locked_chest"] = {name="wrench:technic_mithril_locked_chest", lists={"main"}},
["technic:electric_furnace"] = {name="wrench:technic_electric_furnace", lists={"src", "dst"}},
["technic:electric_furnace_active"] = {name="wrench:technic_electric_furnace_active", lists={"src", "dst"}},
["technic:mv_electric_furnace"] = {name="wrench:technic_mv_electric_furnace", lists={"src", "dst", "upgrade1", "upgrade2"}},
["technic:mv_electric_furnace_active"] = {name="wrench:technic_mv_electric_furnace_active", lists={"src", "dst", "upgrade1", "upgrade2"}},
["technic:coal_alloy_furnace"] = {name="wrench:technic_coal_alloy_furnace", lists={"fuel", "src", "src2", "dst"}},
["technic:coal_alloy_furnace_active"] = {name="wrench:technic_coal_alloy_furnace_active", lists={"fuel", "src", "src2", "dst"}},
["technic:alloy_furnace"] = {name="wrench:technic_alloy_furnace", lists={"src", "src2", "dst"}},
["technic:alloy_furnace_active"] = {name="wrench:technic_alloy_furnace_active", lists={"src", "src2", "dst"}},
["technic:mv_alloy_furnace"] = {name="wrench:technic_mv_alloy_furnace", lists={"src", "src2", "dst", "upgrade1", "upgrade2"}},
["technic:mv_alloy_furnace_active"] = {name="wrench:technic_mv_alloy_furnace_active", lists={"src", "src2", "dst", "upgrade1", "upgrade2"}},
["technic:grinder"] = {name="wrench:technic_grinder", lists={"src", "dst"}},
["technic:grinder_active"] = {name="wrench:technic_grinder_active", lists={"src", "dst"}},
}
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
for i=1,15,1 do
	supported_nodes["technic:gold_chest"..chest_mark_colors[i][1]] = {name="wrench:technic_gold_chest"..chest_mark_colors[i][1], lists={"main"}}
	supported_nodes["technic:gold_locked_chest"..chest_mark_colors[i][1]] = {name="wrench:technic_gold_locked_chest"..chest_mark_colors[i][1], lists={"main"}}
end

local function convert_to_original_name(name)
	for key,value in pairs(supported_nodes) do
		if name == value.name then return key end
	end
end

for name,_ in pairs(supported_nodes) do
	local olddef = minetest.registered_nodes[name]
	if olddef ~= nil then
		local newdef = {}
		for key,value in pairs(olddef) do
			newdef[key] = value
		end
		name = supported_nodes[name].name
		newdef.stack_max = 1
		newdef.description = newdef.description.." with items"
		newdef.groups.not_in_creative_inventory = 1
		newdef.on_construct = nil
		newdef.on_destruct = nil
		newdef.after_place_node = function(pos, placer, itemstack)
			if olddef.after_place_node ~= nil then olddef.after_place_node(pos, placer, itemstack) end
			if not placer:is_player() then return end
			local node = minetest.get_node(pos)
			local item = convert_to_original_name(itemstack:get_name())
			minetest.set_node(pos, {name = item, param2 = node.param2})
			local inv = minetest.get_meta(pos):get_inventory()
			local data = minetest.deserialize(itemstack:get_metadata())
			for listname,list in pairs(data) do
				inv:set_list(listname, list)
			end
		end
		minetest.register_node(name, newdef)
	end
end


minetest.register_tool("wrench:wrench", {
	description = "Wrench",
	inventory_image = "technic_wrench.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3}
		},
		damage_groups = {fleshy=1},
	},
	on_place = function(itemstack, placer, pointed_thing)
		if not placer:is_player() then return end
		local pos = pointed_thing.under
		if pos == nil then return end
		local name = minetest.get_node(pos).name
		local support = supported_nodes[name]
		if support == nil then return end
		if name:find("_locked_chest") ~= nil then
			local meta = minetest.get_meta(pos)
			if not has_locked_chest_privilege(meta, placer) then
				minetest.log("action", player:get_player_name()..
				" tried to destroy a locked chest belonging to "..
				meta:get_string("owner").." at "..
				minetest.pos_to_string(pos))
				return
			end
		end
		local lists = support.lists
		local inv = minetest.get_meta(pos):get_inventory()
		local empty = true
		local list_str = {}
		for i=1,#lists,1 do
			if not inv:is_empty(lists[i]) then empty = false end
			local list = inv:get_list(lists[i])
			for j=1,#list,1 do
				list[j] = list[j]:to_string()
			end
			list_str[lists[i]] = list
		end
		inv = placer:get_inventory()
		local stack = {}
		stack.name = name
		if inv:room_for_item("main", stack) then
			minetest.remove_node(pos)
			itemstack:add_wear(65535/20)
			if empty then
				inv:add_item("main", stack)
			else
				stack.name = supported_nodes[name].name
				stack.metadata = minetest.serialize(list_str)
				inv:add_item("main", stack)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "wrench:wrench",
	recipe = {
	{"default:iron_lump","","default:iron_lump"},
	{"","default:iron_lump",""},
	{"","default:iron_lump",""},
	},
})