--Forcefield mod by ShadowNinja

local forcefield_emitter_buffer_size = 10000
local forcefield_emitter_power_consumption = 0.8
local forcefield_update_interval = 1

minetest.register_craft({
	output = 'technic:forcefield_emitter_off',
	recipe = {
			{'default:mese',         'technic:deployer_off', 'default:mese'        },
			{'technic:deployer_off', 'technic:motor',        'technic:deployer_off'},
			{'default:mese',         'technic:deployer_off', 'default:mese'        },
	}
})

local function get_forcefield_count(range)
	local count = 0
	for x=-range,range do
	for y=-range,range do
	for z=-range,range do
		if ((x*x+y*y+z*z) <= (range * range + range)) then
			if (y == 0) or ((range-1) * (range-1) + (range-1) <= x*x+y*y+z*z) then
				count = count + 1
			end
		end
	end
	end
	end
	return count
end

local function add_forcefield(pos, range)
	for x=-range,range do
	for y=-range,range do
	for z=-range,range do
		if ((x*x+y*y+z*z) <= (range * range + range)) then
			if ((range-1) * (range-1) + (range-1) <= x*x+y*y+z*z) then
				local np={x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local n = minetest.env:get_node(np).name
				if (n == "air") then
					minetest.env:add_node(np, {name = "technic:forcefield"})
				end
			end
		end
	end
	end
	end
	return true
end

local function remove_forcefield(p, range)
	for x=-range,range do
	for y=-range,range do
	for z=-range,range do
		if ((x*x+y*y+z*z) <= (range * range + range)) then
			if ((range-1) * (range-1) + (range-1) <= x*x+y*y+z*z) then
				local np={x=p.x+x,y=p.y+y,z=p.z+z}
				local n = minetest.env:get_node(np).name
				if (n == "technic:forcefield") then
					minetest.env:remove_node(np)
				end
			end
		end
	end
	end
	end
end

forcefield_receive_fields = function(pos, formname, fields, sender)
	local meta = minetest.env:get_meta(pos)
	local range = meta:get_int("range")
	if fields.add then range = range + 1 end
	if fields.subtract then range = range - 1 end
	if fields.toggle then
		if meta:get_int("enabled") == 1 then
			meta:set_int("enabled", 0)
		else
			meta:set_int("enabled", 1)
		end
	end
	if range <= 20 and range >= 0 and meta:get_int("range") ~= range then
		remove_forcefield(pos, meta:get_int("range"))
		meta:set_int("range", range)
		local buffer = meta:get_float("internal_EU_buffer")
		local buffer_size = meta:get_float("internal_EU_buffer_size")
		local load = math.floor(buffer / buffer_size * 100)
		meta:set_string("formspec", get_forcefield_formspec(range, 0))
	end
end

function get_forcefield_formspec(range, load)
	if not load then load = 0 end
	return "invsize[8,9;]"..
	"label[0,0;Forcefield emitter]"..
	"label[1,3;Power level]"..
	"image[1,1;1,2;technic_power_meter_bg.png^[lowpart:"..
	load..":technic_power_meter_fg.png]"..
	"label[4,1;Range]"..
	"label[4,2;"..range.."]"..
	"button[3,2;1,1;add;+]"..
	"button[5,2;1,1;subtract;-]"..
	"button[3,3;3,1;toggle;Enable/Disable]"..
	"list[current_player;main;0,5;8,4;]"
end

local function forcefield_check(pos)
	local meta = minetest.env:get_meta(pos)
	local node = minetest.env:get_node(pos)
	local internal_EU_buffer=meta:get_float("internal_EU_buffer")
	local internal_EU_buffer_size=meta:get_float("internal_EU_buffer_size")

	local load = math.floor(internal_EU_buffer/internal_EU_buffer_size * 100)
	meta:set_string("formspec", get_forcefield_formspec(meta:get_int("range"), load))

	local power_requirement = get_forcefield_count(meta:get_int("range")) * forcefield_emitter_power_consumption
	if meta:get_int("enabled") == 1 and internal_EU_buffer >= power_requirement then
		if node.name == "technic:forcefield_emitter_off" then
			hacky_swap_node(pos, "technic:forcefield_emitter_on")
		end
		internal_EU_buffer=internal_EU_buffer-power_requirement;
		meta:set_float("internal_EU_buffer", internal_EU_buffer)
		add_forcefield(pos, meta:get_int("range"))
	else
		if node.name == "technic:forcefield_emitter_on" then
			remove_forcefield(pos, meta:get_int("range"))
			hacky_swap_node(pos, "technic:forcefield_emitter_off")
		end
	end
	return true

end

local mesecons = {effector = {
	action_on = function(pos, node)
		minetest.env:get_meta(pos):set_int("enabled", 0)
	end,
	action_off = function(pos, node)
		minetest.env:get_meta(pos):set_int("enabled", 1)
	end
}}

minetest.register_node("technic:forcefield_emitter_off", {
	description = "Forcefield emitter",
	inventory_image = minetest.inventorycube("technic_forcefield_emitter_off.png"),
	tiles = {"technic_forcefield_emitter_off.png"},
	is_ground_content = true,
	groups = {cracky = 1},
	technic_power_machine=1,
	on_timer = forcefield_check,
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos)
		minetest.env:get_node_timer(pos):start(forcefield_update_interval)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_float("internal_EU_buffer", 0)
		meta:set_float("internal_EU_buffer_size", forcefield_emitter_buffer_size)
		meta:set_int("range", 10)
		meta:set_int("enabled", 1)
		meta:set_string("formspec", get_forcefield_formspec(meta:get_int("range", 0)))
		meta:set_string("infotext", "Forcefield emitter");
	end,
	mesecons = mesecons
})

minetest.register_node("technic:forcefield_emitter_on", {
	description = "Forcefield emitter on (you hacker you)",
	tiles = {"technic_forcefield_emitter_on.png"},
	is_ground_content = true,
	groups = {cracky = 1, not_in_creative_inventory=1},
	drop='"technic:forcefield_emitter_off" 1',
	on_timer = forcefield_check,
	on_receive_fields = forcefield_receive_fields,
	on_construct = function(pos) 
		minetest.env:get_node_timer(pos):start(forcefield_update_interval)
		local meta = minetest.env:get_meta(pos)
		meta:set_float("technic_power_machine", 1)
		meta:set_float("internal_EU_buffer", 0)
		meta:set_float("internal_EU_buffer_size", forcefield_emitter_buffer_size)
		meta:set_int("range", 10)
		meta:set_int("enabled", 1)
		meta:set_string("formspec", get_forcefield_formspec(meta:get_int("range"), 0))
		meta:set_string("infotext", "Forcefield emitter");
	end,
	on_dig = function(pos, node, digger)	
		remove_forcefield(pos, minetest.env:get_meta(pos):get_int("range"))
		return minetest.node_dig(pos, node, digger)
	end,
	technic_power_machine=1,
	mesecons = mesecons
})

minetest.register_node("technic:forcefield", {
	description = "Forcefield (you hacker you)",
	sunlight_propagates = true,
	drop = '',
	tiles = {{name="technic_forcefield_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}},
	is_ground_content = true,
	groups = {not_in_creative_inventory=1, unbreakable=1},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {  --hacky way to get the field blue and not see through the ground
		type = "fixed",
		fixed={
			{-.5,-.5,-.5,.5,.5,.5},
		},
	},
})

register_MV_machine ("technic:forcefield_emitter_on","RE")
register_MV_machine ("technic:forcefield_emitter_off","RE")




