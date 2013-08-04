--[[
	Wrench mod
		Adds a wrench that allows the player to pickup nodes that contain an inventory with items or metadata that needs perserving.
		The wrench has the same tool capability as the normal hand.
		To pickup a node simply right click on it. If the node contains a formspec, you will need to shift+right click instead.
	supported_nodes
		This table stores all nodes that are compatible with the wrench mod.
		Syntax:
			[<node name>] = {
				name = "wrench:<temporary node name>",
				lists = {"<inventory list name>"},
				metas = {{string="<meta name>"},{int="<meta name>"},{float="<meta name>"}},
				owner_protection[optional] = 1,
				store_meta_always[optional] = 1,
			}
			<temporary node name> - can be anything as long as it is unique
			[optional] - parameters do not have to be included
			owner_protection - nodes that are protected by owner requirements (Ex. locked chests)
			store_meta_always - when nodes are broken this ensures metadata and inventory is always stored (Ex. active state for machines)
--]]
local supported_nodes = {
["default:chest"] = {
	name="wrench:default_chest",
	lists={"main"},
	metas={},
},
["default:chest_locked"] = {
	name="wrench:default_chest_locked",
	lists={"main"},
	metas={{string="owner"},{string="infotext"}},
	owner_protection=1,
},
["default:furnace"] = {
	name="wrench:default_furnace",
	lists={"fuel", "src", "dst"},
	metas={{string="infotext"},{float="fuel_totaltime"},{float="fuel_time"},{float="src_totaltime"},{float="src_time"}},
},
["default:furnace_active"] = {
	name="wrench:default_furnace",
	lists={"fuel", "src", "dst"},
	metas={{string="infotext"},{float="fuel_totaltime"},{float="fuel_time"},{float="src_totaltime"},{float="src_time"}},
	store_meta_always=1,
},
["default:sign_wall"] = {
	name="wrench:default_sing_wall",
	lists={},
	metas={{string="infotext"},{string="text"}},
},
["technic:iron_chest"] = {
	name="wrench:technic_iron_chest",
	lists={"main"},
	metas={},
},
["technic:iron_locked_chest"] = {
	name="wrench:technic_iron_locked_chest",
	lists={"main"},
	metas={{string="infotext"},{string="owner"}},
	owner_protection=1,
},
["technic:copper_chest"] = {
	name="wrench:technic_copper_chest",
	lists={"main"},
	metas={},
},
["technic:copper_locked_chest"] = {
	name="wrench:technic_copper_locked_chest",
	lists={"main"},
	metas={{string="infotext"},{string="owner"}},
	owner_protection=1,
},
["technic:silver_chest"] = {
	name="wrench:technic_silver_chest",
	lists={"main"},
	metas={{string="infotext"},{string="formspec"}},
},
["technic:silver_locked_chest"] = {
	name="wrench:technic_silver_locked_chest",
	lists={"main"},
	metas={{string="infotext"},{string="owner"},{string="formspec"}},
	owner_protection=1,
	},
["technic:gold_chest"] = {
	name="wrench:technic_gold_chest",
	lists={"main"},
	metas={{string="infotext"},{string="formspec"}},
},
["technic:gold_locked_chest"] = {
	name="wrench:technic_gold_locked_chest",
	lists={"main"},
	metas={{string="infotext"},{string="owner"},{string="formspec"}},
	owner_protection=1,
},
["technic:mithril_chest"] = {
	name="wrench:technic_mithril_chest",
	lists={"main"},
	metas={{string="infotext"},{string="formspec"}},
},
["technic:mithril_locked_chest"] = {
	name="wrench:technic_mithril_locked_chest",
	lists={"main"},
	metas={{string="infotext"},{string="owner"},{string="formspec"}},
	owner_protection=1,
},
["technic:electric_furnace"] = {
	name="wrench:technic_electric_furnace",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
},
["technic:electric_furnace_active"] = {
	name="wrench:technic_electric_furnace_active",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
	store_meta_always=1,
},
["technic:mv_electric_furnace"] = {
	name="wrench:technic_mv_electric_furnace",
	lists={"src", "dst", "upgrade1", "upgrade2"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="MV_EU_demand"},{int="MV_EU_input"},{int="tube_time"},{int="src_time"}},
},
["technic:mv_electric_furnace_active"] = {
	name="wrench:technic_mv_electric_furnace_active",
	lists={"src", "dst", "upgrade1", "upgrade2"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="MV_EU_demand"},{int="MV_EU_input"},{int="tube_time"},{int="src_time"}},
	store_meta_always=1,
},
["technic:coal_alloy_furnace"] = {
	name="wrench:technic_coal_alloy_furnace",
	lists={"fuel", "src", "src2", "dst"},
	metas={{string="infotext"},{float="fuel_totaltime"},{float="fuel_time"},{float="src_totaltime"},{float="src_time"}},
},
["technic:coal_alloy_furnace_active"] = {
	name="wrench:technic_coal_alloy_furnace_active",
	lists={"fuel", "src", "src2", "dst"},
	metas={{string="infotext"},{float="fuel_totaltime"},{float="fuel_time"},{float="src_totaltime"},{float="src_time"}},
	store_meta_always=1,
},
["technic:alloy_furnace"] = {
	name="wrench:technic_alloy_furnace",
	lists={"src", "src2", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="tube_time"},{int="src_time"}},
},
["technic:alloy_furnace_active"] = {
	name="wrench:technic_alloy_furnace_active",
	lists={"src", "src2", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="tube_time"},{int="src_time"}},
	store_meta_always=1,
},
["technic:mv_alloy_furnace"] = {
	name="wrench:technic_mv_alloy_furnace",
	lists={"src", "src2", "dst", "upgrade1", "upgrade2"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="MV_EU_demand"},{int="MV_EU_input"},{int="tube_time"},{int="src_time"}},
},
["technic:mv_alloy_furnace_active"] = {
	name="wrench:technic_mv_alloy_furnace_active",
	lists={"src", "src2", "dst", "upgrade1", "upgrade2"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="MV_EU_demand"},{int="MV_EU_input"},{int="tube_time"},{int="src_time"}},
	store_meta_always=1,
},
["technic:tool_workshop"] = {
	name="wrench:technic_tool_workshop",
	lists={"src"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"}},
},
["technic:grinder"] = {
	name="wrench:technic_grinder",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
},
["technic:grinder_active"] = {
	name="wrench:technic_grinder_active",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
	store_meta_always=1,
},
["technic:mv_grinder"] = {
	name="wrench:technic_mv_grinder",
	lists={"src", "dst", "upgrade1", "upgrade2"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="MV_EU_demand"},{int="MV_EU_input"},{int="tube_time"},{int="src_time"}},
},
["technic:mv_grinder_active"] = {
	name="wrench:technic_mv_grinder_active",
	lists={"src", "dst", "upgrade1", "upgrade2"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="MV_EU_demand"},{int="MV_EU_input"},{int="tube_time"},{int="src_time"}},
	store_meta_always=1,
},
["technic:extractor"] = {
	name="wrench:technic_extractor",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
},
["technic:extractor_active"] = {
	name="wrench:technic_extractor_active",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
	store_meta_always=1,
},
["technic:compressor"] = {
	name="wrench:technic_compressor",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
},
["technic:compressor_active"] = {
	name="wrench:technic_compressor_active",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"}},
	store_meta_always=1,
},
["technic:cnc"] = {
	name="wrench:technic_cnc",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"},{string="cnc_product"}},
},
["technic:cnc_active"] = {
	name="wrench:technic_cnc_active",
	lists={"src", "dst"},
	metas={{string="infotext"},{string="formspec"},{int="state"},{int="LV_EU_demand"},{int="LV_EU_input"},{int="src_time"},{string="cnc_product"}},
	store_meta_always=1,
},
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
	supported_nodes["technic:gold_chest"..chest_mark_colors[i][1]] = {
		name="wrench:technic_gold_chest"..chest_mark_colors[i][1],
		lists={"main"},
		metas={{string="infotext"},{string="formspec"}},
	}
	supported_nodes["technic:gold_locked_chest"..chest_mark_colors[i][1]] = {
		name="wrench:technic_gold_locked_chest"..chest_mark_colors[i][1],
		lists={"main"},
		metas={{string="infotext"},{string="owner"},{string="formspec"}},
		owner_protection=1,
	}
end
for i=0,8,1 do
	if i==0 then i="" end
	supported_nodes["technic:battery_box"..i] = {
		name="wrench:technic_battery_box"..i,
		lists={"src", "dst"},
		metas={{string="infotext"},{string="formspec"},{int="LV_EU_demand"},{int="LV_EU_supply"},{int="LV_EU_input"},{int="internal_EU_charge"},{float="last_side_shown"}},
		store_meta_always=1,
	}
	supported_nodes["technic:mv_battery_box"..i] = {
		name="wrench:technic_mv_battery_box"..i,
		lists={"src", "dst"},
		metas={{string="infotext"},{string="formspec"},{int="MV_EU_demand"},{int="MV_EU_supply"},{int="MV_EU_input"},{int="internal_EU_charge"},{float="last_side_shown"}},
		store_meta_always=1,
	}
	supported_nodes["technic:hv_battery_box"..i] = {
		name="wrench:technic_hv_battery_box"..i,
		lists={"src", "dst"},
		metas={{string="infotext"},{string="formspec"},{int="HV_EU_demand"},{int="HV_EU_supply"},{int="HV_EU_input"},{int="internal_EU_charge"},{float="last_side_shown"}},
		store_meta_always=1,
	}
end

local function convert_to_original_name(name)
	for key,value in pairs(supported_nodes) do
		if name == value.name then return key end
	end
end

for name,info in pairs(supported_nodes) do
	local olddef = minetest.registered_nodes[name]
	if olddef ~= nil then
		local newdef = {}
		for key,value in pairs(olddef) do
			newdef[key] = value
		end
		newdef.stack_max = 1
		newdef.description = newdef.description.." with items"
		newdef.groups = {}
		newdef.groups.not_in_creative_inventory = 1
		newdef.on_construct = nil
		newdef.on_destruct = nil
		newdef.after_place_node = function(pos, placer, itemstack)
			minetest.set_node(pos, {name = convert_to_original_name(itemstack:get_name()),
												param2 = minetest.get_node(pos).param2})
			minetest.after(0.5, function(pos, placer, itemstack)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				local data = minetest.deserialize(itemstack:get_metadata())
				local lists = data.lists
				for listname,list in pairs(lists) do
					inv:set_list(listname, list)
				end
				local metas = data.metas
				local temp = nil
				for i=1,#metas,1 do
					temp = metas[i]
					if temp.string ~= nil then
						meta:set_string(temp.string, temp.value)
					end
					if temp.int ~= nil then
						meta:set_int(temp.int, temp.value)
					end
					if temp.float ~= nil then
						meta:set_float(temp.float, temp.value)
					end
				end
			end, pos, placer, itemstack)
		end
		minetest.register_node(info.name, newdef)
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
		local meta = minetest.get_meta(pos)
		if support.owner_protection ~= nil then
			local owner = meta:get_string("owner")
			if owner ~= nil then
				if owner ~= placer:get_player_name() then
					minetest.log("action", placer:get_player_name()..
					" tried to destroy a locked chest belonging to "..
					owner.." at "..
					minetest.pos_to_string(pos))
					return
				end
			end
		end
		
		local lists = support.lists
		local inv = meta:get_inventory()
		local empty = true
		local metadata_str = {}
		local list_str = {}
		for i=1,#lists,1 do
			if not inv:is_empty(lists[i]) then empty = false end
			local list = inv:get_list(lists[i])
			for j=1,#list,1 do
				list[j] = list[j]:to_string()
			end
			list_str[lists[i]] = list
		end
		metadata_str.lists = list_str
		
		local metas = support.metas
		local meta_str = {}
		for i=1,#metas,1 do
			local temp = metas[i]
			if temp.string ~= nil then
				meta_str[i] = {string = temp.string, value = meta:get_string(temp.string)}
			end
			if temp.int ~= nil then
				meta_str[i] = {int = temp.int, value = meta:get_int(temp.int)}
			end
			if temp.float ~= nil then
				meta_str[i] = {float = temp.float, value = meta:get_float(temp.float)}
			end
		end
		metadata_str.metas = meta_str
		
		inv = placer:get_inventory()
		local stack = {name = name}
		if inv:room_for_item("main", stack) then
			minetest.remove_node(pos)
			itemstack:add_wear(65535/20)
			if empty and #lists > 0 and support.store_meta_always == nil then
				inv:add_item("main", stack)
			else
				stack.name = supported_nodes[name].name
				stack.metadata = minetest.serialize(metadata_str)
				inv:add_item("main", stack)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "wrench:wrench",
	recipe = {
	{"default:steel_ingot","","default:steel_ingot"},
	{"","default:steel_ingot",""},
	{"","default:steel_ingot",""},
	},
})