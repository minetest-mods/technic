minetest.register_alias("tool_workshop", "technic:tool_workshop")
minetest.register_craft({
	output = 'technic:tool_workshop',
	recipe = {
		{'default:wood', 'default:wood', 'default:wood'},
		{'default:wood', 'default:diamond', 'default:wood'},
		{'default:stone', 'moreores:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:tool_workshop", {
	description = "Tool Workshop",
	stack_max = 99,
}) 

workshop_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"list[current_name;src;3,1;1,1;]"..
	"label[0,0;Tool Workshop]"..
	"label[1,3;Power level]"..
	"list[current_player;main;0,5;8,4;]"

minetest.register_node("technic:tool_workshop", {
	description = "Tool Workshop",
	tiles = {"technic_workshop_top.png", "technic_machine_bottom.png", "technic_workshop_side.png",
		"technic_workshop_side.png", "technic_workshop_side.png", "technic_workshop_side.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
	technic_power_machine=1,
	internal_EU_buffer=0;
	internal_EU_buffer_size=2000;

	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Tool Workshop")
		meta:set_float("technic_power_machine", 1)
		meta:set_float("internal_EU_buffer", 1)
		meta:set_float("internal_EU_buffer_size", 2000)
		meta:set_string("formspec", workshop_formspec)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		end,	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"technic:tool_workshop"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
	local meta = minetest.env:get_meta(pos)
	local charge= meta:get_float("internal_EU_buffer")
	local max_charge= meta:get_float("internal_EU_buffer_size")
	local load_step=2000
	local load_cost=200
		local inv = meta:get_inventory()
		if inv:is_empty("src")==false  then 
			srcstack = inv:get_stack("src", 1)
			src_item=srcstack:to_table()
			if (src_item["name"]=="technic:water_can" or src_item["name"]=="technic:lava_can") then
				load_step=0
				load_cost=0
				end
			local load1=tonumber((src_item["wear"])) 
			if charge>load_cost then
				if load1>1 then 
					if load1-load_step<0 then load_step=load1 load1=1
					else load1=load1-load_step end
					charge=charge-load_cost
					src_item["wear"]=tostring(load1)
					inv:set_stack("src", 1, src_item)
				end
			end
		end
	
	meta:set_float("internal_EU_buffer",charge)
	
	
	local load = math.floor((charge/max_charge)*100)
	meta:set_string("formspec",
				"invsize[8,9;]"..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]"..
				"list[current_name;src;3,1;1,1;]"..
				"label[0,0;Tool Workshop]"..
				"label[1,3;Power level]"..
				"list[current_player;main;0,5;8,4;]")
	end
}) 

register_LV_machine ("technic:tool_workshop","RE")

