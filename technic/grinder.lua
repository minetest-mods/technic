grinder_recipes ={}

registered_grinder_recipes_count=1

function register_grinder_recipe (string1,string2)
grinder_recipes[registered_grinder_recipes_count]={}
grinder_recipes[registered_grinder_recipes_count].src_name=string1
grinder_recipes[registered_grinder_recipes_count].dst_name=string2
registered_grinder_recipes_count=registered_grinder_recipes_count+1
if unified_inventory then
	unified_inventory.register_craft({
	type = "grinding",
	output = string2,
	items = {string1},
	width = 0,
	})
	end
end

register_grinder_recipe("default:stone","default:sand")
register_grinder_recipe("default:cobble","default:gravel")
register_grinder_recipe("default:gravel","default:dirt")
register_grinder_recipe("default:desert_stone","default:desert_sand")
register_grinder_recipe("default:iron_lump","technic:iron_dust 2")
register_grinder_recipe("default:steel_ingot","technic:iron_dust 1")
register_grinder_recipe("default:coal_lump","technic:coal_dust 2")
register_grinder_recipe("default:copper_lump","technic:copper_dust 2")
register_grinder_recipe("default:copper_ingot","technic:copper_dust 1")
register_grinder_recipe("default:gold_lump","technic:gold_dust 2")
register_grinder_recipe("default:gold_ingot","technic:gold_dust 1")
--register_grinder_recipe("default:bronze_ingot","technic:bronze_dust 1")  -- Dust does not exist yet
register_grinder_recipe("moreores:tin_lump","technic:tin_dust 2")
register_grinder_recipe("moreores:tin_ingot","technic:tin_dust 1")
register_grinder_recipe("moreores:silver_lump","technic:silver_dust 2")
register_grinder_recipe("moreores:silver_ingot","technic:silver_dust 1")
register_grinder_recipe("moreores:mithril_lump","technic:mithril_dust 2")
register_grinder_recipe("moreores:mithril_ingot","technic:mithril_dust 1")
register_grinder_recipe("technic:chromium_lump","technic:chromium_dust 2")
register_grinder_recipe("technic:chromium_ingot","technic:chromium_dust 1")
register_grinder_recipe("technic:stainless_steel_ingot","stainless_steel_dust 1")
register_grinder_recipe("technic:brass_ingot","technic:brass_dust 1")
register_grinder_recipe("homedecor:brass_ingot","technic:brass_dust 1") 
register_grinder_recipe("technic:zinc_lump","technic:zinc_dust 2")
register_grinder_recipe("technic:zinc_ingot","technic:zinc_dust 1")
register_grinder_recipe("technic:coal_dust","dye:black 2")
register_grinder_recipe("default:cactus","dye:green 2")
register_grinder_recipe("default:dry_shrub","dye:brown 2")
register_grinder_recipe("flowers:flower_geranium","dye:blue 2")
register_grinder_recipe("flowers:flower_dandelion_white","dye:white 2")
register_grinder_recipe("flowers:flower_dandelion_yellow","dye:yellow 2")
register_grinder_recipe("flowers:flower_tulip","dye:orange 2")
register_grinder_recipe("flowers:flower_rose","dye:red 2")
register_grinder_recipe("flowers:flower_viola","dye:violet 2")

minetest.register_craftitem( "technic:coal_dust", {
	description = "Coal Dust",
	inventory_image = "technic_coal_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})

minetest.register_craftitem( "technic:iron_dust", {
	description = "Iron Dust",
	inventory_image = "technic_iron_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})

minetest.register_craft({
    type = "cooking",
    output = "default:steel_ingot",
    recipe = "technic:iron_dust",
})

minetest.register_craftitem( "technic:copper_dust", {
	description = "Copper Dust",
	inventory_image = "technic_copper_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "default:copper_ingot",
    recipe = "technic:copper_dust",
})

minetest.register_craftitem( "technic:tin_dust", {
	description = "Tin Dust",
	inventory_image = "technic_tin_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "moreores:tin_ingot",
    recipe = "technic:tin_dust",
})

minetest.register_craftitem( "technic:silver_dust", {
	description = "Silver Dust",
	inventory_image = "technic_silver_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "moreores:silver_ingot",
    recipe = "technic:silver_dust",
})

minetest.register_craftitem( "technic:gold_dust", {
	description = "Gold Dust",
	inventory_image = "technic_gold_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "default:gold_ingot",
    recipe = "technic:gold_dust",
})

minetest.register_craftitem( "technic:mithril_dust", {
	description = "Mithril Dust",
	inventory_image = "technic_mithril_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "moreores:mithril_ingot",
    recipe = "technic:mithril_dust",
})

minetest.register_craftitem( "technic:chromium_dust", {
	description = "Chromium Dust",
	inventory_image = "technic_chromium_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "technic:chromium_ingot",
    recipe = "technic:chromium_dust",
})

minetest.register_craftitem( "technic:bronze_dust", {
	description = "Bronze Dust",
	inventory_image = "technic_bronze_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "default:bronze_ingot",
    recipe = "technic:bronze_dust",
})

minetest.register_craftitem( "technic:brass_dust", {
	description = "Brass Dust",
	inventory_image = "technic_brass_dust.png",
	on_place_on_ground = minetest.craftitem_place_item,
	})
minetest.register_craft({
    type = "cooking",
    output = "technic:brass_ingot",
    recipe = "technic:brass_dust",
})

minetest.register_craftitem( "technic:stainless_steel_dust", {
	description = "Stainless Steel Dust",
	inventory_image = "technic_stainless_steel_dust.png",
	})

minetest.register_craft({
    type = "cooking",
    output = "technic:stainless_steel_ingot",
    recipe = "technic:stainless_steel_dust",
})

minetest.register_craftitem( "technic:zinc_dust", {
	description = "Zinc Dust",
	inventory_image = "technic_zinc_dust.png",
	})

minetest.register_craft({
    type = "cooking",
    output = "technic:zinc_ingot",
    recipe = "technic:zinc_dust",
})

minetest.register_alias("grinder", "technic:grinder")
minetest.register_craft({
	output = 'technic:grinder',
	recipe = {
		{'default:desert_stone', 'default:desert_stone', 'default:desert_stone'},
		{'default:desert_stone', 'default:diamond', 'default:desert_stone'},
		{'default:stone', 'default:copper_ingot', 'default:stone'},
	}
})

minetest.register_craftitem("technic:grinder", {
	description = "Grinder",
	stack_max = 99,
})

grinder_formspec =
	"invsize[8,9;]"..
	"image[1,1;1,2;technic_power_meter_bg.png]"..
	"label[0,0;LV Grinder]"..
	"label[1,3;Power level]"..
	"list[current_name;src;3,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"..
	"background[-0.19,-0.25;8.4,9.75;ui_form_bg.png]"..
	"background[0,0;8,4;ui_lv_grinder.png]"..
	"background[0,5;8,4;ui_main_inventory.png]"


minetest.register_node("technic:grinder", {
	description = "LV Grinder",
	tiles = {"technic_lv_grinder_top.png", "technic_lv_grinder_bottom.png", "technic_lv_grinder_side.png",
		"technic_lv_grinder_side.png", "technic_lv_grinder_side.png", "technic_lv_grinder_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	technic_power_machine=1,
	internal_EU_buffer=0;
	internal_EU_buffer_size=5000;
	grind_time=0;
	grinded = nil;
	src_time = 0;
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Grinder")
		meta:set_float("technic_power_machine", 1)
		meta:set_float("internal_EU_buffer", 0)
		meta:set_float("internal_EU_buffer_size", 5000)
		meta:set_string("formspec", grinder_formspec)
		meta:set_float("grind_time", 0)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
		end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			return false
		end
		if not inv:is_empty("dst") then
			return false
		end
		return true
		end,
})

minetest.register_node("technic:grinder_active", {
	description = "Grinder",
	tiles = {"technic_lv_grinder_top.png", "technic_lv_grinder_bottom.png", "technic_lv_grinder_side.png",
		"technic_lv_grinder_side.png", "technic_lv_grinder_side.png", "technic_lv_grinder_front_active.png"},
	paramtype2 = "facedir",
	groups = {cracky=2,not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			return false
		end
		if not inv:is_empty("dst") then
			return false
		end
		return true
		end,
})

minetest.register_abm({
	nodenames = {"technic:grinder","technic:grinder_active"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)

	local meta = minetest.env:get_meta(pos)
	local charge= meta:get_float("internal_EU_buffer")
	local max_charge= meta:get_float("internal_EU_buffer_size")
	local grind_cost=200

	local load = math.floor((charge/max_charge)*100)
	meta:set_string("formspec",
				grinder_formspec..
				"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
						(load)..":technic_power_meter_fg.png]")

		local inv = meta:get_inventory()
		local srclist = inv:get_list("src")
		if inv:is_empty("src") then meta:set_float("grinder_on",0) end

		if (meta:get_float("grinder_on") == 1) then
			if charge>=grind_cost then
			charge=charge-grind_cost;
			meta:set_float("internal_EU_buffer",charge)
			meta:set_float("src_time", meta:get_float("src_time") + 1)
			if meta:get_float("src_time") >= meta:get_float("grind_time") then
				-- check if there's room for output in "dst" list
				grinded = get_grinded_item (inv:get_stack("src", 1))
				if inv:room_for_item("dst",grinded) then
					-- Put result in "dst" list
					inv:add_item("dst", grinded)
					-- take stuff from "src" list
					srcstack = inv:get_stack("src", 1)
					srcstack:take_item()
					inv:set_stack("src", 1, srcstack)
					if inv:is_empty("src") then meta:set_float("grinder_on",0) end
				else
					print("Grinder inventory full!")
				end
				meta:set_float("src_time", 0)
			end
			end
		end
		if (meta:get_float("grinder_on")==0) then
		local grinded=nil
		if not inv:is_empty("src") then
			grinded = get_grinded_item (inv:get_stack("src", 1))
			if grinded then
				meta:set_float("grinder_on",1)
				hacky_swap_node(pos,"technic:grinder_active")
				meta:set_string("infotext", "Grinder Active")
				grind_time=4
				meta:set_float("grind_time",grind_time)
				meta:set_float("src_time", 0)
				return
			end
			else
				hacky_swap_node(pos,"technic:grinder")
				meta:set_string("infotext", "Grinder Inactive")
		end
		end
	end
})

function get_grinded_item (items)
new_item =nil
src_item=items:to_table()
item_name=src_item["name"]

local counter=registered_grinder_recipes_count-1
for i=1, counter,1 do
	if	grinder_recipes[i].src_name==item_name then return ItemStack(grinder_recipes[i].dst_name) end
end
return nil
end

register_LV_machine ("technic:grinder","RE")
register_LV_machine ("technic:grinder_active","RE")
